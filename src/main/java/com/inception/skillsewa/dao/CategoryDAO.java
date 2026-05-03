package com.inception.skillsewa.dao;

import com.inception.skillsewa.model.CategoryModel;
import com.inception.skillsewa.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;

public class CategoryDAO {

    public boolean categoryExistsByName(String name) {
        String sql = "SELECT * FROM categories WHERE name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public CategoryModel getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CategoryModel category = new CategoryModel();
                category.setCategory(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                return category;
            }
            return null;
        } catch (SQLException e) {
            System.out.println("Category with id " + categoryId + " not found");
            return null;
        }
    }

    public boolean insertCategory(CategoryModel category) {
        String sql = "INSERT INTO categories (name) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to insert category.");
            return false;
        }
    }

    public boolean deleteCategoryById(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to delete category.");
            return false;
        }
    }

    public ArrayList<CategoryModel> getAllCategories() {
        ArrayList<CategoryModel> allCategories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                CategoryModel category = new CategoryModel();
                category.setCategory(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                category.setCreatedAt(rs.getTimestamp("created_at"));
                allCategories.add(category);
            }
            return allCategories;
        } catch (SQLException e) {
            System.out.println("Failed to get all categories.");
            return allCategories;
        }
    }
}
