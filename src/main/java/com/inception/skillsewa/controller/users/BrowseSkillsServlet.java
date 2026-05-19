package com.inception.skillsewa.controller.users;

import com.inception.skillsewa.dao.CategoryDAO;
import com.inception.skillsewa.dao.SkillDAO;
import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.CategoryModel;
import com.inception.skillsewa.model.SkillModel;
import com.inception.skillsewa.model.UserModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet("/user/browse-skills")
public class BrowseSkillsServlet extends HttpServlet {
    private final SkillDAO skillDAO = new SkillDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String category = req.getParameter("category");
        String query = req.getParameter("q");
        Integer selectedCategoryId = null;

        ArrayList<CategoryModel> categories = categoryDAO.getAllCategories();
        Map<Integer, String> categoryNames = new HashMap<>();
        for (CategoryModel c : categories) {
            categoryNames.put(c.getCategory(), c.getName());
        }

        ArrayList<SkillModel> baseSkills;
        if (category == null || category.trim().isEmpty() || "all".equalsIgnoreCase(category.trim())) {
            baseSkills = skillDAO.getAllSkills();
        } else {
            try {
                selectedCategoryId = Integer.parseInt(category.trim());
            } catch (NumberFormatException e) {
                selectedCategoryId = null;
            }

            if (selectedCategoryId == null) {
                baseSkills = skillDAO.getAllSkills();
            } else {
                baseSkills = skillDAO.getSkillsByCategoryId(selectedCategoryId);
            }
        }

        ArrayList<SkillModel> filteredSkills = new ArrayList<>();
        String normalizedQuery = query == null ? "" : query.trim().toLowerCase(Locale.ENGLISH);
        for (SkillModel skill : baseSkills) {
            if (!skill.isActive()) {
                continue;
            }

            if (normalizedQuery.isEmpty()) {
                filteredSkills.add(skill);
                continue;
            }

            String title = skill.getTitle() == null ? "" : skill.getTitle().toLowerCase(Locale.ENGLISH);
            String description = skill.getDescription() == null ? "" : skill.getDescription().toLowerCase(Locale.ENGLISH);
            if (title.contains(normalizedQuery) || description.contains(normalizedQuery)) {
                filteredSkills.add(skill);
            }
        }

        Map<String, String> teacherNames = new HashMap<>();
        for (SkillModel skill : filteredSkills) {
            String teacherId = skill.getTeacherId();
            if (teacherId == null || teacherId.trim().isEmpty() || teacherNames.containsKey(teacherId)) {
                continue;
            }

            UserModel teacher = userDAO.getUserById(teacherId);
            if (teacher != null && teacher.getFullName() != null && !teacher.getFullName().trim().isEmpty()) {
                teacherNames.put(teacherId, teacher.getFullName());
            }
        }

        req.setAttribute("skills", filteredSkills);
        req.setAttribute("categories", categories);
        req.setAttribute("categoryNames", categoryNames);
        req.setAttribute("teacherNames", teacherNames);
        req.setAttribute("selectedCategoryId", selectedCategoryId);

        req.getRequestDispatcher("/WEB-INF/views/browse-skills.jsp").forward(req, resp);
    }
}
