package com.inception.skillsewa.dao;

import com.inception.skillsewa.model.SkillModel;
import com.inception.skillsewa.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;

public class SkillDAO {

    public SkillModel getSkillById(int skillId) {
        String sql = "SELECT * FROM skills WHERE skill_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, skillId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SkillModel skill = mapSkill(rs);
                return skill;
            }
            return null;
        } catch (SQLException e) {
            System.out.println("Skill with id " + skillId + " not found");
            return null;
        }
    }

    public boolean insertSkill(SkillModel skill) {
        String sql = "INSERT INTO skills (teacher_id, category_id, title, description, price_per_10min, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, skill.getTeacherId());
            ps.setInt(2, skill.getCategoryId());
            ps.setString(3, skill.getTitle());
            ps.setString(4, skill.getDescription());
            ps.setDouble(5, skill.getPrice_per_10min());
            ps.setBoolean(6, skill.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to insert skill.");
            return false;
        }
    }

    public boolean deleteSkillById(int skillId) {
        String sql = "DELETE FROM skills WHERE skill_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, skillId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to delete skill.");
            return false;
        }
    }

    public boolean updateSkillActiveStatus(int skillId, boolean isActive) {
        String sql = "UPDATE skills SET is_active = ? WHERE skill_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, skillId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update skill status.");
            return false;
        }
    }

    public boolean updateSkill(SkillModel skill) {
        String sql = "UPDATE skills SET category_id = ?, title = ?, description = ?, price_per_10min = ? WHERE skill_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, skill.getCategoryId());
            ps.setString(2, skill.getTitle());
            ps.setString(3, skill.getDescription());
            ps.setDouble(4, skill.getPrice_per_10min());
            ps.setInt(5, skill.getSkillId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update skill.");
            return false;
        }
    }

    public ArrayList<SkillModel> getAllSkills() {
        ArrayList<SkillModel> allSkills = new ArrayList<>();
        String sql = "SELECT * FROM skills ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                SkillModel skill = mapSkill(rs);
                allSkills.add(skill);
            }
            return allSkills;
        } catch (SQLException e) {
            System.out.println("Failed to get all skills.");
            return allSkills;
        }
    }

    public ArrayList<SkillModel> getSkillsByCategoryId(int categoryId) {
        ArrayList<SkillModel> skills = new ArrayList<>();
        String sql = "SELECT * FROM skills WHERE category_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SkillModel skill = mapSkill(rs);
                skills.add(skill);
            }
            return skills;
        } catch (SQLException e) {
            System.out.println("Failed to get skills by category id.");
            return skills;
        }
    }

    public int getTotalSkillsCount() {
        String sql = "SELECT COUNT(*) FROM skills";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get total skills count.");
            return 0;
        }
    }

    public ArrayList<SkillModel> getSkillsByTeacherId(String teacherId) {
        ArrayList<SkillModel> skills = new ArrayList<>();
        String sql = "SELECT * FROM skills WHERE teacher_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                skills.add(mapSkill(rs));
            }
            return skills;
        } catch (SQLException e) {
            System.out.println("Failed to get skills by teacher id.");
            return skills;
        }
    }

    public int getSkillsCountByTeacher(String teacherId) {
        String sql = "SELECT COUNT(*) FROM skills WHERE teacher_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get skills count by teacher.");
            return 0;
        }
    }

    private SkillModel mapSkill(ResultSet rs) throws SQLException {
        SkillModel skill = new SkillModel();
        skill.setSkillId(rs.getInt("skill_id"));
        skill.setTeacherId(rs.getString("teacher_id"));
        skill.setCategoryId(rs.getInt("category_id"));
        skill.setTitle(rs.getString("title"));
        skill.setDescription(rs.getString("description"));
        skill.setPrice_per_10min(rs.getDouble("price_per_10min"));
        skill.setActive(rs.getBoolean("is_active"));
        skill.setCreatedAt(rs.getTimestamp("created_at"));
        return skill;
    }
}
