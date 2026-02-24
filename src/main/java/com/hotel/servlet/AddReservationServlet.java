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

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

@WebServlet("/add-reservation")
public class AddReservationServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/add-reservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Parse all form parameters
            String nicPassport     = trimOrNull(req.getParameter("nicPassport"));
            String fullName        = trimOrNull(req.getParameter("fullName"));
            String nationality     = trimOrNull(req.getParameter("nationality"));
            String contact         = trimOrNull(req.getParameter("contact"));
            String email           = trimOrNull(req.getParameter("email"));
            String vehicleNumber   = trimOrNull(req.getParameter("vehicleNumber"));
            String roomType        = trimOrNull(req.getParameter("roomType"));
            String specialRequests = trimOrNull(req.getParameter("specialRequests"));
            String roomPreference  = trimOrNull(req.getParameter("roomPreference"));
            String wakeUpCallStr   = trimOrNull(req.getParameter("wakeUpCall"));
            String loyaltyNumber   = trimOrNull(req.getParameter("loyaltyNumber"));
            boolean luggageStorage = req.getParameter("luggageStorage") != null;

            String checkInStr  = trimOrNull(req.getParameter("checkIn"));
            String checkOutStr = trimOrNull(req.getParameter("checkOut"));

            int adults   = safeParseInt(req.getParameter("adults"),   1);
            int children = safeParseInt(req.getParameter("children"), 0);
            int infants  = safeParseInt(req.getParameter("infants"),  0);

            // 2. Mandatory field validation
            if (isBlank(nicPassport) || isBlank(fullName) || isBlank(contact) ||
                    isBlank(nationality) || isBlank(roomType) || isBlank(checkInStr) || isBlank(checkOutStr)) {
                req.setAttribute("error", "All mandatory fields must be filled.");
                forwardWithError(req, resp);
                return;
            }

            Date checkIn  = Date.valueOf(checkInStr);
            Date checkOut = Date.valueOf(checkOutStr);

            if (checkOut.before(checkIn) || checkOut.equals(checkIn)) {
                req.setAttribute("error", "Check-out must be after check-in date.");
                forwardWithError(req, resp);
                return;
            }

            // 3. Room availability (critical - use date-aware version!)
            int roomId = roomDAO.findAvailableRoomId(roomType, checkIn, checkOut);
            if (roomId == -1) {
                req.setAttribute("error", "No " + roomType + " room available for " + checkIn + " to " + checkOut);
                forwardWithError(req, resp);
                return;
            }

            double rate = roomDAO.getRateForType(roomType);
            if (rate <= 0) {
                req.setAttribute("error", "Invalid rate for selected room type.");
                forwardWithError(req, resp);
                return;
            }

            // 4. Wake-up call (safe parsing)
            Time wakeUpTime = null;
            if (!isBlank(wakeUpCallStr)) {
                try {
                    LocalTime lt = LocalTime.parse(wakeUpCallStr.trim());
                    wakeUpTime = Time.valueOf(lt);
                } catch (DateTimeParseException | IllegalArgumentException ex) {
                    req.setAttribute("error", "Wake-up time must be in HH:mm format (24-hour).");
                    forwardWithError(req, resp);
                    return;
                }
            }

            // 5. Guest handling (create or reuse)
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
                int newId = guestDAO.save(guest);
                if (newId == -1) {
                    throw new RuntimeException("Failed to save new guest");
                }
                guest.setId(newId);
            }

            // 6. Create & populate reservation
            Reservation res = new Reservation();
            res.setGuestId(guest.getId());
            res.setRoomId(roomId);               // safe primitive int
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

            // 7. Save
            if (!reservationDAO.save(res)) {
                req.setAttribute("error", "Failed to save reservation. Database error.");
                forwardWithError(req, resp);
                return;
            }

            // 8. Success
            req.getSession().setAttribute("successMsg", "Reservation created successfully! Number: " + res.getReservationNumber());
            resp.sendRedirect("dashboard");

        } catch (Exception e) {
            e.printStackTrace(); // log for debugging
            req.setAttribute("error", "Unexpected error: " + e.getMessage());
            forwardWithError(req, resp);
        }
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/add-reservation.jsp").forward(req, resp);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private String trimOrNull(String s) {
        return (s == null) ? null : s.trim();
    }

    private int safeParseInt(String s, int defaultVal) {
        if (s == null) return defaultVal;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private String generateReservationNumber() {
        // Replace with better logic later (DB sequence, counter, etc.)
        return "RES-" + java.time.Year.now().getValue() + "-" + (System.nanoTime() % 1000000);
    }
}