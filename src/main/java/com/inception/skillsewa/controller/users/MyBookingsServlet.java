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

@WebServlet("/user/my-bookings")
public class MyBookingsServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final SkillDAO skillDAO = new SkillDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = session == null ? null : (String) session.getAttribute("userId");

        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
        }

        String status = req.getParameter("status");
        String selectedStatus = normalizeStatus(status);

        if (userId == null || userId.trim().isEmpty()) {
            req.getRequestDispatcher("/WEB-INF/views/my-bookings.jsp").forward(req, resp);
            return;
        }

        int pendingCount = bookingDAO.getBookingsCountByLearnerAndStatus(userId, "pending");
        int acceptedCount = bookingDAO.getBookingsCountByLearnerAndStatus(userId, "accepted");
        int rejectedCount = bookingDAO.getBookingsCountByLearnerAndStatus(userId, "rejected");
        int completedCount = bookingDAO.getBookingsCountByLearnerAndStatus(userId, "completed");

        ArrayList<BookingModel> filteredBookings = bookingDAO.getBookingsByLearnerAndStatus(userId, selectedStatus);
        Map<Integer, String> skillTitles = new HashMap<>();
        Map<Integer, String> teacherNames = new HashMap<>();
        Map<Integer, String> teacherContactsBySkill = new HashMap<>();
        Map<String, String> teacherContacts = new HashMap<>();
        for (BookingModel booking : filteredBookings) {
            int skillId = booking.getSkillId();
            if (!skillTitles.containsKey(skillId)) {
                SkillModel skill = skillDAO.getSkillById(skillId);
                if (skill != null) {
                    if (skill.getTitle() != null && !skill.getTitle().trim().isEmpty()) {
                        skillTitles.put(skillId, skill.getTitle());
                    }

                    UserModel teacher = userDAO.getUserById(skill.getTeacherId());
                    if (teacher != null && teacher.getFullName() != null && !teacher.getFullName().trim().isEmpty()) {
                        String firstName = teacher.getFullName().trim().split("\\s+")[0];
                        teacherNames.put(skillId, firstName);
                    }

                    if (teacher != null && teacher.getSessionContactInfo() != null) {
                        String sessionContactInfo = teacher.getSessionContactInfo().trim();
                        if (!sessionContactInfo.isEmpty()) {
                            teacherContactsBySkill.put(skillId, sessionContactInfo);
                        }
                    }
                }
            }

            if (booking.isPaid()) {
                String contact = teacherContactsBySkill.get(skillId);
                if (contact != null && !contact.isEmpty()) {
                    teacherContacts.put(booking.getBookingId(), contact);
                }
            }
        }

        req.setAttribute("selectedStatus", selectedStatus);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("acceptedCount", acceptedCount);
        req.setAttribute("rejectedCount", rejectedCount);
        req.setAttribute("completedCount", completedCount);
        req.setAttribute("bookings", filteredBookings);
        req.setAttribute("skillTitles", skillTitles);
        req.setAttribute("teacherNames", teacherNames);
        req.setAttribute("teacherContacts", teacherContacts);

        req.getRequestDispatcher("/WEB-INF/views/my-bookings.jsp").forward(req, resp);
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
