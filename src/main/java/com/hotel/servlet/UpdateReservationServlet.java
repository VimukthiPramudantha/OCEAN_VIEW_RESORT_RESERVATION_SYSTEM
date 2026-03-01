package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.dao.RoomDAO;
import com.hotel.dto.ReservationDisplayDTO;
import com.hotel.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/update-reservation")
public class UpdateReservationServlet extends SecureServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doSecureGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (!isBlank(idStr)) {
            // Edit mode: load one reservation for editing
            try {
                int id = Integer.parseInt(idStr);
                ReservationDisplayDTO res = reservationDAO.findById(id);
                if (res != null) {
                    req.setAttribute("reservation", res);
                    forward(req, resp, "/update-reservation.jsp");
                    return;
                } else {
                    req.setAttribute("error", "Reservation #" + id + " not found.");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid reservation ID.");
            }
        }

        // Default: show list of reservations to choose from
        forwardToList(req, resp);
    }

    @Override
    protected void doSecurePost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("reservationId");
        if (isBlank(idStr)) {
            req.setAttribute("error", "Reservation ID is missing.");
            forwardToList(req, resp);
            return;
        }

        try {
            int reservationId = Integer.parseInt(idStr.trim());

            // Parse new values from form
            String specialRequests = req.getParameter("specialRequests");
            String adultsStr = req.getParameter("adults");
            String childrenStr = req.getParameter("children");
            String checkInStr = req.getParameter("checkIn");
            String checkOutStr = req.getParameter("checkOut");

            // Required fields validation
            if (checkInStr == null || checkOutStr == null || adultsStr == null) {
                req.setAttribute("error", "Check-in, check-out, and adults are required.");
                forwardToList(req, resp);
                return;
            }

            Date newCheckIn = Date.valueOf(checkInStr);
            Date newCheckOut = Date.valueOf(checkOutStr);

            // Date logic check
            if (newCheckOut.before(newCheckIn) || newCheckOut.equals(newCheckIn)) {
                req.setAttribute("error", "Check-out must be after check-in date.");
                forwardToList(req, resp);
                return;
            }

            // Overlap check (exclude current reservation)
            boolean hasConflict = reservationDAO.hasOverlapExcludingSelf(reservationId, newCheckIn, newCheckOut);
            if (hasConflict) {
                req.setAttribute("error", "Selected dates overlap with another active booking.");
                forwardToList(req, resp);
                return;
            }

            // Parse numbers safely
            int adults = safeParseInt(adultsStr, 1);
            int children = safeParseInt(childrenStr, 0);

            // Perform the update
            boolean success = reservationDAO.updateDetails(
                    reservationId, specialRequests, adults, children, newCheckIn, newCheckOut);

            if (success) {
                req.getSession().setAttribute("successMsg", "Reservation #" + reservationId + " updated successfully.");
                redirect(resp, "view-reservations");
            } else {
                req.setAttribute("error", "Failed to update reservation (no changes made or database error).");
                // Reload the reservation and forward back to the form
                ReservationDisplayDTO res = reservationDAO.findById(reservationId);
                req.setAttribute("reservation", res);
                forward(req, resp, "/update-reservation.jsp");
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid number format in form fields.");
            forwardToEdit(req, resp, idStr);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Invalid date format.");
            forwardToEdit(req, resp, idStr);
        } catch (Exception e) {
            req.setAttribute("error", "Unexpected error: " + e.getMessage());
            forwardToEdit(req, resp, idStr);
        }
    }

    private void forwardToEdit(HttpServletRequest req, HttpServletResponse resp, String idStr)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(idStr.trim());
            ReservationDisplayDTO res = reservationDAO.findById(id);
            req.setAttribute("reservation", res);
        } catch (Exception ignored) {
        }
        forward(req, resp, "/update-reservation.jsp");
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ReservationDisplayDTO> reservations = reservationDAO.findActiveForUpdate();
        req.setAttribute("reservations", reservations);
        forward(req, resp, "/update-reservation-list.jsp");
    }
}
