package com.voyastra.controller.planner;

import com.voyastra.dao.planner.TripDAO;
import com.voyastra.model.planner.PremiumTrip;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/trip/customize")
public class CustomizeTripServlet extends HttpServlet {
    private TripDAO tripDAO;

    @Override
    public void init() throws ServletException {
        tripDAO = new TripDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Ensure authentication guard
        if (session == null || session.getAttribute("user_id") == null) {
            String q = request.getQueryString();
            String redirectUrl = "/trip/customize" + (q != null ? "?" + q : "");
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(redirectUrl, "UTF-8"));
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            PremiumTrip trip = tripDAO.getTripById(id);
            if (trip == null) {
                response.sendRedirect(request.getContextPath() + "/explore.jsp");
                return;
            }

            request.setAttribute("trip", trip);
            request.getRequestDispatcher("/pages/payment/trip-checkout.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
        }
    }
}
