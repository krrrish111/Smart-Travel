<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
