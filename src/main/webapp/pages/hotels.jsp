<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">
    <div class="container relative z-10" style="margin-top: 20px;">
        <div class="mb-8 text-center slide-up">
            <h1 class="text-white mb-1 editorial" style="font-size: 3rem; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">Find Your Perfect Stay</h1>
            <p class="text-white text-lg font-light opacity-90 block" style="text-shadow: 0 1px 3px rgba(0,0,0,0.6);">Hotels, Resorts, and Villas around the world</p>
        </div>

        <div class="surface-panel glass-panel rounded-2xl p-6 shadow-xl slide-up mx-auto" style="max-width: 1000px;">
            <form action="${pageContext.request.contextPath}/hotels" method="GET" class="flex flex-col gap-4">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div class="col-span-1 md:col-span-2">
                        <label class="block text-sm font-medium mb-1 text-white">Destination City</label>
                        <input type="text" name="q" class="input-field w-full text-black placeholder-gray-500" value="${searchQuery}" placeholder="Where to?">
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

        <div class="mt-12">
            <c:if test="${not empty hotels}">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <c:forEach var="hotel" items="${hotels}">
                        <div class="surface-panel rounded-2xl overflow-hidden shadow-lg hover:shadow-xl transition-all elevate-hover">
                            <div class="relative h-48 overflow-hidden">
                                <img src="<c:choose><c:when test="${not empty hotel.imageUrl}">${hotel.imageUrl}</c:when><c:otherwise>https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80</c:otherwise></c:choose>" alt="${hotel.name}" class="w-full h-full object-cover">
                                <div class="absolute top-4 right-4 bg-primary text-white text-xs font-bold px-3 py-1 rounded-full shadow-md">
                                    <i class="fas fa-star text-accent mr-1"></i> ${hotel.rating}
                                </div>
                            </div>
                            <div class="p-5">
                                <h3 class="text-xl font-medium mb-1 truncate">${hotel.name}</h3>
                                <p class="text-sm text-gray-500 dark:text-gray-400 mb-3"><i class="fas fa-map-marker-alt mr-1"></i> ${hotel.city}</p>
                                
                                <div class="flex flex-wrap gap-2 mb-4">
                                    <c:forEach var="amenity" items="${hotel.amenitiesArray}">
                                        <span class="text-xs bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded-md">${amenity}</span>
                                    </c:forEach>
                                </div>
                                
                                <form action="${pageContext.request.contextPath}/hotel-details" method="GET">
                                    <input type="hidden" name="id" value="${hotel.id}">
                                    <input type="hidden" name="checkIn" value="${param.checkIn}">
                                    <input type="hidden" name="checkOut" value="${param.checkOut}">
                                    <input type="hidden" name="guests" value="${param.guests}">
                                    <button type="submit" class="btn-outline w-full py-2 rounded-lg text-center mt-2 group">
                                        View Hotel <i class="fas fa-arrow-right ml-1 transition-transform group-hover:translate-x-1"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            <c:if test="${empty hotels and not empty searchQuery}">
                <div class="text-center py-10">
                    <p class="text-xl">No hotels found matching your search.</p>
                </div>
            </c:if>
        </div>
    </div>
</main>
<%@ include file="/components/footer.jsp" %>