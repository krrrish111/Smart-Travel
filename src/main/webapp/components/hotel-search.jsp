<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="mb-8 text-center slide-up">
    <h1 class="text-white mb-1 editorial" style="font-size: 3rem; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">Find Your Perfect Stay</h1>
    <p class="text-white text-lg font-light opacity-90 block" style="text-shadow: 0 1px 3px rgba(0,0,0,0.6);">Hotels, Resorts, and Villas around the world</p>
</div>

<div class="surface-panel glass-panel rounded-2xl p-6 shadow-xl slide-up mx-auto" style="max-width: 1000px;">
    <form action="${pageContext.request.contextPath}/hotels" method="GET" class="flex flex-col gap-4">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div class="col-span-1 md:col-span-2">
                <label class="block text-sm font-medium mb-1 text-white">Destination City</label>
                <input type="text" name="q" class="input-field w-full text-black placeholder-gray-500 voyastra-autocomplete" value="${searchQuery}" placeholder="Where to?">
            </div>
            <div>
                <label class="block text-sm font-medium mb-1 text-white">Check-in</label>
                <input type="date" name="checkIn" class="input-field w-full text-black" value="${checkIn}" required>
            </div>
            <div>
                <label class="block text-sm font-medium mb-1 text-white">Check-out</label>
                <input type="date" name="checkOut" class="input-field w-full text-black" value="${checkOut}" required>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium mb-1 text-white">Rooms</label>
                <input type="number" name="rooms" class="input-field w-full text-black" value="${not empty rooms ? rooms : 1}" min="1">
            </div>
            <div>
                <label class="block text-sm font-medium mb-1 text-white">Adults</label>
                <input type="number" name="adults" class="input-field w-full text-black" value="${not empty adults ? adults : 2}" min="1">
            </div>
            <div>
                <label class="block text-sm font-medium mb-1 text-white">Children</label>
                <input type="number" name="children" class="input-field w-full text-black" value="${not empty children ? children : 0}" min="0">
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-2">
            <div>
                <label class="block text-sm font-medium mb-2 text-white">Hotel Type</label>
                <select name="hotelType" class="input-field w-full text-black">
                    <option value="" ${empty hotelType ? 'selected' : ''}>Any Type</option>
                    <option value="Budget" ${hotelType == 'Budget' ? 'selected' : ''}>Budget</option>
                    <option value="Luxury" ${hotelType == 'Luxury' ? 'selected' : ''}>Luxury</option>
                    <option value="Resort" ${hotelType == 'Resort' ? 'selected' : ''}>Resort</option>
                    <option value="Villa" ${hotelType == 'Villa' ? 'selected' : ''}>Villa</option>
                    <option value="Hostel" ${hotelType == 'Hostel' ? 'selected' : ''}>Hostel</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium mb-2 text-white">Amenities</label>
                <div class="flex flex-wrap gap-4 text-white text-sm mt-2">
                    <label class="flex items-center gap-1 cursor-pointer"><input type="checkbox" name="amenities" value="WiFi" ${selectedAmenities.contains('WiFi') ? 'checked' : ''}> WiFi</label>
                    <label class="flex items-center gap-1 cursor-pointer"><input type="checkbox" name="amenities" value="Pool" ${selectedAmenities.contains('Pool') ? 'checked' : ''}> Pool</label>
                    <label class="flex items-center gap-1 cursor-pointer"><input type="checkbox" name="amenities" value="Gym" ${selectedAmenities.contains('Gym') ? 'checked' : ''}> Gym</label>
                    <label class="flex items-center gap-1 cursor-pointer"><input type="checkbox" name="amenities" value="Parking" ${selectedAmenities.contains('Parking') ? 'checked' : ''}> Parking</label>
                    <label class="flex items-center gap-1 cursor-pointer"><input type="checkbox" name="amenities" value="Breakfast" ${selectedAmenities.contains('Breakfast') ? 'checked' : ''}> Breakfast</label>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn-primary w-full py-3 px-6 rounded-lg text-lg font-bold">Search Hotels</button>
        </div>
    </form>
</div>
