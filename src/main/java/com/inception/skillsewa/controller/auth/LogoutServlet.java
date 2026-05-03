package com.inception.skillsewa.controller.auth;

import com.inception.skillsewa.utils.CookieUtils;
import com.inception.skillsewa.utils.SessionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        SessionUtils.destroyUserSession(req);
        CookieUtils.clearUserCookie(resp);
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
