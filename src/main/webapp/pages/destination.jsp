<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">

    <!-- Destination Hero Section -->
    <div class="container relative z-10 mb-12">
        <div class="glass-panel text-center slide-up" style="padding: 0; overflow: hidden; border-radius: var(--border-radius-lg);">
            <div style="height: 400px; width: 100%; position: relative;">
                <img src="${not empty destination.imageUrl ? destination.imageUrl : 'https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=1200&q=80'}" 
                     alt="${destination.name}" style="width: 100%; height: 100%; object-fit: cover;">
                <div style="position: absolute; inset: 0; background: linear-gradient(to top, var(--color-surface), transparent);"></div>
                <div style="position: absolute; bottom: 40px; left: 0; right: 0;">
                    <h1 class="text-white editorial shadow-text" style="font-size: 3.5rem; text-shadow: 0 4px 12px rgba(0,0,0,0.8);">${destination.name}</h1>
                </div>
            </div>
            <div style="padding: 40px; max-width: 800px; margin: 0 auto;">
                <p class="text-muted text-lg font-body" style="line-height: 1.8;">${destination.description}</p>
                
                <div class="mt-8">
                    <a href="${pageContext.request.contextPath}/planner?location=${destination.name}" class="btn btn-primary" style="padding: 14px 32px; font-size: 1.1rem; border-radius: 50px;">
                        Plan a Trip Here âœ¨
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container relative z-10 grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Left: Reviews Feed -->
        <div class="lg:col-span-2 slide-up delay-1">
            <h2 class="text-main editorial mb-6" style="font-size: 2rem;">Traveller Reviews</h2>
            
            <c:if test="${empty reviews}">
                <div class="glass-panel text-center py-12">
                    <p class="text-muted" style="font-size: 1.1rem;">No reviews yet. Be the first to share your experience!</p>
                </div>
            </c:if>

            <div id="reviewsFeed" class="flex flex-col gap-5" data-skeleton="list" data-skeleton-count="2">
                <c:forEach var="review" items="${reviews}">
                    <div class="glass-panel relative" style="padding: 24px;">
                        <div class="flex justify-between items-start mb-3">
                            <div>
                                <h4 class="text-main font-bold m-0" style="font-size: 1.1rem;">${review.userName}</h4>
                                <span class="text-muted text-xs"><fmt:formatDate value="${review.createdAt}" pattern="MMM dd, yyyy" /></span>
                            </div>
                            <div class="text-primary font-bold" style="font-size: 1.2rem;">
                                <!-- Simple Star Rating -->
                                <c:forEach begin="1" end="5" var="i">
                                    <span style="color: ${i <= review.rating ? 'var(--color-primary)' : 'rgba(255,255,255,0.2)'}">â˜…</span>
                                </c:forEach>
                            </div>
                        </div>
                        <p class="text-white opacity-90 m-0" style="font-size: 0.95rem; line-height: 1.6;">
                            <c:out value="${review.comment}" />
                        </p>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Right Sidebar -->
        <div class="slide-up delay-2">
            
            <!-- Weather Widget -->
            <div class="glass-panel mb-6" id="weatherWidget" style="padding: 24px; border: 1px solid rgba(255,255,255,0.1); display: none;">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-xs uppercase tracking-widest text-muted m-0">Current Weather</h3>
                    <div id="weatherIcon" style="font-size: 1.5rem;"></div>
                </div>
                <div class="flex items-baseline gap-2">
                    <div id="weatherTemp" class="text-main font-bold" style="font-size: 2.5rem; line-height: 1;">--</div>
                    <div class="text-muted text-sm">Â°C</div>
                </div>
                <div id="weatherDesc" class="text-primary font-medium mt-2 capitalize" style="font-size: 0.9rem;">Loading forecast...</div>
                
                <div class="grid grid-cols-2 gap-4 mt-6 pt-6" style="border-top: 1px solid rgba(255,255,255,0.05);">
                    <div>
                        <span class="text-[0.65rem] text-muted uppercase font-bold tracking-wider">Humidity</span>
                        <div id="weatherHum" class="text-white font-bold" style="font-size: 0.95rem;">--</div>
                    </div>
                    <div>
                        <span class="text-[0.65rem] text-muted uppercase font-bold tracking-wider">Wind Speed</span>
                        <div id="weatherWind" class="text-white font-bold" style="font-size: 0.95rem;">--</div>
                    </div>
                </div>
            </div>

            <div class="glass-panel" style="position: sticky; top: 120px;">
                <h3 class="text-main mb-4 editorial" style="font-size: 1.5rem;">Write a Review</h3>
                
                <form id="addReviewForm" action="${pageContext.request.contextPath}/review" method="POST" data-vx>
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="destination_id" value="${destination.id}">
                    
                    <div class="form-group mb-4">
                        <label class="form-label">Rating (1-5)</label>
                        <select name="rating" id="reviewRating" class="form-control"
                                data-v-required data-v-label="Rating"
                                style="appearance: none; background-color: rgba(255,255,255,0.05);">
                            <option value="5" style="color:#000">â­â­â­â­â­ (5) Excellent</option>
                            <option value="4" style="color:#000">â­â­â­â­ (4) Very Good</option>
                            <option value="3" style="color:#000">â­â­â­ (3) Average</option>
                            <option value="2" style="color:#000">â­â­ (2) Poor</option>
                            <option value="1" style="color:#000">â­ (1) Terrible</option>
                        </select>
                    </div>
                    
                    <div class="form-group mb-5">
                        <label class="form-label">Your Experience</label>
                        <textarea id="reviewComment" name="comment" class="form-control" rows="4"
                                  placeholder="Tell us what you loved..."
                                  data-v-required data-v-min-len="10" data-v-label="Review"
                                  style="resize: none;"></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-secondary w-full" style="padding: 12px; font-weight: bold;">
                        Post Review
                    </button>
                    
                    <!-- Form Submission Auth Guard -->
                    <script>
                        document.getElementById('addReviewForm').addEventListener('submit', function(e) {
                            if (typeof VoyastraAuth !== 'undefined' && !VoyastraAuth.isAuthenticated()) {
                                e.preventDefault();
                                VoyastraAuth.requireAuth('${pageContext.request.contextPath}/destination?id=${destination.id}');
                            }
                        });
                    </script>
                </form>
            </div>
        </div>
    </div>
<script>
    // Fetch Weather Data from our Proxy Servlet
    async function fetchWeather() {
        const locationName = "${destination.name}";
        const widget = document.getElementById('weatherWidget');
        if (!widget) return;

        try {
            const response = await fetch(`${pageContext.request.contextPath}/api/weather?location=` + encodeURIComponent(locationName));
            if (!response.ok) throw new Error('Weather unavailable');
            const data = await response.json();

            // Mapping OpenWeather icons to emojis
            const iconMap = {
                'Clear': 'â˜€ï¸',
                'Clouds': 'â˜ï¸',
                'Rain': 'ðŸŒ§ï¸',
                'Drizzle': 'ðŸŒ¦ï¸',
                'Thunderstorm': 'â›ˆï¸',
                'Snow': 'â„ï¸',
                'Mist': 'ðŸŒ«ï¸',
                'Smoke': 'ðŸŒ«ï¸',
                'Haze': 'ðŸŒ«ï¸'
            };

            const condition = data.weather[0].main;
            document.getElementById('weatherIcon').innerText = iconMap[condition] || 'â›…';
            document.getElementById('weatherTemp').innerText = Math.round(data.main.temp);
            document.getElementById('weatherDesc').innerText = data.weather[0].description;
            document.getElementById('weatherHum').innerText = data.main.humidity + '%';
            document.getElementById('weatherWind').innerText = data.wind.speed + ' m/s';
            
            // Show widget with animation
            widget.style.display = 'block';
            widget.classList.add('slide-up');
        } catch (err) {
            console.error('Weather fetch error:', err);
            // Hide widget if something goes wrong
            widget.style.display = 'none';
        }
    }

    // Load weather on page load
    window.addEventListener('DOMContentLoaded', fetchWeather);
</script>
</main>

<%@ include file="/components/footer.jsp" %>

