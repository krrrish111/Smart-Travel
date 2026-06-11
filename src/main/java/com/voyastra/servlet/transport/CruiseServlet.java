package com.voyastra.servlet.transport;

import com.voyastra.dao.CruiseDAO;
import com.voyastra.model.CruiseResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/transport/cruise/search")
public class CruiseServlet extends HttpServlet {
    private CruiseDAO cruiseDAO;

    @Override
    public void init() {
        cruiseDAO = new CruiseDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String departurePort = request.getParameter("departurePort");
        String destination = request.getParameter("destination");
        String cruiseDate = request.getParameter("cruiseDate");
        String cabinType = request.getParameter("cabinType");
        int paxCount = Integer.parseInt(request.getParameter("paxCount"));

        List<CruiseResult> results = cruiseDAO.searchCruises(cabinType);
        
        request.setAttribute("cruiseResults", results);
        request.setAttribute("departurePort", departurePort);
        request.setAttribute("destination", destination);
        request.setAttribute("cruiseDate", cruiseDate);
        request.setAttribute("cabinType", cabinType);
        request.setAttribute("paxCount", paxCount);

        request.getRequestDispatcher("/pages/transport/cruise-results.jsp").forward(request, response);
    }
}
