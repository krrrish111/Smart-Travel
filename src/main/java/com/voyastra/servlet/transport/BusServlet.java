package com.voyastra.servlet.transport;

import com.voyastra.dao.BusDAO;
import com.voyastra.model.BusResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/transport/bus/search")
public class BusServlet extends HttpServlet {
    private BusDAO busDAO;

    @Override
    public void init() {
        busDAO = new BusDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String date = request.getParameter("date");
        String type = request.getParameter("type"); // AC, Non AC, etc.

        List<BusResult> results = busDAO.searchBuses(from, to, date, type);
        request.setAttribute("busResults", results);
        request.setAttribute("from", from);
        request.setAttribute("to", to);
        request.setAttribute("date", date);

        request.getRequestDispatcher("/pages/transport/bus-results.jsp").forward(request, response);
    }
}
