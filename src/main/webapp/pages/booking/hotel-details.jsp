<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; background: #f8f9fa;" class="dark:bg-[#0a0a0a]">
    <div class="container mx-auto max-w-7xl px-4 py-6">
        
        <!-- Breadcrumbs -->
        <div class="mb-4 flex items-center text-sm text-gray-500 dark:text-gray-400">
            <a href="${pageContext.request.contextPath}/hotels" class="hover:text-primary transition-colors"><i class="fas fa-home mr-1"></i> Home</a>
            <i class="fas fa-chevron-right mx-2 text-xs"></i>
            <a href="${pageContext.request.contextPath}/hotel-search" class="hover:text-primary transition-colors">Search Results</a>
            <i class="fas fa-chevron-right mx-2 text-xs"></i>
            <span class="text-gray-900 dark:text-white font-medium truncate">${hotel.name}</span>
        </div>

        <div class="mb-6">
            <jsp:include page="/components/booking-stepper.jsp">
                <jsp:param name="step" value="1"/>
                <jsp:param name="type" value="hotel"/>
            </jsp:include>
        </div>

        <!-- Hotel Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-end gap-4 mb-6 relative">
            <div>
                <div class="flex flex-wrap gap-2 mb-2">
                    <c:if test="${hotel.bestSeller}"><span class="bg-yellow-400 text-yellow-900 text-xs font-bold px-2 py-1 rounded">Best Seller</span></c:if>
                    <c:if test="${hotel.recommended}"><span class="bg-purple-500 text-white text-xs font-bold px-2 py-1 rounded">Recommended</span></c:if>
                </div>
                <div class="flex items-center gap-3 mb-2">
                    <h1 class="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white editorial">${hotel.name}</h1>
                    <div class="flex text-accent text-sm">
                        <c:forEach var="i" begin="1" end="${hotel.rating >= 4.5 ? 5 : (hotel.rating >= 3.5 ? 4 : 3)}">
                            <i class="fas fa-star"></i>
                        </c:forEach>
                    </div>
                    <button id="wishlistBtn" class="ml-4 text-2xl ${isWishlisted ? 'text-red-500' : 'text-gray-300'} hover:text-red-500 transition-colors" onclick="toggleWishlist(${hotel.id})">
                        <i class="fa-heart ${isWishlisted ? 'fas' : 'far'}"></i>
                    </button>
                </div>
                <p class="text-gray-600 dark:text-gray-400 flex items-center gap-2">
                    <i class="fas fa-map-marker-alt text-primary"></i> ${hotel.address}, ${hotel.city}
                    <a href="#map-section" class="text-primary text-sm font-medium hover:underline ml-2">Show on map</a>
                </p>
            </div>
            <div class="flex flex-col items-end">
                <div class="flex items-center gap-3 bg-white dark:bg-gray-800 p-3 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700">
                    <div class="text-right">
                        <div class="font-bold text-gray-900 dark:text-white text-lg">${hotel.rating > 4.5 ? 'Exceptional' : 'Very Good'}</div>
                        <div class="text-sm text-gray-500">${hotel.rating > 0 ? '1,204' : '0'} reviews</div>
                    </div>
                    <div class="bg-primary text-white text-xl font-bold w-12 h-12 flex items-center justify-center rounded-lg shadow-md">
                        ${String.format("%.1f", hotel.rating)}
                    </div>
                </div>
            </div>
        </div>

        <!-- Photo Gallery -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-2 md:gap-4 mb-12 h-[500px] rounded-2xl overflow-hidden group">
            <!-- Main Image -->
            <div class="md:col-span-2 h-full relative overflow-hidden">
                <img src="${not empty photos ? photos[0].url : hotel.imageUrl}" alt="Main view" class="w-full h-full object-cover transition-transform duration-700 hover:scale-105 cursor-pointer">
            </div>
            <!-- Sub Images Grid -->
            <div class="hidden md:grid md:col-span-2 grid-cols-2 grid-rows-2 gap-4 h-full">
                <c:forEach var="photo" items="${photos}" begin="1" end="3" varStatus="loop">
                    <div class="relative overflow-hidden rounded-xl">
                        <img src="${photo.url}" alt="${photo.caption}" class="w-full h-full object-cover transition-transform duration-700 hover:scale-105 cursor-pointer">
                    </div>
                </c:forEach>
                <!-- Fill remaining with placeholders if not enough photos -->
                <c:if test="${empty photos or photos.size() < 4}">
                    <div class="relative overflow-hidden rounded-xl">
                        <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80" alt="Room" class="w-full h-full object-cover transition-transform duration-700 hover:scale-105 cursor-pointer">
                    </div>
                    <div class="relative overflow-hidden rounded-xl bg-gray-900 group cursor-pointer">
                        <img src="https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80" alt="Dining" class="w-full h-full object-cover opacity-60 transition-transform duration-700 hover:scale-105">
                        <div class="absolute inset-0 flex items-center justify-center">
                            <span class="text-white font-bold text-lg border-2 border-white px-4 py-2 rounded-lg backdrop-blur-sm">View All Photos</span>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty photos and photos.size() >= 4}">
                    <div class="relative overflow-hidden rounded-xl bg-gray-900 group cursor-pointer">
                        <img src="${photos[3].url}" alt="${photos[3].caption}" class="w-full h-full object-cover opacity-60 transition-transform duration-700 hover:scale-105">
                        <div class="absolute inset-0 flex items-center justify-center">
                            <span class="text-white font-bold text-lg border-2 border-white px-4 py-2 rounded-lg backdrop-blur-sm">View All ${photos.size() + 1} Photos</span>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="flex flex-col lg:flex-row gap-8">
            
            <!-- Left Column: Info & Details -->
            <div class="lg:w-2/3">
                
                <!-- Description -->
                <section class="surface-panel rounded-2xl p-6 md:p-8 shadow-sm mb-8">
                    <h2 class="text-2xl font-bold mb-4 editorial">About this hotel</h2>
                    <p class="text-gray-600 dark:text-gray-300 leading-relaxed">
                        <c:choose>
                            <c:when test="${not empty hotel.description}">${hotel.description}</c:when>
                            <c:otherwise>Experience world-class hospitality and premium comfort at ${hotel.name}. This premium hotel located in ${hotel.city} offers exceptional service, modern amenities, and a truly unforgettable stay for both leisure and business travelers. Enjoy easy access to top local attractions and a relaxing environment tailored to your every need.</c:otherwise>
                        </c:choose>
                    </p>
                </section>

                <!-- Amenities -->
                <section class="surface-panel rounded-2xl p-6 md:p-8 shadow-sm mb-8">
                    <h2 class="text-2xl font-bold mb-6 editorial">Most Popular Amenities</h2>
                    <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <c:choose>
                            <c:when test="${not empty hotel.amenitiesArray}">
                                <c:forEach var="amenity" items="${hotel.amenitiesArray}">
                                    <div class="flex items-center gap-3 text-gray-700 dark:text-gray-300 bg-gray-50 dark:bg-gray-800/50 p-3 rounded-xl border border-gray-100 dark:border-gray-800">
                                        <i class="fas fa-check-circle text-green-500"></i>
                                        <span class="font-medium">${amenity}</span>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="amenity" items="WiFi,Pool,Parking,Restaurant,Gym,Spa,Room Service">
                                    <div class="flex items-center gap-3 text-gray-700 dark:text-gray-300 bg-gray-50 dark:bg-gray-800/50 p-3 rounded-xl border border-gray-100 dark:border-gray-800">
                                        <i class="fas fa-check-circle text-green-500"></i>
                                        <span class="font-medium">${amenity}</span>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <!-- Availability & Rooms -->
                <section id="rooms-section" class="mb-8">
                    <h2 class="text-2xl font-bold mb-6 editorial">Availability</h2>
                    
                    <c:if test="${empty checkIn or empty checkOut}">
                        <div class="bg-yellow-50 dark:bg-yellow-900/30 border-l-4 border-yellow-400 p-4 mb-6 rounded-r-lg shadow-sm">
                            <p class="text-yellow-800 dark:text-yellow-200 font-medium flex items-center gap-2">
                                <i class="fas fa-calendar-alt"></i> Please enter Check-in and Check-out dates to view accurate pricing and book a room.
                            </p>
                        </div>
                    </c:if>

                    <div class="flex flex-col gap-6">
                    <form action="${pageContext.request.contextPath}/hotel-checkout" method="GET" id="roomSelectionForm" class="relative pb-24">
                        <input type="hidden" name="hotelId" value="${hotel.id}">
                        <input type="hidden" name="checkIn" value="${checkIn}">
                        <input type="hidden" name="checkOut" value="${checkOut}">
                        <input type="hidden" name="guests" value="${guests}">
                        
                        <div class="flex flex-col gap-6">
                            <c:choose>
                                <c:when test="${not empty rooms}">
                                    <c:forEach var="room" items="${rooms}">
                                        <label for="room-${room.id}" class="cursor-pointer group relative block">
                                            <input type="radio" name="roomId" value="${room.id}" id="room-${room.id}" class="peer absolute opacity-0 w-0 h-0" onchange="updateSelectedRoom('${room.type}', ${room.pricePerNight})" ${empty checkIn or empty checkOut ? 'disabled' : ''}>
                                            <div class="surface-panel rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-all duration-300 flex flex-col md:flex-row border-2 border-transparent peer-checked:border-primary peer-checked:bg-primary/5 dark:peer-checked:bg-primary/10">
                                                
                                                <!-- Room Image -->
                                                <div class="md:w-1/3 h-48 md:h-auto relative">
                                                    <img src="${room.imageUrl}" alt="${room.type}" class="w-full h-full object-cover">
                                                </div>
                                                
                                                <!-- Room Details -->
                                                <div class="md:w-2/3 p-6 flex flex-col">
                                                    <div class="flex justify-between items-start mb-4">
                                                        <div>
                                                            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">${room.type}</h3>
                                                            <div class="flex flex-wrap gap-4 text-sm text-gray-600 dark:text-gray-400">
                                                                <div class="flex items-center gap-1.5"><i class="fas fa-vector-square text-gray-400"></i> ${room.roomSize != null ? room.roomSize : '30 m²'}</div>
                                                                <div class="flex items-center gap-1.5"><i class="fas fa-bed text-gray-400"></i> ${room.bedType != null ? room.bedType : '1 Double Bed'}</div>
                                                                <div class="flex items-center gap-1.5"><i class="fas fa-user-friends text-gray-400"></i> Max ${room.capacity} Guests</div>
                                                            </div>
                                                        </div>
                                                        <div class="text-right">
                                                            <div class="text-2xl font-bold text-primary">$${room.pricePerNight}</div>
                                                            <div class="text-xs text-gray-500">per night</div>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="flex flex-wrap gap-2 mb-4">
                                                        <c:forEach var="ramen" items="${room.amenitiesArray}">
                                                            <span class="text-xs font-medium bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 px-2.5 py-1 rounded-md border border-gray-100 dark:border-gray-700">
                                                                ${ramen}
                                                            </span>
                                                        </c:forEach>
                                                    </div>

                                                    <div class="mt-auto pt-4 border-t border-gray-100 dark:border-gray-800 flex flex-col sm:flex-row justify-between items-center gap-4">
                                                        <div class="w-full">
                                                            <c:if test="${room.freeCancellation}">
                                                                <div class="text-sm text-green-600 font-medium mb-1"><i class="fas fa-check"></i> Free Cancellation before check-in</div>
                                                            </c:if>
                                                            <c:if test="${room.breakfastIncluded}">
                                                                <div class="text-sm text-green-600 font-medium mb-1"><i class="fas fa-coffee"></i> Breakfast Included</div>
                                                            </c:if>
                                                            <c:if test="${!room.freeCancellation && !room.breakfastIncluded}">
                                                                <div class="text-sm text-gray-500 font-medium mb-1"><i class="fas fa-info-circle"></i> Standard rate</div>
                                                            </c:if>
                                                        </div>
                                                        <div class="hidden peer-checked:flex w-full sm:w-auto items-center justify-end text-primary font-bold whitespace-nowrap">
                                                            <i class="fas fa-check-circle mr-2"></i> Selected
                                                        </div>
                                                        <div class="flex sm:hidden peer-checked:hidden w-full items-center text-gray-400 font-medium whitespace-nowrap text-sm border border-gray-200 dark:border-gray-700 px-4 py-2 rounded-lg justify-center">
                                                            Tap to select
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </label>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <label for="room-mock" class="cursor-pointer group relative block">
                                        <input type="radio" name="roomId" value="-1" id="room-mock" class="peer absolute opacity-0 w-0 h-0" onchange="updateSelectedRoom('Standard Double Room', ${hotel.startingPrice > 0 ? hotel.startingPrice : 150})" ${empty checkIn or empty checkOut ? 'disabled' : ''}>
                                        <div class="surface-panel rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-all duration-300 flex flex-col md:flex-row border-2 border-transparent peer-checked:border-primary peer-checked:bg-primary/5 dark:peer-checked:bg-primary/10">
                                            <div class="md:w-1/3 h-48 md:h-auto relative">
                                                <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80" alt="Standard Double Room" class="w-full h-full object-cover">
                                            </div>
                                            <div class="md:w-2/3 p-6 flex flex-col">
                                                <div class="flex justify-between items-start mb-4">
                                                    <div>
                                                        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Standard Double Room</h3>
                                                        <div class="flex flex-wrap gap-4 text-sm text-gray-600 dark:text-gray-400">
                                                            <div class="flex items-center gap-1.5"><i class="fas fa-vector-square text-gray-400"></i> 30 m²</div>
                                                            <div class="flex items-center gap-1.5"><i class="fas fa-bed text-gray-400"></i> 1 Double Bed</div>
                                                            <div class="flex items-center gap-1.5"><i class="fas fa-user-friends text-gray-400"></i> Max 2 Guests</div>
                                                        </div>
                                                    </div>
                                                    <div class="text-right">
                                                        <div class="text-2xl font-bold text-primary">$${hotel.startingPrice > 0 ? hotel.startingPrice : 150}</div>
                                                        <div class="text-xs text-gray-500">per night</div>
                                                    </div>
                                                </div>
                                                <div class="flex flex-wrap gap-2 mb-4">
                                                    <span class="text-xs font-medium bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 px-2.5 py-1 rounded-md border border-gray-100 dark:border-gray-700">Air Conditioning</span>
                                                    <span class="text-xs font-medium bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 px-2.5 py-1 rounded-md border border-gray-100 dark:border-gray-700">Free WiFi</span>
                                                    <span class="text-xs font-medium bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 px-2.5 py-1 rounded-md border border-gray-100 dark:border-gray-700">Flat-screen TV</span>
                                                </div>
                                                <div class="mt-auto pt-4 border-t border-gray-100 dark:border-gray-800 flex flex-col sm:flex-row justify-between items-center gap-4">
                                                    <div class="w-full">
                                                        <div class="text-sm text-green-600 font-medium mb-1"><i class="fas fa-check"></i> Free Cancellation before check-in</div>
                                                    </div>
                                                    <div class="hidden peer-checked:flex w-full sm:w-auto items-center justify-end text-primary font-bold whitespace-nowrap">
                                                        <i class="fas fa-check-circle mr-2"></i> Selected
                                                    </div>
                                                    <div class="flex sm:hidden peer-checked:hidden w-full items-center text-gray-400 font-medium whitespace-nowrap text-sm border border-gray-200 dark:border-gray-700 px-4 py-2 rounded-lg justify-center">
                                                        Tap to select
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Sticky Selection Bar -->
                        <div id="stickySelectionBar" class="fixed bottom-0 left-0 w-full bg-white dark:bg-gray-900 border-t border-gray-200 dark:border-gray-800 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.1)] p-4 transform translate-y-full transition-transform duration-300 z-50 flex justify-center">
                            <div class="w-full max-w-7xl px-4 flex flex-col sm:flex-row justify-between items-center gap-4">
                                <div>
                                    <div class="text-sm text-gray-500 mb-1">Selected Room</div>
                                    <div class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-3">
                                        <span id="selectedRoomName">--</span>
                                        <span class="text-primary" id="selectedRoomPrice">$--</span>
                                    </div>
                                </div>
                                <button type="submit" class="btn-primary py-3 px-8 rounded-xl font-bold shadow-md hover:shadow-lg w-full sm:w-auto text-lg">
                                    Continue Booking <i class="fas fa-arrow-right ml-2"></i>
                                </button>
                            </div>
                        </div>

                    </form>

                    <script>
                        function updateSelectedRoom(name, price) {
                            document.getElementById('selectedRoomName').innerText = name;
                            document.getElementById('selectedRoomPrice').innerText = '$' + price + ' / night';
                            document.getElementById('stickySelectionBar').classList.remove('translate-y-full');
                        }
                    </script>
                </section>

                <!-- Reviews Section -->
                <section class="surface-panel rounded-2xl p-6 md:p-8 shadow-sm mb-8">
                    <div class="flex flex-col sm:flex-row items-center justify-between mb-6 gap-4">
                        <h2 class="text-2xl font-bold editorial">Guest Reviews</h2>
                        <c:if test="${not empty sessionScope.user}">
                            <button onclick="document.getElementById('reviewForm').classList.toggle('hidden')" class="btn-outline px-4 py-2 text-sm rounded-lg whitespace-nowrap">Write a Review</button>
                        </c:if>
                    </div>
                    
                    <c:if test="${not empty sessionScope.user}">
                        <div id="reviewForm" class="hidden mb-8 bg-gray-50 dark:bg-gray-800 p-6 rounded-xl">
                            <form action="${pageContext.request.contextPath}/add-hotel-review" method="POST">
                                <input type="hidden" name="hotelId" value="${hotel.id}">
                                <div class="mb-4">
                                    <label class="block text-sm font-medium mb-2">Rating</label>
                                    <select name="rating" class="form-input w-full md:w-1/3">
                                        <option value="5">5 - Excellent</option>
                                        <option value="4">4 - Very Good</option>
                                        <option value="3">3 - Average</option>
                                        <option value="2">2 - Poor</option>
                                        <option value="1">1 - Terrible</option>
                                    </select>
                                </div>
                                <div class="mb-4">
                                    <label class="block text-sm font-medium mb-2">Review</label>
                                    <textarea name="reviewText" rows="4" class="form-input w-full" required></textarea>
                                </div>
                                <button type="submit" class="btn-primary px-6 py-2 rounded-lg">Submit Review</button>
                            </form>
                        </div>
                    </c:if>

                    <c:if test="${empty reviews}">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                            <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl border border-gray-100 dark:border-gray-800">
                                <div class="flex items-center gap-4 mb-4">
                                    <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center text-primary font-bold text-xl">S</div>
                                    <div>
                                        <div class="font-bold">Sarah Jenkins</div>
                                        <div class="text-xs text-gray-500">2 days ago</div>
                                    </div>
                                </div>
                                <div class="flex text-accent text-sm mb-2">
                                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                </div>
                                <p class="text-sm text-gray-600 dark:text-gray-400">"Absolutely loved my stay here! The staff was incredibly welcoming and the room was spotless. Will definitely be coming back."</p>
                            </div>
                            <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl border border-gray-100 dark:border-gray-800">
                                <div class="flex items-center gap-4 mb-4">
                                    <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center text-primary font-bold text-xl">M</div>
                                    <div>
                                        <div class="font-bold">Michael T.</div>
                                        <div class="text-xs text-gray-500">1 week ago</div>
                                    </div>
                                </div>
                                <div class="flex text-accent text-sm mb-2">
                                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i>
                                </div>
                                <p class="text-sm text-gray-600 dark:text-gray-400">"Great location and very comfortable beds. The breakfast buffet had a fantastic variety of options."</p>
                            </div>
                            <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl border border-gray-100 dark:border-gray-800">
                                <div class="flex items-center gap-4 mb-4">
                                    <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center text-primary font-bold text-xl">E</div>
                                    <div>
                                        <div class="font-bold">Emily Chen</div>
                                        <div class="text-xs text-gray-500">2 weeks ago</div>
                                    </div>
                                </div>
                                <div class="flex text-accent text-sm mb-2">
                                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                </div>
                                <p class="text-sm text-gray-600 dark:text-gray-400">"The best hotel experience I've had in years. Highly recommend this place to anyone visiting the city!"</p>
                            </div>
                        </div>
                    </c:if>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                        <c:forEach var="review" items="${reviews}" end="3">
                            <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl border border-gray-100 dark:border-gray-800">
                                <div class="flex items-center gap-4 mb-4">
                                    <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center text-primary font-bold text-xl">${review.userName.substring(0,1)}</div>
                                    <div>
                                        <div class="font-bold">${review.userName}</div>
                                        <div class="text-xs text-gray-500">${review.createdAt}</div>
                                    </div>
                                </div>
                                <div class="flex text-accent text-sm mb-2">
                                    <c:forEach var="i" begin="1" end="${review.rating}">
                                        <i class="fas fa-star"></i>
                                    </c:forEach>
                                    <c:forEach var="i" begin="${review.rating + 1}" end="5">
                                        <i class="far fa-star"></i>
                                    </c:forEach>
                                </div>
                                <p class="text-sm text-gray-600 dark:text-gray-400">"${review.reviewText}"</p>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${not empty reviews}">
                        <button class="text-primary font-bold text-sm hover:underline">Read all ${reviews.size()} reviews <i class="fas fa-arrow-right ml-1"></i></button>
                    </c:if>
                </section>

            </div>

            <!-- Right Column: Sidebar (Policies & Map) -->
            <aside class="lg:w-1/3">
                <div class="sticky top-[100px] flex flex-col gap-6">
                    
                    <!-- Map Widget -->
                    <div id="map-section" class="surface-panel rounded-2xl overflow-hidden shadow-sm">
                        <div class="p-4 border-b border-gray-100 dark:border-gray-800">
                            <h3 class="font-bold text-lg">Location</h3>
                        </div>
                        <div class="h-64 bg-gray-200 relative">
                            <!-- Mock Map Iframe based on City -->
                            <iframe 
                                width="100%" 
                                height="100%" 
                                frameborder="0" 
                                style="border:0" 
                                src="https://maps.google.com/maps?q=${hotel.city}&t=&z=13&ie=UTF8&iwloc=&output=embed" 
                                allowfullscreen>
                            </iframe>
                        </div>
                        <div class="p-4 bg-white dark:bg-gray-900">
                            <p class="text-sm text-gray-600 dark:text-gray-400 flex items-start gap-2">
                                <i class="fas fa-map-pin text-primary mt-1"></i> 
                                ${hotel.address}, ${hotel.city}
                            </p>
                        </div>
                    </div>
                    
                    <!-- Nearby Places Widget -->
                    <c:if test="${not empty nearbyPlaces}">
                        <div class="surface-panel rounded-2xl shadow-sm p-6">
                            <h3 class="font-bold text-lg mb-4 border-b border-gray-100 dark:border-gray-800 pb-2">Nearby Places</h3>
                            <div class="flex flex-col gap-4">
                                <c:forEach var="place" items="${nearbyPlaces}">
                                    <div class="flex justify-between items-center">
                                        <div class="flex items-center gap-3">
                                            <i class="${place.placeType == 'Attraction' ? 'fas fa-camera text-blue-500' : 'fas fa-utensils text-orange-500'}"></i>
                                            <span class="text-sm font-medium">${place.name}</span>
                                        </div>
                                        <span class="text-xs text-gray-500">${place.distanceKm} km</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Policies Widget -->
                    <div class="surface-panel rounded-2xl shadow-sm p-6">
                        <h3 class="font-bold text-lg mb-4 border-b border-gray-100 dark:border-gray-800 pb-2">Hotel Policies</h3>
                        
                        <div class="flex flex-col gap-4">
                            <div class="flex gap-4">
                                <div class="w-8 flex justify-center text-gray-400"><i class="fas fa-clock text-xl"></i></div>
                                <div>
                                    <div class="font-bold text-sm">Check-in / Check-out</div>
                                    <div class="text-sm text-gray-600 dark:text-gray-400">Check-in from 14:00<br>Check-out until 12:00</div>
                                </div>
                            </div>
                            
                            <div class="flex gap-4">
                                <div class="w-8 flex justify-center text-gray-400"><i class="fas fa-times-circle text-xl"></i></div>
                                <div>
                                    <div class="font-bold text-sm">Cancellation / Prepayment</div>
                                    <div class="text-sm text-gray-600 dark:text-gray-400">Cancellation policies vary according to room type. Please check the room conditions.</div>
                                </div>
                            </div>
                            
                            <div class="flex gap-4">
                                <div class="w-8 flex justify-center text-gray-400"><i class="fas fa-paw text-xl"></i></div>
                                <div>
                                    <div class="font-bold text-sm">Pets</div>
                                    <div class="text-sm text-gray-600 dark:text-gray-400">Pets are not allowed.</div>
                                </div>
                            </div>

                            <div class="flex gap-4">
                                <div class="w-8 flex justify-center text-gray-400"><i class="fas fa-credit-card text-xl"></i></div>
                                <div>
                                    <div class="font-bold text-sm">Accepted payment methods</div>
                                    <div class="flex gap-2 mt-1 text-2xl text-gray-500">
                                        <i class="fab fa-cc-visa"></i>
                                        <i class="fab fa-cc-mastercard"></i>
                                        <i class="fab fa-cc-amex"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </aside>

        </div>
    </div>
</main>

<script>
    function toggleWishlist(hotelId) {
        fetch('${pageContext.request.contextPath}/toggle-wishlist', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'hotelId=' + hotelId
        })
        .then(response => {
            if (response.status === 401) {
                window.location.href = '${pageContext.request.contextPath}/login.jsp';
                return;
            }
            return response.json();
        })
        .then(data => {
            if (data && data.status === 'success') {
                const btn = document.getElementById('wishlistBtn');
                const icon = btn.querySelector('i');
                if (data.isWishlisted) {
                    btn.classList.remove('text-gray-300');
                    btn.classList.add('text-red-500');
                    icon.classList.remove('far');
                    icon.classList.add('fas');
                } else {
                    btn.classList.add('text-gray-300');
                    btn.classList.remove('text-red-500');
                    icon.classList.add('far');
                    icon.classList.remove('fas');
                }
            }
        });
    }
</script>

<%@ include file="/components/footer.jsp" %>