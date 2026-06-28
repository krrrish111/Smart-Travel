package com.voyastra.controller.booking;

import com.voyastra.dao.CouponDAO;
import com.voyastra.model.Coupon;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/apply-coupon")
public class ApplyCouponServlet extends HttpServlet {

    private CouponDAO couponDAO = new CouponDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (session == null || session.getAttribute("grandTotal") == null) {
            response.getWriter().write("{\"success\":false, \"message\":\"Session expired.\"}");
            return;
        }

        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false, \"message\":\"Invalid code.\"}");
            return;
        }

        Coupon coupon = couponDAO.getCouponByCode(code.toUpperCase());
        if (coupon == null) {
            response.getWriter().write("{\"success\":false, \"message\":\"Coupon invalid or expired.\"}");
            return;
        }

        // Original total before ANY discounts
        double originalTotal = (double) session.getAttribute("originalGrandTotal");
        if (originalTotal == 0) {
            originalTotal = (double) session.getAttribute("grandTotal");
            session.setAttribute("originalGrandTotal", originalTotal);
        }

        double discount = (originalTotal * coupon.getDiscountPercent()) / 100.0;
        if (discount > coupon.getMaxDiscount()) {
            discount = coupon.getMaxDiscount();
        }

        double newTotal = originalTotal - discount;
        
        // Update session
        session.setAttribute("grandTotal", newTotal);
        session.setAttribute("appliedCoupon", coupon.getCode());
        session.setAttribute("discountAmount", discount);

        String jsonResponse = String.format(
            "{\"success\":true, \"newTotal\":%.2f, \"discount\":%.2f, \"message\":\"Coupon applied successfully!\"}",
            newTotal, discount
        );
        response.getWriter().write(jsonResponse);
    }
}
