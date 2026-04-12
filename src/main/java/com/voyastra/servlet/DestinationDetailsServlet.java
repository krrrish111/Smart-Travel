package com.voyastra.servlet;

import com.voyastra.dao.DestinationDAO;
import com.voyastra.dao.ReviewDAO;
import com.voyastra.model.Destination;
import com.voyastra.model.Review;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/destination")
public class DestinationDetailsServlet extends HttpServlet {

    private DestinationDAO destinationDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            
            // 1. Fetch Destination
            Destination dest = destinationDAO.getDestinationById(id);
            if (dest == null) {
                response.sendRedirect(request.getContextPath() + "/explore.jsp?error=notFound");
                return;
            }
            
            // 2. Fetch all reviews for this specific destination
            List<Review> reviews = reviewDAO.getReviewsByDestination(id);
            
            // 3. Set Attributes
            request.setAttribute("destination", dest);
            request.setAttribute("reviews", reviews);
            
            // 4. Forward to the dynamic jsp
            request.getRequestDispatcher("/destination.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/explore.jsp?error=serverError");
        }
    }
}
