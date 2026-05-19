package com.inception.skillsewa.dao;

import com.inception.skillsewa.model.UserModel;
import com.inception.skillsewa.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;


public class UserDAO {

    public boolean userExistsByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean userExistsByPhone(String phone) {
        String sql = "SELECT * FROM users WHERE phone = ?";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public UserModel getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserModel user = new UserModel();
                user.setUserId(rs.getString("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setSessionContactInfo(rs.getString("session_contact_info"));
                user.setRole(rs.getString("role"));
                user.setSuspended(rs.getBoolean("is_suspended"));
                return user;
            }
            return null;
        } catch (SQLException e) {
            System.out.println("User with email " + email + " not found");
            return null;
        }
    }

    public UserModel getUserById(String userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserModel user = new UserModel();
                user.setUserId(rs.getString("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setSessionContactInfo(rs.getString("session_contact_info"));
                user.setRole(rs.getString("role"));
                user.setSuspended(rs.getBoolean("is_suspended"));
                return user;
            }
            return null;
        } catch (SQLException e) {
            System.out.println("User with id " + userId + " not found");
            return null;
        }
    }

    public boolean insertUser(UserModel user) {
        String sql = "INSERT INTO users (user_id, full_name, email, password, phone, session_contact_info, role, is_suspended) \n" +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setString(1, user.getUserId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getSessionContactInfo());
            ps.setString(7, user.getRole());
            ps.setBoolean(8, user.isSuspended());

            return ps.executeUpdate() > 0;
        }
        catch (SQLException e) {
            System.out.println("Failed to create user.");
            return false;
        }
    }

    public ArrayList<UserModel> getAllUsers() {
        ArrayList<UserModel> allUsers = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try(Connection conn = DBConnection.getConnection();
            Statement st = conn.createStatement();){
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                UserModel user = new UserModel();
                user.setUserId(rs.getString("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setPassword(rs.getString("password"));
                user.setSuspended(rs.getBoolean("is_suspended"));
                user.setSessionContactInfo(rs.getString("session_contact_info"));
                allUsers.add(user);
            }
            return allUsers;
        } catch (SQLException e) {
            System.out.println("Failed to get all users.");
            return allUsers;
        }
    }

    public int getTotalUsersCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get total users count.");
            return 0;
        }
    }

    public ArrayList<UserModel> getRecentUsers(int limit) {
        ArrayList<UserModel> recentUsers = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserModel user = new UserModel();
                user.setUserId(rs.getString("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setPassword(rs.getString("password"));
                user.setSuspended(rs.getBoolean("is_suspended"));
                user.setSessionContactInfo(rs.getString("session_contact_info"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                recentUsers.add(user);
            }
            return recentUsers;
        } catch (SQLException e) {
            System.out.println("Failed to get recent users.");
            return recentUsers;
        }
    }

    public boolean updateUserSuspendedStatus(String userId, boolean suspended) {
        String sql = "UPDATE users SET is_suspended = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, suspended);
            ps.setString(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update user suspended status.");
            return false;
        }
    }

    public boolean deleteUserById(String userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to delete user.");
            return false;
        }
    }

    public boolean phoneExistsForOtherUser(String phone, String userId) {
        String sql = "SELECT 1 FROM users WHERE phone = ? AND user_id <> ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("Failed to check phone uniqueness.");
            return false;
        }
    }

    public boolean updateUserProfile(String userId, String fullName, String phone, String sessionContactInfo) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, session_contact_info = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, sessionContactInfo);
            ps.setString(4, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update user profile.");
            return false;
        }
    }

    public boolean updateUserPassword(String userId, String passwordHash) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setString(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update user password.");
            return false;
        }
    }


}
