package com.voyastra.servlet.transport;

import com.voyastra.dao.TrainBookingDAO;
import com.voyastra.model.TrainBooking;
import com.voyastra.model.TrainPassenger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/transport/train/booking")
public class TrainBookingServlet extends HttpServlet {
    private TrainBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new TrainBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "details"; // Default step
        }

        switch (action) {
            case "details":
                showDetails(request, response);
                break;
            case "passengers":
                showPassengersForm(request, response);
                break;
            case "review":
                processPassengersAndShowReview(request, response);
                break;
            case "save":
                saveDraftAndRedirect(request, response);
                break;
            default:
                showDetails(request, response);
                break;
        }
    }

    private void showDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainNo = request.getParameter("trainNo");
        String fare = request.getParameter("fare");
        request.setAttribute("trainNo", trainNo);
        request.setAttribute("fare", fare);
        request.getRequestDispatcher("/pages/transport/train-details.jsp").forward(request, response);
    }

    private void showPassengersForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainNo = request.getParameter("trainNo");
        String fare = request.getParameter("fare");
        request.setAttribute("trainNo", trainNo);
        request.setAttribute("fare", fare);
        request.getRequestDispatcher("/pages/transport/train-passengers.jsp").forward(request, response);
    }

    private void processPassengersAndShowReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainNo = request.getParameter("trainNo");
        String fareStr = request.getParameter("fare");
        double fare = Double.parseDouble(fareStr != null ? fareStr : "0");

        String[] names = request.getParameterValues("passengerName");
        String[] ages = request.getParameterValues("passengerAge");
        String[] genders = request.getParameterValues("passengerGender");
        String[] berths = request.getParameterValues("passengerBerth");

        TrainBooking draft = new TrainBooking();
        draft.setId("TRN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setTrainNumber(trainNo);
        draft.setFare(fare);
        draft.setStatus("DRAFT");
        // Using a mock user id for now since auth might not be fully linked in this context
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        draft.setUserId(userId != null ? userId : 1);

        if (names != null) {
            for (int i = 0; i < names.length; i++) {
                TrainPassenger p = new TrainPassenger(
                    names[i], 
                    Integer.parseInt(ages[i]), 
                    genders[i], 
                    berths[i]
                );
                draft.addPassenger(p);
            }
        }

        // Save Draft to DB - REMOVED for Phase 5. Only save upon successful payment.
        // bookingDAO.saveDraft(draft);

        // Store in session for review page
        request.getSession().setAttribute("currentTrainBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/train-review.jsp");
    }

    private void saveDraftAndRedirect(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Proceed to payment integration
        response.sendRedirect(request.getContextPath() + "/pages/transport/train-payment.jsp");
    }
}
