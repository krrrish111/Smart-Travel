<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
.itinerary-hero {
    position: relative;
    width: 100%;
    min-height: 40vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background-size: cover;
    background-position: center;
    background-image: url('${not empty destination.imageUrl ? destination.imageUrl : "https://images.unsplash.com/photo-1542332213-31f87348057f"}');
    padding-top: 80px;
}
.itinerary-hero-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(15,11,8,0.9) 100%);
    z-index: 1;
}
.itinerary-hero-content {
    position: relative;
    z-index: 2;
    text-align: center;
    max-width: 800px;
}
.itinerary-timeline {
    position: relative;
    border-left: 2px solid var(--color-primary);
    padding-left: 30px;
    margin-left: 20px;
}
.itinerary-day {
    position: relative;
    margin-bottom: 40px;
    padding: 30px;
    background: var(--surface-glass);
    border: 1px solid var(--color-border);
    border-radius: 20px;
}
.itinerary-day::before {
    content: '';
    position: absolute;
    left: -40px;
    top: 30px;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: var(--color-primary);
    border: 4px solid var(--color-surface);
}
</style>

<main>
    <section class="itinerary-hero">
        <div class="itinerary-hero-overlay"></div>
        <div class="itinerary-hero-content">
            <h1 class="text-4xl font-bold text-white mb-2 editorial">Itinerary for ${destination.title}</h1>
            <p class="text-lg text-gray-300">${destination.durationDays} Days of unforgettable experiences</p>
        </div>
    </section>

    <div class="container my-12 max-w-4xl">
        <div class="mb-8 flex justify-between items-center">
            <a href="${pageContext.request.contextPath}/destination/details?id=${destination.id}" class="text-primary hover:underline">&larr; Back to Details</a>
            <a href="${pageContext.request.contextPath}/destination/customize?id=${destination.id}" class="btn btn-primary">Book This Trip</a>
        </div>

        <c:if test="${empty itineraries}">
            <div class="p-8 text-center glass-panel rounded-2xl">
                <p class="text-muted text-lg">Detailed itinerary is being prepared for this destination.</p>
            </div>
        </c:if>

        <div class="itinerary-timeline">
            <c:forEach var="it" items="${itineraries}">
                <div class="itinerary-day">
                    <h4 class="font-bold text-xl text-primary mb-3">Day ${it.dayNumber}: ${it.title}</h4>
                    <p class="text-muted text-base leading-relaxed">${it.details}</p>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
