package com.inception.skillsewa.dao;

import com.inception.skillsewa.model.PaymentModel;
import com.inception.skillsewa.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;

public class PaymentDAO {

    public PaymentModel getPaymentByBookingId(String bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PaymentModel payment = mapPayment(rs);
                return payment;
            }
            return null;
        } catch (SQLException e) {
            System.out.println("Payment for booking " + bookingId + " not found");
            return null;
        }
    }

    public boolean insertPayment(PaymentModel payment) {
        String sql = "INSERT INTO payments (payment_id, booking_id, learner_id, amount, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, payment.getPaymentId());
            ps.setString(2, payment.getBookingId());
            ps.setString(3, payment.getLearnerId());
            ps.setDouble(4, payment.getAmount());
            ps.setString(5, payment.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to insert payment.");
            return false;
        }
    }

    public boolean updatePaymentStatus(String paymentId, String status) {
        String sql = "UPDATE payments SET status = ? WHERE payment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, paymentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to update payment status.");
            return false;
        }
    }

    public ArrayList<PaymentModel> getAllPayments() {
        ArrayList<PaymentModel> allPayments = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                PaymentModel payment = mapPayment(rs);
                allPayments.add(payment);
            }
            return allPayments;
        } catch (SQLException e) {
            System.out.println("Failed to get all payments.");
            return allPayments;
        }
    }

    private PaymentModel mapPayment(ResultSet rs) throws SQLException {
        PaymentModel payment = new PaymentModel();
        payment.setPaymentId(rs.getString("payment_id"));
        payment.setBookingId(rs.getString("booking_id"));
        payment.setLearnerId(rs.getString("learner_id"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setStatus(rs.getString("status"));
        payment.setCreatedAt(rs.getTimestamp("created_at"));
        return payment;
    }
}
