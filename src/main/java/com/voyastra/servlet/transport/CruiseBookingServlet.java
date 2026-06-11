package com.voyastra.servlet.transport;

import com.voyastra.dao.CruiseDAO;
import com.voyastra.model.CruiseBooking;
import com.voyastra.model.CruisePassenger;
import com.voyastra.model.CruiseResult;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/transport/cruise/booking")
public class CruiseBookingServlet extends HttpServlet {
    private CruiseDAO cruiseDAO;

    @Override
    public void init() {
        cruiseDAO = new CruiseDAO();
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
        } else if ("passengers".equals(action)) {
            handlePassengers(request, response);
        } else if ("review".equals(action)) {
            handleReview(request, response);
        }
    }

    private void handleDetails(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        String cruiseId = request.getParameter("cruiseId");
        String cabinType = request.getParameter("cabinType");
        int paxCount = Integer.parseInt(request.getParameter("paxCount"));
        String departurePort = request.getParameter("departurePort");
        String destination = request.getParameter("destination");
        String cruiseDate = request.getParameter("cruiseDate");

        CruiseResult cruise = cruiseDAO.getCruiseById(cruiseId, cabinType);

        CruiseBooking draft = new CruiseBooking();
        draft.setId("CRZ-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setShipName(cruise.getShipName());
        draft.setCruiseLine(cruise.getCruiseLine());
        draft.setCabinType(cruise.getCabinType());
        draft.setDeparturePort(departurePort);
        draft.setDestination(destination);
        draft.setCruiseDate(cruiseDate);
        draft.setDurationDays(cruise.getDurationDays());
        draft.setPaxCount(paxCount);
        
        // Multiplier based on cabin class for mock realism
        double multiplier = 1.0;
        if ("Ocean View".equals(cabinType)) multiplier = 1.2;
        if ("Balcony".equals(cabinType)) multiplier = 1.5;
        if ("Suite".equals(cabinType)) multiplier = 2.5;

        draft.setAmount((cruise.getBaseFare() * multiplier) * paxCount);
        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentCruiseBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/cruise-passengers.jsp");
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CruiseBooking draft = (CruiseBooking) request.getSession().getAttribute("currentCruiseBooking");
        if (draft != null) {
            List<CruisePassenger> passengers = new ArrayList<>();
            for (int i = 0; i < draft.getPaxCount(); i++) {
                String name = request.getParameter("name_" + i);
                int age = Integer.parseInt(request.getParameter("age_" + i));
                String gender = request.getParameter("gender_" + i);
                String passport = request.getParameter("passport_" + i);

                CruisePassenger p = new CruisePassenger();
                p.setName(name);
                p.setAge(age);
                p.setGender(gender);
                p.setPassportNumber(passport);
                passengers.add(p);
            }
            draft.setPassengers(passengers);
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/cruise-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/transport/cruise-payment.jsp");
    }
}
