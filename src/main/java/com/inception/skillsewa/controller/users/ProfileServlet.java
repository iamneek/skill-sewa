package com.inception.skillsewa.controller.users;

import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.UserModel;
import com.inception.skillsewa.utils.PasswordUtils;
import com.inception.skillsewa.utils.SessionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/user/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = session == null ? null : (String) session.getAttribute("userId");
        if (userId == null || userId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        moveFlashMessage(session, req, "success");
        moveFlashMessage(session, req, "error");

        UserModel profileUser = userDAO.getUserById(userId);
        if (profileUser == null) {
            req.getSession().setAttribute("error", "Unable to load your profile.");
            resp.sendRedirect(req.getContextPath() + "/user/dashboard");
            return;
        }

        req.setAttribute("profileUser", profileUser);
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = session == null ? null : (String) session.getAttribute("userId");
        if (userId == null || userId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("profile".equals(action)) {
            handleProfileUpdate(req, resp, userId);
            return;
        }

        if ("password".equals(action)) {
            handlePasswordUpdate(req, resp, userId);
            return;
        }

        req.getSession().setAttribute("error", "Invalid profile action.");
        resp.sendRedirect(req.getContextPath() + "/user/profile");
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse resp, String userId) throws IOException {
        String fullName = trim(req.getParameter("fullName"));
        String phone = trim(req.getParameter("phone"));
        String sessionContactInfo = trim(req.getParameter("sessionContactInfo"));

        if (fullName.isEmpty() || phone.isEmpty()) {
            req.getSession().setAttribute("error", "Full name and phone are required.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        if (userDAO.phoneExistsForOtherUser(phone, userId)) {
            req.getSession().setAttribute("error", "Phone number already exists.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        String contactValue = sessionContactInfo.isEmpty() ? null : sessionContactInfo;
        boolean updated = userDAO.updateUserProfile(userId, fullName, phone, contactValue);
        if (!updated) {
            req.getSession().setAttribute("error", "Could not update profile. Try again.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        refreshUserSession(req, userId);
        req.getSession().setAttribute("success", "Profile updated successfully.");
        resp.sendRedirect(req.getContextPath() + "/user/profile");
    }

    private void handlePasswordUpdate(HttpServletRequest req, HttpServletResponse resp, String userId) throws IOException {
        String currentPassword = trim(req.getParameter("currentPassword"));
        String newPassword = trim(req.getParameter("newPassword"));
        String confirmPassword = trim(req.getParameter("confirmPassword"));

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            req.getSession().setAttribute("error", "Please fill all password fields.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.getSession().setAttribute("error", "New passwords do not match.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        if (newPassword.length() < 6) {
            req.getSession().setAttribute("error", "New password must be at least 6 characters.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        UserModel user = userDAO.getUserById(userId);
        if (user == null || user.getPassword() == null || !PasswordUtils.checkPassword(currentPassword, user.getPassword())) {
            req.getSession().setAttribute("error", "Current password is incorrect.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        String passwordHash = PasswordUtils.hashPassword(newPassword);
        boolean updated = userDAO.updateUserPassword(userId, passwordHash);
        if (!updated) {
            req.getSession().setAttribute("error", "Could not update password. Try again.");
            resp.sendRedirect(req.getContextPath() + "/user/profile");
            return;
        }

        refreshUserSession(req, userId);
        req.getSession().setAttribute("success", "Password updated successfully.");
        resp.sendRedirect(req.getContextPath() + "/user/profile");
    }

    private void refreshUserSession(HttpServletRequest req, String userId) {
        UserModel refreshedUser = userDAO.getUserById(userId);
        if (refreshedUser != null) {
            SessionUtils.setUserSession(req, refreshedUser);
        }
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
