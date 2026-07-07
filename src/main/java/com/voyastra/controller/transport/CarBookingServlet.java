package com.voyastra.controller.transport;

import com.voyastra.config.UploadConfig;
import com.voyastra.dao.transport.CarDAO;
import com.voyastra.model.booking.CarBooking;
import com.voyastra.model.transport.CarCustomer;
import com.voyastra.model.transport.CarResult;
import com.voyastra.model.profile.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/transport/car/booking")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CarBookingServlet extends HttpServlet {
    private CarDAO carDAO;

    @Override
    public void init() {
        carDAO = new CarDAO();
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
        } else if ("customer".equals(action)) {
            handleCustomer(request, response);
        } else if ("review".equals(action)) {
            handleReview(request, response);
        }
    }

    private void handleDetails(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        String carId = request.getParameter("carId");
        String pickupCity = request.getParameter("pickupCity");
        String pickupDate = request.getParameter("pickupDate");
        String returnDate = request.getParameter("returnDate");
        int days = Integer.parseInt(request.getParameter("days"));

        CarResult car = carDAO.getCarById(carId);

        CarBooking draft = new CarBooking();
        draft.setId("CAR-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setCarModel(car.getCarModel());
        draft.setVehicleType(car.getVehicleType());
        draft.setPickupCity(pickupCity);
        draft.setPickupDate(pickupDate);
        draft.setReturnDate(returnDate);
        draft.setAmount(car.getPricePerDay() * days);
        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentCarBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/car-customer.jsp");
    }

    private void handleCustomer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        // Handle File Upload
        Part filePart = request.getPart("driving_license");
        String dlPath = "";
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            
            // Create uploads directory if it doesn't exist
            String uploadPath = UploadConfig.getDlPath(getServletContext());
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            File destFile = new File(uploadDir, uniqueFileName);
            try (java.io.InputStream input = filePart.getInputStream()) {
                java.nio.file.Files.copy(input, destFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            }
            UploadConfig.copyToSourceFolder("dl", uniqueFileName, destFile);
            dlPath = UploadConfig.DL_URL + "/" + uniqueFileName;
        }

        CarBooking draft = (CarBooking) request.getSession().getAttribute("currentCarBooking");
        if (draft != null) {
            CarCustomer c = new CarCustomer();
            c.setName(name);
            c.setPhone(phone);
            c.setEmail(email);
            c.setDlPath(dlPath);
            draft.setCustomer(c);
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/car-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/transport/car/payment");
    }
}
