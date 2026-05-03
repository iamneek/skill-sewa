package com.inception.skillsewa.controller.auth;

import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.UserModel;
import com.inception.skillsewa.utils.CookieUtils;
import com.inception.skillsewa.utils.PasswordUtils;
import com.inception.skillsewa.utils.SessionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        UserModel user = userDAO.getUserByEmail(email);
        if(user==null){
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }
        if(user.isSuspended()) {
            req.setAttribute("error", "Your account has been suspended");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        if (PasswordUtils.checkPassword(password, user.getPassword())){
            SessionUtils.setUserSession(req, user);
            CookieUtils.setUserCookie(resp, email);
            if ("admin".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
        }
        else {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
