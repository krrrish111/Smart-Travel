<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
