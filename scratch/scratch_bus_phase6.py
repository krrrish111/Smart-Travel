import os

base_dir = "c:/Users/Dell/Desktop/antigravity/"
sql_dir = base_dir + "sql/"
src_main_java = base_dir + "src/main/java/com/voyastra/"
model_dir = src_main_java + "model/"
dao_dir = src_main_java + "dao/"
servlet_dir = src_main_java + "servlet/transport/"
webapp_dir = base_dir + "src/main/webapp/pages/transport/"

# 1. SQL
bus_sql = """CREATE TABLE IF NOT EXISTS bus_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    bus_name VARCHAR(100),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bus_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(20),
    seat_preference VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES bus_bookings(id) ON DELETE CASCADE
);
"""
with open(sql_dir + "bus_tables.sql", "w", encoding="utf-8") as f:
    f.write(bus_sql)

# 2. Models
bus_result_java = """package com.voyastra.model;

public class BusResult {
    private String id;
    private String operatorName;
    private String busType;
    private String departureTime;
    private String arrivalTime;
    private String duration;
    private int availableSeats;
    private double fare;

    public BusResult(String id, String operatorName, String busType, String departureTime, String arrivalTime, String duration, int availableSeats, double fare) {
        this.id = id;
        this.operatorName = operatorName;
        this.busType = busType;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.duration = duration;
        this.availableSeats = availableSeats;
        this.fare = fare;
    }

    public String getId() { return id; }
    public String getOperatorName() { return operatorName; }
    public String getBusType() { return busType; }
    public String getDepartureTime() { return departureTime; }
    public String getArrivalTime() { return arrivalTime; }
    public String getDuration() { return duration; }
    public int getAvailableSeats() { return availableSeats; }
    public double getFare() { return fare; }
}
"""
with open(model_dir + "BusResult.java", "w", encoding="utf-8") as f:
    f.write(bus_result_java)

bus_passenger_java = """package com.voyastra.model;

public class BusPassenger {
    private String name;
    private int age;
    private String gender;
    private String seatPreference;

    public BusPassenger() {}

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getSeatPreference() { return seatPreference; }
    public void setSeatPreference(String seatPreference) { this.seatPreference = seatPreference; }
}
"""
with open(model_dir + "BusPassenger.java", "w", encoding="utf-8") as f:
    f.write(bus_passenger_java)

bus_booking_java = """package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class BusBooking {
    private String id;
    private int userId;
    private String busName;
    private double fare;
    private String status;
    private List<BusPassenger> passengers = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getBusName() { return busName; }
    public void setBusName(String busName) { this.busName = busName; }
    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<BusPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<BusPassenger> passengers) { this.passengers = passengers; }
}
"""
with open(model_dir + "BusBooking.java", "w", encoding="utf-8") as f:
    f.write(bus_booking_java)

# 3. DAOs
bus_dao_java = """package com.voyastra.dao;

import com.voyastra.model.BusResult;
import java.util.ArrayList;
import java.util.List;

public class BusDAO {
    public List<BusResult> searchBuses(String from, String to, String date, String type) {
        List<BusResult> list = new ArrayList<>();
        list.add(new BusResult("B101", "IntrCity SmartBus", "AC Sleeper", "21:00", "06:00", "9h 00m", 15, 1200.0));
        list.add(new BusResult("B102", "Zingbus", "Volvo AC Seater", "22:30", "07:00", "8h 30m", 10, 950.0));
        list.add(new BusResult("B103", "Orange Travels", "Non AC Sleeper", "19:00", "05:00", "10h 00m", 25, 800.0));
        list.add(new BusResult("B104", "VRL Travels", "AC Luxury", "23:00", "08:00", "9h 00m", 5, 1500.0));

        if (type != null && !type.isEmpty() && !type.equalsIgnoreCase("All")) {
            List<BusResult> filtered = new ArrayList<>();
            for (BusResult b : list) {
                if (b.getBusType().toLowerCase().contains(type.toLowerCase())) {
                    filtered.add(b);
                }
            }
            return filtered;
        }

        return list;
    }

    public BusResult getBusById(String id) {
        return new BusResult(id, "Selected Bus Travels", "AC Sleeper", "21:00", "06:00", "9h 00m", 15, 1200.0);
    }
}
"""
with open(dao_dir + "BusDAO.java", "w", encoding="utf-8") as f:
    f.write(bus_dao_java)

bus_booking_dao_java = """package com.voyastra.dao;

import com.voyastra.model.BusBooking;
import com.voyastra.model.BusPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BusBookingDAO {
    
    public boolean saveBooking(BusBooking booking) {
        String insertBookingSql = "INSERT INTO bus_bookings (id, user_id, bus_name, amount, status) VALUES (?, ?, ?, ?, ?)";
        String insertPassengerSql = "INSERT INTO bus_passengers (booking_id, name, age, gender, seat_preference) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if(conn == null) return false;
            
            // Insert Booking
            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getBusName());
                ps.setDouble(4, booking.getFare() * booking.getPassengers().size());
                ps.setString(5, booking.getStatus());
                ps.executeUpdate();
            }

            // Insert Passengers
            try (PreparedStatement ps = conn.prepareStatement(insertPassengerSql)) {
                for (BusPassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setInt(3, p.getAge());
                    ps.setString(4, p.getGender());
                    ps.setString(5, p.getSeatPreference());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<BusBooking> getBookingsByUserId(int userId) {
        List<BusBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM bus_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusBooking b = new BusBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setBusName(rs.getString("bus_name"));
                    b.setFare(rs.getDouble("amount"));
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
with open(dao_dir + "BusBookingDAO.java", "w", encoding="utf-8") as f:
    f.write(bus_booking_dao_java)


# 4. Servlets
bus_servlet_java = """package com.voyastra.servlet.transport;

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
"""
with open(servlet_dir + "BusServlet.java", "w", encoding="utf-8") as f:
    f.write(bus_servlet_java)

bus_booking_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.BusDAO;
import com.voyastra.model.BusBooking;
import com.voyastra.model.BusPassenger;
import com.voyastra.model.BusResult;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/transport/bus/booking")
public class BusBookingServlet extends HttpServlet {
    private BusDAO busDAO;

    @Override
    public void init() {
        busDAO = new BusDAO();
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
        String busId = request.getParameter("busId");
        BusResult bus = busDAO.getBusById(busId);

        BusBooking draft = new BusBooking();
        draft.setId("BUS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setBusName(bus.getOperatorName() + " (" + bus.getBusType() + ")");
        draft.setFare(bus.getFare());
        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentBusBooking", draft);
        request.setAttribute("bus", bus);
        request.getRequestDispatcher("/pages/transport/bus-details.jsp").forward(request, response);
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] names = request.getParameterValues("name[]");
        String[] ages = request.getParameterValues("age[]");
        String[] genders = request.getParameterValues("gender[]");
        String[] seats = request.getParameterValues("seat[]");

        BusBooking draft = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        if (draft != null && names != null) {
            draft.getPassengers().clear();
            for (int i = 0; i < names.length; i++) {
                if(names[i].trim().isEmpty()) continue;
                BusPassenger p = new BusPassenger();
                p.setName(names[i]);
                p.setAge(Integer.parseInt(ages[i]));
                p.setGender(genders[i]);
                p.setSeatPreference(seats[i]);
                draft.getPassengers().add(p);
            }
        }

        request.getSession().setAttribute("currentBusBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/bus-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/transport/bus-payment.jsp");
    }
}
"""
with open(servlet_dir + "BusBookingServlet.java", "w", encoding="utf-8") as f:
    f.write(bus_booking_servlet_java)


bus_payment_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.BusBookingDAO;
import com.voyastra.model.BusBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/bus/payment-callback")
public class BusPaymentServlet extends HttpServlet {
    private BusBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BusBookingDAO();
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

        BusBooking draft = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            if (bookingDAO.saveBooking(draft)) {
                response.sendRedirect(request.getContextPath() + "/transport/bus/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
"""
with open(servlet_dir + "BusPaymentServlet.java", "w", encoding="utf-8") as f:
    f.write(bus_payment_servlet_java)


bus_confirmation_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.model.BusBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/bus/confirmation")
public class BusConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BusBooking confirmedBooking = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/bus-confirmation.jsp").forward(request, response);
    }
}
"""
with open(servlet_dir + "BusConfirmationServlet.java", "w", encoding="utf-8") as f:
    f.write(bus_confirmation_servlet_java)


# 5. JSPs
bus_search_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="search-form-container bg-gray-900 bg-opacity-70 backdrop-blur-md p-8 rounded-xl border border-gray-700 w-full animate-fade-in-up">
    <h2 class="text-3xl font-bold text-white mb-6">Search Buses</h2>
    <form action="${pageContext.request.contextPath}/transport/bus/search" method="post" class="grid grid-cols-1 md:grid-cols-4 gap-6">
        
        <!-- From -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">FROM</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">📍</span>
                <input type="text" name="from" placeholder="Origin City" required 
                       class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition">
            </div>
        </div>

        <!-- To -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">TO</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">📍</span>
                <input type="text" name="to" placeholder="Destination City" required 
                       class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition">
            </div>
        </div>

        <!-- Date -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">JOURNEY DATE</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">📅</span>
                <input type="date" name="date" required 
                       class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition">
            </div>
        </div>

        <!-- Bus Type -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">BUS TYPE</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">🚌</span>
                <select name="type" class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition appearance-none">
                    <option value="All">All Types</option>
                    <option value="AC">AC</option>
                    <option value="Non AC">Non AC</option>
                    <option value="Sleeper">Sleeper</option>
                    <option value="Seater">Seater</option>
                    <option value="Volvo">Volvo</option>
                    <option value="Luxury">Luxury</option>
                </select>
            </div>
        </div>

        <!-- Search Button -->
        <div class="md:col-span-4 flex justify-center mt-4">
            <button type="submit" class="btn-primary text-xl font-bold py-4 px-16 rounded-full shadow-lg hover:shadow-blue-500/30 transform hover:-translate-y-1 transition duration-300">
                SEARCH BUSES
            </button>
        </div>
    </form>
</div>
"""
with open(webapp_dir + "bus-search.jsp", "w", encoding="utf-8") as f:
    f.write(bus_search_jsp)

bus_results_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4">
        <h2 class="text-2xl font-bold text-white mb-6">Buses from ${from} to ${to} on ${date}</h2>
        <div class="flex flex-col gap-4">
            <c:forEach var="bus" items="${busResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex justify-between items-center hover:border-blue-500 transition">
                    <div>
                        <h3 class="text-xl font-bold text-white">${bus.operatorName}</h3>
                        <p class="text-gray-400 text-sm mb-2">${bus.busType}</p>
                        <div class="flex items-center gap-4 text-gray-300">
                            <span>${bus.departureTime}</span>
                            <span class="text-gray-500">→</span>
                            <span>${bus.arrivalTime}</span>
                            <span class="text-xs bg-gray-700 px-2 py-1 rounded">${bus.duration}</span>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-2xl font-bold text-green-400 mb-1">₹${bus.fare}</p>
                        <p class="text-sm text-gray-400 mb-3">${bus.availableSeats} Seats Available</p>
                        <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post">
                            <input type="hidden" name="action" value="details">
                            <input type="hidden" name="busId" value="${bus.id}">
                            <button type="submit" class="bg-blue-600 hover:bg-blue-500 text-white font-bold py-2 px-6 rounded transition">Book Now</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-results.jsp", "w", encoding="utf-8") as f:
    f.write(bus_results_jsp)

bus_details_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Bus Details</h1>
            <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 mb-6">
                <h2 class="text-xl font-bold text-blue-400">${bus.operatorName}</h2>
                <p class="text-gray-400">${bus.busType}</p>
                <div class="mt-4 flex justify-between text-gray-300">
                    <div>
                        <p class="text-sm">Departure</p>
                        <p class="font-bold text-lg text-white">${bus.departureTime}</p>
                    </div>
                    <div>
                        <p class="text-sm">Duration</p>
                        <p class="font-bold">${bus.duration}</p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm">Arrival</p>
                        <p class="font-bold text-lg text-white">${bus.arrivalTime}</p>
                    </div>
                </div>
            </div>
            
            <div class="text-right mt-6">
                <a href="${pageContext.request.contextPath}/pages/transport/bus-passengers.jsp" class="btn-primary py-3 px-8 rounded-lg font-bold">Continue</a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-details.jsp", "w", encoding="utf-8") as f:
    f.write(bus_details_jsp)

bus_passengers_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Passenger Details</h1>
            <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post" id="passengerForm">
                <input type="hidden" name="action" value="passengers">
                
                <div id="passengerContainer">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 mb-4 passenger-block">
                        <h3 class="text-lg text-white mb-4">Passenger 1</h3>
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div class="md:col-span-2">
                                <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                                <input type="text" name="name[]" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Age</label>
                                <input type="number" name="age[]" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Gender</label>
                                <select name="gender[]" class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                                    <option>Male</option><option>Female</option><option>Other</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Seat Pref</label>
                                <select name="seat[]" class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                                    <option>Window</option><option>Aisle</option><option>Any</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="button" onclick="addPassenger()" class="text-blue-400 hover:text-blue-300 font-bold mb-6">+ Add Another Passenger</button>
                
                <div class="text-right">
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<script>
    let paxCount = 1;
    function addPassenger() {
        paxCount++;
        const block = document.createElement('div');
        block.className = 'p-5 bg-gray-800 rounded-lg border border-gray-700 mb-4 passenger-block';
        block.innerHTML = `
            <h3 class="text-lg text-white mb-4">Passenger ${paxCount}</h3>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div class="md:col-span-2">
                    <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                    <input type="text" name="name[]" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                </div>
                <div>
                    <label class="block text-gray-400 text-sm mb-1">Age</label>
                    <input type="number" name="age[]" required class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                </div>
                <div>
                    <label class="block text-gray-400 text-sm mb-1">Gender</label>
                    <select name="gender[]" class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                        <option>Male</option><option>Female</option><option>Other</option>
                    </select>
                </div>
                <div>
                    <label class="block text-gray-400 text-sm mb-1">Seat Pref</label>
                    <select name="seat[]" class="w-full bg-gray-900 border border-gray-700 text-white rounded p-2 focus:border-blue-500 outline-none">
                        <option>Window</option><option>Aisle</option><option>Any</option>
                    </select>
                </div>
            </div>
        `;
        document.getElementById('passengerContainer').appendChild(block);
    }
</script>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-passengers.jsp", "w", encoding="utf-8") as f:
    f.write(bus_passengers_jsp)

bus_review_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">📋 Review Your Bus Booking</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-3">🚌 Bus Details</h2>
                        <p class="text-gray-300">Operator: <span class="font-bold text-white">${currentBusBooking.busName}</span></p>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-3">👥 Passengers</h2>
                        <div class="flex flex-col gap-3">
                            <c:forEach var="pax" items="${currentBusBooking.passengers}">
                                <div class="flex justify-between items-center bg-gray-900 p-3 rounded">
                                    <div>
                                        <p class="text-white font-bold">${pax.name}</p>
                                        <p class="text-xs text-gray-400">${pax.age} yrs, ${pax.gender}</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-sm text-gray-300">Seat Pref: ${pax.seatPreference}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Price Summary</h2>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Base Fare (x${currentBusBooking.passengers.size()})</span>
                            <span>₹${currentBusBooking.fare * currentBusBooking.passengers.size()}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Taxes & Fees</span>
                            <span>₹50.0</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${(currentBusBooking.fare * currentBusBooking.passengers.size()) + 50}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="btn-primary w-full py-3 rounded-lg font-bold text-lg">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-review.jsp", "w", encoding="utf-8") as f:
    f.write(bus_review_jsp)

bus_payment_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-2xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center;">
            <h1 class="text-2xl font-bold text-white mb-4">💳 Secure Payment</h1>
            <p class="text-gray-400 mb-8">Please complete your payment to confirm the bus booking.</p>
            
            <div class="bg-gray-800 p-6 rounded-lg mb-8 border border-gray-700">
                <h2 class="text-lg text-white mb-2">Total Amount Payable</h2>
                <p class="text-4xl font-bold text-green-400">₹${(currentBusBooking.fare * currentBusBooking.passengers.size()) + 50}</p>
            </div>

            <button id="rzp-button1" class="btn-primary w-full py-4 rounded-lg font-bold text-xl uppercase tracking-wider">Pay Now</button>

            <form id="razorpayForm" action="${pageContext.request.contextPath}/transport/bus/payment-callback" method="POST" style="display: none;">
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
            body: 'amount=' + ${(currentBusBooking.fare * currentBusBooking.passengers.size()) + 50} + '&receipt=${currentBusBooking.id}'
        })
        .then(response => response.json())
        .then(orderData => {
            var options = {
                "key": "rzp_test_YourKeyIdHere", 
                "amount": orderData.amount,
                "currency": "INR",
                "name": "Voyastra",
                "description": "Bus Booking Payment",
                "order_id": orderData.id,
                "handler": function (response){
                    document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                    document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                    document.getElementById('razorpay_signature').value = response.razorpay_signature;
                    document.getElementById('razorpayForm').submit();
                },
                "prefill": {
                    "name": "${currentBusBooking.passengers[0].name}",
                    "email": "user@example.com",
                    "contact": "9999999999"
                },
                "theme": { "color": "#f39c12" } // Orange accent for buses
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
with open(webapp_dir + "bus-payment.jsp", "w", encoding="utf-8") as f:
    f.write(bus_payment_jsp)

bus_confirmation_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-white">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Bus Booking Confirmed!</h1>
            <p class="text-gray-400">Your payment was successful and your bus seats are reserved.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking ID</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Bus Operator</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.busName}</p>
                </div>
            </div>

            <h3 class="text-lg font-bold text-white mb-4">Passengers</h3>
            <div class="space-y-3 mb-6 border-b border-gray-700 pb-6">
                <c:forEach var="pax" items="${booking.passengers}">
                    <div class="flex justify-between items-center bg-gray-800 p-3 rounded">
                        <div>
                            <p class="text-white font-bold">${pax.name}</p>
                            <p class="text-xs text-gray-400">${pax.age} yrs, ${pax.gender}</p>
                        </div>
                        <span class="bg-green-500 bg-opacity-20 text-green-400 px-3 py-1 rounded text-sm font-bold">
                            CNF / ${pax.seatPreference}
                        </span>
                    </div>
                </c:forEach>
            </div>

            <div class="flex justify-center gap-4">
                <a href="${pageContext.request.contextPath}/pages/transport/bus-ticket.jsp" target="_blank" class="px-6 py-3 bg-blue-600 hover:bg-blue-500 text-white rounded-lg font-bold flex items-center gap-2 transition">
                    <span>📄</span> Download Ticket (PDF)
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="px-6 py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-bold transition">
                    Go to My Bookings
                </a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-confirmation.jsp", "w", encoding="utf-8") as f:
    f.write(bus_confirmation_jsp)

bus_ticket_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bus E-Ticket - ${currentBusBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 20px; background: #fff; color: #333; }
        .ticket-container { max-width: 800px; margin: 0 auto; border: 2px solid #e67e22; padding: 30px; border-radius: 8px; }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: bold; color: #d35400; }
        .pnr-box { text-align: right; }
        .pnr-label { font-size: 12px; color: #7f8c8d; text-transform: uppercase; }
        .pnr-val { font-size: 20px; font-weight: bold; }
        .section-title { font-size: 16px; font-weight: bold; background: #fdf2e9; padding: 8px 12px; margin-bottom: 15px; border-radius: 4px; color: #d35400; }
        table { border-collapse: collapse; margin-bottom: 20px; width: 100%; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { font-size: 12px; color: #7f8c8d; text-transform: uppercase; }
        .print-btn { display: block; margin: 30px auto; padding: 12px 24px; background: #e67e22; color: #fff; text-align: center; font-size: 16px; border: none; border-radius: 4px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { padding: 0; } .ticket-container { border: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="ticket-container">
        <div class="header">
            <div class="logo">🚌 Voyastra Bus Service</div>
            <div class="pnr-box">
                <div class="pnr-label">Booking ID</div>
                <div class="pnr-val">${currentBusBooking.id}</div>
            </div>
        </div>

        <div class="section-title">Bus Details</div>
        <table>
            <tr>
                <th>Operator</th>
                <th>Status</th>
                <th>Total Fare</th>
            </tr>
            <tr>
                <td><strong>${currentBusBooking.busName}</strong></td>
                <td><strong>${currentBusBooking.status}</strong></td>
                <td><strong>Rs. ${(currentBusBooking.fare * currentBusBooking.passengers.size()) + 50}</strong></td>
            </tr>
        </table>

        <div class="section-title">Passenger Details</div>
        <table>
            <tr>
                <th>S.No</th>
                <th>Name</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Seat Pref</th>
            </tr>
            <c:forEach var="pax" items="${currentBusBooking.passengers}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td><strong>${pax.name}</strong></td>
                    <td>${pax.age}</td>
                    <td>${pax.gender}</td>
                    <td><strong>${pax.seatPreference}</strong></td>
                </tr>
            </c:forEach>
        </table>

        <div style="font-size: 12px; color: #7f8c8d; margin-top: 30px; text-align: center;">
            <p>This is a computer-generated e-ticket. Please carry a valid ID proof and present this ticket while boarding.</p>
            <p>Thank you for choosing Voyastra!</p>
        </div>
    </div>

    <button class="print-btn" onclick="window.print()">Print Ticket / Save as PDF</button>
</body>
</html>
"""
with open(webapp_dir + "bus-ticket.jsp", "w", encoding="utf-8") as f:
    f.write(bus_ticket_jsp)

print("Phase 6 generation complete!")
