package com.voyastra.servlet.transport;

import com.voyastra.dao.CabDAO;
import com.voyastra.model.CabBooking;
import com.voyastra.model.CabPassenger;
import com.voyastra.model.CabResult;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/transport/cab/booking")
public class CabBookingServlet extends HttpServlet {
    private CabDAO cabDAO;

    @Override
    public void init() {
        cabDAO = new CabDAO();
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
        String cabId = request.getParameter("cabId");
        String tripType = request.getParameter("tripType");
        String pickup = request.getParameter("pickup");
        String dropoff = request.getParameter("dropoff");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        CabResult cab = cabDAO.getCabById(cabId);

        CabBooking draft = new CabBooking();
        draft.setId("CAB-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setProvider(cab.getProvider());
        draft.setVehicleType(cab.getVehicleType());
        draft.setBookingType(tripType);
        draft.setPickup(pickup);
        draft.setDropoff(dropoff);
        draft.setDate(date);
        draft.setTime(time);
        draft.setAmount(cab.getBaseFare());
        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentCabBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/cab-passengers.jsp");
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        CabBooking draft = (CabBooking) request.getSession().getAttribute("currentCabBooking");
        if (draft != null) {
            CabPassenger p = new CabPassenger();
            p.setName(name);
            p.setPhone(phone);
            p.setEmail(email);
            draft.setPassenger(p);
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/cab-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/transport/cab-payment.jsp");
    }
}
