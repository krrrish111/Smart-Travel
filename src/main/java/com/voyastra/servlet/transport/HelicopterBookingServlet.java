package com.voyastra.servlet.transport;

import com.voyastra.dao.HelicopterDAO;
import com.voyastra.model.HelicopterBooking;
import com.voyastra.model.HelicopterPassenger;
import com.voyastra.model.HelicopterResult;
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

@WebServlet("/transport/helicopter/booking")
public class HelicopterBookingServlet extends HttpServlet {
    private HelicopterDAO heliDAO;

    @Override
    public void init() {
        heliDAO = new HelicopterDAO();
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
        String heliId = request.getParameter("heliId");
        int paxCount = Integer.parseInt(request.getParameter("paxCount"));
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        
        HelicopterResult flight = heliDAO.getFlightById(heliId);

        HelicopterBooking draft = new HelicopterBooking();
        draft.setId("HEL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setOperator(flight.getOperator());
        draft.setFlightType(flight.getType());
        draft.setOrigin(origin);
        draft.setDestination(destination);
        draft.setTravelDate(travelDate);
        draft.setTravelTime(flight.getEta());
        draft.setPaxCount(paxCount);

        // Crucial logic: Shared is per pax, Private is flat rate
        if ("Shared".equalsIgnoreCase(flight.getType())) {
            draft.setAmount(flight.getBaseFare() * paxCount);
        } else {
            draft.setAmount(flight.getBaseFare());
        }

        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentHeliBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/helicopter-passengers.jsp");
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HelicopterBooking draft = (HelicopterBooking) request.getSession().getAttribute("currentHeliBooking");
        if (draft != null) {
            List<HelicopterPassenger> passengers = new ArrayList<>();
            for (int i = 0; i < draft.getPaxCount(); i++) {
                String name = request.getParameter("name_" + i);
                double weight = Double.parseDouble(request.getParameter("weight_" + i));

                HelicopterPassenger p = new HelicopterPassenger();
                p.setName(name);
                p.setWeightKg(weight);
                passengers.add(p);
            }
            draft.setPassengers(passengers);
            
            // If private charter, also capture the preferred time
            if ("Private".equalsIgnoreCase(draft.getFlightType())) {
                String prefTime = request.getParameter("prefTime");
                if (prefTime != null && !prefTime.isEmpty()) {
                    draft.setTravelTime(prefTime);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/helicopter-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/transport/helicopter-payment.jsp");
    }
}
