package com.voyastra.servlet;

import com.voyastra.dao.HotelDAO;
import com.voyastra.model.HotelReview;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/add-hotel-review")
public class AddHotelReviewServlet extends HttpServlet {
    private HotelDAO hotelDAO = new HotelDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");
        int hotelId = Integer.parseInt(request.getParameter("hotelId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");

        HotelReview review = new HotelReview();
        review.setUserId(user.getId());
        review.setHotelId(hotelId);
        review.setRating(rating);
        review.setReviewText(reviewText);

        hotelDAO.addReview(review);

        response.sendRedirect(request.getContextPath() + "/hotel-details?id=" + hotelId);
    }
}
