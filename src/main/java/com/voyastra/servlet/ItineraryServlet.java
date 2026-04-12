package com.voyastra.servlet;

import com.voyastra.dao.ItineraryDAO;
import com.voyastra.model.Itinerary;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet for managing user-saved AI itineraries.
 */
@WebServlet("/itinerary")
public class ItineraryServlet extends HttpServlet {

    private ItineraryDAO itineraryDAO;

    @Override
    public void init() {
        itineraryDAO = new ItineraryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("delete".equals(action) && idStr != null) {
            itineraryDAO.delete(Integer.parseInt(idStr));
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }

        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Itinerary itinerary = itineraryDAO.getById(id);

                if (itinerary != null && itinerary.getUserId() == (Integer) session.getAttribute("user_id")) {
                    request.setAttribute("itinerary", itinerary);
                    request.getRequestDispatcher("/view-itinerary.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Itinerary not found or access denied.");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format.");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\": \"error\", \"message\": \"Please login to save the itinerary\"}");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("user_id");
            String title = request.getParameter("title");
            String destination = request.getParameter("destination");
            String itineraryData = request.getParameter("itineraryData");

            if (title == null || itineraryData == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\": \"error\", \"message\": \"Missing required fields\"}");
                return;
            }

            Itinerary it = new Itinerary();
            it.setUserId(userId);
            it.setTitle(title);
            it.setDestination(destination != null ? destination : "Your Smart Trip");
            it.setItineraryData(itineraryData);

            boolean success = itineraryDAO.save(it);

            if (success) {
                out.print("{\"status\": \"success\", \"message\": \"Itinerary saved successfully!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"status\": \"error\", \"message\": \"Database error while saving.\"}");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\": \"error\", \"message\": \"An internal error occurred.\"}");
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }
}
