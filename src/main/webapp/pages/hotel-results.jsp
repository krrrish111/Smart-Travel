<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; background: #f8f9fa;" class="dark:bg-[#0a0a0a]">
    
    <!-- Top Search Summary Bar -->
    <div class="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 shadow-sm sticky top-[72px] z-20">
        <div class="container mx-auto max-w-7xl px-4 py-4 flex flex-col md:flex-row items-center justify-between gap-4">
            <div>
                <h1 class="text-2xl font-bold editorial text-gray-900 dark:text-white">
                    <c:choose>
                        <c:when test="${not empty searchQuery}">${searchQuery}</c:when>
                        <c:otherwise>All Destinations</c:otherwise>
                    </c:choose>
                </h1>
                <p class="text-sm text-gray-500">
                    ${not empty checkIn ? checkIn : 'Any Date'} &bull; ${not empty checkOut ? checkOut : 'Any Date'} &bull; ${guests != null ? guests : (adults + children)} Guest(s)
                </p>
            </div>
            <div class="flex gap-3 items-center">
                <a href="${pageContext.request.contextPath}/hotels" class="btn-outline px-4 py-2 text-sm rounded-lg flex items-center gap-2">
                    <i class="fas fa-search"></i> Modify Search
                </a>
                <div class="relative">
                    <select class="input-field appearance-none pl-4 pr-10 py-2 text-sm bg-gray-50 dark:bg-gray-800 border-none rounded-lg cursor-pointer">
                        <option value="recommended">Recommended</option>
                        <option value="cheapest">Price (Lowest First)</option>
                        <option value="highest_rated">Highest Rated</option>
                        <option value="most_popular">Most Popular</option>
                    </select>
                    <i class="fas fa-chevron-down absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none text-xs"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="container mx-auto max-w-7xl px-4 py-8">
        <div class="flex flex-col lg:flex-row gap-8">
            
            <!-- Sidebar Filters -->
            <aside class="lg:w-1/4 flex-shrink-0">
                <div class="surface-panel rounded-2xl p-6 shadow-xl sticky top-[160px]">
                    <div class="flex justify-between items-center mb-6 pb-4 border-b border-gray-200 dark:border-gray-700">
                        <h2 class="text-lg font-bold">Filters</h2>
                        <button class="text-primary text-sm font-medium hover:underline">Clear All</button>
                    </div>

                    <!-- Price Filter -->
                    <div class="mb-6">
                        <h3 class="font-medium mb-3 text-sm uppercase tracking-wider text-gray-500">Price Range</h3>
                        <input type="range" class="w-full accent-primary" min="0" max="1000" value="500">
                        <div class="flex justify-between text-sm mt-2 text-gray-600 dark:text-gray-400">
                            <span>$0</span>
                            <span class="font-medium text-gray-900 dark:text-white">Up to $500</span>
                        </div>
                    </div>

                    <!-- Rating Filter -->
                    <div class="mb-6">
                        <h3 class="font-medium mb-3 text-sm uppercase tracking-wider text-gray-500">Star Rating</h3>
                        <div class="space-y-2">
                            <c:forEach var="i" begin="3" end="5" step="1">
                                <label class="flex items-center gap-3 cursor-pointer group">
                                    <input type="checkbox" class="w-4 h-4 rounded text-primary focus:ring-primary border-gray-300">
                                    <span class="text-sm group-hover:text-primary transition-colors flex items-center">
                                        ${i} <i class="fas fa-star text-accent text-xs ml-1"></i> & Up
                                    </span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Property Type -->
                    <div class="mb-6">
                        <h3 class="font-medium mb-3 text-sm uppercase tracking-wider text-gray-500">Property Type</h3>
                        <div class="space-y-2">
                            <c:forEach var="type" items="Hotel,Resort,Villa,Hostel">
                                <label class="flex items-center gap-3 cursor-pointer group">
                                    <input type="checkbox" class="w-4 h-4 rounded text-primary focus:ring-primary border-gray-300">
                                    <span class="text-sm group-hover:text-primary transition-colors">${type}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Amenities -->
                    <div class="mb-6">
                        <h3 class="font-medium mb-3 text-sm uppercase tracking-wider text-gray-500">Amenities</h3>
                        <div class="space-y-2">
                            <c:forEach var="amenity" items="WiFi,Pool,Gym,Parking,Breakfast">
                                <label class="flex items-center gap-3 cursor-pointer group">
                                    <input type="checkbox" class="w-4 h-4 rounded text-primary focus:ring-primary border-gray-300" ${selectedAmenities.contains(amenity) ? 'checked' : ''}>
                                    <span class="text-sm group-hover:text-primary transition-colors">${amenity}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                </div>
            </aside>

            <!-- Main Results List -->
            <div class="lg:w-3/4">
                
                <c:if test="${empty hotels}">
                    <div class="surface-panel rounded-2xl p-12 text-center shadow-xl">
                        <div class="w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mx-auto mb-6">
                            <i class="fas fa-search text-3xl text-gray-400"></i>
                        </div>
                        <h2 class="text-2xl font-bold mb-2">No hotels found</h2>
                        <p class="text-gray-500 mb-6">Try adjusting your filters or search criteria.</p>
                        <a href="${pageContext.request.contextPath}/hotels" class="btn-primary py-3 px-6 rounded-lg inline-block">Modify Search</a>
                    </div>
                </c:if>

                <div class="flex flex-col gap-6">
                    <c:forEach var="hotel" items="${hotels}">
                        <div class="surface-panel rounded-2xl overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300 flex flex-col sm:flex-row group border border-transparent hover:border-primary/30">
                            
                            <!-- Image Section -->
                            <div class="sm:w-1/3 relative overflow-hidden">
                                <img src="<c:choose><c:when test="${not empty hotel.imageUrl}">${hotel.imageUrl}</c:when><c:otherwise>https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80</c:otherwise></c:choose>" alt="${hotel.name}" class="w-full h-48 sm:h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                <div class="absolute top-3 left-3 bg-white/90 dark:bg-black/90 backdrop-blur-sm text-xs font-bold px-3 py-1.5 rounded-lg shadow-sm flex items-center gap-1">
                                    <i class="fas fa-star text-accent"></i> ${hotel.rating} <span class="text-gray-500 font-normal ml-1">(${hotel.reviewCount} reviews)</span>
                                </div>
                                <button class="absolute top-3 right-3 w-8 h-8 bg-white/50 dark:bg-black/50 backdrop-blur-md rounded-full flex items-center justify-center text-gray-800 dark:text-white hover:text-red-500 hover:bg-white transition-colors">
                                    <i class="far fa-heart"></i>
                                </button>
                            </div>

                            <!-- Content Section -->
                            <div class="sm:w-2/3 p-5 sm:p-6 flex flex-col">
                                <div class="flex justify-between items-start gap-4 mb-2">
                                    <div>
                                        <h3 class="text-xl sm:text-2xl font-bold text-gray-900 dark:text-white group-hover:text-primary transition-colors leading-tight mb-1">
                                            ${hotel.name}
                                        </h3>
                                        <div class="flex items-center text-sm text-gray-500 mb-2">
                                            <i class="fas fa-map-marker-alt text-primary mr-1.5"></i> 
                                            ${hotel.city} &bull; <span class="ml-1">${hotel.distanceFromCenter != null ? String.format("%.1f", hotel.distanceFromCenter) : '1.2'} km from center</span>
                                        </div>
                                    </div>
                                    <div class="text-right flex-shrink-0 bg-gray-50 dark:bg-gray-800/50 p-3 rounded-xl border border-gray-100 dark:border-gray-700">
                                        <div class="text-xs text-gray-500 uppercase tracking-wide mb-1">Price / Night</div>
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">$${hotel.startingPrice != null && hotel.startingPrice > 0 ? hotel.startingPrice : 150.0}</div>
                                        <div class="text-xs text-green-600 font-medium mt-1">Includes Taxes & Fees</div>
                                    </div>
                                </div>

                                <div class="flex flex-wrap gap-2 mb-4 mt-auto">
                                    <c:forEach var="amenity" items="${hotel.amenitiesArray}">
                                        <span class="text-xs font-medium bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 px-2.5 py-1 rounded-md border border-gray-200 dark:border-gray-700">
                                            ${amenity}
                                        </span>
                                    </c:forEach>
                                </div>

                                <div class="flex flex-col sm:flex-row justify-between items-center mt-4 pt-4 border-t border-gray-100 dark:border-gray-800 gap-4">
                                    <div class="w-full sm:w-auto">
                                        <div class="text-sm font-medium ${hotel.cancellationPolicy.contains('Free') ? 'text-green-600 dark:text-green-400' : 'text-gray-600 dark:text-gray-400'} mb-1 flex items-center gap-1.5">
                                            <i class="fas ${hotel.cancellationPolicy.contains('Free') ? 'fa-check-circle' : 'fa-info-circle'}"></i> 
                                            ${hotel.cancellationPolicy != null ? hotel.cancellationPolicy : 'Free Cancellation'}
                                        </div>
                                        <div class="text-xs text-red-500 font-medium flex items-center gap-1">
                                            <i class="fas fa-fire-alt"></i> Only ${hotel.availableRooms != null && hotel.availableRooms > 0 ? hotel.availableRooms : 3} rooms left at this price!
                                        </div>
                                    </div>
                                    
                                    <div class="flex gap-2 w-full sm:w-auto mt-2 sm:mt-0">
                                        <form action="${pageContext.request.contextPath}/hotel-details" method="GET" class="w-1/2 sm:w-auto">
                                            <input type="hidden" name="id" value="${hotel.id}">
                                            <input type="hidden" name="checkIn" value="${param.checkIn}">
                                            <input type="hidden" name="checkOut" value="${param.checkOut}">
                                            <input type="hidden" name="guests" value="${param.guests}">
                                            <button type="submit" class="w-full btn-outline py-2.5 px-4 rounded-lg text-sm font-medium whitespace-nowrap">
                                                View Details
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/hotel-details" method="GET" class="w-1/2 sm:w-auto">
                                            <input type="hidden" name="id" value="${hotel.id}">
                                            <input type="hidden" name="checkIn" value="${param.checkIn}">
                                            <input type="hidden" name="checkOut" value="${param.checkOut}">
                                            <input type="hidden" name="guests" value="${param.guests}">
                                            <button type="submit" class="w-full btn-primary py-2.5 px-6 rounded-lg text-sm font-bold whitespace-nowrap shadow-md hover:shadow-lg transform transition hover:-translate-y-0.5">
                                                Book Now
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
