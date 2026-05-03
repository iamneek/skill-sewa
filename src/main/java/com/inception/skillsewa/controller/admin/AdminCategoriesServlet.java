package com.inception.skillsewa.controller.admin;

import com.inception.skillsewa.dao.CategoryDAO;
import com.inception.skillsewa.model.CategoryModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/categories")
public class AdminCategoriesServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ArrayList<CategoryModel> categories = categoryDAO.getAllCategories();
        req.setAttribute("categories", categories);

        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
            moveFlashMessage(session, req, "addCategoryName");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/manage-categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            handleAddCategory(req, resp);
            return;
        }

        if ("delete".equals(action)) {
            handleDeleteCategory(req, resp);
            return;
        }

        req.getSession().setAttribute("error", "Invalid category action.");
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void handleAddCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String categoryName = req.getParameter("categoryName");
        String cleanedName = categoryName == null ? "" : categoryName.trim();

        if (cleanedName.isEmpty()) {
            req.getSession().setAttribute("error", "Category name is required.");
            req.getSession().setAttribute("addCategoryName", cleanedName);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
            return;
        }

        if (cleanedName.length() > 100) {
            req.getSession().setAttribute("error", "Category name must be 100 characters or fewer.");
            req.getSession().setAttribute("addCategoryName", cleanedName);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
            return;
        }

        if (categoryDAO.categoryExistsByName(cleanedName)) {
            req.getSession().setAttribute("error", "Category already exists.");
            req.getSession().setAttribute("addCategoryName", cleanedName);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
            return;
        }

        CategoryModel category = new CategoryModel();
        category.setName(cleanedName);
        boolean added = categoryDAO.insertCategory(category);

        if (added) {
            req.getSession().setAttribute("success", "Category added successfully.");
        } else {
            req.getSession().setAttribute("error", "Unable to add category.");
            req.getSession().setAttribute("addCategoryName", cleanedName);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void handleDeleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String categoryIdText = req.getParameter("categoryId");

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdText);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid category id.");
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
            return;
        }

        boolean deleted = categoryDAO.deleteCategoryById(categoryId);
        if (deleted) {
            req.getSession().setAttribute("success", "Category deleted successfully.");
        } else {
            req.getSession().setAttribute("error", "Unable to delete category. It may be in use.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
