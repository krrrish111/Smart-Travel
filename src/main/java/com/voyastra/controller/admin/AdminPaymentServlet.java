package com.voyastra.controller.admin;

import com.voyastra.dao.payment.PaymentDAO;
import com.voyastra.dao.payment.RefundDAO;
import com.voyastra.model.payment.Payment;
import com.voyastra.model.payment.Refund;
import com.voyastra.util.AdminLogger;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/payments-api")
public class AdminPaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private RefundDAO refundDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
        refundDAO = new RefundDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<Payment> payments = paymentDAO.getAllPayments();
        List<Refund> refunds = refundDAO.getAllRefunds();
        
        JsonObject result = new JsonObject();
        Gson gson = new Gson();
        result.add("payments", gson.toJsonTree(payments));
        result.add("refunds", gson.toJsonTree(refunds));

        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(result.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("updatePaymentStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                
                boolean updated = paymentDAO.updatePaymentStatus(id, status);
                if (updated) {
                    AdminLogger.log(request, "UPDATE", "Payment", id, "Updated payment status to " + status);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"success\"}");
                } else {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to update payment\"}");
                }
            } else if ("updateRefundStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                
                boolean updated = refundDAO.updateRefundStatus(id, status);
                if (updated) {
                    AdminLogger.log(request, "UPDATE", "Refund", id, "Updated refund status to " + status);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"success\"}");
                } else {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to update refund\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Unknown action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
