package com.inception.skillsewa.controller.admin;


import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.UserModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ArrayList<UserModel> allUsers = userDAO.getAllUsers();
        req.setAttribute("users", allUsers);

        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/manage-users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String userId = req.getParameter("userId");

        if (userId == null || userId.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Invalid user id.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        String cleanedUserId = userId.trim();
        Object sessionUserIdObj = req.getSession().getAttribute("userId");
        String sessionUserId = sessionUserIdObj == null ? "" : sessionUserIdObj.toString();

        if ("toggleSuspend".equals(action)) {
            if (cleanedUserId.equals(sessionUserId)) {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }

            String suspendText = req.getParameter("suspend");
            if (suspendText == null) {
                req.getSession().setAttribute("error", "Invalid suspend request.");
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }

            boolean suspend = Boolean.parseBoolean(suspendText);
            boolean updated = userDAO.updateUserSuspendedStatus(cleanedUserId, suspend);
            if (updated) {
                req.getSession().setAttribute("success", suspend ? "User suspended successfully." : "User unsuspended successfully.");
            } else {
                req.getSession().setAttribute("error", "Unable to update user status.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        if ("delete".equals(action)) {
            if (cleanedUserId.equals(sessionUserId)) {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }

            boolean deleted = userDAO.deleteUserById(cleanedUserId);
            if (deleted) {
                req.getSession().setAttribute("success", "User deleted successfully.");
            } else {
                req.getSession().setAttribute("error", "Unable to delete user. It may be referenced by other records.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        req.getSession().setAttribute("error", "Invalid user action.");
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
