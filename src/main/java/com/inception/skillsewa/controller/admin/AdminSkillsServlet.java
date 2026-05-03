package com.inception.skillsewa.controller.admin;

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

@WebServlet("/admin/skills")
public class AdminSkillsServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String categoryFilter = req.getParameter("category");
        Integer selectedCategoryId = null;
        ArrayList<SkillModel> skills;

        if (categoryFilter == null || categoryFilter.trim().isEmpty()) {
            skills = skillDAO.getAllSkills();
        } else {
            try {
                selectedCategoryId = Integer.parseInt(categoryFilter.trim());
                skills = skillDAO.getSkillsByCategoryId(selectedCategoryId);
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid category filter.");
                skills = skillDAO.getAllSkills();
            }
        }

        ArrayList<CategoryModel> categories = categoryDAO.getAllCategories();
        Map<Integer, String> categoryNames = new HashMap<>();
        for (CategoryModel category : categories) {
            categoryNames.put(category.getCategory(), category.getName());
        }

        req.setAttribute("skills", skills);
        req.setAttribute("categories", categories);
        req.setAttribute("categoryNames", categoryNames);
        req.setAttribute("selectedCategoryId", selectedCategoryId);

        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/manage-skills.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            handleDeleteSkill(req, resp);
            return;
        }

        if ("toggle".equals(action)) {
            handleToggleSkill(req, resp);
            return;
        }

        req.getSession().setAttribute("error", "Invalid skill action.");
        resp.sendRedirect(req.getContextPath() + "/admin/skills");
    }

    private void handleDeleteSkill(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer skillId = parseSkillId(req.getParameter("skillId"));
        String redirectUrl = buildRedirectUrl(req);

        if (skillId == null) {
            req.getSession().setAttribute("error", "Invalid skill id.");
            resp.sendRedirect(redirectUrl);
            return;
        }

        boolean deleted = skillDAO.deleteSkillById(skillId);
        if (deleted) {
            req.getSession().setAttribute("success", "Skill deleted successfully.");
        } else {
            req.getSession().setAttribute("error", "Unable to delete skill.");
        }

        resp.sendRedirect(redirectUrl);
    }

    private void handleToggleSkill(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer skillId = parseSkillId(req.getParameter("skillId"));
        String isActiveText = req.getParameter("isActive");
        String redirectUrl = buildRedirectUrl(req);

        if (skillId == null || isActiveText == null) {
            req.getSession().setAttribute("error", "Invalid skill update request.");
            resp.sendRedirect(redirectUrl);
            return;
        }

        boolean newStatus = Boolean.parseBoolean(isActiveText);
        boolean updated = skillDAO.updateSkillActiveStatus(skillId, newStatus);

        if (updated) {
            req.getSession().setAttribute("success", newStatus ? "Skill activated successfully." : "Skill deactivated successfully.");
        } else {
            req.getSession().setAttribute("error", "Unable to update skill status.");
        }

        resp.sendRedirect(redirectUrl);
    }

    private Integer parseSkillId(String skillIdText) {
        try {
            return Integer.parseInt(skillIdText);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String buildRedirectUrl(HttpServletRequest req) {
        String category = req.getParameter("category");
        if (category == null || category.trim().isEmpty()) {
            return req.getContextPath() + "/admin/skills";
        }
        return req.getContextPath() + "/admin/skills?category=" + category.trim();
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
