package com.inception.skillsewa.controller.admin;

import com.inception.skillsewa.dao.BookingDAO;
import com.inception.skillsewa.dao.SkillDAO;
import com.inception.skillsewa.model.BookingModel;
import com.inception.skillsewa.model.SkillModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet("/admin/bookings")
public class AdminBookingsServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final SkillDAO skillDAO = new SkillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String statusFilter = req.getParameter("status");
        String normalizedStatus = normalizeStatus(statusFilter);
        boolean hasStatusFilter = normalizedStatus != null && !normalizedStatus.isEmpty();

        if (hasStatusFilter && !isAllowedStatus(normalizedStatus)) {
            req.setAttribute("error", "Invalid status filter.");
            normalizedStatus = null;
        }

        ArrayList<BookingModel> bookings;
        if (normalizedStatus == null || normalizedStatus.isEmpty()) {
            bookings = bookingDAO.getAllBookings();
        } else {
            bookings = bookingDAO.getBookingsByStatus(normalizedStatus);
            req.setAttribute("selectedStatus", normalizedStatus);
        }

        Map<Integer, String> skillTitles = buildSkillTitlesMap(bookings);

        req.setAttribute("bookings", bookings);
        req.setAttribute("skillTitles", skillTitles);

        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/manage-bookings.jsp").forward(req, resp);
    }

    private String normalizeStatus(String status) {
        if (status == null) {
            return null;
        }
        return status.trim().toLowerCase(Locale.ENGLISH);
    }

    private boolean isAllowedStatus(String status) {
        return "accepted".equals(status) || "pending".equals(status) || "rejected".equals(status);
    }

    private Map<Integer, String> buildSkillTitlesMap(ArrayList<BookingModel> bookings) {
        Map<Integer, String> skillTitles = new HashMap<>();
        for (BookingModel booking : bookings) {
            int skillId = booking.getSkillId();
            if (skillTitles.containsKey(skillId)) {
                continue;
            }

            SkillModel skill = skillDAO.getSkillById(skillId);
            if (skill != null && skill.getTitle() != null && !skill.getTitle().trim().isEmpty()) {
                skillTitles.put(skillId, skill.getTitle());
            }
        }
        return skillTitles;
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
