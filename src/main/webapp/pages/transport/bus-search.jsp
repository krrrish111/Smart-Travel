<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="search-form-container bg-gray-900 bg-opacity-70 backdrop-blur-md p-8 rounded-xl border border-gray-700 w-full animate-fade-in-up">
    <h2 class="text-3xl font-bold text-white mb-6">Search Buses</h2>
    <form action="${pageContext.request.contextPath}/transport/bus/search" method="post" class="grid grid-cols-1 md:grid-cols-4 gap-6">
        
        <!-- From -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">FROM</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">📍</span>
                <input type="text" name="from" placeholder="Origin City" required 
                       class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition">
            </div>
        </div>

        <!-- To -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">TO</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">📍</span>
                <input type="text" name="to" placeholder="Destination City" required 
                       class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition">
            </div>
        </div>

        <!-- Date -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">JOURNEY DATE</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">📅</span>
                <input type="date" name="date" required 
                       class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition">
            </div>
        </div>

        <!-- Bus Type -->
        <div class="form-group relative">
            <label class="text-sm font-bold text-gray-400 block mb-2">BUS TYPE</label>
            <div class="relative">
                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">🚌</span>
                <select name="type" class="w-full bg-gray-800 text-white text-lg rounded-lg border border-gray-600 pl-12 pr-4 py-3 focus:border-blue-500 focus:ring-1 focus:ring-blue-500 outline-none transition appearance-none">
                    <option value="All">All Types</option>
                    <option value="AC">AC</option>
                    <option value="Non AC">Non AC</option>
                    <option value="Sleeper">Sleeper</option>
                    <option value="Seater">Seater</option>
                    <option value="Volvo">Volvo</option>
                    <option value="Luxury">Luxury</option>
                </select>
            </div>
        </div>

        <!-- Search Button -->
        <div class="md:col-span-4 flex justify-center mt-4">
            <button type="submit" class="btn-primary text-xl font-bold py-4 px-16 rounded-full shadow-lg hover:shadow-blue-500/30 transform hover:-translate-y-1 transition duration-300">
                SEARCH BUSES
            </button>
        </div>
    </form>
</div>
