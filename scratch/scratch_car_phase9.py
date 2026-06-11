import os

base_dir = "c:/Users/Dell/Desktop/antigravity/"
sql_dir = base_dir + "sql/"
src_main_java = base_dir + "src/main/java/com/voyastra/"
model_dir = src_main_java + "model/"
dao_dir = src_main_java + "dao/"
servlet_dir = src_main_java + "servlet/transport/"
webapp_dir = base_dir + "src/main/webapp/pages/transport/"

# 1. SQL
car_sql = """CREATE TABLE IF NOT EXISTS car_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    car_model VARCHAR(100),
    vehicle_type VARCHAR(50),
    pickup_city VARCHAR(255),
    pickup_date VARCHAR(50),
    return_date VARCHAR(50),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS car_customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    dl_path VARCHAR(255),
    FOREIGN KEY (booking_id) REFERENCES car_bookings(id) ON DELETE CASCADE
);
"""
with open(sql_dir + "car_tables.sql", "w", encoding="utf-8") as f:
    f.write(car_sql)

# 2. Models
car_result_java = """package com.voyastra.model;

public class CarResult {
    private String id;
    private String carModel;
    private String vehicleType;
    private String transmission;
    private int seats;
    private double pricePerDay;

    public CarResult() {}

    public CarResult(String id, String carModel, String vehicleType, String transmission, int seats, double pricePerDay) {
        this.id = id;
        this.carModel = carModel;
        this.vehicleType = vehicleType;
        this.transmission = transmission;
        this.seats = seats;
        this.pricePerDay = pricePerDay;
    }

    public String getId() { return id; }
    public String getCarModel() { return carModel; }
    public String getVehicleType() { return vehicleType; }
    public String getTransmission() { return transmission; }
    public int getSeats() { return seats; }
    public double getPricePerDay() { return pricePerDay; }
}
"""
with open(model_dir + "CarResult.java", "w", encoding="utf-8") as f:
    f.write(car_result_java)

car_customer_java = """package com.voyastra.model;

public class CarCustomer {
    private String name;
    private String phone;
    private String email;
    private String dlPath;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getDlPath() { return dlPath; }
    public void setDlPath(String dlPath) { this.dlPath = dlPath; }
}
"""
with open(model_dir + "CarCustomer.java", "w", encoding="utf-8") as f:
    f.write(car_customer_java)

car_booking_java = """package com.voyastra.model;

public class CarBooking {
    private String id;
    private int userId;
    private String carModel;
    private String vehicleType;
    private String pickupCity;
    private String pickupDate;
    private String returnDate;
    private double amount;
    private String status;
    private CarCustomer customer;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getCarModel() { return carModel; }
    public void setCarModel(String carModel) { this.carModel = carModel; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public String getPickupCity() { return pickupCity; }
    public void setPickupCity(String pickupCity) { this.pickupCity = pickupCity; }
    public String getPickupDate() { return pickupDate; }
    public void setPickupDate(String pickupDate) { this.pickupDate = pickupDate; }
    public String getReturnDate() { return returnDate; }
    public void setReturnDate(String returnDate) { this.returnDate = returnDate; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public CarCustomer getCustomer() { return customer; }
    public void setCustomer(CarCustomer customer) { this.customer = customer; }
}
"""
with open(model_dir + "CarBooking.java", "w", encoding="utf-8") as f:
    f.write(car_booking_java)


# 3. DAOs
car_dao_java = """package com.voyastra.dao;

import com.voyastra.model.CarResult;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {
    public List<CarResult> searchCars(String vehicleTypeReq) {
        List<CarResult> list = new ArrayList<>();
        list.add(new CarResult("CAR-01", "Maruti Swift", "Hatchback", "Manual", 5, 1200.0));
        list.add(new CarResult("CAR-02", "Honda City", "Sedan", "Automatic", 5, 2000.0));
        list.add(new CarResult("CAR-03", "Mahindra XUV700", "SUV", "Automatic", 7, 3500.0));
        list.add(new CarResult("CAR-04", "BMW 3 Series", "Luxury", "Automatic", 5, 8000.0));
        list.add(new CarResult("CAR-05", "Tata Nexon EV", "Electric", "Automatic", 5, 2500.0));

        if (vehicleTypeReq != null && !vehicleTypeReq.isEmpty() && !vehicleTypeReq.equalsIgnoreCase("All")) {
            List<CarResult> filtered = new ArrayList<>();
            for (CarResult c : list) {
                if (c.getVehicleType().equalsIgnoreCase(vehicleTypeReq)) {
                    filtered.add(c);
                }
            }
            return filtered;
        }

        return list;
    }

    public CarResult getCarById(String id) {
        if ("CAR-01".equals(id)) return new CarResult("CAR-01", "Maruti Swift", "Hatchback", "Manual", 5, 1200.0);
        if ("CAR-02".equals(id)) return new CarResult("CAR-02", "Honda City", "Sedan", "Automatic", 5, 2000.0);
        if ("CAR-03".equals(id)) return new CarResult("CAR-03", "Mahindra XUV700", "SUV", "Automatic", 7, 3500.0);
        if ("CAR-04".equals(id)) return new CarResult("CAR-04", "BMW 3 Series", "Luxury", "Automatic", 5, 8000.0);
        return new CarResult("CAR-05", "Tata Nexon EV", "Electric", "Automatic", 5, 2500.0);
    }
}
"""
with open(dao_dir + "CarDAO.java", "w", encoding="utf-8") as f:
    f.write(car_dao_java)


car_booking_dao_java = """package com.voyastra.dao;

import com.voyastra.model.CarBooking;
import com.voyastra.model.CarCustomer;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CarBookingDAO {
    
    public boolean saveBooking(CarBooking booking) {
        String insertBooking = "INSERT INTO car_bookings (id, user_id, car_model, vehicle_type, pickup_city, pickup_date, return_date, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertCustomer = "INSERT INTO car_customers (booking_id, name, phone, email, dl_path) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getCarModel());
                ps.setString(4, booking.getVehicleType());
                ps.setString(5, booking.getPickupCity());
                ps.setString(6, booking.getPickupDate());
                ps.setString(7, booking.getReturnDate());
                ps.setDouble(8, booking.getAmount());
                ps.setString(9, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertCustomer)) {
                ps.setString(1, booking.getId());
                ps.setString(2, booking.getCustomer().getName());
                ps.setString(3, booking.getCustomer().getPhone());
                ps.setString(4, booking.getCustomer().getEmail());
                ps.setString(5, booking.getCustomer().getDlPath());
                ps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CarBooking> getBookingsByUserId(int userId) {
        List<CarBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM car_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CarBooking b = new CarBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setCarModel(rs.getString("car_model"));
                    b.setVehicleType(rs.getString("vehicle_type"));
                    b.setAmount(rs.getDouble("amount"));
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
"""
with open(dao_dir + "CarBookingDAO.java", "w", encoding="utf-8") as f:
    f.write(car_booking_dao_java)


# 4. Servlets
car_servlet_java = """package com.voyastra.servlet.transport;

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
"""
with open(servlet_dir + "CarServlet.java", "w", encoding="utf-8") as f:
    f.write(car_servlet_java)


car_booking_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.CarDAO;
import com.voyastra.model.CarBooking;
import com.voyastra.model.CarCustomer;
import com.voyastra.model.CarResult;
import com.voyastra.model.User;

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
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "dl";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(uploadPath + File.separator + uniqueFileName);
            dlPath = "uploads/dl/" + uniqueFileName;
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
        response.sendRedirect(request.getContextPath() + "/pages/transport/car-payment.jsp");
    }
}
"""
with open(servlet_dir + "CarBookingServlet.java", "w", encoding="utf-8") as f:
    f.write(car_booking_servlet_java)


car_payment_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.CarBookingDAO;
import com.voyastra.model.CarBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/car/payment-callback")
public class CarPaymentServlet extends HttpServlet {
    private CarBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new CarBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String razorpayPaymentId = request.getParameter("razorpay_payment_id");
        String razorpayOrderId = request.getParameter("razorpay_order_id");
        String razorpaySignature = request.getParameter("razorpay_signature");

        if (!RazorpayConfig.verifySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Payment%20Verification%20Failed");
            return;
        }

        CarBooking draft = (CarBooking) request.getSession().getAttribute("currentCarBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            if (bookingDAO.saveBooking(draft)) {
                response.sendRedirect(request.getContextPath() + "/transport/car/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
"""
with open(servlet_dir + "CarPaymentServlet.java", "w", encoding="utf-8") as f:
    f.write(car_payment_servlet_java)


car_confirmation_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.model.CarBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/car/confirmation")
public class CarConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CarBooking confirmedBooking = (CarBooking) request.getSession().getAttribute("currentCarBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/car-confirmation.jsp").forward(request, response);
    }
}
"""
with open(servlet_dir + "CarConfirmationServlet.java", "w", encoding="utf-8") as f:
    f.write(car_confirmation_servlet_java)


# 5. JSPs
car_search_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="search-form-container bg-gray-900 bg-opacity-70 backdrop-blur-md p-8 rounded-xl border border-gray-700 w-full animate-fade-in-up">
    <h2 class="text-3xl font-bold text-white mb-6">Self Drive Cars</h2>
    
    <form action="${pageContext.request.contextPath}/transport/car/search" method="post" class="grid grid-cols-1 md:grid-cols-4 gap-6">
        
        <!-- Pickup City -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">PICKUP CITY</label>
            <input type="text" name="pickupCity" placeholder="Enter City" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
        </div>

        <!-- Pickup Date -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">PICKUP DATE</label>
            <input type="date" name="pickupDate" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
        </div>

        <!-- Return Date -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">RETURN DATE</label>
            <input type="date" name="returnDate" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
        </div>

        <!-- Vehicle Type -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">VEHICLE CLASS</label>
            <select name="vehicleType" class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
                <option value="All">All Classes</option>
                <option value="Hatchback">Hatchback</option>
                <option value="Sedan">Sedan</option>
                <option value="SUV">SUV</option>
                <option value="Luxury">Luxury</option>
                <option value="Electric">Electric</option>
            </select>
        </div>

        <!-- Search Button -->
        <div class="md:col-span-4 flex justify-center mt-4">
            <button type="submit" class="w-full md:w-auto text-xl font-bold py-4 px-16 rounded-full shadow-lg transform hover:-translate-y-1 transition duration-300 text-white" style="background-color: #8b5cf6;">
                FIND CARS
            </button>
        </div>
    </form>
</div>
"""
with open(webapp_dir + "car-search.jsp", "w", encoding="utf-8") as f:
    f.write(car_search_jsp)

car_results_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-purple-400 font-bold">${pickupCity}</span>
            </div>
            <div class="text-sm">
                ${pickupDate} &nbsp; ➡ &nbsp; ${returnDate} &nbsp; <span class="bg-gray-700 px-2 py-1 rounded text-white">${days} Days</span>
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Self Drive Cars</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="car" items="${carResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-purple-500 transition">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${car.carModel}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${car.vehicleType}</p>
                        </div>
                        <div class="text-right">
                            <p class="text-2xl font-bold text-green-400">₹${car.pricePerDay}</p>
                            <p class="text-xs text-gray-500">per day</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>👤 ${car.seats} Seats</span>
                        <span>⚙️ ${car.transmission}</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/car/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="carId" value="${car.id}">
                        <input type="hidden" name="pickupCity" value="${pickupCity}">
                        <input type="hidden" name="pickupDate" value="${pickupDate}">
                        <input type="hidden" name="returnDate" value="${returnDate}">
                        <input type="hidden" name="days" value="${days}">
                        <button type="submit" class="w-full hover:bg-purple-600 text-white font-bold py-3 rounded transition" style="background-color: #8b5cf6;">
                            Select Vehicle
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "car-results.jsp", "w", encoding="utf-8") as f:
    f.write(car_results_jsp)

car_customer_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Customer & License Details</h1>
            
            <div class="bg-gray-800 p-4 rounded mb-6 border border-gray-700">
                <p class="text-purple-400 font-bold">${currentCarBooking.carModel}</p>
                <p class="text-gray-300 text-sm">${currentCarBooking.pickupDate} to ${currentCarBooking.returnDate}</p>
            </div>

            <!-- IMPORTANT: enctype multipart/form-data for File Upload -->
            <form action="${pageContext.request.contextPath}/transport/car/booking" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="customer">
                
                <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Primary Driver Information</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                    <div class="md:col-span-2">
                        <label class="block text-gray-400 text-sm mb-1">Full Name (As per Driving License)</label>
                        <input type="text" name="name" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-purple-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Mobile Number</label>
                        <input type="text" name="phone" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-purple-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Email ID</label>
                        <input type="email" name="email" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-purple-500 outline-none">
                    </div>
                </div>

                <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Mandatory Document</h3>
                <div class="mb-8 p-6 border-2 border-dashed border-gray-600 rounded-lg text-center bg-gray-900">
                    <label class="block text-gray-300 font-bold mb-2">Upload Driving License</label>
                    <p class="text-xs text-gray-500 mb-4">Please upload a clear image or PDF of your valid driving license.</p>
                    <input type="file" name="driving_license" required accept="image/*,.pdf" class="text-gray-400 w-full md:w-2/3 mx-auto block file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-purple-600 file:text-white hover:file:bg-purple-500">
                </div>

                <div class="text-right">
                    <button type="submit" class="text-white py-3 px-8 rounded-lg font-bold transition" style="background-color: #8b5cf6;">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "car-customer.jsp", "w", encoding="utf-8") as f:
    f.write(car_customer_jsp)


car_review_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">🚗 Review Rental Details</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-4">Rental Information</h2>
                        <div class="space-y-2">
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Vehicle:</span> <strong class="text-white">${currentCarBooking.carModel} (${currentCarBooking.vehicleType})</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Pickup City:</span> <strong class="text-white">${currentCarBooking.pickupCity}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Dates:</span> <strong class="text-white">${currentCarBooking.pickupDate} to ${currentCarBooking.returnDate}</strong></p>
                        </div>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 flex justify-between items-center">
                        <div>
                            <h2 class="text-lg font-bold text-white mb-1">Driver Details</h2>
                            <p class="text-gray-400 text-sm">${currentCarBooking.customer.name}</p>
                            <p class="text-gray-400 text-sm">${currentCarBooking.customer.phone} | ${currentCarBooking.customer.email}</p>
                        </div>
                        <div class="text-right">
                            <span class="bg-purple-900 bg-opacity-50 px-3 py-1 rounded text-sm text-purple-400 font-bold border border-purple-500">
                                DL Uploaded ✓
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Fare Breakdown</h2>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Rental Charges</span>
                            <span>₹${currentCarBooking.amount}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Refundable Deposit</span>
                            <span>₹5000.0</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Taxes & Fees</span>
                            <span>₹500.0</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${currentCarBooking.amount + 5500}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/car/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="w-full py-3 rounded-lg font-bold text-lg text-white transition" style="background-color: #8b5cf6;">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "car-review.jsp", "w", encoding="utf-8") as f:
    f.write(car_review_jsp)

car_payment_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-2xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center;">
            <h1 class="text-2xl font-bold text-white mb-4">💳 Security Deposit & Payment</h1>
            <p class="text-gray-400 mb-8">Complete your payment including the refundable deposit.</p>
            
            <div class="bg-gray-800 p-6 rounded-lg mb-8 border border-gray-700">
                <h2 class="text-lg text-white mb-2">Total Amount Payable</h2>
                <p class="text-4xl font-bold text-green-400">₹${currentCarBooking.amount + 5500}</p>
            </div>

            <button id="rzp-button1" class="w-full py-4 rounded-lg font-bold text-xl tracking-wider text-white transition" style="background-color: #8b5cf6;">Pay Now</button>

            <form id="razorpayForm" action="${pageContext.request.contextPath}/transport/car/payment-callback" method="POST" style="display: none;">
                <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
                <input type="hidden" name="razorpay_order_id" id="razorpay_order_id">
                <input type="hidden" name="razorpay_signature" id="razorpay_signature">
            </form>
        </div>
    </div>
</main>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    document.getElementById('rzp-button1').onclick = function(e) {
        e.preventDefault();
        
        fetch('${pageContext.request.contextPath}/api/razorpay/create-order', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'amount=' + ${currentCarBooking.amount + 5500} + '&receipt=${currentCarBooking.id}'
        })
        .then(response => response.json())
        .then(orderData => {
            var options = {
                "key": "rzp_test_YourKeyIdHere", 
                "amount": orderData.amount,
                "currency": "INR",
                "name": "Voyastra Cars",
                "description": "Car Rental Security Deposit",
                "order_id": orderData.id,
                "handler": function (response){
                    document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                    document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                    document.getElementById('razorpay_signature').value = response.razorpay_signature;
                    document.getElementById('razorpayForm').submit();
                },
                "prefill": {
                    "name": "${currentCarBooking.customer.name}",
                    "email": "${currentCarBooking.customer.email}",
                    "contact": "${currentCarBooking.customer.phone}"
                },
                "theme": { "color": "#8b5cf6" } // Purple accent for self drive cars
            };
            var rzp1 = new Razorpay(options);
            rzp1.open();
        })
        .catch(err => {
            alert('Error initializing payment. ' + err);
        });
    }
</script>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "car-payment.jsp", "w", encoding="utf-8") as f:
    f.write(car_payment_jsp)

car_confirmation_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-white">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Car Rental Confirmed!</h1>
            <p class="text-gray-400">Your deposit is secured and your vehicle is blocked. Please bring original DL to the pickup point.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking ID</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Vehicle</p>
                    <p class="text-xl font-mono text-purple-400 font-bold">${booking.carModel}</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-6">
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Pickup details</p>
                    <p class="text-white">${booking.pickupCity}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.pickupDate}</p>
                </div>
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Return details</p>
                    <p class="text-white">${booking.pickupCity} Hub</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.returnDate}</p>
                </div>
            </div>

            <div class="flex justify-center gap-4 mt-8">
                <a href="${pageContext.request.contextPath}/pages/transport/car-ticket.jsp" target="_blank" class="px-6 py-3 text-white rounded-lg font-bold flex items-center gap-2 transition" style="background-color: #8b5cf6;">
                    <span>📄</span> Download Receipt
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="px-6 py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-bold transition">
                    View My Bookings
                </a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "car-confirmation.jsp", "w", encoding="utf-8") as f:
    f.write(car_confirmation_jsp)

car_ticket_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Car Rental Receipt - ${currentCarBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #fff; color: #111827; }
        .receipt-card { max-width: 600px; margin: 0 auto; border: 2px solid #8b5cf6; padding: 40px; border-radius: 12px; }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #8b5cf6; }
        .ref { text-align: right; }
        .ref-id { font-size: 18px; font-weight: bold; font-family: monospace; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .info-block { background: #f9fafb; padding: 15px; border-radius: 8px; border: 1px solid #e5e7eb; }
        .label { font-size: 12px; color: #6b7280; text-transform: uppercase; font-weight: bold; margin-bottom: 5px; }
        .val { font-size: 16px; font-weight: bold; }
        .total-row { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; border-top: 2px solid #f3f4f6; padding-top: 20px; margin-top: 20px; }
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #8b5cf6; color: #fff; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { padding: 0; } .receipt-card { border: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚗 Voyastra Self Drive</div>
            <div class="ref">
                <div class="label">Booking ID</div>
                <div class="ref-id">${currentCarBooking.id}</div>
            </div>
        </div>

        <div class="info-block" style="margin-bottom: 20px;">
            <div class="label">Driver Details</div>
            <div class="val">${currentCarBooking.customer.name}</div>
            <div style="font-size: 14px; color: #4b5563; margin-top: 4px;">DL Verification: <span style="color: #059669; font-weight: bold;">Document Uploaded ✓</span></div>
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Vehicle</div>
                <div class="val">${currentCarBooking.carModel}</div>
            </div>
            <div class="info-block">
                <div class="label">Location</div>
                <div class="val">${currentCarBooking.pickupCity} Hub</div>
            </div>
            <div class="info-block">
                <div class="label">Pickup Date</div>
                <div class="val">${currentCarBooking.pickupDate}</div>
            </div>
            <div class="info-block">
                <div class="label">Return Date</div>
                <div class="val">${currentCarBooking.returnDate}</div>
            </div>
        </div>

        <div class="total-row">
            <span>Total Paid (inc. Deposit)</span>
            <span style="color: #059669;">Rs. ${currentCarBooking.amount + 5500}</span>
        </div>

        <p style="text-align: center; color: #ef4444; font-size: 12px; margin-top: 40px; font-weight: bold;">
            Original Driving License MUST be presented at the time of pickup.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print Receipt / PDF</button>
</body>
</html>
"""
with open(webapp_dir + "car-ticket.jsp", "w", encoding="utf-8") as f:
    f.write(car_ticket_jsp)

print("Phase 9 generation complete!")
