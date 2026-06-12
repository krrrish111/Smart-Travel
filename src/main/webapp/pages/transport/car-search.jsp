<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="search-form-container bg-gray-900 bg-opacity-70 backdrop-blur-md p-8 rounded-xl border border-gray-700 w-full animate-fade-in-up">
    <h2 class="text-3xl font-bold text-white mb-6">Self Drive Cars</h2>
    
    <form action="${pageContext.request.contextPath}/transport/car/search" method="post" class="grid grid-cols-1 md:grid-cols-4 gap-6">
        
        <!-- Pickup City -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">PICKUP CITY</label>
            <input type="text" name="pickupCity" placeholder="Enter City" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
        </div>

        <!-- Pickup Date -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">PICKUP DATE</label>
            <input type="date" name="pickupDate" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
        </div>

        <!-- Return Date -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">RETURN DATE</label>
            <input type="date" name="returnDate" required 
                   class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
        </div>

        <!-- Vehicle Type -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">VEHICLE CLASS</label>
            <select name="vehicleType" class="w-full bg-gray-800 text-white rounded-lg border border-gray-600 px-4 py-3 focus:border-purple-500 outline-none transition">
                <option value="All">All Classes</option>
                <option value="Hatchback">Hatchback</option>
                <option value="Sedan">Sedan</option>
                <option value="SUV">SUV</option>
                <option value="Luxury">Luxury</option>
                <option value="Electric">Electric</option>
            </select>
        </div>

        <!-- Search Button -->
        <div class="md:col-span-4 flex justify-center mt-4">
            <button type="submit" class="w-full md:w-auto text-xl font-bold py-4 px-16 rounded-full shadow-lg transform hover:-translate-y-1 transition duration-300 text-white" style="background-color: #8b5cf6;">
                FIND CARS
            </button>
        </div>
    </form>
</div>
