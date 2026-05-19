package com.inception.skillsewa.controller.users;

import com.inception.skillsewa.dao.BookingDAO;
import com.inception.skillsewa.dao.CategoryDAO;
import com.inception.skillsewa.dao.SkillDAO;
import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.BookingModel;
import com.inception.skillsewa.model.CategoryModel;
import com.inception.skillsewa.model.SkillModel;
import com.inception.skillsewa.model.UserModel;
import com.inception.skillsewa.utils.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Locale;

@WebServlet("/user/skill-detail")
public class SkillDetailServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
        }

        String skillIdText = req.getParameter("id");
        int skillId;
        try {
            skillId = Integer.parseInt(skillIdText);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/user/browse-skills");
            return;
        }

        SkillModel skill = skillDAO.getSkillById(skillId);
        if (skill == null || !skill.isActive()) {
            resp.sendRedirect(req.getContextPath() + "/user/browse-skills");
            return;
        }

        CategoryModel category = categoryDAO.getCategoryById(skill.getCategoryId());
        UserModel teacher = userDAO.getUserById(skill.getTeacherId());

        req.setAttribute("skillTitle", skill.getTitle());
        req.setAttribute("skillDescription", skill.getDescription());
        req.setAttribute("pricePer10", skill.getPrice_per_10min());
        req.setAttribute("categoryName", category == null ? "Category" : category.getName());
        req.setAttribute("teacherName", teacher == null ? skill.getTeacherId() : teacher.getFullName());

        req.getRequestDispatcher("/WEB-INF/views/skill-detail.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String learnerId = session == null ? null : (String) session.getAttribute("userId");
        if (learnerId == null || learnerId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String skillIdText = req.getParameter("skillId");
        String durationText = req.getParameter("duration");
        String message = req.getParameter("message");

        int skillId;
        int duration;
        try {
            skillId = Integer.parseInt(skillIdText);
            duration = Integer.parseInt(durationText);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid booking details.");
            resp.sendRedirect(req.getContextPath() + "/user/browse-skills");
            return;
        }

        if (duration < 10 || duration > 120 || duration % 10 != 0) {
            req.getSession().setAttribute("error", "Please choose a valid duration.");
            resp.sendRedirect(req.getContextPath() + "/user/skill-detail?id=" + skillId);
            return;
        }

        SkillModel skill = skillDAO.getSkillById(skillId);
        if (skill == null || !skill.isActive()) {
            req.getSession().setAttribute("error", "This skill is no longer available.");
            resp.sendRedirect(req.getContextPath() + "/user/browse-skills");
            return;
        }

        if (learnerId.equals(skill.getTeacherId())) {
            req.getSession().setAttribute("error", "You cannot book your own skill.");
            resp.sendRedirect(req.getContextPath() + "/user/skill-detail?id=" + skillId);
            return;
        }

        String bookingId = IDGenerator.generateID();
        BookingModel booking = new BookingModel();
        booking.setBookingId(bookingId);
        booking.setSkillId(skillId);
        booking.setLearnerId(learnerId);
        booking.setDurationMinutes(duration);
        booking.setTotalPrice((duration / 10.0) * skill.getPrice_per_10min());
        booking.setMessage(message == null ? null : message.trim());
        booking.setStatus("pending");
        booking.setPaid(false);

        boolean inserted = bookingDAO.insertBooking(booking);
        if (inserted) {
            req.getSession().setAttribute("success", "Booking request sent successfully.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=pending");
            return;
        }

        req.getSession().setAttribute("error", "Unable to place booking right now. Please try again.");
        resp.sendRedirect(req.getContextPath() + "/user/skill-detail?id=" + skillId);
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
