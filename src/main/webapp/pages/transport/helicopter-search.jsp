<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-yellow-500 outline-none transition voyastra-autocomplete">
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
