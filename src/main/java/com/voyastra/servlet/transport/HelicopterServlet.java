package com.voyastra.servlet.transport;

import com.voyastra.dao.HelicopterDAO;
import com.voyastra.model.HelicopterResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/transport/helicopter/search")
public class HelicopterServlet extends HttpServlet {
    private HelicopterDAO heliDAO;

    @Override
    public void init() {
        heliDAO = new HelicopterDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        String flightType = request.getParameter("flightType");
        int paxCount = Integer.parseInt(request.getParameter("paxCount"));

        List<HelicopterResult> results = heliDAO.searchFlights(origin, destination, flightType);
        
        request.setAttribute("heliResults", results);
        request.setAttribute("origin", origin);
        request.setAttribute("destination", destination);
        request.setAttribute("travelDate", travelDate);
        request.setAttribute("flightType", flightType);
        request.setAttribute("paxCount", paxCount);

        request.getRequestDispatcher("/pages/transport/helicopter-results.jsp").forward(request, response);
    }
}
