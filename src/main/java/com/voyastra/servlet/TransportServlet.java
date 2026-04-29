package com.voyastra.servlet;

import com.voyastra.dao.TransportDAO;
import com.voyastra.model.Transport;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.google.gson.Gson;

@WebServlet("/transport")
public class TransportServlet extends HttpServlet {

    private TransportDAO transportDAO;

    @Override
    public void init() throws ServletException {
        transportDAO = new TransportDAO();
    }

    /**
     * Endpoint to fetch and display transportation options based on search route.
     * Expects: origin (String code) and destination (String code)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");

        try {
            List<Transport> results;
            
            if (origin != null && !origin.trim().isEmpty() && destination != null && !destination.trim().isEmpty()) {
                // Return explicitly filtered transport matching the user's route
                results = transportDAO.getTransportByRoute(origin.trim(), destination.trim());
                
                // Keep context so the UI reflects what they searched for
                request.setAttribute("searchOrigin", origin.toUpperCase());
                request.setAttribute("searchDestination", destination.toUpperCase());
            } else {
                // If they visited /transport blindly, pull the full catalog as default
                results = transportDAO.getAllTransportOptions();
            }

            if ("json".equals(request.getParameter("format"))) {
                response.setContentType("application/json;charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                new Gson().toJson(results, response.getWriter());
            } else {
                // Bind the results wrapper to the JSP and dispatch
                request.setAttribute("transports", results);
                request.getRequestDispatcher("/pages/booking.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/booking.jsp?error=transportFetchFailed");
        }
    }

    /**
     * Secure administrative route designed to easily pipe new transport options into the system.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/index.jsp";

        // Filter: Admin Verification Only
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            if ("add".equals(action)) {
                Transport t = new Transport();
                t.setType(request.getParameter("type"));
                t.setCompanyLogo(request.getParameter("company_logo"));
                t.setCompanyName(request.getParameter("company_name"));
                t.setTransportNumber(request.getParameter("transport_number"));
                t.setDepartureTime(request.getParameter("departure_time"));
                t.setOriginCode(request.getParameter("origin_code"));
                t.setDuration(request.getParameter("duration"));
                t.setArrivalTime(request.getParameter("arrival_time"));
                t.setDestinationCode(request.getParameter("destination_code"));
                t.setPrice(Double.parseDouble(request.getParameter("price")));
                t.setBadge(request.getParameter("badge")); // Optional e.g. "Cheapest"

                transportDAO.addTransport(t);
                AdminLogger.log(request, "ADD", "Transport", 0, "Added " + t.getType() + " '" + t.getCompanyName() + "' (" + t.getOriginCode() + " â†’ " + t.getDestinationCode() + ")");
                response.sendRedirect(redirectUrl + "?transportAdded=true");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                transportDAO.deleteTransport(id);
                AdminLogger.log(request, "DELETE", "Transport", id, "Deleted transport #" + id);
                response.sendRedirect(redirectUrl + "?transportDeleted=true");
            } else {
                response.sendRedirect(redirectUrl);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectUrl + "?error=invalidTransportEntry");
        }
    }
}

