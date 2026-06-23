package com.voyastra.servlet.trip;

import com.voyastra.dao.TripBookingDAO;
import com.voyastra.model.User;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/trip/set-active")
public class SetActiveTripServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject json = new JsonObject();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            json.addProperty("success", false);
            json.addProperty("message", "Unauthorized");
            response.getWriter().write(json.toString());
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            User user = (User) session.getAttribute("user");
            
            TripBookingDAO dao = new TripBookingDAO();
            boolean success = dao.setActiveTrip(user.getId(), bookingId);
            
            json.addProperty("success", success);
            if (success) {
                json.addProperty("message", "Active trip updated.");
            } else {
                json.addProperty("message", "Failed to update active trip.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Invalid request parameters.");
        }
        
        response.getWriter().write(json.toString());
    }
}
