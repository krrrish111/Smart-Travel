package com.voyastra.servlet.transport;

import com.voyastra.dao.CarDAO;
import com.voyastra.model.CarResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet("/transport/car/search")
public class CarServlet extends HttpServlet {
    private CarDAO carDAO;

    @Override
    public void init() {
        carDAO = new CarDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pickupCity = request.getParameter("pickupCity");
        String pickupDate = request.getParameter("pickupDate");
        String returnDate = request.getParameter("returnDate");
        String vehicleType = request.getParameter("vehicleType");

        long days = 1;
        try {
            LocalDate d1 = LocalDate.parse(pickupDate);
            LocalDate d2 = LocalDate.parse(returnDate);
            days = ChronoUnit.DAYS.between(d1, d2);
            if(days <= 0) days = 1;
        } catch (Exception e) {
            days = 1;
        }

        List<CarResult> results = carDAO.searchCars(vehicleType);
        
        request.setAttribute("carResults", results);
        request.setAttribute("pickupCity", pickupCity);
        request.setAttribute("pickupDate", pickupDate);
        request.setAttribute("returnDate", returnDate);
        request.setAttribute("days", days);

        request.getRequestDispatcher("/pages/transport/car-results.jsp").forward(request, response);
    }
}
