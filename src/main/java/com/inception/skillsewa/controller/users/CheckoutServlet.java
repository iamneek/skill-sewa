package com.inception.skillsewa.controller.users;

import com.inception.skillsewa.dao.BookingDAO;
import com.inception.skillsewa.dao.PaymentDAO;
import com.inception.skillsewa.dao.SkillDAO;
import com.inception.skillsewa.dao.UserDAO;
import com.inception.skillsewa.model.BookingModel;
import com.inception.skillsewa.model.PaymentModel;
import com.inception.skillsewa.model.SkillModel;
import com.inception.skillsewa.model.UserModel;
import com.inception.skillsewa.utils.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/user/checkout")
public class CheckoutServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final SkillDAO skillDAO = new SkillDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            moveFlashMessage(session, req, "success");
            moveFlashMessage(session, req, "error");
        }
        String learnerId = session == null ? null : (String) session.getAttribute("userId");
        if (learnerId == null || learnerId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String bookingId = req.getParameter("bookingId");
        if (bookingId == null || bookingId.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Missing booking reference.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        BookingModel booking = bookingDAO.getBookingById(bookingId.trim());
        if (booking == null || !learnerId.equals(booking.getLearnerId())) {
            req.getSession().setAttribute("error", "Booking not found.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        if (!"accepted".equalsIgnoreCase(booking.getStatus())) {
            req.getSession().setAttribute("error", "Only accepted bookings can be paid.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        if (booking.isPaid()) {
            req.getSession().setAttribute("success", "This booking is already paid.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        SkillModel skill = skillDAO.getSkillById(booking.getSkillId());
        UserModel teacher = null;
        if (skill != null) {
            teacher = userDAO.getUserById(skill.getTeacherId());
        }

        req.setAttribute("booking", booking);
        req.setAttribute("skillTitle", skill == null ? "Skill" : skill.getTitle());
        req.setAttribute("teacherName", teacher == null ? "Teacher" : teacher.getFullName());
        req.setAttribute("pricePer10", skill == null ? 0.0 : skill.getPrice_per_10min());

        req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String learnerId = session == null ? null : (String) session.getAttribute("userId");
        if (learnerId == null || learnerId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String bookingId = req.getParameter("bookingId");
        String cardNumber = req.getParameter("cardNumber");
        String expiry = req.getParameter("expiry");
        String cvv = req.getParameter("cvv");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Missing booking reference.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        if (isBlank(cardNumber) || isBlank(expiry) || isBlank(cvv)) {
            req.getSession().setAttribute("error", "Please fill card details.");
            resp.sendRedirect(req.getContextPath() + "/user/checkout?bookingId=" + bookingId.trim());
            return;
        }

        if (!isValidCardNumber(cardNumber)) {
            req.getSession().setAttribute("error", "Card number must contain 13 to 19 digits.");
            resp.sendRedirect(req.getContextPath() + "/user/checkout?bookingId=" + bookingId.trim());
            return;
        }

        if (!isValidExpiry(expiry)) {
            req.getSession().setAttribute("error", "Expiry must be 4 digits in MMYY format.");
            resp.sendRedirect(req.getContextPath() + "/user/checkout?bookingId=" + bookingId.trim());
            return;
        }

        if (!isValidCvv(cvv)) {
            req.getSession().setAttribute("error", "CVV must be 3 or 4 digits.");
            resp.sendRedirect(req.getContextPath() + "/user/checkout?bookingId=" + bookingId.trim());
            return;
        }

        BookingModel booking = bookingDAO.getBookingById(bookingId.trim());
        if (booking == null || !learnerId.equals(booking.getLearnerId())) {
            req.getSession().setAttribute("error", "Booking not found.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        if (!"accepted".equalsIgnoreCase(booking.getStatus())) {
            req.getSession().setAttribute("error", "Only accepted bookings can be paid.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        if (booking.isPaid()) {
            req.getSession().setAttribute("success", "This booking is already paid.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        boolean bookingUpdated = bookingDAO.updateBookingPaidStatus(booking.getBookingId(), true);
        if (!bookingUpdated) {
            req.getSession().setAttribute("error", "Payment failed. Please try again.");
            resp.sendRedirect(req.getContextPath() + "/user/checkout?bookingId=" + booking.getBookingId());
            return;
        }

        PaymentModel payment = paymentDAO.getPaymentByBookingId(booking.getBookingId());
        boolean paymentSaved;
        if (payment == null) {
            PaymentModel newPayment = new PaymentModel();
            newPayment.setPaymentId(IDGenerator.generateID());
            newPayment.setBookingId(booking.getBookingId());
            newPayment.setLearnerId(learnerId);
            newPayment.setAmount(booking.getTotalPrice());
            newPayment.setStatus("completed");
            paymentSaved = paymentDAO.insertPayment(newPayment);
        } else {
            paymentSaved = paymentDAO.updatePaymentStatus(payment.getPaymentId(), "completed");
        }

        if (!paymentSaved) {
            req.getSession().setAttribute("error", "Payment saved partially. Please contact support.");
            resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
            return;
        }

        req.getSession().setAttribute("success", "Payment successful. Teacher contact unlocked.");
        resp.sendRedirect(req.getContextPath() + "/user/my-bookings?status=accepted");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isValidCardNumber(String value) {
        String digits = value == null ? "" : value.replaceAll("\\s+", "");
        return digits.matches("\\d{13,19}");
    }

    private boolean isValidExpiry(String value) {
        String digits = value == null ? "" : value.replaceAll("\\D", "");
        if (!digits.matches("\\d{4}")) {
            return false;
        }
        int month = Integer.parseInt(digits.substring(0, 2));
        return month >= 1 && month <= 12;
    }

    private boolean isValidCvv(String value) {
        String digits = value == null ? "" : value.replaceAll("\\D", "");
        return digits.matches("\\d{3,4}");
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest req, String key) {
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }
}
