import os

base_dir = "c:/Users/Dell/Desktop/antigravity/"
sql_dir = base_dir + "sql/"
src_main_java = base_dir + "src/main/java/com/voyastra/"
model_dir = src_main_java + "model/"
dao_dir = src_main_java + "dao/"
servlet_dir = src_main_java + "servlet/transport/"
webapp_dir = base_dir + "src/main/webapp/pages/transport/"

# 1. SQL
helicopter_sql = """CREATE TABLE IF NOT EXISTS helicopter_bookings (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    operator VARCHAR(100),
    flight_type VARCHAR(50),
    origin VARCHAR(255),
    destination VARCHAR(255),
    travel_date VARCHAR(50),
    travel_time VARCHAR(50),
    amount DOUBLE,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS helicopter_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    weight_kg DOUBLE,
    FOREIGN KEY (booking_id) REFERENCES helicopter_bookings(id) ON DELETE CASCADE
);
"""
with open(sql_dir + "helicopter_tables.sql", "w", encoding="utf-8") as f:
    f.write(helicopter_sql)

# 2. Models
helicopter_result_java = """package com.voyastra.model;

public class HelicopterResult {
    private String id;
    private String operator;
    private String type; // Shared or Private
    private int capacity;
    private double baseFare;
    private String origin;
    private String destination;
    private String eta;

    public HelicopterResult() {}

    public HelicopterResult(String id, String operator, String type, int capacity, double baseFare, String origin, String destination, String eta) {
        this.id = id;
        this.operator = operator;
        this.type = type;
        this.capacity = capacity;
        this.baseFare = baseFare;
        this.origin = origin;
        this.destination = destination;
        this.eta = eta;
    }

    public String getId() { return id; }
    public String getOperator() { return operator; }
    public String getType() { return type; }
    public int getCapacity() { return capacity; }
    public double getBaseFare() { return baseFare; }
    public String getOrigin() { return origin; }
    public String getDestination() { return destination; }
    public String getEta() { return eta; }
}
"""
with open(model_dir + "HelicopterResult.java", "w", encoding="utf-8") as f:
    f.write(helicopter_result_java)

helicopter_passenger_java = """package com.voyastra.model;

public class HelicopterPassenger {
    private String name;
    private double weightKg;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getWeightKg() { return weightKg; }
    public void setWeightKg(double weightKg) { this.weightKg = weightKg; }
}
"""
with open(model_dir + "HelicopterPassenger.java", "w", encoding="utf-8") as f:
    f.write(helicopter_passenger_java)

helicopter_booking_java = """package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class HelicopterBooking {
    private String id;
    private int userId;
    private String operator;
    private String flightType;
    private String origin;
    private String destination;
    private String travelDate;
    private String travelTime;
    private int paxCount;
    private double amount;
    private String status;
    private List<HelicopterPassenger> passengers = new ArrayList<>();

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getOperator() { return operator; }
    public void setOperator(String operator) { this.operator = operator; }
    public String getFlightType() { return flightType; }
    public void setFlightType(String flightType) { this.flightType = flightType; }
    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public String getTravelDate() { return travelDate; }
    public void setTravelDate(String travelDate) { this.travelDate = travelDate; }
    public String getTravelTime() { return travelTime; }
    public void setTravelTime(String travelTime) { this.travelTime = travelTime; }
    public int getPaxCount() { return paxCount; }
    public void setPaxCount(int paxCount) { this.paxCount = paxCount; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<HelicopterPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<HelicopterPassenger> passengers) { this.passengers = passengers; }
}
"""
with open(model_dir + "HelicopterBooking.java", "w", encoding="utf-8") as f:
    f.write(helicopter_booking_java)


# 3. DAOs
helicopter_dao_java = """package com.voyastra.dao;

import com.voyastra.model.HelicopterResult;
import java.util.ArrayList;
import java.util.List;

public class HelicopterDAO {
    public List<HelicopterResult> searchFlights(String origin, String destination, String flightType) {
        List<HelicopterResult> list = new ArrayList<>();
        
        // Mock data
        if ("Shared".equalsIgnoreCase(flightType)) {
            list.add(new HelicopterResult("HELI-01", "Pawan Hans", "Shared", 5, 8500.0, origin, destination, "08:30 AM"));
            list.add(new HelicopterResult("HELI-02", "Heritage Aviation", "Shared", 6, 9200.0, origin, destination, "10:15 AM"));
        } else {
            list.add(new HelicopterResult("HELI-03", "Blade India", "Private", 4, 150000.0, origin, destination, "Flexible"));
            list.add(new HelicopterResult("HELI-04", "Global Vectra", "Private", 6, 210000.0, origin, destination, "Flexible"));
        }
        return list;
    }

    public HelicopterResult getFlightById(String id) {
        if ("HELI-01".equals(id)) return new HelicopterResult("HELI-01", "Pawan Hans", "Shared", 5, 8500.0, "Any", "Any", "08:30 AM");
        if ("HELI-02".equals(id)) return new HelicopterResult("HELI-02", "Heritage Aviation", "Shared", 6, 9200.0, "Any", "Any", "10:15 AM");
        if ("HELI-03".equals(id)) return new HelicopterResult("HELI-03", "Blade India", "Private", 4, 150000.0, "Any", "Any", "Flexible");
        return new HelicopterResult("HELI-04", "Global Vectra", "Private", 6, 210000.0, "Any", "Any", "Flexible");
    }
}
"""
with open(dao_dir + "HelicopterDAO.java", "w", encoding="utf-8") as f:
    f.write(helicopter_dao_java)


helicopter_booking_dao_java = """package com.voyastra.dao;

import com.voyastra.model.HelicopterBooking;
import com.voyastra.model.HelicopterPassenger;
import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class HelicopterBookingDAO {
    
    public boolean saveBooking(HelicopterBooking booking) {
        String insertBooking = "INSERT INTO helicopter_bookings (id, user_id, operator, flight_type, origin, destination, travel_date, travel_time, amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertPassenger = "INSERT INTO helicopter_passengers (booking_id, name, weight_kg) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;
            
            try (PreparedStatement ps = conn.prepareStatement(insertBooking)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getOperator());
                ps.setString(4, booking.getFlightType());
                ps.setString(5, booking.getOrigin());
                ps.setString(6, booking.getDestination());
                ps.setString(7, booking.getTravelDate());
                ps.setString(8, booking.getTravelTime());
                ps.setDouble(9, booking.getAmount());
                ps.setString(10, booking.getStatus());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(insertPassenger)) {
                for (HelicopterPassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setDouble(3, p.getWeightKg());
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

    public List<HelicopterBooking> getBookingsByUserId(int userId) {
        List<HelicopterBooking> list = new ArrayList<>();
        String sql = "SELECT * FROM helicopter_bookings WHERE user_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HelicopterBooking b = new HelicopterBooking();
                    b.setId(rs.getString("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setOperator(rs.getString("operator"));
                    b.setFlightType(rs.getString("flight_type"));
                    b.setOrigin(rs.getString("origin"));
                    b.setDestination(rs.getString("destination"));
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
with open(dao_dir + "HelicopterBookingDAO.java", "w", encoding="utf-8") as f:
    f.write(helicopter_booking_dao_java)


# 4. Servlets
helicopter_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.HelicopterDAO;
import com.voyastra.model.HelicopterResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/transport/helicopter/search")
public class HelicopterServlet extends HttpServlet {
    private HelicopterDAO heliDAO;

    @Override
    public void init() {
        heliDAO = new HelicopterDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        String flightType = request.getParameter("flightType");
        int paxCount = Integer.parseInt(request.getParameter("paxCount"));

        List<HelicopterResult> results = heliDAO.searchFlights(origin, destination, flightType);
        
        request.setAttribute("heliResults", results);
        request.setAttribute("origin", origin);
        request.setAttribute("destination", destination);
        request.setAttribute("travelDate", travelDate);
        request.setAttribute("flightType", flightType);
        request.setAttribute("paxCount", paxCount);

        request.getRequestDispatcher("/pages/transport/helicopter-results.jsp").forward(request, response);
    }
}
"""
with open(servlet_dir + "HelicopterServlet.java", "w", encoding="utf-8") as f:
    f.write(helicopter_servlet_java)


helicopter_booking_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.HelicopterDAO;
import com.voyastra.model.HelicopterBooking;
import com.voyastra.model.HelicopterPassenger;
import com.voyastra.model.HelicopterResult;
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

@WebServlet("/transport/helicopter/booking")
public class HelicopterBookingServlet extends HttpServlet {
    private HelicopterDAO heliDAO;

    @Override
    public void init() {
        heliDAO = new HelicopterDAO();
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
        String heliId = request.getParameter("heliId");
        int paxCount = Integer.parseInt(request.getParameter("paxCount"));
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        
        HelicopterResult flight = heliDAO.getFlightById(heliId);

        HelicopterBooking draft = new HelicopterBooking();
        draft.setId("HEL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setUserId(user.getId());
        draft.setOperator(flight.getOperator());
        draft.setFlightType(flight.getType());
        draft.setOrigin(origin);
        draft.setDestination(destination);
        draft.setTravelDate(travelDate);
        draft.setTravelTime(flight.getEta());
        draft.setPaxCount(paxCount);

        // Crucial logic: Shared is per pax, Private is flat rate
        if ("Shared".equalsIgnoreCase(flight.getType())) {
            draft.setAmount(flight.getBaseFare() * paxCount);
        } else {
            draft.setAmount(flight.getBaseFare());
        }

        draft.setStatus("DRAFT");

        request.getSession().setAttribute("currentHeliBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/helicopter-passengers.jsp");
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HelicopterBooking draft = (HelicopterBooking) request.getSession().getAttribute("currentHeliBooking");
        if (draft != null) {
            List<HelicopterPassenger> passengers = new ArrayList<>();
            for (int i = 0; i < draft.getPaxCount(); i++) {
                String name = request.getParameter("name_" + i);
                double weight = Double.parseDouble(request.getParameter("weight_" + i));

                HelicopterPassenger p = new HelicopterPassenger();
                p.setName(name);
                p.setWeightKg(weight);
                passengers.add(p);
            }
            draft.setPassengers(passengers);
            
            // If private charter, also capture the preferred time
            if ("Private".equalsIgnoreCase(draft.getFlightType())) {
                String prefTime = request.getParameter("prefTime");
                if (prefTime != null && !prefTime.isEmpty()) {
                    draft.setTravelTime(prefTime);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/helicopter-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/transport/helicopter-payment.jsp");
    }
}
"""
with open(servlet_dir + "HelicopterBookingServlet.java", "w", encoding="utf-8") as f:
    f.write(helicopter_booking_servlet_java)


helicopter_payment_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.HelicopterBookingDAO;
import com.voyastra.model.HelicopterBooking;
import com.voyastra.util.RazorpayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/helicopter/payment-callback")
public class HelicopterPaymentServlet extends HttpServlet {
    private HelicopterBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new HelicopterBookingDAO();
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

        HelicopterBooking draft = (HelicopterBooking) request.getSession().getAttribute("currentHeliBooking");
        if (draft != null) {
            draft.setStatus("CONFIRMED");
            if (bookingDAO.saveBooking(draft)) {
                response.sendRedirect(request.getContextPath() + "/transport/helicopter/confirmation");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Failed%20to%20save%20booking");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/error.jsp?msg=Session%20Expired");
        }
    }
}
"""
with open(servlet_dir + "HelicopterPaymentServlet.java", "w", encoding="utf-8") as f:
    f.write(helicopter_payment_servlet_java)


helicopter_confirmation_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.model.HelicopterBooking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/transport/helicopter/confirmation")
public class HelicopterConfirmationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HelicopterBooking confirmedBooking = (HelicopterBooking) request.getSession().getAttribute("currentHeliBooking");
        if (confirmedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        request.setAttribute("booking", confirmedBooking);
        request.getRequestDispatcher("/pages/transport/helicopter-confirmation.jsp").forward(request, response);
    }
}
"""
with open(servlet_dir + "HelicopterConfirmationServlet.java", "w", encoding="utf-8") as f:
    f.write(helicopter_confirmation_servlet_java)


# 5. JSPs
helicopter_search_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="search-form-container bg-gray-900 bg-opacity-70 backdrop-blur-md p-8 rounded-xl border border-gray-700 w-full animate-fade-in-up">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold text-white">🚁 Helicopter Charter</h2>
        <span class="bg-yellow-500 text-gray-900 text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wide">Premium</span>
    </div>
    
    <form action="${pageContext.request.contextPath}/transport/helicopter/search" method="post" class="grid grid-cols-1 md:grid-cols-5 gap-6">
        
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">ORIGIN</label>
            <input type="text" name="origin" placeholder="e.g. Dehradun" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-yellow-500 outline-none transition">
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">DESTINATION</label>
            <input type="text" name="destination" placeholder="e.g. Kedarnath" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-yellow-500 outline-none transition">
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">TRAVEL DATE</label>
            <input type="date" name="travelDate" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-yellow-500 outline-none transition">
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">FLIGHT CLASS</label>
            <select name="flightType" class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-yellow-500 outline-none transition">
                <option value="Shared">Shared Shuttle</option>
                <option value="Private">Private Charter</option>
            </select>
        </div>

        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">PASSENGERS</label>
            <select name="paxCount" class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-yellow-500 outline-none transition">
                <option value="1">1 Passenger</option>
                <option value="2">2 Passengers</option>
                <option value="3">3 Passengers</option>
                <option value="4">4 Passengers</option>
                <option value="5">5 Passengers</option>
            </select>
        </div>

        <div class="md:col-span-5 flex justify-center mt-4">
            <button type="submit" class="w-full md:w-auto text-xl font-bold py-4 px-16 rounded-full shadow-lg transform hover:-translate-y-1 transition duration-300 text-gray-900" style="background-color: #f59e0b;">
                FIND FLIGHTS
            </button>
        </div>
    </form>
</div>
"""
with open(webapp_dir + "helicopter-search.jsp", "w", encoding="utf-8") as f:
    f.write(helicopter_search_jsp)

helicopter_results_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl">
        <div class="mb-6 bg-gray-800 p-4 rounded-lg border border-gray-700 flex justify-between items-center text-gray-300">
            <div>
                <span class="text-yellow-500 font-bold">${origin} ➡ ${destination}</span>
            </div>
            <div class="text-sm">
                ${travelDate} &nbsp; | &nbsp; ${paxCount} Pax &nbsp; | &nbsp; ${flightType} Class
            </div>
        </div>
        
        <h2 class="text-2xl font-bold text-white mb-6">Available Choppers</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:forEach var="heli" items="${heliResults}">
                <div class="bg-gray-800 rounded-lg p-6 border border-gray-700 flex flex-col justify-between hover:border-yellow-500 transition relative overflow-hidden">
                    <c:if test="${heli.type == 'Private'}">
                        <div class="absolute top-0 right-0 bg-yellow-500 text-gray-900 text-xs font-bold px-3 py-1 rounded-bl-lg uppercase">Exclusive</div>
                    </c:if>

                    <div class="flex justify-between items-start mb-4 mt-2">
                        <div>
                            <h3 class="text-xl font-bold text-white mb-1">${heli.operator}</h3>
                            <p class="text-gray-400 text-sm font-bold bg-gray-700 inline-block px-2 py-1 rounded">${heli.type} Flight</p>
                        </div>
                        <div class="text-right">
                            <p class="text-2xl font-bold text-white">₹${heli.baseFare}</p>
                            <p class="text-xs text-gray-500 uppercase">${heli.type == 'Shared' ? 'Per Seat' : 'Total Charter'}</p>
                        </div>
                    </div>
                    
                    <div class="flex gap-4 text-gray-400 text-sm mb-6">
                        <span>🕒 ${heli.eta}</span>
                        <span>💺 Max Cap: ${heli.capacity} Pax</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/transport/helicopter/booking" method="post" class="mt-auto">
                        <input type="hidden" name="action" value="details">
                        <input type="hidden" name="heliId" value="${heli.id}">
                        <input type="hidden" name="paxCount" value="${paxCount}">
                        <input type="hidden" name="origin" value="${origin}">
                        <input type="hidden" name="destination" value="${destination}">
                        <input type="hidden" name="travelDate" value="${travelDate}">
                        <button type="submit" class="w-full hover:bg-yellow-600 text-gray-900 font-bold py-3 rounded transition" style="background-color: #f59e0b;">
                            Select Flight
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "helicopter-results.jsp", "w", encoding="utf-8") as f:
    f.write(helicopter_results_jsp)

helicopter_passengers_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div class="bg-yellow-500 bg-opacity-20 border border-yellow-500 rounded-lg p-4 mb-6 flex items-start gap-4">
            <span class="text-3xl">⚖️</span>
            <div>
                <h3 class="text-yellow-500 font-bold text-lg">Aviation Weight Restrictions Apply</h3>
                <p class="text-gray-300 text-sm">For rotary-wing aircraft safety, accurate passenger weights are mandatory. Standard baggage allowance is 2kg per person. Exceeding weight limits may result in boarding denial without refund.</p>
            </div>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">Flight Manifest</h1>
            
            <form action="${pageContext.request.contextPath}/transport/helicopter/booking" method="post">
                <input type="hidden" name="action" value="passengers">
                
                <c:if test="${currentHeliBooking.flightType == 'Private'}">
                    <div class="mb-6 p-5 bg-gray-900 rounded-lg border border-gray-700">
                        <h3 class="text-lg text-white mb-2 font-bold text-yellow-500">Private Charter Preferences</h3>
                        <label class="block text-gray-400 text-sm mb-1">Preferred Departure Time</label>
                        <input type="time" name="prefTime" class="bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                    </div>
                </c:if>

                <c:forEach var="i" begin="0" end="${currentHeliBooking.paxCount - 1}">
                    <div class="mb-6 border border-gray-700 rounded-lg p-5 bg-gray-900">
                        <h3 class="text-lg text-white mb-4 border-b border-gray-700 pb-2">Passenger ${i + 1}</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Full Name</label>
                                <input type="text" name="name_${i}" required class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                            </div>
                            <div>
                                <label class="block text-gray-400 text-sm mb-1">Exact Body Weight (in Kg)</label>
                                <input type="number" step="0.1" name="weight_${i}" required placeholder="e.g. 75.5" class="w-full bg-gray-800 border border-gray-700 text-white rounded p-3 focus:border-yellow-500 outline-none">
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <div class="text-right">
                    <button type="submit" class="text-gray-900 py-3 px-8 rounded-lg font-bold transition" style="background-color: #f59e0b;">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "helicopter-passengers.jsp", "w", encoding="utf-8") as f:
    f.write(helicopter_passengers_jsp)


helicopter_review_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">🚁 Review Flight Details</h1>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-4">Flight Itinerary</h2>
                        <div class="space-y-2">
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Operator:</span> <strong class="text-white">${currentHeliBooking.operator}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Route:</span> <strong class="text-white">${currentHeliBooking.origin} to ${currentHeliBooking.destination}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Date:</span> <strong class="text-white">${currentHeliBooking.travelDate}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Time:</span> <strong class="text-white">${currentHeliBooking.travelTime}</strong></p>
                            <p class="text-gray-300"><span class="text-gray-500 w-24 inline-block">Class:</span> <strong class="text-yellow-500">${currentHeliBooking.flightType}</strong></p>
                        </div>
                    </div>

                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-lg font-bold text-white mb-4">Passenger Manifest (${currentHeliBooking.paxCount} Pax)</h2>
                        <ul class="space-y-3">
                            <c:set var="totalWeight" value="0" />
                            <c:forEach var="p" items="${currentHeliBooking.passengers}" varStatus="status">
                                <c:set var="totalWeight" value="${totalWeight + p.weightKg}" />
                                <li class="flex justify-between border-b border-gray-700 pb-2">
                                    <span class="text-gray-300">${status.index + 1}. ${p.name}</span>
                                    <span class="text-gray-500 text-sm">Weight: ${p.weightKg} kg</span>
                                </li>
                            </c:forEach>
                        </ul>
                        <div class="mt-4 text-right">
                            <span class="text-gray-400 text-sm uppercase">Total Manifest Weight: </span>
                            <span class="text-white font-bold">${totalWeight} kg</span>
                        </div>
                    </div>
                </div>

                <!-- Fare Summary -->
                <div>
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 sticky top-24">
                        <h2 class="text-xl font-bold text-white mb-4">Fare Breakdown</h2>
                        <c:if test="${currentHeliBooking.flightType == 'Shared'}">
                            <div class="flex justify-between text-gray-300 mb-2">
                                <span>Per Seat Rate</span>
                                <span>₹${currentHeliBooking.amount / currentHeliBooking.paxCount}</span>
                            </div>
                            <div class="flex justify-between text-gray-300 mb-2">
                                <span>Seats</span>
                                <span>x ${currentHeliBooking.paxCount}</span>
                            </div>
                        </c:if>
                        <c:if test="${currentHeliBooking.flightType == 'Private'}">
                            <div class="flex justify-between text-gray-300 mb-2">
                                <span>Whole Charter</span>
                                <span>₹${currentHeliBooking.amount}</span>
                            </div>
                        </c:if>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Aviation Taxes</span>
                            <span>Included</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-yellow-500">₹${currentHeliBooking.amount}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/helicopter/booking" method="post">
                            <input type="hidden" name="action" value="review">
                            <button type="submit" class="w-full py-3 rounded-lg font-bold text-lg text-gray-900 transition" style="background-color: #f59e0b;">Proceed to Payment</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "helicopter-review.jsp", "w", encoding="utf-8") as f:
    f.write(helicopter_review_jsp)

helicopter_payment_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-2xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); text-align: center;">
            <h1 class="text-2xl font-bold text-white mb-4">💳 Flight Payment</h1>
            <p class="text-gray-400 mb-8">Secure your flight by completing the payment.</p>
            
            <div class="bg-gray-800 p-6 rounded-lg mb-8 border border-gray-700">
                <h2 class="text-lg text-white mb-2">Total Amount Payable</h2>
                <p class="text-4xl font-bold text-yellow-500">₹${currentHeliBooking.amount}</p>
            </div>

            <button id="rzp-button1" class="w-full py-4 rounded-lg font-bold text-xl uppercase tracking-wider text-gray-900 transition" style="background-color: #f59e0b;">Pay Now</button>

            <form id="razorpayForm" action="${pageContext.request.contextPath}/transport/helicopter/payment-callback" method="POST" style="display: none;">
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
            body: 'amount=' + ${currentHeliBooking.amount} + '&receipt=${currentHeliBooking.id}'
        })
        .then(response => response.json())
        .then(orderData => {
            var options = {
                "key": "rzp_test_YourKeyIdHere", 
                "amount": orderData.amount,
                "currency": "INR",
                "name": "Voyastra Aviation",
                "description": "${currentHeliBooking.flightType} Flight Booking",
                "order_id": orderData.id,
                "handler": function (response){
                    document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                    document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                    document.getElementById('razorpay_signature').value = response.razorpay_signature;
                    document.getElementById('razorpayForm').submit();
                },
                "prefill": {
                    "name": "${currentHeliBooking.passengers[0].name}"
                },
                "theme": { "color": "#f59e0b" } // Yellow accent for helicopters
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
with open(webapp_dir + "helicopter-payment.jsp", "w", encoding="utf-8") as f:
    f.write(helicopter_payment_jsp)

helicopter_confirmation_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-3xl">
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-yellow-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl text-gray-900">✓</span>
            </div>
            <h1 class="text-3xl font-bold text-white mb-2">Flight Confirmed!</h1>
            <p class="text-gray-400">Your helicopter booking is secured. Please arrive 45 mins early for weighing.</p>
        </div>

        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6 border-b border-gray-700 pb-4">
                <div>
                    <p class="text-gray-400 text-sm">Booking Reference</p>
                    <p class="text-xl font-mono text-white font-bold">${booking.id}</p>
                </div>
                <div class="text-right">
                    <p class="text-gray-400 text-sm">Operator</p>
                    <p class="text-xl font-mono text-yellow-500 font-bold">${booking.operator}</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-6">
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Origin</p>
                    <p class="text-white">${booking.origin}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.travelDate}</p>
                </div>
                <div class="bg-gray-800 p-4 rounded">
                    <p class="text-xs text-gray-500 uppercase font-bold">Destination</p>
                    <p class="text-white">${booking.destination}</p>
                    <p class="text-gray-400 text-sm mt-2">${booking.travelTime}</p>
                </div>
            </div>

            <div class="flex justify-center gap-4 mt-8">
                <a href="${pageContext.request.contextPath}/pages/transport/helicopter-ticket.jsp" target="_blank" class="px-6 py-3 text-gray-900 rounded-lg font-bold flex items-center gap-2 transition" style="background-color: #f59e0b;">
                    <span>🎫</span> Download Flight Voucher
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
with open(webapp_dir + "helicopter-confirmation.jsp", "w", encoding="utf-8") as f:
    f.write(helicopter_confirmation_jsp)

helicopter_ticket_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Charter Flight Voucher - ${currentHeliBooking.id}</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; padding: 40px; background: #f9fafb; color: #111827; }
        .receipt-card { max-width: 700px; margin: 0 auto; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-top: 10px solid #f59e0b; }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #f3f4f6; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: 800; color: #f59e0b; }
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
        .print-btn { display: block; width: 200px; margin: 40px auto; padding: 12px; background: #f59e0b; color: #111827; font-weight: bold; text-align: center; border: none; border-radius: 6px; cursor: pointer; }
        @media print { .print-btn { display: none; } body { background: #fff; padding: 0; } .receipt-card { box-shadow: none; padding: 0; } }
    </style>
</head>
<body>
    <div class="receipt-card">
        <div class="header">
            <div class="logo">🚁 Voyastra Aviation</div>
            <div class="ref">
                <div class="label">Booking Ref</div>
                <div class="ref-id">${currentHeliBooking.id}</div>
            </div>
        </div>

        <div style="text-align: center; font-size: 20px; font-weight: bold; margin-bottom: 20px; text-transform: uppercase;">
            ${currentHeliBooking.flightType} Flight Voucher
        </div>

        <div class="info-grid">
            <div class="info-block">
                <div class="label">Operator</div>
                <div class="val">${currentHeliBooking.operator}</div>
            </div>
            <div class="info-block">
                <div class="label">Route</div>
                <div class="val">${currentHeliBooking.origin} -> ${currentHeliBooking.destination}</div>
            </div>
            <div class="info-block">
                <div class="label">Date of Flight</div>
                <div class="val">${currentHeliBooking.travelDate}</div>
            </div>
            <div class="info-block">
                <div class="label">Time</div>
                <div class="val">${currentHeliBooking.travelTime}</div>
            </div>
        </div>

        <div class="label">Manifest & Weight Record</div>
        <table class="manifest-table">
            <thead>
                <tr>
                    <th>Passenger Name</th>
                    <th>Declared Weight</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="totalW" value="0" />
                <c:forEach var="p" items="${currentHeliBooking.passengers}">
                    <c:set var="totalW" value="${totalW + p.weightKg}" />
                    <tr>
                        <td>${p.name}</td>
                        <td>${p.weightKg} kg</td>
                    </tr>
                </c:forEach>
                <tr>
                    <td style="font-weight: bold; text-align: right;">Total Payload:</td>
                    <td style="font-weight: bold;">${totalW} kg</td>
                </tr>
            </tbody>
        </table>

        <div class="total-row">
            <span>Total Amount Paid</span>
            <span style="color: #059669;">Rs. ${currentHeliBooking.amount}</span>
        </div>

        <p style="text-align: center; color: #ef4444; font-size: 12px; margin-top: 40px; font-weight: bold;">
            NOTICE: Baggage strictly limited to 2kg per passenger in soft bags only. Weight variations at helipad may lead to de-boarding.
        </p>
    </div>

    <button class="print-btn" onclick="window.print()">Print Voucher</button>
</body>
</html>
"""
with open(webapp_dir + "helicopter-ticket.jsp", "w", encoding="utf-8") as f:
    f.write(helicopter_ticket_jsp)

print("Phase 11 generation complete!")
