import os

base_dir = "c:/Users/Dell/Desktop/antigravity/"
servlet_dir = base_dir + "src/main/java/com/voyastra/servlet/transport/"
webapp_dir = base_dir + "src/main/webapp/pages/transport/"

# 1. Update BusBookingServlet.java
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
        } else if ("seats".equals(action)) {
            handleSeats(request, response);
        } else if ("passengers".equals(action)) {
            handlePassengers(request, response);
        } else if ("save_passengers".equals(action)) {
            handleSavePassengers(request, response);
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

    private void handleSeats(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/transport/bus-seats.jsp").forward(request, response);
    }

    private void handlePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String selectedSeatsStr = request.getParameter("selectedSeats");
        BusBooking draft = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        
        if (draft != null && selectedSeatsStr != null && !selectedSeatsStr.isEmpty()) {
            draft.getPassengers().clear();
            String[] seats = selectedSeatsStr.split(",");
            for (String seat : seats) {
                BusPassenger p = new BusPassenger();
                p.setSeatPreference(seat.trim());
                draft.getPassengers().add(p);
            }
        }
        
        request.getRequestDispatcher("/pages/transport/bus-passengers.jsp").forward(request, response);
    }

    private void handleSavePassengers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] names = request.getParameterValues("name[]");
        String[] ages = request.getParameterValues("age[]");
        String[] genders = request.getParameterValues("gender[]");

        BusBooking draft = (BusBooking) request.getSession().getAttribute("currentBusBooking");
        if (draft != null && names != null) {
            for (int i = 0; i < names.length; i++) {
                if(i < draft.getPassengers().size()) {
                    BusPassenger p = draft.getPassengers().get(i);
                    p.setName(names[i]);
                    p.setAge(Integer.parseInt(ages[i]));
                    p.setGender(genders[i]);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/pages/transport/bus-review.jsp");
    }

    private void handleReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/transport/bus-payment.jsp");
    }
}
"""
with open(servlet_dir + "BusBookingServlet.java", "w", encoding="utf-8") as f:
    f.write(bus_booking_servlet_java)


# 2. Update bus-details.jsp
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
            
            <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post" class="text-right mt-6">
                <input type="hidden" name="action" value="seats">
                <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Select Seats</button>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-details.jsp", "w", encoding="utf-8") as f:
    f.write(bus_details_jsp)

# 3. Create bus-seats.jsp
bus_seats_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<style>
    .seat-grid {
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        gap: 15px;
        margin: 0 auto;
        max-width: 400px;
    }
    .seat {
        width: 100%;
        aspect-ratio: 1;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.2s ease;
        border: 2px solid transparent;
        font-size: 0.9rem;
    }
    .seat.available {
        background: #374151; /* gray-700 */
        color: #fff;
        border-color: #4b5563; /* gray-600 */
    }
    .seat.available:hover {
        background: #4b5563;
    }
    .seat.booked {
        background: #ef4444; /* red-500 */
        color: #fca5a5;
        cursor: not-allowed;
        opacity: 0.6;
    }
    .seat.female {
        background: #ec4899; /* pink-500 */
        color: #fff;
    }
    .seat.selected {
        background: #10b981; /* green-500 */
        color: #fff;
        border-color: #059669; /* green-600 */
        transform: scale(1.05);
        box-shadow: 0 0 10px rgba(16, 185, 129, 0.5);
    }
    .aisle {
        visibility: hidden;
    }
    .legend-box {
        width: 20px;
        height: 20px;
        border-radius: 4px;
        display: inline-block;
        margin-right: 8px;
        vertical-align: middle;
    }
</style>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-5xl flex flex-col md:flex-row gap-8">
        
        <!-- Interactive Layout -->
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);" class="flex-1">
            <h1 class="text-2xl font-bold text-white mb-6 text-center">Select Your Seats</h1>
            
            <!-- Legends -->
            <div class="flex justify-center gap-6 mb-8 text-sm text-gray-300 flex-wrap">
                <div class="flex items-center"><div class="legend-box" style="background:#374151;"></div> Available</div>
                <div class="flex items-center"><div class="legend-box" style="background:#ef4444; opacity:0.6;"></div> Booked</div>
                <div class="flex items-center"><div class="legend-box" style="background:#ec4899;"></div> Female</div>
                <div class="flex items-center"><div class="legend-box" style="background:#10b981;"></div> Selected</div>
            </div>

            <!-- Seat Layout Grid -->
            <div class="bg-gray-800 p-8 rounded-xl border border-gray-700 relative">
                <!-- Steering wheel indicator -->
                <div class="absolute right-8 top-2 text-2xl text-gray-500">⚪</div>
                
                <div class="seat-grid mt-8" id="seatGrid">
                    <!-- Javascript will render the grid here -->
                </div>
            </div>
        </div>

        <!-- Selection Summary -->
        <div class="w-full md:w-80">
            <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); position: sticky; top: 100px;">
                <h2 class="text-xl font-bold text-white mb-4">Your Selection</h2>
                
                <div id="selectionSummary" class="text-gray-400 mb-6">
                    <p>No seats selected.</p>
                </div>

                <div class="border-t border-gray-700 pt-4 mb-6">
                    <div class="flex justify-between text-white font-bold text-lg">
                        <span>Total Fare</span>
                        <span id="totalFare" class="text-green-400">₹0</span>
                    </div>
                    <p class="text-xs text-gray-500 mt-1">₹${currentBusBooking.fare} per seat + Taxes</p>
                </div>

                <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post" id="seatForm">
                    <input type="hidden" name="action" value="passengers">
                    <input type="hidden" name="selectedSeats" id="selectedSeatsInput" value="">
                    <button type="submit" id="continueBtn" class="btn-primary w-full py-3 rounded-lg font-bold" disabled style="opacity: 0.5;">Proceed to Passengers</button>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    const ROWS = 10;
    const COLS = 5; // 2x2 layout with 1 aisle in the middle (indices: 0,1 [left], 2 [aisle], 3,4 [right])
    const baseFare = ${currentBusBooking.fare};
    
    // Mock data for booked and female seats
    const bookedSeats = ['1C', '1D', '4A', '4B', '7C', '10A', '10B'];
    const femaleSeats = ['3A', '3B', '5C'];
    
    const seatGrid = document.getElementById('seatGrid');
    const selectedSeatsInput = document.getElementById('selectedSeatsInput');
    const selectionSummary = document.getElementById('selectionSummary');
    const totalFareSpan = document.getElementById('totalFare');
    const continueBtn = document.getElementById('continueBtn');
    
    let selectedSeats = new Set();

    const letters = ['A', 'B', '', 'C', 'D'];

    // Generate Layout
    for (let r = 1; r <= ROWS; r++) {
        for (let c = 0; c < COLS; c++) {
            const div = document.createElement('div');
            
            if (c === 2) {
                // Aisle
                div.className = 'seat aisle';
            } else {
                const seatId = r + letters[c];
                div.textContent = seatId;
                div.dataset.seatId = seatId;
                
                if (bookedSeats.includes(seatId)) {
                    div.className = 'seat booked';
                } else if (femaleSeats.includes(seatId)) {
                    div.className = 'seat female';
                    div.onclick = () => toggleSeat(seatId, div);
                } else {
                    div.className = 'seat available';
                    div.onclick = () => toggleSeat(seatId, div);
                }
            }
            seatGrid.appendChild(div);
        }
    }

    function toggleSeat(seatId, element) {
        if (selectedSeats.has(seatId)) {
            selectedSeats.delete(seatId);
            element.classList.remove('selected');
        } else {
            selectedSeats.add(seatId);
            element.classList.add('selected');
        }
        updateSummary();
    }

    function updateSummary() {
        const arr = Array.from(selectedSeats);
        selectedSeatsInput.value = arr.join(',');
        
        if (arr.length === 0) {
            selectionSummary.innerHTML = '<p>No seats selected.</p>';
            totalFareSpan.textContent = '₹0';
            continueBtn.disabled = true;
            continueBtn.style.opacity = '0.5';
        } else {
            selectionSummary.innerHTML = `<p class="text-white font-bold bg-blue-900 bg-opacity-50 border border-blue-700 rounded px-3 py-2">Selected: ${arr.join(', ')}</p>`;
            const total = arr.length * baseFare;
            totalFareSpan.textContent = '₹' + total;
            continueBtn.disabled = false;
            continueBtn.style.opacity = '1';
        }
    }
</script>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-seats.jsp", "w", encoding="utf-8") as f:
    f.write(bus_seats_jsp)

# 4. Update bus-passengers.jsp
bus_passengers_jsp = """<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4 max-w-4xl">
        <div style="background: var(--color-surface); border-radius: 12px; padding: 30px; box-shadow: 0 4px 32px rgba(0,0,0,0.28);">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-white">Passenger Details</h1>
                <span class="bg-blue-500 bg-opacity-20 text-blue-400 font-bold px-3 py-1 rounded">Selected Seats: ${currentBusBooking.passengers.size()}</span>
            </div>

            <form action="${pageContext.request.contextPath}/transport/bus/booking" method="post" id="passengerForm">
                <input type="hidden" name="action" value="save_passengers">
                
                <div id="passengerContainer">
                    <c:forEach var="pax" items="${currentBusBooking.passengers}" varStatus="status">
                        <div class="p-5 bg-gray-800 rounded-lg border border-gray-700 mb-4 passenger-block">
                            <div class="flex justify-between items-center mb-4 border-b border-gray-700 pb-2">
                                <h3 class="text-lg text-white font-bold">Passenger ${status.index + 1}</h3>
                                <span class="bg-gray-900 text-green-400 font-bold font-mono px-3 py-1 rounded">Seat: ${pax.seatPreference}</span>
                            </div>
                            
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <div class="md:col-span-1">
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
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="text-right mt-6">
                    <button type="submit" class="btn-primary py-3 px-8 rounded-lg font-bold">Review Booking</button>
                </div>
            </form>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>
"""
with open(webapp_dir + "bus-passengers.jsp", "w", encoding="utf-8") as f:
    f.write(bus_passengers_jsp)

print("Phase 7 files updated successfully!")
