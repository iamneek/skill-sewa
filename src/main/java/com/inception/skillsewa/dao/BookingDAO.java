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
