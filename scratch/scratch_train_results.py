import os

base_dir = "c:/Users/Dell/Desktop/antigravity/src/main/java/com/voyastra/"
models_dir = base_dir + "model/"
daos_dir = base_dir + "dao/"
servlets_dir = base_dir + "servlet/"
webapp_dir = "c:/Users/Dell/Desktop/antigravity/src/main/webapp/pages/transport/"

# TrainResult.java
train_result_java = """package com.voyastra.model;

public class TrainResult {
    private String trainNumber;
    private String trainName;
    private String departureTime;
    private String arrivalTime;
    private String duration;
    private int availableSeats;
    private double fare;

    public TrainResult(String trainNumber, String trainName, String departureTime, String arrivalTime, String duration, int availableSeats, double fare) {
        this.trainNumber = trainNumber;
        this.trainName = trainName;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.duration = duration;
        this.availableSeats = availableSeats;
        this.fare = fare;
    }

    public String getTrainNumber() { return trainNumber; }
    public String getTrainName() { return trainName; }
    public String getDepartureTime() { return departureTime; }
    public String getArrivalTime() { return arrivalTime; }
    public String getDuration() { return duration; }
    public int getAvailableSeats() { return availableSeats; }
    public double getFare() { return fare; }
}
"""

with open(models_dir + "TrainResult.java", "w", encoding="utf-8") as f:
    f.write(train_result_java)

# TrainDAO.java
train_dao_java = """package com.voyastra.dao;

import com.voyastra.model.TrainResult;
import java.util.ArrayList;
import java.util.List;

public class TrainDAO {
    public List<TrainResult> searchTrains(String from, String to, String date) {
        // Return Mock Data
        List<TrainResult> results = new ArrayList<>();
        results.add(new TrainResult("12951", "Rajdhani Express", "16:30", "08:35", "16h 05m", 45, 2850.0));
        results.add(new TrainResult("12909", "Garib Rath", "16:55", "10:50", "17h 55m", 120, 1050.0));
        results.add(new TrainResult("12925", "Paschim Express", "11:25", "10:40", "23h 15m", 15, 650.0));
        results.add(new TrainResult("12239", "Duronto Express", "23:10", "10:40", "11h 30m", 8, 3200.0));
        results.add(new TrainResult("22221", "Vande Bharat", "05:50", "14:15", "08h 25m", 60, 1850.0));
        return results;
    }
}
"""

with open(daos_dir + "TrainDAO.java", "w", encoding="utf-8") as f:
    f.write(train_dao_java)

# TrainServlet.java
train_servlet_java = """package com.voyastra.servlet;

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
"""

with open(servlets_dir + "TrainServlet.java", "w", encoding="utf-8") as f:
    f.write(train_servlet_java)

# train-results.jsp
train_results_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4">
        
        <!-- Search Summary Header -->
        <div class="mb-6 flex justify-between items-center bg-gray-800 rounded-lg p-4 shadow-lg" style="background: var(--color-surface); border: 1px solid var(--color-border);">
            <div>
                <h1 class="text-2xl font-bold text-white flex items-center gap-2">
                    <span>🚆</span> Trains: <c:out value="${searchFrom}" default="Delhi"/> to <c:out value="${searchTo}" default="Mumbai"/>
                </h1>
                <p class="text-sm text-gray-400 mt-1">
                    <c:out value="${searchDate}" default="Any Date"/> | Class: <c:out value="${searchClass}" default="All"/> | Quota: <c:out value="${searchQuota}" default="General"/>
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/booking.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 text-white rounded-lg transition text-sm">Modify Search</a>
        </div>

        <!-- Results Section -->
        <div class="flex flex-col gap-4">
            <c:choose>
                <c:when test="${not empty trainResults}">
                    <c:forEach var="train" items="${trainResults}">
                        <div class="bg-gray-800 rounded-lg p-5 shadow flex flex-col md:flex-row justify-between items-center" style="background: var(--color-surface); border: 1px solid var(--color-border);">
                            
                            <!-- Train Info -->
                            <div class="flex items-center gap-4 mb-4 md:mb-0" style="width: 25%;">
                                <div class="bg-blue-500 bg-opacity-20 p-3 rounded-full flex items-center justify-center">
                                    <span class="text-2xl">🚆</span>
                                </div>
                                <div>
                                    <h3 class="text-lg font-bold text-white"><c:out value="${train.trainName}"/></h3>
                                    <p class="text-sm text-gray-400">#<c:out value="${train.trainNumber}"/></p>
                                </div>
                            </div>

                            <!-- Timing -->
                            <div class="flex items-center justify-between gap-6" style="width: 40%;">
                                <div class="text-center">
                                    <p class="text-xl font-bold text-white"><c:out value="${train.departureTime}"/></p>
                                    <p class="text-xs text-gray-400"><c:out value="${searchFrom}" default="Origin"/></p>
                                </div>
                                <div class="flex flex-col items-center flex-1">
                                    <p class="text-xs text-gray-400 mb-1"><c:out value="${train.duration}"/></p>
                                    <div class="w-full h-px bg-gray-600 relative">
                                        <div class="absolute w-2 h-2 rounded-full bg-gray-400 -mt-1 left-0"></div>
                                        <div class="absolute w-2 h-2 rounded-full bg-gray-400 -mt-1 right-0"></div>
                                    </div>
                                    <p class="text-xs text-green-400 mt-1">Direct</p>
                                </div>
                                <div class="text-center">
                                    <p class="text-xl font-bold text-white"><c:out value="${train.arrivalTime}"/></p>
                                    <p class="text-xs text-gray-400"><c:out value="${searchTo}" default="Destination"/></p>
                                </div>
                            </div>

                            <!-- Seats & Price -->
                            <div class="flex flex-col items-end gap-2" style="width: 25%;">
                                <p class="text-2xl font-bold text-white">₹<c:out value="${train.fare}"/></p>
                                <c:choose>
                                    <c:when test="${train.availableSeats > 20}">
                                        <p class="text-sm text-green-400">Available: <c:out value="${train.availableSeats}"/></p>
                                    </c:when>
                                    <c:when test="${train.availableSeats > 0}">
                                        <p class="text-sm text-orange-400">Filling Fast: <c:out value="${train.availableSeats}"/></p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-sm text-red-400">Waitlist</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex flex-col gap-2 w-full md:w-auto mt-4 md:mt-0">
                                <button class="px-6 py-2 bg-gray-700 hover:bg-gray-600 text-white text-sm font-bold rounded-lg transition w-full">View Details</button>
                                <form action="${pageContext.request.contextPath}/transport/train/booking" method="post" class="m-0">
                                    <input type="hidden" name="trainNo" value="${train.trainNumber}">
                                    <input type="hidden" name="fare" value="${train.fare}">
                                    <button type="submit" class="px-6 py-2 btn-primary text-black text-sm font-bold rounded-lg transition w-full" style="background: var(--color-primary);">Book Now</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-10">
                        <p class="text-gray-400 text-lg">No trains found for this route.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
"""

with open(webapp_dir + "train-results.jsp", "w", encoding="utf-8") as f:
    f.write(train_results_jsp)

print("Files generated!")
