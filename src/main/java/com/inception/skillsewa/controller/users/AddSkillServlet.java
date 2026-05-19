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

@WebServlet("/user/add-skill")
public class AddSkillServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SkillDAO skillDAO = new SkillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ArrayList<CategoryModel> categories = categoryDAO.getAllCategories();
        req.setAttribute("categories", categories);

        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
            moveFlashMessage(session, req, "formTitle");
            moveFlashMessage(session, req, "formCategoryId");
            moveFlashMessage(session, req, "formDescription");
            moveFlashMessage(session, req, "formPrice");
        }

        req.getRequestDispatcher("/WEB-INF/views/add-skill.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String teacherId = session == null ? null : (String) session.getAttribute("userId");
        if (teacherId == null || teacherId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String title = clean(req.getParameter("title"));
        String categoryIdText = clean(req.getParameter("categoryId"));
        String description = clean(req.getParameter("description"));
        String priceText = clean(req.getParameter("pricePer10"));

        req.getSession().setAttribute("formTitle", title);
        req.getSession().setAttribute("formCategoryId", categoryIdText);
        req.getSession().setAttribute("formDescription", description);
        req.getSession().setAttribute("formPrice", priceText);

        if (title.isEmpty()) {
            req.getSession().setAttribute("error", "Title is required.");
            resp.sendRedirect(req.getContextPath() + "/user/add-skill");
            return;
        }
        if (title.length() > 150) {
            req.getSession().setAttribute("error", "Title must be 150 characters or fewer.");
            resp.sendRedirect(req.getContextPath() + "/user/add-skill");
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdText);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Please select a valid category.");
            resp.sendRedirect(req.getContextPath() + "/user/add-skill");
            return;
        }

        CategoryModel category = categoryDAO.getCategoryById(categoryId);
        if (category == null) {
            req.getSession().setAttribute("error", "Selected category does not exist.");
            resp.sendRedirect(req.getContextPath() + "/user/add-skill");
            return;
        }

        if (description.length() > 2000) {
            req.getSession().setAttribute("error", "Description must be 2000 characters or fewer.");
            resp.sendRedirect(req.getContextPath() + "/user/add-skill");
            return;
        }

        double pricePer10;
        try {
            pricePer10 = Double.parseDouble(priceText);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Enter a valid price.");
            resp.sendRedirect(req.getContextPath() + "/user/add-skill");
            return;
        }

        if (pricePer10 <= 0 || pricePer10 > 9999) {
            req.getSession().setAttribute("error", "Price must be between 0.01 and 9999.");
            resp.sendRedirect(req.getContextPath() + "/user/add-skill");
            return;
        }

        SkillModel skill = new SkillModel();
        skill.setTeacherId(teacherId);
        skill.setCategoryId(categoryId);
        skill.setTitle(title);
        skill.setDescription(description);
        skill.setPrice_per_10min(pricePer10);
        skill.setActive(true);

        boolean inserted = skillDAO.insertSkill(skill);
        if (inserted) {
            clearFormFlash(req.getSession());
            req.getSession().setAttribute("success", "Skill published successfully.");
            resp.sendRedirect(req.getContextPath() + "/user/my-skills");
            return;
        }

        req.getSession().setAttribute("error", "Unable to publish skill right now.");
        resp.sendRedirect(req.getContextPath() + "/user/add-skill");
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
