package com.inception.skillsewa.controller.admin;

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

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final SkillDAO skillDAO = new SkillDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int totalUsers = userDAO.getTotalUsersCount();
        int totalSkills = skillDAO.getTotalSkillsCount();
        int totalBookings = bookingDAO.getTotalBookingsCount();
        int pendingBookings = bookingDAO.getPendingBookingsCount();

        ArrayList<UserModel> recentUsers = userDAO.getRecentUsers(5);
        ArrayList<BookingModel> recentBookings = bookingDAO.getRecentBookings(5);
        Map<Integer, String> skillTitles = buildSkillTitlesMap(recentBookings);

        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalSkills", totalSkills);
        req.setAttribute("totalBookings", totalBookings);
        req.setAttribute("pendingBookings", pendingBookings);
        req.setAttribute("recentUsers", recentUsers);
        req.setAttribute("recentBookings", recentBookings);
        req.setAttribute("skillTitles", skillTitles);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
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
}
