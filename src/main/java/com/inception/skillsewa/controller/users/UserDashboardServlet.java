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
import java.util.Map;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = session == null ? null : (String) session.getAttribute("userId");

        if (userId == null || userId.trim().isEmpty()) {
            req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
            return;
        }

        int skillsPostedCount = skillDAO.getSkillsCountByTeacher(userId);
        int bookingsMadeCount = bookingDAO.getBookingsCountByLearner(userId);
        int sessionsCompletedCount = bookingDAO.getCompletedSessionsCountByLearner(userId);

        ArrayList<BookingModel> recentBookings = bookingDAO.getRecentBookingsByLearner(userId, 5);
        ArrayList<BookingModel> teacherRequests = bookingDAO.getRecentRequestsForTeacher(userId, 5);
        Map<Integer, String> skillTitles = buildSkillTitles(recentBookings, teacherRequests);
        Map<String, String> learnerNames = buildLearnerFirstNames(teacherRequests);

        req.setAttribute("skillsPostedCount", skillsPostedCount);
        req.setAttribute("bookingsMadeCount", bookingsMadeCount);
        req.setAttribute("sessionsCompletedCount", sessionsCompletedCount);
        req.setAttribute("recentBookings", recentBookings);
        req.setAttribute("teacherRequests", teacherRequests);
        req.setAttribute("skillTitles", skillTitles);
        req.setAttribute("learnerNames", learnerNames);

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }

    private Map<Integer, String> buildSkillTitles(ArrayList<BookingModel> recentBookings, ArrayList<BookingModel> teacherRequests) {
        Map<Integer, String> titles = new HashMap<>();
        fillTitlesFromBookings(titles, recentBookings);
        fillTitlesFromBookings(titles, teacherRequests);
        return titles;
    }

    private void fillTitlesFromBookings(Map<Integer, String> titles, ArrayList<BookingModel> bookings) {
        for (BookingModel booking : bookings) {
            int skillId = booking.getSkillId();
            if (titles.containsKey(skillId)) {
                continue;
            }

            SkillModel skill = skillDAO.getSkillById(skillId);
            if (skill != null && skill.getTitle() != null && !skill.getTitle().trim().isEmpty()) {
                titles.put(skillId, skill.getTitle());
            }
        }
    }

    private Map<String, String> buildLearnerFirstNames(ArrayList<BookingModel> teacherRequests) {
        Map<String, String> learnerNames = new HashMap<>();
        for (BookingModel booking : teacherRequests) {
            String learnerId = booking.getLearnerId();
            if (learnerId == null || learnerId.trim().isEmpty() || learnerNames.containsKey(learnerId)) {
                continue;
            }

            UserModel learner = userDAO.getUserById(learnerId);
            if (learner == null || learner.getFullName() == null || learner.getFullName().trim().isEmpty()) {
                continue;
            }

            String firstName = learner.getFullName().trim().split("\\s+")[0];
            learnerNames.put(learnerId, firstName);
        }
        return learnerNames;
    }
}
