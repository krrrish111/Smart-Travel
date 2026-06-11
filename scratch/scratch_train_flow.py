import os

base_dir = "c:/Users/Dell/Desktop/antigravity/src/main/java/com/voyastra/"
models_dir = base_dir + "model/"
daos_dir = base_dir + "dao/"
servlets_dir = base_dir + "servlet/transport/"
webapp_dir = "c:/Users/Dell/Desktop/antigravity/src/main/webapp/pages/transport/"

# TrainPassenger.java
train_passenger_java = """package com.voyastra.model;

public class TrainPassenger {
    private String name;
    private int age;
    private String gender;
    private String berthPreference;

    public TrainPassenger() {}

    public TrainPassenger(String name, int age, String gender, String berthPreference) {
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.berthPreference = berthPreference;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getBerthPreference() { return berthPreference; }
    public void setBerthPreference(String berthPreference) { this.berthPreference = berthPreference; }
}
"""

with open(models_dir + "TrainPassenger.java", "w", encoding="utf-8") as f:
    f.write(train_passenger_java)

# TrainBooking.java modifications (Since it exists, we will read and rewrite it)
# We will use simple rewrite for TrainBooking to include passengers list, id, userId, trainNo, status
train_booking_java = """package com.voyastra.model;

import java.util.ArrayList;
import java.util.List;

public class TrainBooking {
    private String id;
    private int userId;
    private String trainNumber;
    private double fare;
    private String status; // DRAFT, CONFIRMED, CANCELLED
    private List<TrainPassenger> passengers = new ArrayList<>();

    public TrainBooking() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTrainNumber() { return trainNumber; }
    public void setTrainNumber(String trainNumber) { this.trainNumber = trainNumber; }

    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<TrainPassenger> getPassengers() { return passengers; }
    public void setPassengers(List<TrainPassenger> passengers) { this.passengers = passengers; }
    public void addPassenger(TrainPassenger p) { this.passengers.add(p); }
}
"""

with open(models_dir + "TrainBooking.java", "w", encoding="utf-8") as f:
    f.write(train_booking_java)

# TrainBookingDAO.java (Rewriting it entirely to support DB saving)
train_booking_dao_java = """package com.voyastra.dao;

import com.voyastra.model.TrainBooking;
import com.voyastra.model.TrainPassenger;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TrainBookingDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/voyastra";
    private String jdbcUsername = "root";
    private String jdbcPassword = ""; // Adjust password if necessary

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return connection;
    }

    public boolean saveDraft(TrainBooking booking) {
        String insertBookingSql = "INSERT INTO train_bookings (id, user_id, train_number, amount, status) VALUES (?, ?, ?, ?, ?)";
        String insertPassengerSql = "INSERT INTO train_passengers (booking_id, name, age, gender, berth_preference) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection()) {
            if(conn == null) return false;
            
            // Insert Booking
            try (PreparedStatement ps = conn.prepareStatement(insertBookingSql)) {
                ps.setString(1, booking.getId());
                ps.setInt(2, booking.getUserId());
                ps.setString(3, booking.getTrainNumber());
                ps.setDouble(4, booking.getFare());
                ps.setString(5, booking.getStatus());
                ps.executeUpdate();
            }

            // Insert Passengers
            try (PreparedStatement ps = conn.prepareStatement(insertPassengerSql)) {
                for (TrainPassenger p : booking.getPassengers()) {
                    ps.setString(1, booking.getId());
                    ps.setString(2, p.getName());
                    ps.setInt(3, p.getAge());
                    ps.setString(4, p.getGender());
                    ps.setString(5, p.getBerthPreference());
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
}
"""
with open(daos_dir + "TrainBookingDAO.java", "w", encoding="utf-8") as f:
    f.write(train_booking_dao_java)


# TrainBookingServlet.java (Multi-step flow)
train_booking_servlet_java = """package com.voyastra.servlet.transport;

import com.voyastra.dao.TrainBookingDAO;
import com.voyastra.model.TrainBooking;
import com.voyastra.model.TrainPassenger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/transport/train/booking")
public class TrainBookingServlet extends HttpServlet {
    private TrainBookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new TrainBookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "details"; // Default step
        }

        switch (action) {
            case "details":
                showDetails(request, response);
                break;
            case "passengers":
                showPassengersForm(request, response);
                break;
            case "review":
                processPassengersAndShowReview(request, response);
                break;
            case "save":
                saveDraftAndRedirect(request, response);
                break;
            default:
                showDetails(request, response);
                break;
        }
    }

    private void showDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainNo = request.getParameter("trainNo");
        String fare = request.getParameter("fare");
        request.setAttribute("trainNo", trainNo);
        request.setAttribute("fare", fare);
        request.getRequestDispatcher("/pages/transport/train-details.jsp").forward(request, response);
    }

    private void showPassengersForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainNo = request.getParameter("trainNo");
        String fare = request.getParameter("fare");
        request.setAttribute("trainNo", trainNo);
        request.setAttribute("fare", fare);
        request.getRequestDispatcher("/pages/transport/train-passengers.jsp").forward(request, response);
    }

    private void processPassengersAndShowReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trainNo = request.getParameter("trainNo");
        String fareStr = request.getParameter("fare");
        double fare = Double.parseDouble(fareStr != null ? fareStr : "0");

        String[] names = request.getParameterValues("passengerName");
        String[] ages = request.getParameterValues("passengerAge");
        String[] genders = request.getParameterValues("passengerGender");
        String[] berths = request.getParameterValues("passengerBerth");

        TrainBooking draft = new TrainBooking();
        draft.setId("TRN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        draft.setTrainNumber(trainNo);
        draft.setFare(fare);
        draft.setStatus("DRAFT");
        // Using a mock user id for now since auth might not be fully linked in this context
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        draft.setUserId(userId != null ? userId : 1);

        if (names != null) {
            for (int i = 0; i < names.length; i++) {
                TrainPassenger p = new TrainPassenger(
                    names[i], 
                    Integer.parseInt(ages[i]), 
                    genders[i], 
                    berths[i]
                );
                draft.addPassenger(p);
            }
        }

        // Save Draft to DB
        bookingDAO.saveDraft(draft);

        // Store in session for review page
        request.getSession().setAttribute("currentTrainBooking", draft);
        response.sendRedirect(request.getContextPath() + "/pages/transport/train-review.jsp");
    }

    private void saveDraftAndRedirect(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Here we could update status to "PAYMENT_PENDING" or just clear session.
        request.getSession().removeAttribute("currentTrainBooking");
        // Redirect to profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
"""
with open(servlets_dir + "TrainBookingServlet.java", "w", encoding="utf-8") as f:
    f.write(train_booking_servlet_java)

# train-details.jsp
train_details_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-4">🚆 Train Details</h1>
            <p class="text-gray-300">Train Number: <strong>${trainNo}</strong></p>
            <p class="text-gray-300">Fare per passenger: <strong>₹${fare}</strong></p>
            
            <div class="mt-6 p-4 bg-gray-800 rounded-lg">
                <h3 class="text-lg font-bold text-white mb-2">Amenities Included</h3>
                <ul class="list-disc list-inside text-gray-400">
                    <li>Pantry Car available</li>
                    <li>Clean Bedrolls (For AC Classes)</li>
                    <li>Charging points in all cabins</li>
                </ul>
            </div>

            <div class="mt-6 flex justify-end gap-4">
                <form action="${pageContext.request.contextPath}/transport/train/booking" method="post">
                    <input type="hidden" name="action" value="passengers">
                    <input type="hidden" name="trainNo" value="${trainNo}">
                    <input type="hidden" name="fare" value="${fare}">
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Continue to Passengers</button>
                </form>
            </div>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "train-details.jsp", "w", encoding="utf-8") as f:
    f.write(train_details_jsp)

# train-passengers.jsp
train_passengers_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <h1 class="text-2xl font-bold text-white mb-6">👥 Passenger Details</h1>
            
            <form action="${pageContext.request.contextPath}/transport/train/booking" method="post" id="passengerForm">
                <input type="hidden" name="action" value="review">
                <input type="hidden" name="trainNo" value="${trainNo}">
                <input type="hidden" name="fare" value="${fare}">
                
                <div id="passengerContainer">
                    <!-- Passenger 1 -->
                    <div class="passenger-card p-4 bg-gray-800 rounded-lg mb-4 border border-gray-700">
                        <h3 class="text-white font-bold mb-3">Passenger 1</h3>
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Full Name</label>
                                <input type="text" name="passengerName" class="w-full bg-gray-900 text-white rounded p-2" required>
                            </div>
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Age</label>
                                <input type="number" name="passengerAge" class="w-full bg-gray-900 text-white rounded p-2" required min="1" max="120">
                            </div>
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Gender</label>
                                <select name="passengerGender" class="w-full bg-gray-900 text-white rounded p-2">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm text-gray-400 mb-1">Berth Pref.</label>
                                <select name="passengerBerth" class="w-full bg-gray-900 text-white rounded p-2">
                                    <option value="No Preference">No Preference</option>
                                    <option value="Lower">Lower</option>
                                    <option value="Middle">Middle</option>
                                    <option value="Upper">Upper</option>
                                    <option value="Side Lower">Side Lower</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-6">
                    <button type="button" class="text-blue-400 hover:text-blue-300 font-bold" onclick="addPassenger()">+ Add Another Passenger</button>
                </div>

                <div class="mt-6 flex justify-between">
                    <button type="button" onclick="history.back()" class="bg-gray-700 text-white py-3 px-8 rounded-lg">Back</button>
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
        const html = `
            <div class="passenger-card p-4 bg-gray-800 rounded-lg mb-4 border border-gray-700">
                <div class="flex justify-between items-center mb-3">
                    <h3 class="text-white font-bold">Passenger ${paxCount}</h3>
                    <button type="button" class="text-red-400 text-sm" onclick="this.parentElement.parentElement.remove()">Remove</button>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <input type="text" name="passengerName" placeholder="Full Name" class="w-full bg-gray-900 text-white rounded p-2" required>
                    </div>
                    <div>
                        <input type="number" name="passengerAge" placeholder="Age" class="w-full bg-gray-900 text-white rounded p-2" required min="1" max="120">
                    </div>
                    <div>
                        <select name="passengerGender" class="w-full bg-gray-900 text-white rounded p-2">
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div>
                        <select name="passengerBerth" class="w-full bg-gray-900 text-white rounded p-2">
                            <option value="No Preference">No Preference</option>
                            <option value="Lower">Lower</option>
                            <option value="Middle">Middle</option>
                            <option value="Upper">Upper</option>
                            <option value="Side Lower">Side Lower</option>
                        </select>
                    </div>
                </div>
            </div>`;
        document.getElementById('passengerContainer').insertAdjacentHTML('beforeend', html);
    }
</script>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "train-passengers.jsp", "w", encoding="utf-8") as f:
    f.write(train_passengers_jsp)

# train-review.jsp
train_review_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-2xl font-bold text-white">📋 Review Your Booking</h1>
                <span class="bg-yellow-500 bg-opacity-20 text-yellow-500 px-3 py-1 rounded-full text-sm font-bold">Draft Saved</span>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Main Content -->
                <div class="md:col-span-2 flex flex-col gap-6">
                    
                    <!-- Train Info -->
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-3 flex items-center gap-2">🚆 Train Details</h2>
                        <p class="text-gray-300">Train Number: <span class="font-mono bg-gray-900 px-2 py-1 rounded">${currentTrainBooking.trainNumber}</span></p>
                        <p class="text-gray-300 mt-2">Booking ID: <span class="text-blue-400 font-bold">${currentTrainBooking.id}</span></p>
                    </div>

                    <!-- Passengers -->
                    <div class="p-5 bg-gray-800 rounded-lg border border-gray-700">
                        <h2 class="text-xl font-bold text-white mb-3 flex items-center gap-2">👥 Passengers</h2>
                        <div class="flex flex-col gap-3">
                            <c:forEach var="pax" items="${currentTrainBooking.passengers}" varStatus="status">
                                <div class="flex justify-between items-center bg-gray-900 p-3 rounded">
                                    <div>
                                        <p class="text-white font-bold">${pax.name}</p>
                                        <p class="text-xs text-gray-400">${pax.age} yrs, ${pax.gender}</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-sm text-gray-300">Berth: ${pax.berthPreference}</p>
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
                            <span>Base Fare (x${currentTrainBooking.passengers.size()})</span>
                            <span>₹${currentTrainBooking.fare * currentTrainBooking.passengers.size()}</span>
                        </div>
                        <div class="flex justify-between text-gray-300 mb-4">
                            <span>Taxes & Fees</span>
                            <span>₹150.0</span>
                        </div>
                        <hr class="border-gray-600 mb-4">
                        <div class="flex justify-between text-white font-bold text-lg mb-6">
                            <span>Total Amount</span>
                            <span class="text-green-400">₹${(currentTrainBooking.fare * currentTrainBooking.passengers.size()) + 150}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/transport/train/booking" method="post">
                            <input type="hidden" name="action" value="save">
                            <button type="submit" class="btn-primary w-full py-3 rounded-lg font-bold text-lg">Confirm & Proceed</button>
                        </form>
                        <p class="text-xs text-gray-500 text-center mt-3">Payment integration disabled for Phase 4. Clicking confirm will save this draft.</p>
                    </div>
                </div>
            </div>

        </div>

    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "train-review.jsp", "w", encoding="utf-8") as f:
    f.write(train_review_jsp)

# SQL script to create train_passengers table
sql_script = """USE voyastra;
CREATE TABLE IF NOT EXISTS train_passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10),
    berth_preference VARCHAR(20)
);
"""
with open("c:/Users/Dell/Desktop/antigravity/sql/train_passengers.sql", "w", encoding="utf-8") as f:
    f.write(sql_script)

print("Files generated!")
