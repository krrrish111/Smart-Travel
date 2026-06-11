package com.voyastra.servlet;

import com.voyastra.dao.TrainDAO;
import com.voyastra.model.TrainResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/trains")
public class TrainServlet extends HttpServlet {

    private TrainDAO trainDAO;

    @Override
    public void init() throws ServletException {
        trainDAO = new TrainDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String from = request.getParameter("fromStation");
        String to = request.getParameter("toStation");
        String date = request.getParameter("journeyDate");
        String trainClass = request.getParameter("trainClass");
        String quota = request.getParameter("quota");

        if (from != null && to != null) {
            List<TrainResult> results = trainDAO.searchTrains(from, to, date);
            request.setAttribute("trainResults", results);
            request.setAttribute("searchFrom", from);
            request.setAttribute("searchTo", to);
            request.setAttribute("searchDate", date);
            request.setAttribute("searchClass", trainClass);
            request.setAttribute("searchQuota", quota);
        }

        request.getRequestDispatcher("/pages/transport/train-results.jsp").forward(request, response);
    }
}
