package com.inception.skillsewa.dao;

import com.inception.skillsewa.model.BookingModel;
import com.inception.skillsewa.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;

public class BookingDAO {

    public BookingModel getBookingById(String bookingId) {
        String sql = "SELECT * FROM bookings WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BookingModel booking = mapBooking(rs);
                return booking;
            }
            return null;
        } catch (SQLException e) {
            System.out.println("Booking with id " + bookingId + " not found");
            return null;
        }
    }

    public boolean insertBooking(BookingModel booking) {
        String sql = "INSERT INTO bookings (booking_id, skill_id, learner_id, duration_minutes, total_price, message, " +
                "status, rejection_note, acceptance_note, is_paid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, booking.getBookingId());
            ps.setInt(2, booking.getSkillId());
            ps.setString(3, booking.getLearnerId());
            ps.setInt(4, booking.getDurationMinutes());
            ps.setDouble(5, booking.getTotalPrice());
            ps.setString(6, booking.getMessage());
            ps.setString(7, booking.getStatus());
            ps.setString(8, booking.getRejectionNote());
            ps.setString(9, booking.getAcceptanceNote());
            ps.setBoolean(10, booking.isPaid());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to insert booking.");
            return false;
        }
    }

    public boolean updateBookingStatus(String bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update booking status.");
            return false;
        }
    }

    public boolean updateBookingDecision(String bookingId, String status, String acceptanceNote, String rejectionNote) {
        String sql = "UPDATE bookings SET status = ?, acceptance_note = ?, rejection_note = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, acceptanceNote);
            ps.setString(3, rejectionNote);
            ps.setString(4, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update booking decision.");
            return false;
        }
    }

    public boolean updateBookingPaidStatus(String bookingId, boolean paid) {
        String sql = "UPDATE bookings SET is_paid = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, paid);
            ps.setString(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update booking payment status.");
            return false;
        }
    }

    public ArrayList<BookingModel> getAllBookings() {
        ArrayList<BookingModel> allBookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                BookingModel booking = mapBooking(rs);
                allBookings.add(booking);
            }
            return allBookings;
        } catch (SQLException e) {
            System.out.println("Failed to get all bookings.");
            return allBookings;
        }
    }

    public ArrayList<BookingModel> getBookingsByStatus(String status) {
        ArrayList<BookingModel> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE status = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingModel booking = mapBooking(rs);
                bookings.add(booking);
            }
            return bookings;
        } catch (SQLException e) {
            System.out.println("Failed to get bookings by status.");
            return bookings;
        }
    }

    public int getBookingsCountByLearnerAndStatus(String learnerId, String status) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE learner_id = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, learnerId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get bookings count by learner and status.");
            return 0;
        }
    }

    public ArrayList<BookingModel> getBookingsByLearnerAndStatus(String learnerId, String status) {
        ArrayList<BookingModel> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE learner_id = ? AND status = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, learnerId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapBooking(rs));
            }
            return bookings;
        } catch (SQLException e) {
            System.out.println("Failed to get bookings by learner and status.");
            return bookings;
        }
    }

    public int getTotalBookingsCount() {
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get total bookings count.");
            return 0;
        }
    }

    public int getPendingBookingsCount() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = 'pending'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get pending bookings count.");
            return 0;
        }
    }

    public int getBookingsCountByLearner(String learnerId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE learner_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, learnerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get bookings count by learner.");
            return 0;
        }
    }

    public int getCompletedSessionsCountByLearner(String learnerId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE learner_id = ? AND status = 'completed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, learnerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get completed sessions count by learner.");
            return 0;
        }
    }

    public ArrayList<BookingModel> getRecentBookingsByLearner(String learnerId, int limit) {
        ArrayList<BookingModel> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE learner_id = ? ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, learnerId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapBooking(rs));
            }
            return bookings;
        } catch (SQLException e) {
            System.out.println("Failed to get recent bookings by learner.");
            return bookings;
        }
    }

    public ArrayList<BookingModel> getRecentRequestsForTeacher(String teacherId, int limit) {
        ArrayList<BookingModel> bookings = new ArrayList<>();
        String sql = "SELECT b.* FROM bookings b " +
                "JOIN skills s ON b.skill_id = s.skill_id " +
                "WHERE s.teacher_id = ? ORDER BY b.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapBooking(rs));
            }
            return bookings;
        } catch (SQLException e) {
            System.out.println("Failed to get recent requests for teacher.");
            return bookings;
        }
    }

    public int getTeacherRequestCountByStatus(String teacherId, String status) {
        String sql = "SELECT COUNT(*) FROM bookings b " +
                "JOIN skills s ON b.skill_id = s.skill_id " +
                "WHERE s.teacher_id = ? AND b.status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Failed to get teacher request count by status.");
            return 0;
        }
    }

    public ArrayList<BookingModel> getTeacherRequestsByStatus(String teacherId, String status, Integer skillId) {
        ArrayList<BookingModel> bookings = new ArrayList<>();
        String sql = "SELECT b.* FROM bookings b " +
                "JOIN skills s ON b.skill_id = s.skill_id " +
                "WHERE s.teacher_id = ? AND b.status = ?" +
                (skillId == null ? "" : " AND b.skill_id = ?") +
                " ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            ps.setString(2, status);
            if (skillId != null) {
                ps.setInt(3, skillId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookings.add(mapBooking(rs));
            }
            return bookings;
        } catch (SQLException e) {
            System.out.println("Failed to get teacher requests by status.");
            return bookings;
        }
    }

    public boolean bookingBelongsToTeacher(String bookingId, String teacherId) {
        String sql = "SELECT 1 FROM bookings b " +
                "JOIN skills s ON b.skill_id = s.skill_id " +
                "WHERE b.booking_id = ? AND s.teacher_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            ps.setString(2, teacherId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("Failed to validate booking teacher ownership.");
            return false;
        }
    }

    public ArrayList<BookingModel> getRecentBookings(int limit) {
        ArrayList<BookingModel> recentBookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingModel booking = mapBooking(rs);
                recentBookings.add(booking);
            }
            return recentBookings;
        } catch (SQLException e) {
            System.out.println("Failed to get recent bookings.");
            return recentBookings;
        }
    }

    private BookingModel mapBooking(ResultSet rs) throws SQLException {
        BookingModel booking = new BookingModel();
        booking.setBookingId(rs.getString("booking_id"));
        booking.setSkillId(rs.getInt("skill_id"));
        booking.setLearnerId(rs.getString("learner_id"));
        booking.setDurationMinutes(rs.getInt("duration_minutes"));
        booking.setTotalPrice(rs.getDouble("total_price"));
        booking.setMessage(rs.getString("message"));
        booking.setStatus(rs.getString("status"));
        booking.setRejectionNote(rs.getString("rejection_note"));
        booking.setAcceptanceNote(rs.getString("acceptance_note"));
        booking.setPaid(rs.getBoolean("is_paid"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        return booking;
    }
}
