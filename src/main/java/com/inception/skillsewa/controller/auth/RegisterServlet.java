package com.inception.skillsewa.controller.auth;

import com.inception.skillsewa.utils.CookieUtils;
import com.inception.skillsewa.utils.IDGenerator;
import com.inception.skillsewa.utils.PasswordUtils;
import com.inception.skillsewa.utils.SessionUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.UserModel;


import java.io.IOException;

@WebServlet("/register")
/**
 * Handles registration page rendering and new user account creation.
 *
 * @author Neek Kafle
 * @author Pratha Bhattarai
 * @author Samira Ghimire
 * @author Abiraj Baskota
 * @author Ashim Shrestha
 * @author Bipin Chaudhary
 */
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmedPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");
        String sessionContactInfo = req.getParameter("sessionContactInfo");

        phone = phone == null ? "" : phone.trim();

        if(!(password.equals(confirmedPassword))){
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if(userDAO.userExistsByEmail(email)){
            req.setAttribute("error", "Email already exists");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if(!phone.matches("\\+?\\d{7,14}")){
            req.setAttribute("error", "Enter a valid phone number (optional '+' and up to 14 digits)");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if(userDAO.userExistsByPhone(phone)){
            req.setAttribute("error", "Phone number already exists");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        UserModel newUser = new UserModel();
        newUser.setUserId(IDGenerator.generateID());
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPassword(PasswordUtils.hashPassword(password));
        newUser.setPhone(phone);
        newUser.setRole("user");

        if(!(sessionContactInfo.isEmpty())) {
            newUser.setSessionContactInfo(sessionContactInfo);
        }

        if(userDAO.insertUser(newUser)){
            SessionUtils.setUserSession(req, newUser);
            CookieUtils.setUserCookie(resp, email);
            resp.sendRedirect(req.getContextPath() + "/");
        }
        else {
            req.setAttribute("error", "Account creation failed! Try again later.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }
    }
}
