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
import java.util.Locale;

@WebServlet("/user/edit-skill")
public class EditSkillServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String teacherId = session == null ? null : (String) session.getAttribute("userId");
        if (teacherId == null || teacherId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int skillId = parseSkillId(req.getParameter("id"));
        if (skillId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        SkillModel skill = skillDAO.getSkillById(skillId);
        if (skill == null || !teacherId.equals(skill.getTeacherId())) {
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        ArrayList<CategoryModel> categories = categoryDAO.getAllCategories();
        req.setAttribute("categories", categories);
        req.setAttribute("skillId", skillId);

        moveFlashMessage(session, req, "success");
        moveFlashMessage(session, req, "error");
        moveFlashMessage(session, req, "formTitle");
        moveFlashMessage(session, req, "formCategoryId");
        moveFlashMessage(session, req, "formDescription");
        moveFlashMessage(session, req, "formPrice");

        if (req.getAttribute("formTitle") == null) {
            req.setAttribute("formTitle", skill.getTitle());
        }
        if (req.getAttribute("formCategoryId") == null) {
            req.setAttribute("formCategoryId", String.valueOf(skill.getCategoryId()));
        }
        if (req.getAttribute("formDescription") == null) {
            req.setAttribute("formDescription", skill.getDescription());
        }
        if (req.getAttribute("formPrice") == null) {
            req.setAttribute("formPrice", String.format(Locale.ENGLISH, "%.2f", skill.getPrice_per_10min()));
        }

        req.getRequestDispatcher("/WEB-INF/views/edit-skill.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String teacherId = session == null ? null : (String) session.getAttribute("userId");
        if (teacherId == null || teacherId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int skillId = parseSkillId(req.getParameter("skillId"));
        SkillModel existing = skillDAO.getSkillById(skillId);
        if (skillId <= 0 || existing == null || !teacherId.equals(existing.getTeacherId())) {
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        String title = clean(req.getParameter("title"));
        String categoryIdText = clean(req.getParameter("categoryId"));
        String description = clean(req.getParameter("description"));
        String priceText = clean(req.getParameter("pricePer10"));

        session.setAttribute("formTitle", title);
        session.setAttribute("formCategoryId", categoryIdText);
        session.setAttribute("formDescription", description);
        session.setAttribute("formPrice", priceText);

        if (title.isEmpty()) {
            session.setAttribute("error", "Title is required.");
            resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
            return;
        }
        if (title.length() > 150) {
            session.setAttribute("error", "Title must be 150 characters or fewer.");
            resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdText);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Please select a valid category.");
            resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
            return;
        }
        if (categoryDAO.getCategoryById(categoryId) == null) {
            session.setAttribute("error", "Selected category does not exist.");
            resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
            return;
        }

        if (description.length() > 2000) {
            session.setAttribute("error", "Description must be 2000 characters or fewer.");
            resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
            return;
        }

        double pricePer10;
        try {
            pricePer10 = Double.parseDouble(priceText);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Enter a valid price.");
            resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
            return;
        }
        if (pricePer10 <= 0 || pricePer10 > 9999) {
            session.setAttribute("error", "Price must be between 0.01 and 9999.");
            resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
            return;
        }

        SkillModel updated = new SkillModel();
        updated.setSkillId(skillId);
        updated.setCategoryId(categoryId);
        updated.setTitle(title);
        updated.setDescription(description);
        updated.setPrice_per_10min(pricePer10);

        boolean done = skillDAO.updateSkill(updated);
        if (done) {
            clearFormFlash(session);
            session.setAttribute("success", "Skill updated successfully.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        session.setAttribute("error", "Unable to update skill right now.");
        resp.sendRedirect(req.getContextPath() + "/user/edit-skill?id=" + skillId);
    }

    private int parseSkillId(String skillIdText) {
        try {
            return Integer.parseInt(skillIdText);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }

    private void clearFormFlash(HttpSession session) {
        session.removeAttribute("formTitle");
        session.removeAttribute("formCategoryId");
        session.removeAttribute("formDescription");
        session.removeAttribute("formPrice");
    }
}
