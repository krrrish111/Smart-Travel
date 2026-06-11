<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
