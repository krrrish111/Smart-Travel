package com.voyastra.servlet;

import com.voyastra.dao.HotelDAO;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/toggle-wishlist")
public class HotelWishlistServlet extends HttpServlet {
    private HotelDAO hotelDAO = new HotelDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));

        hotelDAO.toggleWishlist(user.getId(), hotelId);
        boolean isWishlisted = hotelDAO.isWishlisted(user.getId(), hotelId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"status\":\"success\", \"isWishlisted\": " + isWishlisted + "}");
    }
}
