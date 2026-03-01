package com.hotel.servlet;

import com.hotel.dao.GuestDAO;
import com.hotel.dao.ReservationDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.model.Guest;
import com.hotel.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.hotel.config.DBUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

@WebServlet("/add-reservation")
public class AddReservationServlet extends SecureServlet {

    private final GuestDAO guestDAO = new GuestDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/add-reservation.jsp");
    }

    @Override
    protected void doSecurePost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Connection conn = null;
        try {
            // === Parse ===
            String nicPassport = trimOrNull(req.getParameter("nicPassport"));
            String fullName = trimOrNull(req.getParameter("fullName"));
            String nationality = trimOrNull(req.getParameter("nationality"));
            String contact = trimOrNull(req.getParameter("contact"));
            String email = trimOrNull(req.getParameter("email"));
            String vehicleNumber = trimOrNull(req.getParameter("vehicleNumber"));
            String roomType = trimOrNull(req.getParameter("roomType"));
            String specialRequests = trimOrNull(req.getParameter("specialRequests"));
            String roomPreference = trimOrNull(req.getParameter("roomPreference"));
            String wakeUpCallStr = trimOrNull(req.getParameter("wakeUpCall"));
            String loyaltyNumber = trimOrNull(req.getParameter("loyaltyNumber"));
            boolean luggageStorage = req.getParameter("luggageStorage") != null;

            String checkInStr = trimOrNull(req.getParameter("checkIn"));
            String checkOutStr = trimOrNull(req.getParameter("checkOut"));

            int adults = safeParseInt(req.getParameter("adults"), 1);
            int children = safeParseInt(req.getParameter("children"), 0);
            int infants = safeParseInt(req.getParameter("infants"), 0);

            // === Validate ===
            if (isBlank(nicPassport) || isBlank(fullName) || isBlank(contact) ||
                    isBlank(nationality) || isBlank(roomType) || isBlank(checkInStr) || isBlank(checkOutStr)) {
                handleError(req, resp, "All mandatory fields must be filled.", "/add-reservation.jsp");
                return;
            }

            Date checkIn = Date.valueOf(checkInStr);
            Date checkOut = Date.valueOf(checkOutStr);

            if (checkOut.before(checkIn) || checkOut.equals(checkIn)) {
                handleError(req, resp, "Check-out must be after check-in date.", "/add-reservation.jsp");
                return;
            }

            // === Availability & Rate ===
            int roomId = roomDAO.findAvailableRoomId(roomType, checkIn, checkOut);
            if (roomId == -1) {
                handleError(req, resp, "No " + roomType + " room available for selected dates.",
                        "/add-reservation.jsp");
                return;
            }

            double rate = roomDAO.getRateForType(roomType);
            if (rate <= 0) {
                handleError(req, resp, "Invalid rate for selected room type.", "/add-reservation.jsp");
                return;
            }

            // === Wake-up call ===
            Time wakeUpTime = null;
            if (!isBlank(wakeUpCallStr)) {
                try {
                    LocalTime lt = LocalTime.parse(wakeUpCallStr.trim());
                    wakeUpTime = Time.valueOf(lt);
                } catch (DateTimeParseException | IllegalArgumentException ex) {
                    handleError(req, resp, "Wake-up time must be in HH:mm format (24-hour).", "/add-reservation.jsp");
                    return;
                }
            }

            // === Guest handling ===
            Guest guest = guestDAO.findByContactOrNic(contact, nicPassport);
            if (guest == null) {
                guest = new Guest();
                guest.setName(fullName);
                guest.setNicPassport(nicPassport);
                guest.setAdults(adults);
                guest.setChildren(children);
                guest.setInfants(infants);
                guest.setNationality(nationality);
                guest.setContact(contact);
                guest.setEmail(email);

                int newGuestId = guestDAO.save(guest);
                if (newGuestId == -1) {
                    handleError(req, resp, "Failed to save guest details.", "/add-reservation.jsp");
                    return;
                }
                guest.setId(newGuestId);
            }

            // === Build reservation ===
            Reservation res = new Reservation();
            res.setGuestId(guest.getId());
            res.setRoomId(roomId);
            res.setCheckIn(checkIn);
            res.setCheckOut(checkOut);
            res.setRatePerNight(rate);
            res.setSpecialRequests(specialRequests);
            res.setVehicleNumber(vehicleNumber);
            res.setRoomPreference(roomPreference);
            res.setWakeUpCall(wakeUpTime);
            res.setLuggageStorage(luggageStorage);
            res.setLoyaltyNumber(loyaltyNumber);
            res.setReservationNumber(generateReservationNumber());

            // === Transaction ===
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            try {
                if (!reservationDAO.save(res, conn)) {
                    throw new SQLException("Failed to save reservation");
                }
                if (!roomDAO.markAsBooked(roomId, conn)) {
                    throw new SQLException("Failed to update room status to booked");
                }
                conn.commit();

                req.getSession().setAttribute("successMsg",
                        "Reservation created successfully! Number: " + res.getReservationNumber());
                redirect(resp, "dashboard");

            } catch (SQLException e) {
                if (conn != null)
                    conn.rollback();
                handleError(req, resp, "Failed to create reservation: " + e.getMessage(), "/add-reservation.jsp");
            } finally {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            handleError(req, resp, "Unexpected error: " + e.getMessage(), "/add-reservation.jsp");
        }
    }

    private String generateReservationNumber() {
        return "RES-" + java.time.Year.now().getValue() + "-" + (System.nanoTime() % 1000000);
    }
}
