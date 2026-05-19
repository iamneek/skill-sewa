package com.inception.skillsewa.controller.users;

import com.inception.skillsewa.dao.BookingDAO;
import com.inception.skillsewa.dao.SkillDAO;
import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.BookingModel;
import com.inception.skillsewa.model.SkillModel;
import com.inception.skillsewa.model.UserModel;
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

@WebServlet("/user/my-skill-requests")
public class MySkillRequestsServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final SkillDAO skillDAO = new SkillDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String teacherId = session == null ? null : (String) session.getAttribute("userId");
        if (teacherId == null || teacherId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        moveFlashMessage(session, req, "success");
        moveFlashMessage(session, req, "error");

        String status = normalizeStatus(req.getParameter("status"));

        int pendingCount = bookingDAO.getTeacherRequestCountByStatus(teacherId, "pending");
        int acceptedCount = bookingDAO.getTeacherRequestCountByStatus(teacherId, "accepted");
        int rejectedCount = bookingDAO.getTeacherRequestCountByStatus(teacherId, "rejected");
        int completedCount = bookingDAO.getTeacherRequestCountByStatus(teacherId, "completed");

        ArrayList<BookingModel> requests = bookingDAO.getTeacherRequestsByStatus(teacherId, status, null);

        Map<Integer, String> skillTitles = new HashMap<>();
        Map<String, String> learnerNames = new HashMap<>();
        for (BookingModel booking : requests) {
            int currentSkillId = booking.getSkillId();
            if (!skillTitles.containsKey(currentSkillId)) {
                SkillModel skill = skillDAO.getSkillById(currentSkillId);
                if (skill != null && skill.getTitle() != null && !skill.getTitle().trim().isEmpty()) {
                    skillTitles.put(currentSkillId, skill.getTitle());
                }
            }

            String learnerId = booking.getLearnerId();
            if (learnerId != null && !learnerId.trim().isEmpty() && !learnerNames.containsKey(learnerId)) {
                UserModel learner = userDAO.getUserById(learnerId);
                if (learner != null && learner.getFullName() != null && !learner.getFullName().trim().isEmpty()) {
                    String firstName = learner.getFullName().trim().split("\\s+")[0];
                    learnerNames.put(learnerId, firstName);
                }
            }
        }

        req.setAttribute("selectedStatus", status);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("acceptedCount", acceptedCount);
        req.setAttribute("rejectedCount", rejectedCount);
        req.setAttribute("completedCount", completedCount);
        req.setAttribute("requests", requests);
        req.setAttribute("skillTitles", skillTitles);
        req.setAttribute("learnerNames", learnerNames);

        req.getRequestDispatcher("/WEB-INF/views/my-skill-requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String teacherId = session == null ? null : (String) session.getAttribute("userId");
        if (teacherId == null || teacherId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String bookingId = req.getParameter("bookingId");
        String selectedStatus = normalizeStatus(req.getParameter("status"));
        String note = req.getParameter("note");
        String trimmedNote = note == null ? "" : note.trim();

        if (bookingId == null || bookingId.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Invalid booking request.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=" + selectedStatus);
            return;
        }

        if (!bookingDAO.bookingBelongsToTeacher(bookingId.trim(), teacherId)) {
            req.getSession().setAttribute("error", "You are not allowed to update this request.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=" + selectedStatus);
            return;
        }

        if ("accept".equals(action)) {
            boolean updated = bookingDAO.updateBookingDecision(bookingId.trim(), "accepted",
                    trimmedNote.isEmpty() ? null : trimmedNote, null);
            if (updated) {
                req.getSession().setAttribute("success", "Request accepted successfully.");
                resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=accepted");
                return;
            }

            req.getSession().setAttribute("error", "Unable to accept request.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=" + selectedStatus);
            return;
        }

        if ("reject".equals(action)) {
            if (trimmedNote.isEmpty()) {
                req.getSession().setAttribute("error", "Please add a rejection reason.");
                resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=" + selectedStatus);
                return;
            }

            boolean updated = bookingDAO.updateBookingDecision(bookingId.trim(), "rejected", null, trimmedNote);
            if (updated) {
                req.getSession().setAttribute("success", "Request rejected successfully.");
                resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=rejected");
                return;
            }

            req.getSession().setAttribute("error", "Unable to reject request.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=" + selectedStatus);
            return;
        }

        if ("complete".equals(action)) {
            BookingModel booking = bookingDAO.getBookingById(bookingId.trim());
            if (booking == null || !"accepted".equalsIgnoreCase(booking.getStatus())) {
                req.getSession().setAttribute("error", "Only accepted requests can be marked completed.");
                resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=" + selectedStatus);
                return;
            }

            if (!booking.isPaid()) {
                req.getSession().setAttribute("error", "You can mark completed only after learner payment.");
                resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=accepted");
                return;
            }

            boolean updated = bookingDAO.updateBookingStatus(bookingId.trim(), "completed");
            if (updated) {
                req.getSession().setAttribute("success", "Session marked as completed.");
                resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=completed");
                return;
            }

            req.getSession().setAttribute("error", "Unable to mark session as completed.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=accepted");
            return;
        }

        req.getSession().setAttribute("error", "Invalid request action.");
        resp.sendRedirect(req.getContextPath() + "/user/my-skill-requests?status=" + selectedStatus);
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "pending";
        }
        String normalized = status.trim().toLowerCase(Locale.ENGLISH);
        if ("accepted".equals(normalized) || "rejected".equals(normalized) || "completed".equals(normalized)) {
            return normalized;
        }
        return "pending";
    }

}
