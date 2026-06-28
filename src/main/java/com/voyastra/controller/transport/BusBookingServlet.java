package com.voyastra.controller.transport;

import com.voyastra.dao.transport.BusDAO;
import com.voyastra.model.booking.BusBooking;
import com.voyastra.model.transport.BusPassenger;
import com.voyastra.model.transport.BusResult;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/transport/bus/booking")
public class BusBookingServlet extends HttpServlet {
    private BusDAO busDAO;

    @Override
    public void init() {
        busDAO = new BusDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?msg=Please%20login");
            return;
        }

        String action = request.getParameter("action");
        if ("details".equals(action)) {
            handleDetails(request, response, user);
        } else if ("seats".equals(action)) {
            handleSeats(request, response);
        } else if ("passengers".equals(action)) {
            handlePassengers(request, response);
        } else if ("save_passengers".equals(action)) {
            handleSavePassengers(request, response);
        } else if ("review".equals(action)) {
            handleReview(request, response);
        }
    }

    private void handleDetails(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        String busId = request.getParameter("busId");
        BusResult bus = busDAO.getBusById(busId);

        BusBooking draft = new BusBooking();
        draft.setId("BUS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setBusName(bus.getOperatorName() + " (" + bus.getBusType() + ")");
        draft.setFare(bus.getFare());
        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentBusBooking", draft);
        request.setAttribute("bus", bus);
        request.getRequestDispatcher("/pages/transport/bus-details.jsp").forward(request, response);
    }

    private void handleSeats(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/transport/bus-seats.jsp").forward(request, response);
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String selectedSeatsStr = request.getParameter("selectedSeats");
        BusBooking draft = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        
        if (draft != null && selectedSeatsStr != null && !selectedSeatsStr.isEmpty()) {
            draft.getPassengers().clear();
            String[] seats = selectedSeatsStr.split(",");
            for (String seat : seats) {
                BusPassenger p = new BusPassenger();
                p.setSeatPreference(seat.trim());
                draft.getPassengers().add(p);
            }
        }
        
        request.getRequestDispatcher("/pages/transport/bus-passengers.jsp").forward(request, response);
    }

    private void handleSavePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] names = request.getParameterValues("name[]");
        String[] ages = request.getParameterValues("age[]");
        String[] genders = request.getParameterValues("gender[]");

        BusBooking draft = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        if (draft != null && names != null) {
            for (int i = 0; i < names.length; i++) {
                if(i < draft.getPassengers().size()) {
                    BusPassenger p = draft.getPassengers().get(i);
                    p.setName(names[i]);
                    p.setAge(Integer.parseInt(ages[i]));
                    p.setGender(genders[i]);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/bus-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/transport/bus/payment");
    }
}
