import os

base_dir = "c:/Users/Dell/Desktop/antigravity/"
sql_dir = base_dir + "sql/"
src_main_java = base_dir + "src/main/java/com/voyastra/"
model_dir = src_main_java + "model/"
dao_dir = src_main_java + "dao/"
servlet_dir = src_main_java + "servlet/transport/"
webapp_dir = base_dir + "src/main/webapp/pages/transport/"

# 1. SQL
cruise_sql = """CREATE TABLE IF NOT EXISTS cruise_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    ship_name VARCHAR(100),
    cruise_line VARCHAR(100),
    cabin_type VARCHAR(50),
    departure_port VARCHAR(255),
    destination VARCHAR(255),
    cruise_date VARCHAR(50),
    duration_days INT,
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cruise_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(20),
    passport_number VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES cruise_bookings(id) ON DELETE CASCADE
);
"""
with open(sql_dir + "cruise_tables.sql", "w", encoding="utf-8") as f:
    f.write(cruise_sql)

# 2. Models
cruise_result_java = """package com.voyastra.model;

public class CruiseResult {
    private String id;
    private String shipName;
    private String cruiseLine;
    private String departurePort;
    private String destination;
    private int durationDays;
    private String cabinType;
    private double baseFare;

    public CruiseResult() {}

    public CruiseResult(String id, String shipName, String cruiseLine, String departurePort, String destination, int durationDays, String cabinType, double baseFare) {
        this.id = id;
        this.shipName = shipName;
        this.cruiseLine = cruiseLine;
        this.departurePort = departurePort;
        this.destination = destination;
        this.durationDays = durationDays;
        this.cabinType = cabinType;
        this.baseFare = baseFare;
    }

    public String getId() { return id; }
    public String getShipName() { return shipName; }
    public String getCruiseLine() { return cruiseLine; }
    public String getDeparturePort() { return departurePort; }
    public String getDestination() { return destination; }
    public int getDurationDays() { return durationDays; }
    public String getCabinType() { return cabinType; }
    public double getBaseFare() { return baseFare; }
}
"""
with open(model_dir + "CruiseResult.java", "w", encoding="utf-8") as f:
    f.write(cruise_result_java)

cruise_passenger_java = """package com.voyastra.model;

public class CruisePassenger {
    private String name;
    private int age;
    private String gender;
    private String passportNumber;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getPassportNumber() { return passportNumber; }
    public void setPassportNumber(String passportNumber) { this.passportNumber = passportNumber; }
}
"""
with open(model_dir + "CruisePassenger.java", "w", encoding="utf-8") as f:
    f.write(cruise_passenger_java)

cruise_booking_java = """package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class CruiseBooking {
    private String id;
    private int userId;
    private String shipName;
    private String cruiseLine;
    private String cabinType;
    private String departurePort;
    private String destination;
    private String cruiseDate;
    private int durationDays;
    private int paxCount;
    private double amount;
    private String status;
    private List<CruisePassenger> passengers = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getShipName() { return shipName; }
    public void setShipName(String shipName) { this.shipName = shipName; }
    public String getCruiseLine() { return cruiseLine; }
    public void setCruiseLine(String cruiseLine) { this.cruiseLine = cruiseLine; }
    public String getCabinType() { return cabinType; }
    public void setCabinType(String cabinType) { this.cabinType = cabinType; }
    public String getDeparturePort() { return departurePort; }
    public void setDeparturePort(String departurePort) { this.departurePort = departurePort; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public String getCruiseDate() { return cruiseDate; }
    public void setCruiseDate(String cruiseDate) { this.cruiseDate = cruiseDate; }
    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }
    public int getPaxCount() { return paxCount; }
    public void setPaxCount(int paxCount) { this.paxCount = paxCount; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<CruisePassenger> getPassengers() { return passengers; }
    public void setPassengers(List<CruisePassenger> passengers) { this.passengers = passengers; }
}
"""
with open(model_dir + "CruiseBooking.java", "w", encoding="utf-8") as f:
    f.write(cruise_booking_java)


# 3. DAOs
cruise_dao_java = """package com.voyastra.dao;

import com.voyastra.model.CruiseResult;
import java.util.ArrayList;
import java.util.List;

public class CruiseDAO {
    public List<CruiseResult> searchCruises(String cabinTypeReq) {
        List<CruiseResult> list = new ArrayList<>();
        // Mock data
        list.add(new CruiseResult("CRZ-01", "Empress", "Cordelia Cruises", "Mumbai", "Goa", 3, "Interior", 15000.0));
        list.add(new CruiseResult("CRZ-02", "Spectrum of the Seas", "Royal Caribbean", "Singapore", "Penang", 4, "Ocean View", 45000.0));
        list.add(new CruiseResult("CRZ-03", "Diamond Princess", "Princess Cruises", "Yokohama", "Okinawa", 7, "Balcony", 85000.0));
        list.add(new CruiseResult("CRZ-04", "Costa Serena", "Costa Cruises", "Mumbai", "Lakshadweep", 5, "Suite", 120000.0));

        if (cabinTypeReq != null && !cabinTypeReq.isEmpty() && !cabinTypeReq.equalsIgnoreCase("All")) {
            List<CruiseResult> filtered = new ArrayList<>();
            for (CruiseResult c : list) {
                // Simplified mocking: assume if they requested a specific cabin type, we just adjust our mock to pretend it has that cabin available.
                filtered.add(new CruiseResult(c.getId(), c.getShipName(), c.getCruiseLine(), c.getDeparturePort(), c.getDestination(), c.getDurationDays(), cabinTypeReq, c.getBaseFare()));
            }
            return filtered;
        }

        return list;
    }

    public CruiseResult getCruiseById(String id, String cabinType) {
        if ("CRZ-01".equals(id)) return new CruiseResult("CRZ-01", "Empress", "Cordelia Cruises", "Mumbai", "Goa", 3, cabinType, 15000.0);
        if ("CRZ-02".equals(id)) return new CruiseResult("CRZ-02", "Spectrum of the Seas", "Royal Caribbean", "Singapore", "Penang", 4, cabinType, 45000.0);
        if ("CRZ-03".equals(id)) return new CruiseResult("CRZ-03", "Diamond Princess", "Princess Cruises", "Yokohama", "Okinawa", 7, cabinType, 85000.0);
        return new CruiseResult("CRZ-04", "Costa Serena", "Costa Cruises", "Mumbai", "Lakshadweep", 5, cabinType, 120000.0);
    }
}
"""
with open(dao_dir + "CruiseDAO.java", "w", encoding="utf-8") as f:
    f.write(cruise_dao_java)


cruise_booking_dao_java = """package com.voyastra.dao;

import com.voyastra.model.CruiseBooking;
import com.voyastra.model.CruisePassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CruiseBookingDAO {
    
    public boolean saveBooking(CruiseBooking booking) {
        String insertBooking = "INSERT INTO cruise_bookings (id, user_id, ship_name, cruise_line, cabin_type, departure_port, destination, cruise_date, duration_days, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO cruise_passengers (booking_id, name, age, gender, passport_number) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getShipName());
                ps.setString(4, booking.getCruiseLine());
                ps.setString(5, booking.getCabinType());
                ps.setString(6, booking.getDeparturePort());
                ps.setString(7, booking.getDestination());
                ps.setString(8, booking.getCruiseDate());
                ps.setInt(9, booking.getDurationDays());
                ps.setDouble(10, booking.getAmount());
                ps.setString(11, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertPassenger)) {
                for (CruisePassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setInt(3, p.getAge());
                    ps.setString(4, p.getGender());
                    ps.setString(5, p.getPassportNumber());
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

    public List<CruiseBooking> getBookingsByUserId(int userId) {
        List<CruiseBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM cruise_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CruiseBooking b = new CruiseBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setShipName(rs.getString("ship_name"));
                    b.setCruiseLine(rs.getString("cruise_line"));
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
with open(dao_dir + "CruiseBookingDAO.java", "w", encoding="utf-8") as f:
    f.write(cruise_booking_dao_java)


# 4. Servlets
cruise_servlet_java = """package com.voyastra.servlet.transport;

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
"""
with open(servlet_dir + "CruiseServlet.java", "w", encoding="utf-8") as f:
    f.write(cruise_servlet_java)


cruise_booking_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.CruiseDAO;
import com.voyastra.model.CruiseBooking;
import com.voyastra.model.CruisePassenger;
import com.voyastra.model.CruiseResult;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/transport/cruise/booking")
public class CruiseBookingServlet extends HttpServlet {
    private CruiseDAO cruiseDAO;

    @Override
    public void init() {
        cruiseDAO = new CruiseDAO();
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
        String cruiseId = request.getParameter("cruiseId");
        String cabinType = request.getParameter("cabinType");
        int paxCount = Integer.parseInt(request.getParameter("paxCount"));
        String departurePort = request.getParameter("departurePort");
        String destination = request.getParameter("destination");
        String cruiseDate = request.getParameter("cruiseDate");

        CruiseResult cruise = cruiseDAO.getCruiseById(cruiseId, cabinType);

        CruiseBooking draft = new CruiseBooking();
        draft.setId("CRZ-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setShipName(cruise.getShipName());
        draft.setCruiseLine(cruise.getCruiseLine());
        draft.setCabinType(cruise.getCabinType());
        draft.setDeparturePort(departurePort);
        draft.setDestination(destination);
        draft.setCruiseDate(cruiseDate);
        draft.setDurationDays(cruise.getDurationDays());
        draft.setPaxCount(paxCount);
        
        // Multiplier based on cabin class for mock realism
        double multiplier = 1.0;
        if ("Ocean View".equals(cabinType)) multiplier = 1.2;
        if ("Balcony".equals(cabinType)) multiplier = 1.5;
        if ("Suite".equals(cabinType)) multiplier = 2.5;

        draft.setAmount((cruise.getBaseFare() * multiplier) * paxCount);
        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentCruiseBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/cruise-passengers.jsp");
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CruiseBooking draft = (CruiseBooking) request.getSession().getAttribute("currentCruiseBooking");
        if (draft != null) {
            List<CruisePassenger> passengers = new ArrayList<>();
            for (int i = 0; i < draft.getPaxCount(); i++) {
                String name = request.getParameter("name_" + i);
                int age = Integer.parseInt(request.getParameter("age_" + i));
                String gender = request.getParameter("gender_" + i);
                String passport = request.getParameter("passport_" + i);

                CruisePassenger p = new CruisePassenger();
                p.setName(name);
                p.setAge(age);
                p.setGender(gender);
                p.setPassportNumber(passport);
                passengers.add(p);
            }
            draft.setPassengers(passengers);
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/cruise-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/transport/cruise-payment.jsp");
    }
}
"""
with open(servlet_dir + "CruiseBookingServlet.java", "w", encoding="utf-8") as f:
    f.write(cruise_booking_servlet_java)


cruise_payment_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.CruiseBookingDAO;
import com.voyastra.model.CruiseBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cruise/payment-callback")
public class CruisePaymentServlet extends HttpServlet {
    private CruiseBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new CruiseBookingDAO();
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

        CruiseBooking draft = (CruiseBooking) request.getSession().getAttribute("currentCruiseBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            if (bookingDAO.saveBooking(draft)) {
                response.sendRedirect(request.getContextPath() + "/transport/cruise/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
"""
with open(servlet_dir + "CruisePaymentServlet.java", "w", encoding="utf-8") as f:
    f.write(cruise_payment_servlet_java)


cruise_confirmation_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.model.CruiseBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/cruise/confirmation")
public class CruiseConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CruiseBooking confirmedBooking = (CruiseBooking) request.getSession().getAttribute("currentCruiseBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/cruise-confirmation.jsp").forward(request, response);
    }
}
"""
with open(servlet_dir + "CruiseConfirmationServlet.java", "w", encoding="utf-8") as f:
    f.write(cruise_confirmation_servlet_java)


# 5. JSPs
cruise_search_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="search-form-container bg-gray-900 bg-opacity-70 backdrop-blur-md p-8 rounded-xl border border-gray-700 w-full animate-fade-in-up">
    <h2 class="text-3xl font-bold text-white mb-6">🚢 Cruise Holidays</h2>
    
    <form action="${pageContext.request.contextPath}/transport/cruise/search" method="post" class="grid grid-cols-1 md:grid-cols-5 gap-6">
        
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">DEPARTURE PORT</label>
            <input type="text" name="departurePort" placeholder="e.g. Mumbai" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-cyan-500 outline-none transition">
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">DESTINATION</label>
            <input type="text" name="destination" placeholder="e.g. Goa" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-cyan-500 outline-none transition">
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">CRUISE DATE</label>
            <input type="date" name="cruiseDate" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-cyan-500 outline-none transition">
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">CABIN TYPE</label>
            <select name="cabinType" class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-cyan-500 outline-none transition">
                <option value="Interior">Interior</option>
                <option value="Ocean View">Ocean View</option>
                <option value="Balcony">Balcony</option>
                <option value="Suite">Suite</option>
            </select>
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">PASSENGERS</label>
            <select name="paxCount" class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-cyan-500 outline-none transition">
                <option value="1">1 Passenger</option>
                <option value="2" selected>2 Passengers</option>
                <option value="3">3 Passengers</option>
                <option value="4">4 Passengers</option>
            </select>
        </div>

        <div class="md:col-span-5 flex justify-center mt-4">
            <button type="submit" class="w-full md:w-auto text-xl font-bold py-4 px-16 rounded-full shadow-lg transform hover:-translate-y-1 transition duration-300 text-gray-900" style="background-color: #06b6d4;">
                SEARCH CRUISES
            </button>
        </div>
    </form>
</div>
"""
with open(webapp_dir + "cruise-search.jsp", "w", encoding="utf-8") as f:
    f.write(cruise_search_jsp)

cruise_results_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-cyan-400 font-bold">${departurePort} ➡ ${destination}</span>
            </div>
            <div class="text-sm">
                ${cruiseDate} &nbsp; | &nbsp; ${paxCount} Passenger(s) &nbsp; | &nbsp; ${cabinType}
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Sailings</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="cruise" items="${cruiseResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-cyan-500 transition">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${cruise.shipName}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${cruise.cruiseLine}</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>🌙 ${cruise.durationDays} Nights</span>
                        <span>🛏️ ${cruise.cabinType} Cabin</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/cruise/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="cruiseId" value="${cruise.id}">
                        <input type="hidden" name="cabinType" value="${cabinType}">
                        <input type="hidden" name="paxCount" value="${paxCount}">
                        <input type="hidden" name="departurePort" value="${departurePort}">
                        <input type="hidden" name="destination" value="${destination}">
                        <input type="hidden" name="cruiseDate" value="${cruiseDate}">
                        <button type="submit" class="w-full hover:bg-cyan-600 text-gray-900 font-bold py-3 rounded transition" style="background-color: #06b6d4;">
                            Select Cabin
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "cruise-results.jsp", "w", encoding="utf-8") as f:
    f.write(cruise_results_jsp)

cruise_passengers_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Passenger Details</h1>
            
            <div class="bg-gray-800 p-4 rounded mb-6 border border-gray-700 flex justify-between">
                <div>
                    <p class="text-cyan-400 font-bold text-lg">${currentCruiseBooking.shipName} (${currentCruiseBooking.cruiseLine})</p>
                    <p class="text-gray-300 text-sm">Sailing: ${currentCruiseBooking.cruiseDate} | ${currentCruiseBooking.durationDays} Nights</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Cabin</p>
                    <p class="text-white font-bold">${currentCruiseBooking.cabinType}</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/transport/cruise/booking" method="post">
                <input type="hidden" name="action" value="passengers">
                
                <c:forEach var="i" begin="0" end="${currentCruiseBooking.paxCount - 1}">
                    <div class="mb-6 border border-gray-700 rounded-lg p-5 bg-gray-900">
                        <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Passenger ${i + 1}</h3>
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div class="md:col-span-2">
                                <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                                <input type="text" name="name_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Age</label>
                                <input type="number" name="age_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Gender</label>
                                <select name="gender_${i}" class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                </select>
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-gray-400 text-sm mb-1">Passport Number / Govt ID</label>
                                <input type="text" name="passport_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-cyan-500 outline-none">
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <div class="text-right">
                    <button type="submit" class="text-gray-900 py-3 px-8 rounded-lg font-bold transition" style="background-color: #06b6d4;">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "cruise-passengers.jsp", "w", encoding="utf-8") as f:
    f.write(cruise_passengers_jsp)


cruise_review_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">⚓ Review Cruise Itinerary</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-4">Sailing Details</h2>
                        <div class="space-y-2">
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Vessel:</span> <strong class="text-white">${currentCruiseBooking.shipName}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Route:</span> <strong class="text-white">${currentCruiseBooking.departurePort} to ${currentCruiseBooking.destination}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Departure:</span> <strong class="text-white">${currentCruiseBooking.cruiseDate}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Duration:</span> <strong class="text-white">${currentCruiseBooking.durationDays} Nights</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Cabin:</span> <strong class="text-white">${currentCruiseBooking.cabinType}</strong></p>
                        </div>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-lg font-bold text-white mb-4">Guest Manifest (${currentCruiseBooking.paxCount} Pax)</h2>
                        <ul class="space-y-3">
                            <c:forEach var="p" items="${currentCruiseBooking.passengers}" varStatus="status">
                                <li class="flex justify-between border-b border-gray-700 pb-2">
                                    <span class="text-gray-300">${status.index + 1}. ${p.name} (${p.age} yrs, ${p.gender})</span>
                                    <span class="text-gray-500 text-sm">Passport: ${p.passportNumber}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Fare Breakdown</h2>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Cabin Fare</span>
                            <span>₹${currentCruiseBooking.amount}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-2">
                            <span>Port Taxes</span>
                            <span>₹${currentCruiseBooking.paxCount * 2500}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Gratuities</span>
                            <span>Included</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${currentCruiseBooking.amount + (currentCruiseBooking.paxCount * 2500)}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/cruise/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="w-full py-3 rounded-lg font-bold text-lg text-gray-900 transition" style="background-color: #06b6d4;">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "cruise-review.jsp", "w", encoding="utf-8") as f:
    f.write(cruise_review_jsp)

cruise_payment_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-2xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center;">
            <h1 class="text-2xl font-bold text-white mb-4">💳 Cruise Payment</h1>
            <p class="text-gray-400 mb-8">Secure your cabin by completing the payment.</p>
            
            <c:set var="totalAmount" value="${currentCruiseBooking.amount + (currentCruiseBooking.paxCount * 2500)}" />

            <div class="bg-gray-800 p-6 rounded-lg mb-8 border border-gray-700">
                <h2 class="text-lg text-white mb-2">Total Amount Payable</h2>
                <p class="text-4xl font-bold text-green-400">₹${totalAmount}</p>
            </div>

            <button id="rzp-button1" class="w-full py-4 rounded-lg font-bold text-xl uppercase tracking-wider text-gray-900 transition" style="background-color: #06b6d4;">Pay Now</button>

            <form id="razorpayForm" action="${pageContext.request.contextPath}/transport/cruise/payment-callback" method="POST" style="display: none;">
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
            body: 'amount=' + ${totalAmount} + '&receipt=${currentCruiseBooking.id}'
        })
        .then(response => response.json())
        .then(orderData => {
            var options = {
                "key": "rzp_test_YourKeyIdHere", 
                "amount": orderData.amount,
                "currency": "INR",
                "name": "Voyastra Cruises",
                "description": "Cruise Cabin Booking",
                "order_id": orderData.id,
                "handler": function (response){
                    document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                    document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                    document.getElementById('razorpay_signature').value = response.razorpay_signature;
                    document.getElementById('razorpayForm').submit();
                },
                "prefill": {
                    "name": "${currentCruiseBooking.passengers[0].name}"
                },
                "theme": { "color": "#06b6d4" } // Cyan accent for cruises
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
with open(webapp_dir + "cruise-payment.jsp", "w", encoding="utf-8") as f:
    f.write(cruise_payment_jsp)

cruise_confirmation_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-white">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Cruise Booking Confirmed!</h1>
            <p class="text-gray-400">Your cabin is secured. Please prepare your passports for boarding.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking Reference</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Ship</p>
                    <p class="text-xl font-mono text-cyan-400 font-bold">${booking.shipName}</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-6">
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Embarkation</p>
                    <p class="text-white">${booking.departurePort}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.cruiseDate}</p>
                </div>
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Itinerary</p>
                    <p class="text-white">${booking.destination}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.durationDays} Nights</p>
                </div>
            </div>

            <div class="flex justify-center gap-4 mt-8">
                <a href="${pageContext.request.contextPath}/pages/transport/cruise-ticket.jsp" target="_blank" class="px-6 py-3 text-gray-900 rounded-lg font-bold flex items-center gap-2 transition" style="background-color: #06b6d4;">
                    <span>🎫</span> Download Boarding Pass
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
with open(webapp_dir + "cruise-confirmation.jsp", "w", encoding="utf-8") as f:
    f.write(cruise_confirmation_jsp)

cruise_ticket_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cruise E-Ticket - ${currentCruiseBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #f9fafb; color: #111827; }
        .receipt-card { max-width: 700px; margin: 0 auto; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 10px solid #06b6d4; }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #06b6d4; }
        .ref { text-align: right; }
        .ref-id { font-size: 18px; font-weight: bold; font-family: monospace; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .info-block { background: #f9fafb; padding: 15px; border-radius: 8px; }
        .label { font-size: 12px; color: #6b7280; text-transform: uppercase; font-weight: bold; margin-bottom: 5px; }
        .val { font-size: 16px; font-weight: bold; }
        .manifest-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .manifest-table th, .manifest-table td { padding: 10px; text-align: left; border-bottom: 1px solid #e5e7eb; }
        .manifest-table th { background: #f9fafb; font-size: 12px; text-transform: uppercase; color: #6b7280; }
        .total-row { display: flex; justify-content: space-between; font-size: 20px; font-weight: bold; border-top: 2px solid #f3f4f6; padding-top: 20px; }
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #06b6d4; color: #fff; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { background: #fff; padding: 0; } .receipt-card { box-shadow: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚢 Voyastra Cruises</div>
            <div class="ref">
                <div class="label">Booking Ref</div>
                <div class="ref-id">${currentCruiseBooking.id}</div>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Vessel</div>
                <div class="val">${currentCruiseBooking.shipName} (${currentCruiseBooking.cruiseLine})</div>
            </div>
            <div class="info-block">
                <div class="label">Cabin Details</div>
                <div class="val">${currentCruiseBooking.cabinType}</div>
            </div>
            <div class="info-block">
                <div class="label">Embarkation Port</div>
                <div class="val">${currentCruiseBooking.departurePort}</div>
            </div>
            <div class="info-block">
                <div class="label">Sailing Date</div>
                <div class="val">${currentCruiseBooking.cruiseDate} (${currentCruiseBooking.durationDays} Nights)</div>
            </div>
        </div>

        <div class="label">Passenger Manifest</div>
        <table class="manifest-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Age</th>
                    <th>Gender</th>
                    <th>Passport/ID</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${currentCruiseBooking.passengers}">
                    <tr>
                        <td>${p.name}</td>
                        <td>${p.age}</td>
                        <td>${p.gender}</td>
                        <td>${p.passportNumber}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="total-row">
            <span>Total Paid Amount</span>
            <span style="color: #059669;">Rs. ${currentCruiseBooking.amount + (currentCruiseBooking.paxCount * 2500)}</span>
        </div>

        <p style="text-align: center; color: #ef4444; font-size: 12px; margin-top: 40px; font-weight: bold;">
            Gates close 2 hours prior to departure. Original passports are mandatory for international waters.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print E-Ticket</button>
</body>
</html>
"""
with open(webapp_dir + "cruise-ticket.jsp", "w", encoding="utf-8") as f:
    f.write(cruise_ticket_jsp)

print("Phase 10 generation complete!")
