package com.voyastra.controller.booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/flight-details")
public class FlightDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Flight Details Opened");

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String seatClass = request.getParameter("class");
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String date = request.getParameter("date");
        String passengers = request.getParameter("passengers");

        java.util.Map<String, String> currentFlight = new java.util.HashMap<>();
        currentFlight.put("id", id);
        currentFlight.put("name", name);
        currentFlight.put("price", price);
        currentFlight.put("class", seatClass);
        currentFlight.put("from", from);
        currentFlight.put("to", to);
        currentFlight.put("date", date);
        currentFlight.put("passengers", passengers);
        request.getSession().setAttribute("currentFlight", currentFlight);

        request.setAttribute("id", id);
        request.setAttribute("name", name);
        request.setAttribute("price", price);
        request.setAttribute("seatClass", seatClass);
        request.setAttribute("from", from);
        request.setAttribute("to", to);
        request.setAttribute("date", date);
        request.setAttribute("passengers", passengers);

        request.getRequestDispatcher("/WEB-INF/views/flight-details.jsp").forward(request, response);
    }
}
