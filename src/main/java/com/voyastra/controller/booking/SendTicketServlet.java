package com.voyastra.controller.booking;

import com.voyastra.util.EmailService;
import java.util.logging.Logger;
import java.util.logging.Level;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/api/send-ticket")
@MultipartConfig
public class SendTicketServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(SendTicketServlet.class.getName());


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String userEmail = (String) session.getAttribute("email");
        if (userEmail == null || userEmail.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String bookingCode = (String) session.getAttribute("confirmedBookingCode");
        String filename = "Voyastra-Ticket-" + (bookingCode != null ? bookingCode : "Booking") + ".pdf";

        try {
            Part filePart = request.getPart("ticketPdf");
            if (filePart != null) {
                try (InputStream fileContent = filePart.getInputStream()) {
                    EmailService.sendTicketEmail(userEmail, fileContent, filename);
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"status\":\"success\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\", \"message\":\"No file part found\"}");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
