import os

base_dir = "c:/Users/Dell/Desktop/antigravity/"
sql_dir = base_dir + "sql/"
src_main_java = base_dir + "src/main/java/com/voyastra/"
model_dir = src_main_java + "model/"
dao_dir = src_main_java + "dao/"
servlet_dir = src_main_java + "servlet/transport/"
webapp_dir = base_dir + "src/main/webapp/pages/transport/"

# 1. SQL
cab_sql = """CREATE TABLE IF NOT EXISTS cab_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(100),
    vehicle_type VARCHAR(50),
    booking_type VARCHAR(50),
    pickup VARCHAR(255),
    dropoff VARCHAR(255),
    journey_date VARCHAR(50),
    journey_time VARCHAR(50),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cab_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES cab_bookings(id) ON DELETE CASCADE
);
"""
with open(sql_dir + "cab_tables.sql", "w", encoding="utf-8") as f:
    f.write(cab_sql)

# 2. Models
cab_result_java = """package com.voyastra.model;

public class CabResult {
    private String id;
    private String provider;
    private String vehicleType;
    private int capacity;
    private String eta;
    private double baseFare;

    public CabResult() {}

    public CabResult(String id, String provider, String vehicleType, int capacity, String eta, double baseFare) {
        this.id = id;
        this.provider = provider;
        this.vehicleType = vehicleType;
        this.capacity = capacity;
        this.eta = eta;
        this.baseFare = baseFare;
    }

    public String getId() { return id; }
    public String getProvider() { return provider; }
    public String getVehicleType() { return vehicleType; }
    public int getCapacity() { return capacity; }
    public String getEta() { return eta; }
    public double getBaseFare() { return baseFare; }
}
"""
with open(model_dir + "CabResult.java", "w", encoding="utf-8") as f:
    f.write(cab_result_java)

cab_passenger_java = """package com.voyastra.model;

public class CabPassenger {
    private String name;
    private String phone;
    private String email;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
"""
with open(model_dir + "CabPassenger.java", "w", encoding="utf-8") as f:
    f.write(cab_passenger_java)

cab_booking_java = """package com.voyastra.model;

public class CabBooking {
    private String id;
    private int userId;
    private String provider;
    private String vehicleType;
    private String bookingType;
    private String pickup;
    private String dropoff;
    private String date;
    private String time;
    private double amount;
    private String status;
    private CabPassenger passenger;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getProvider() { return provider; }
    public void setProvider(String provider) { this.provider = provider; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public String getBookingType() { return bookingType; }
    public void setBookingType(String bookingType) { this.bookingType = bookingType; }
    public String getPickup() { return pickup; }
    public void setPickup(String pickup) { this.pickup = pickup; }
    public String getDropoff() { return dropoff; }
    public void setDropoff(String dropoff) { this.dropoff = dropoff; }
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public CabPassenger getPassenger() { return passenger; }
    public void setPassenger(CabPassenger passenger) { this.passenger = passenger; }
}
"""
with open(model_dir + "CabBooking.java", "w", encoding="utf-8") as f:
    f.write(cab_booking_java)


# 3. DAOs
cab_dao_java = """package com.voyastra.dao;

import com.voyastra.model.CabResult;
import java.util.ArrayList;
import java.util.List;

public class CabDAO {
    public List<CabResult> searchCabs(String bookingType, String vehicleTypeReq) {
        List<CabResult> list = new ArrayList<>();
        list.add(new CabResult("CAB-01", "Ola", "Mini", 4, "5 mins", 350.0));
        list.add(new CabResult("CAB-02", "Uber", "Sedan", 4, "8 mins", 500.0));
        list.add(new CabResult("CAB-03", "Savaari", "SUV", 6, "15 mins", 850.0));
        list.add(new CabResult("CAB-04", "Uber Black", "Luxury", 4, "20 mins", 2500.0));

        if (vehicleTypeReq != null && !vehicleTypeReq.isEmpty() && !vehicleTypeReq.equalsIgnoreCase("All")) {
            List<CabResult> filtered = new ArrayList<>();
            for (CabResult c : list) {
                if (c.getVehicleType().equalsIgnoreCase(vehicleTypeReq)) {
                    filtered.add(c);
                }
            }
            return filtered;
        }

        return list;
    }

    public CabResult getCabById(String id) {
        if ("CAB-01".equals(id)) return new CabResult("CAB-01", "Ola", "Mini", 4, "5 mins", 350.0);
        if ("CAB-02".equals(id)) return new CabResult("CAB-02", "Uber", "Sedan", 4, "8 mins", 500.0);
        if ("CAB-03".equals(id)) return new CabResult("CAB-03", "Savaari", "SUV", 6, "15 mins", 850.0);
        return new CabResult("CAB-04", "Uber Black", "Luxury", 4, "20 mins", 2500.0);
    }
}
"""
with open(dao_dir + "CabDAO.java", "w", encoding="utf-8") as f:
    f.write(cab_dao_java)


cab_booking_dao_java = """package com.voyastra.dao;

import com.voyastra.model.CabBooking;
import com.voyastra.model.CabPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CabBookingDAO {
    
    public boolean saveBooking(CabBooking booking) {
        String insertBooking = "INSERT INTO cab_bookings (id, user_id, provider, vehicle_type, booking_type, pickup, dropoff, journey_date, journey_time, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO cab_passengers (booking_id, name, phone, email) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getProvider());
                ps.setString(4, booking.getVehicleType());
                ps.setString(5, booking.getBookingType());
                ps.setString(6, booking.getPickup());
                ps.setString(7, booking.getDropoff());
                ps.setString(8, booking.getDate());
                ps.setString(9, booking.getTime());
                ps.setDouble(10, booking.getAmount());
                ps.setString(11, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertPassenger)) {
                ps.setString(1, booking.getId());
                ps.setString(2, booking.getPassenger().getName());
                ps.setString(3, booking.getPassenger().getPhone());
                ps.setString(4, booking.getPassenger().getEmail());
                ps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<CabBooking> getBookingsByUserId(int userId) {
        List<CabBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM cab_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CabBooking b = new CabBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setProvider(rs.getString("provider"));
                    b.setVehicleType(rs.getString("vehicle_type"));
                    b.setBookingType(rs.getString("booking_type"));
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
with open(dao_dir + "CabBookingDAO.java", "w", encoding="utf-8") as f:
    f.write(cab_booking_dao_java)


# 4. Servlets
cab_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.CabDAO;
import com.voyastra.model.CabResult;

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
"""
with open(servlet_dir + "CabServlet.java", "w", encoding="utf-8") as f:
    f.write(cab_servlet_java)


cab_booking_servlet_java = """package com.voyastra.servlet.transport;

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
"""
with open(servlet_dir + "CabBookingServlet.java", "w", encoding="utf-8") as f:
    f.write(cab_booking_servlet_java)


cab_payment_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.CabBookingDAO;
import com.voyastra.model.CabBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cab/payment-callback")
public class CabPaymentServlet extends HttpServlet {
    private CabBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new CabBookingDAO();
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

        CabBooking draft = (CabBooking) request.getSession().getAttribute("currentCabBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            if (bookingDAO.saveBooking(draft)) {
                response.sendRedirect(request.getContextPath() + "/transport/cab/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
"""
with open(servlet_dir + "CabPaymentServlet.java", "w", encoding="utf-8") as f:
    f.write(cab_payment_servlet_java)


cab_confirmation_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.model.CabBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cab/confirmation")
public class CabConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CabBooking confirmedBooking = (CabBooking) request.getSession().getAttribute("currentCabBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/cab-confirmation.jsp").forward(request, response);
    }
}
"""
with open(servlet_dir + "CabConfirmationServlet.java", "w", encoding="utf-8") as f:
    f.write(cab_confirmation_servlet_java)


# 5. JSPs
cab_search_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="search-form-container bg-gray-900 bg-opacity-70 backdrop-blur-md p-8 rounded-xl border border-gray-700 w-full animate-fade-in-up">
    <h2 class="text-3xl font-bold text-white mb-6">Book a Cab</h2>
    
    <form action="${pageContext.request.contextPath}/transport/cab/search" method="post">
        <!-- Trip Type -->
        <div class="flex gap-4 mb-6">
            <label class="flex items-center gap-2 text-white font-bold cursor-pointer">
                <input type="radio" name="tripType" value="Airport Transfer" checked onclick="toggleDropField(true)" class="w-5 h-5 text-blue-600 focus:ring-blue-500 bg-gray-800 border-gray-600">
                Airport Transfer
            </label>
            <label class="flex items-center gap-2 text-white font-bold cursor-pointer">
                <input type="radio" name="tripType" value="Local Rental" onclick="toggleDropField(false)" class="w-5 h-5 text-blue-600 focus:ring-blue-500 bg-gray-800 border-gray-600">
                Local Rental
            </label>
            <label class="flex items-center gap-2 text-white font-bold cursor-pointer">
                <input type="radio" name="tripType" value="Outstation" onclick="toggleDropField(true)" class="w-5 h-5 text-blue-600 focus:ring-blue-500 bg-gray-800 border-gray-600">
                Outstation
            </label>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-5 gap-6 mb-6">
            <!-- Pickup -->
            <div class="form-group relative md:col-span-2">
                <label class="text-sm font-bold text-gray-400 block mb-2">PICKUP LOCATION</label>
                <input type="text" name="pickup" placeholder="Enter Pickup Address" required 
                       class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-blue-500 outline-none transition">
            </div>

            <!-- Drop (Changes based on Trip Type) -->
            <div class="form-group relative md:col-span-2" id="dropFieldContainer">
                <label class="text-sm font-bold text-gray-400 block mb-2" id="dropLabel">DROP LOCATION</label>
                <input type="text" name="drop" id="dropInput" placeholder="Enter Drop Address" required 
                       class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-blue-500 outline-none transition">
            </div>

            <!-- Vehicle Type -->
            <div class="form-group relative">
                <label class="text-sm font-bold text-gray-400 block mb-2">VEHICLE</label>
                <select name="vehicleType" class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-blue-500 outline-none transition">
                    <option value="All">All Cabs</option>
                    <option value="Mini">Mini</option>
                    <option value="Sedan">Sedan</option>
                    <option value="SUV">SUV</option>
                    <option value="Luxury">Luxury</option>
                </select>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8 w-1/2">
            <!-- Date -->
            <div class="form-group relative">
                <label class="text-sm font-bold text-gray-400 block mb-2">PICKUP DATE</label>
                <input type="date" name="date" required 
                       class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-blue-500 outline-none transition">
            </div>
            <!-- Time -->
            <div class="form-group relative">
                <label class="text-sm font-bold text-gray-400 block mb-2">PICKUP TIME</label>
                <input type="time" name="time" required 
                       class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-blue-500 outline-none transition">
            </div>
        </div>

        <!-- Search Button -->
        <div class="flex justify-center mt-4">
            <button type="submit" class="btn-primary text-xl font-bold py-4 px-16 rounded-full shadow-lg hover:shadow-blue-500/30 transform hover:-translate-y-1 transition duration-300">
                SEARCH CABS
            </button>
        </div>
    </form>
</div>
<script>
    function toggleDropField(isStandard) {
        const dropLabel = document.getElementById('dropLabel');
        const dropInput = document.getElementById('dropInput');
        if (isStandard) {
            dropLabel.textContent = 'DROP LOCATION';
            dropInput.placeholder = 'Enter Drop Address';
        } else {
            dropLabel.textContent = 'PACKAGE (DURATION/KM)';
            dropInput.placeholder = 'e.g. 8 Hrs / 80 Km';
        }
    }
</script>
"""
with open(webapp_dir + "cab-search.jsp", "w", encoding="utf-8") as f:
    f.write(cab_search_jsp)

cab_results_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-blue-400 font-bold">${tripType}</span> &nbsp;|&nbsp; 
                ${date} at ${time}
            </div>
            <div class="text-sm">
                <strong>Pickup:</strong> ${pickup} &nbsp; <strong>Drop:</strong> ${dropoff}
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Cabs</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="cab" items="${cabResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-yellow-500 transition">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${cab.provider}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${cab.vehicleType}</p>
                        </div>
                        <div class="text-right">
                            <p class="text-2xl font-bold text-green-400">₹${cab.baseFare}</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>👤 ${cab.capacity} Seats</span>
                        <span>⏱ ETA: ${cab.eta}</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/cab/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="cabId" value="${cab.id}">
                        <input type="hidden" name="tripType" value="${tripType}">
                        <input type="hidden" name="pickup" value="${pickup}">
                        <input type="hidden" name="dropoff" value="${dropoff}">
                        <input type="hidden" name="date" value="${date}">
                        <input type="hidden" name="time" value="${time}">
                        <button type="submit" class="w-full bg-yellow-500 hover:bg-yellow-400 text-gray-900 font-bold py-3 rounded transition">
                            Book This Cab
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "cab-results.jsp", "w", encoding="utf-8") as f:
    f.write(cab_results_jsp)

cab_passengers_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Rider Details</h1>
            
            <div class="bg-gray-800 p-4 rounded mb-6 border border-gray-700">
                <p class="text-yellow-400 font-bold">${currentCabBooking.provider} ${currentCabBooking.vehicleType}</p>
                <p class="text-gray-300 text-sm">${currentCabBooking.date} | ${currentCabBooking.time}</p>
            </div>

            <form action="${pageContext.request.contextPath}/transport/cab/booking" method="post">
                <input type="hidden" name="action" value="passengers">
                
                <div class="grid grid-cols-1 gap-4 mb-6">
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                        <input type="text" name="name" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Mobile Number (Driver will contact this number)</label>
                        <input type="text" name="phone" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-gray-400 text-sm mb-1">Email ID</label>
                        <input type="email" name="email" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                </div>

                <div class="text-right">
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold" style="background-color: #eab308; color: #111827;">Review Trip</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "cab-passengers.jsp", "w", encoding="utf-8") as f:
    f.write(cab_passengers_jsp)


cab_review_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">🚕 Review Trip Details</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-4">Trip Information</h2>
                        <div class="space-y-2">
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Type:</span> <strong class="text-white">${currentCabBooking.bookingType}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Pickup:</span> <strong class="text-white">${currentCabBooking.pickup}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Drop:</span> <strong class="text-white">${currentCabBooking.dropoff}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Date/Time:</span> <strong class="text-white">${currentCabBooking.date} at ${currentCabBooking.time}</strong></p>
                        </div>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 flex justify-between items-center">
                        <div>
                            <h2 class="text-lg font-bold text-white mb-1">Contact Details</h2>
                            <p class="text-gray-400 text-sm">${currentCabBooking.passenger.name}</p>
                            <p class="text-gray-400 text-sm">${currentCabBooking.passenger.phone} | ${currentCabBooking.passenger.email}</p>
                        </div>
                        <div class="text-right">
                            <span class="bg-gray-700 px-3 py-1 rounded text-sm text-yellow-400 font-bold border border-yellow-500">
                                ${currentCabBooking.provider} ${currentCabBooking.vehicleType}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Fare Breakdown</h2>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Base Fare</span>
                            <span>₹${currentCabBooking.amount}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Taxes & Surcharges</span>
                            <span>₹50.0</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${currentCabBooking.amount + 50}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/cab/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="w-full py-3 rounded-lg font-bold text-lg text-gray-900 transition" style="background-color: #eab308;">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "cab-review.jsp", "w", encoding="utf-8") as f:
    f.write(cab_review_jsp)

cab_payment_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-2xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center;">
            <h1 class="text-2xl font-bold text-white mb-4">💳 Cab Payment</h1>
            <p class="text-gray-400 mb-8">Confirm your ride by completing the payment.</p>
            
            <div class="bg-gray-800 p-6 rounded-lg mb-8 border border-gray-700">
                <h2 class="text-lg text-white mb-2">Total Amount Payable</h2>
                <p class="text-4xl font-bold text-green-400">₹${currentCabBooking.amount + 50}</p>
            </div>

            <button id="rzp-button1" class="w-full py-4 rounded-lg font-bold text-xl uppercase tracking-wider text-gray-900 transition" style="background-color: #eab308;">Pay Now</button>

            <form id="razorpayForm" action="${pageContext.request.contextPath}/transport/cab/payment-callback" method="POST" style="display: none;">
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
            body: 'amount=' + ${currentCabBooking.amount + 50} + '&receipt=${currentCabBooking.id}'
        })
        .then(response => response.json())
        .then(orderData => {
            var options = {
                "key": "rzp_test_YourKeyIdHere", 
                "amount": orderData.amount,
                "currency": "INR",
                "name": "Voyastra",
                "description": "Cab Booking Payment",
                "order_id": orderData.id,
                "handler": function (response){
                    document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                    document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                    document.getElementById('razorpay_signature').value = response.razorpay_signature;
                    document.getElementById('razorpayForm').submit();
                },
                "prefill": {
                    "name": "${currentCabBooking.passenger.name}",
                    "email": "${currentCabBooking.passenger.email}",
                    "contact": "${currentCabBooking.passenger.phone}"
                },
                "theme": { "color": "#eab308" } // Yellow accent for cabs
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
with open(webapp_dir + "cab-payment.jsp", "w", encoding="utf-8") as f:
    f.write(cab_payment_jsp)

cab_confirmation_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-white">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Cab Booking Confirmed!</h1>
            <p class="text-gray-400">Your ride is scheduled. Driver details will be shared 30 mins before pickup.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking Reference</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Cab Partner</p>
                    <p class="text-xl font-mono text-yellow-400 font-bold">${booking.provider} ${booking.vehicleType}</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-6">
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Pickup</p>
                    <p class="text-white">${booking.pickup}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.date} at ${booking.time}</p>
                </div>
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Drop</p>
                    <p class="text-white">${booking.dropoff}</p>
                </div>
            </div>

            <div class="flex justify-center gap-4 mt-8">
                <a href="${pageContext.request.contextPath}/pages/transport/cab-ticket.jsp" target="_blank" class="px-6 py-3 text-gray-900 rounded-lg font-bold flex items-center gap-2 transition" style="background-color: #eab308;">
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
with open(webapp_dir + "cab-confirmation.jsp", "w", encoding="utf-8") as f:
    f.write(cab_confirmation_jsp)

cab_ticket_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cab Booking Receipt - ${currentCabBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #f9fafb; color: #111827; }
        .receipt-card { max-width: 600px; margin: 0 auto; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #eab308; }
        .ref { text-align: right; }
        .ref-id { font-size: 18px; font-weight: bold; font-family: monospace; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .info-block { background: #f9fafb; padding: 15px; border-radius: 8px; }
        .label { font-size: 12px; color: #6b7280; text-transform: uppercase; font-weight: bold; margin-bottom: 5px; }
        .val { font-size: 16px; font-weight: bold; }
        .total-row { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; border-top: 2px solid #f3f4f6; padding-top: 20px; margin-top: 20px; }
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #eab308; color: #111827; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { background: #fff; padding: 0; } .receipt-card { box-shadow: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚕 Voyastra Cabs</div>
            <div class="ref">
                <div class="label">Booking Ref</div>
                <div class="ref-id">${currentCabBooking.id}</div>
            </div>
        </div>

        <div class="info-block" style="margin-bottom: 20px;">
            <div class="label">Rider</div>
            <div class="val">${currentCabBooking.passenger.name} (${currentCabBooking.passenger.phone})</div>
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Pickup</div>
                <div class="val">${currentCabBooking.pickup}</div>
            </div>
            <div class="info-block">
                <div class="label">Drop / Package</div>
                <div class="val">${currentCabBooking.dropoff}</div>
            </div>
            <div class="info-block">
                <div class="label">Date & Time</div>
                <div class="val">${currentCabBooking.date} at ${currentCabBooking.time}</div>
            </div>
            <div class="info-block">
                <div class="label">Vehicle</div>
                <div class="val">${currentCabBooking.provider} ${currentCabBooking.vehicleType}</div>
            </div>
        </div>

        <div class="total-row">
            <span>Total Paid Amount</span>
            <span style="color: #059669;">Rs. ${currentCabBooking.amount + 50}</span>
        </div>

        <p style="text-align: center; color: #6b7280; font-size: 12px; margin-top: 40px;">
            This is a computer generated receipt.<br>Driver contact details will be shared via SMS 30 mins prior to the pickup time.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print Receipt</button>
</body>
</html>
"""
with open(webapp_dir + "cab-ticket.jsp", "w", encoding="utf-8") as f:
    f.write(cab_ticket_jsp)

print("Phase 8 generation complete!")
