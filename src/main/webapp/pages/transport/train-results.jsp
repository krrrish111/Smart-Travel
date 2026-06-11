<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4">
        
        <!-- Search Summary Header -->
        <div class="mb-6 flex justify-between items-center bg-gray-800 rounded-lg p-4 shadow-lg" style="background: var(--color-surface); border: 1px solid var(--color-border);">
            <div>
                <h1 class="text-2xl font-bold text-white flex items-center gap-2">
                    <span>🚆</span> Trains: <c:out value="${searchFrom}" default="Delhi"/> to <c:out value="${searchTo}" default="Mumbai"/>
                </h1>
                <p class="text-sm text-gray-400 mt-1">
                    <c:out value="${searchDate}" default="Any Date"/> | Class: <c:out value="${searchClass}" default="All"/> | Quota: <c:out value="${searchQuota}" default="General"/>
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/booking.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 text-white rounded-lg transition text-sm">Modify Search</a>
        </div>

        <!-- Results Section -->
        <div class="flex flex-col gap-4">
            <c:choose>
                <c:when test="${not empty trainResults}">
                    <c:forEach var="train" items="${trainResults}">
                        <div class="bg-gray-800 rounded-lg p-5 shadow flex flex-col md:flex-row justify-between items-center" style="background: var(--color-surface); border: 1px solid var(--color-border);">
                            
                            <!-- Train Info -->
                            <div class="flex items-center gap-4 mb-4 md:mb-0" style="width: 25%;">
                                <div class="bg-blue-500 bg-opacity-20 p-3 rounded-full flex items-center justify-center">
                                    <span class="text-2xl">🚆</span>
                                </div>
                                <div>
                                    <h3 class="text-lg font-bold text-white"><c:out value="${train.trainName}"/></h3>
                                    <p class="text-sm text-gray-400">#<c:out value="${train.trainNumber}"/></p>
                                </div>
                            </div>

                            <!-- Timing -->
                            <div class="flex items-center justify-between gap-6" style="width: 40%;">
                                <div class="text-center">
                                    <p class="text-xl font-bold text-white"><c:out value="${train.departureTime}"/></p>
                                    <p class="text-xs text-gray-400"><c:out value="${searchFrom}" default="Origin"/></p>
                                </div>
                                <div class="flex flex-col items-center flex-1">
                                    <p class="text-xs text-gray-400 mb-1"><c:out value="${train.duration}"/></p>
                                    <div class="w-full h-px bg-gray-600 relative">
                                        <div class="absolute w-2 h-2 rounded-full bg-gray-400 -mt-1 left-0"></div>
                                        <div class="absolute w-2 h-2 rounded-full bg-gray-400 -mt-1 right-0"></div>
                                    </div>
                                    <p class="text-xs text-green-400 mt-1">Direct</p>
                                </div>
                                <div class="text-center">
                                    <p class="text-xl font-bold text-white"><c:out value="${train.arrivalTime}"/></p>
                                    <p class="text-xs text-gray-400"><c:out value="${searchTo}" default="Destination"/></p>
                                </div>
                            </div>

                            <!-- Seats & Price -->
                            <div class="flex flex-col items-end gap-2" style="width: 25%;">
                                <p class="text-2xl font-bold text-white">₹<c:out value="${train.fare}"/></p>
                                <c:choose>
                                    <c:when test="${train.availableSeats > 20}">
                                        <p class="text-sm text-green-400">Available: <c:out value="${train.availableSeats}"/></p>
                                    </c:when>
                                    <c:when test="${train.availableSeats > 0}">
                                        <p class="text-sm text-orange-400">Filling Fast: <c:out value="${train.availableSeats}"/></p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-sm text-red-400">Waitlist</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex flex-col gap-2 w-full md:w-auto mt-4 md:mt-0">
                                <button class="px-6 py-2 bg-gray-700 hover:bg-gray-600 text-white text-sm font-bold rounded-lg transition w-full">View Details</button>
                                <form action="${pageContext.request.contextPath}/transport/train/booking" method="post" class="m-0">
                                    <input type="hidden" name="trainNo" value="${train.trainNumber}">
                                    <input type="hidden" name="fare" value="${train.fare}">
                                    <button type="submit" class="px-6 py-2 btn-primary text-black text-sm font-bold rounded-lg transition w-full" style="background: var(--color-primary);">Book Now</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-10">
                        <p class="text-gray-400 text-lg">No trains found for this route.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
