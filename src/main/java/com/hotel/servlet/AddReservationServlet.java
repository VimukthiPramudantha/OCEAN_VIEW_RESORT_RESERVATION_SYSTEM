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

@WebServlet("/add-reservation")
public class AddReservationServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Show form if GET
        req.getRequestDispatcher("/add-reservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Parse parameters
        java.lang.String nicPassport = req.getParameter("nicPassport");
        java.lang.String fullName = req.getParameter("fullName");
        int adults = Integer.parseInt(req.getParameter("adults"));
        int children = Integer.parseInt(req.getParameter("children"));
        int infants = Integer.parseInt(req.getParameter("infants"));
        java.lang.String nationality = req.getParameter("nationality");
        java.lang.String contact = req.getParameter("contact");
        java.lang.String email = req.getParameter("email");

        java.lang.String vehicleNumber = req.getParameter("vehicleNumber");
        Date checkIn = Date.valueOf(req.getParameter("checkIn"));
        Date checkOut = Date.valueOf(req.getParameter("checkOut"));
        java.lang.String roomType = req.getParameter("roomType");
        java.lang.String specialRequests = req.getParameter("specialRequests");

        java.lang.String roomPreference = req.getParameter("roomPreference");
        java.lang.String wakeUpCall = req.getParameter("wakeUpCall");
        boolean luggageStorage = req.getParameter("luggageStorage") != null;
        java.lang.String loyaltyNumber = req.getParameter("loyaltyNumber");

        // Validation (server-side)
        if (checkOut.before(checkIn)) {
            req.setAttribute("error", "Check-out must be after check-in");
            req.getRequestDispatcher("/add-reservation.jsp").forward(req, resp);
            return;
        }
//        if (!roomDAO.isRoomAvailable(roomType, checkIn, checkOut)) {
//            req.setAttribute("error", "No available room for selected type and dates");
//            req.getRequestDispatcher("/add-reservation.jsp").forward(req, resp);
//            return;
//        }

        // Auto-save guest (check if exists by contact/nic)
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
            // guest.setAddress(?) — add if needed
            guestDAO.save(guest);
        }

        // Create reservation
        Reservation res = new Reservation();
        res.setGuestId(guest.getId());
//        res.setRoomId(roomDAO.findAvailableRoomId(roomType));
        res.setCheckIn(checkIn);
        res.setCheckOut(checkOut);
//        res.setRatePerNight(roomDAO.getRateForType(roomType));
        res.setSpecialRequests(specialRequests);
        res.setVehicleNumber(vehicleNumber);
        res.setRoomPreference(roomPreference);
        res.setWakeUpCall(wakeUpCall != null ? java.sql.Time.valueOf(wakeUpCall) : null);
        res.setLuggageStorage(luggageStorage);
        res.setLoyaltyNumber(loyaltyNumber);
        res.setReservationNumber(generateReservationNumber()); // implement util

        reservationDAO.save(res);

        // Success - redirect
        req.getSession().setAttribute("success", "Reservation created successfully: " + res.getReservationNumber());
        resp.sendRedirect("dashboard");
    }

    private String generateReservationNumber() {
        // e.g. "RES-" + year + "-" + padded ID
        return "RES-2026-" + System.currentTimeMillis() % 10000; // dummy; use DB auto or sequence
    }
}