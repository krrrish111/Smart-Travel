package com.voyastra.controller.transport;

import com.voyastra.dao.transport.CabDAO;
import com.voyastra.model.transport.CabResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/transport/cab/search")
public class CabServlet extends HttpServlet {
    private CabDAO cabDAO;

    @Override
    public void init() {
        cabDAO = new CabDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tripType = request.getParameter("tripType");
        String pickup = request.getParameter("pickup");
        String dropoff = request.getParameter("drop"); // Could be duration for local
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String vehicleType = request.getParameter("vehicleType");

        List<CabResult> results = cabDAO.searchCabs(tripType, vehicleType);
        
        request.setAttribute("cabResults", results);
        request.setAttribute("tripType", tripType);
        request.setAttribute("pickup", pickup);
        request.setAttribute("dropoff", dropoff);
        request.setAttribute("date", date);
        request.setAttribute("time", time);

        request.getRequestDispatcher("/pages/transport/cab-results.jsp").forward(request, response);
    }
}
