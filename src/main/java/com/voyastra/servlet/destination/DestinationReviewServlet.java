package com.voyastra.servlet.destination;

import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Destination;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/destination/review")
public class DestinationReviewServlet extends HttpServlet {
    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/explore.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String destinationIdStr = request.getParameter("destination_id");
            if (destinationIdStr != null) {
                int destId = Integer.parseInt(destinationIdStr);
                Destination dest = destinationDAO.getDestinationById(destId);
                request.setAttribute("destination", dest);
            }

            // From booking.jsp to review.jsp
            request.setAttribute("travel_date", request.getParameter("travel_date"));
            request.setAttribute("travellers", request.getParameter("travellers"));
            request.setAttribute("hotel_category", request.getParameter("hotel_category"));
            request.setAttribute("final_price", request.getParameter("final_price"));
            request.setAttribute("activities", request.getParameter("activities"));
            
            // Passenger details
            request.setAttribute("primary_name", request.getParameter("primary_name"));
            request.setAttribute("primary_email", request.getParameter("primary_email"));
            request.setAttribute("primary_phone", request.getParameter("primary_phone"));
            
            request.getRequestDispatcher("/pages/destination-review.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/explore.jsp?error=invalidRequest");
        }
    }
}
