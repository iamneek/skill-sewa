package com.inception.skillsewa.controller.users;

import com.inception.skillsewa.dao.CategoryDAO;
import com.inception.skillsewa.dao.SkillDAO;
import com.inception.skillsewa.model.CategoryModel;
import com.inception.skillsewa.model.SkillModel;
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

@WebServlet("/user/my-skills")
public class MySkillsServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = session == null ? null : (String) session.getAttribute("userId");

        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
        }

        if (userId != null && !userId.trim().isEmpty()) {
            ArrayList<SkillModel> mySkills = skillDAO.getSkillsByTeacherId(userId);
            ArrayList<CategoryModel> categories = categoryDAO.getAllCategories();

            Map<Integer, String> categoryNames = new HashMap<>();
            for (CategoryModel category : categories) {
                categoryNames.put(category.getCategory(), category.getName());
            }

            req.setAttribute("mySkills", mySkills);
            req.setAttribute("categoryNames", categoryNames);
        }

        req.getRequestDispatcher("/WEB-INF/views/my-skills.jsp").forward(req, resp);
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
        if (!"delete".equals(action)) {
            req.getSession().setAttribute("error", "Invalid skill action.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        String skillIdText = req.getParameter("skillId");
        int skillId;
        try {
            skillId = Integer.parseInt(skillIdText);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid skill id.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        SkillModel skill = skillDAO.getSkillById(skillId);
        if (skill == null) {
            req.getSession().setAttribute("error", "Skill not found.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        if (!teacherId.equals(skill.getTeacherId())) {
            req.getSession().setAttribute("error", "You cannot delete this skill.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        boolean deleted = skillDAO.deleteSkillById(skillId);
        if (deleted) {
            req.getSession().setAttribute("success", "Skill deleted successfully.");
        } else {
            req.getSession().setAttribute("error", "Unable to delete skill right now.");
        }
        resp.sendRedirect(req.getContextPath() + "/user/my-skills");
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
