<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container mx-auto px-4 relative" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh;">

    <!-- Top Bar -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 slide-up">
        <div>
            <a href="${pageContext.request.contextPath}/command-center" class="text-sm text-muted hover:text-primary mb-2 inline-block"><i class="ri-search-line mr-1"></i> New Search</a>
            <h1 class="text-primary editorial" style="font-size: 3rem;">${destination}</h1>
            <p class="text-muted">Live Destination Intelligence & Forecasting</p>
        </div>
        <div class="mt-4 md:mt-0 text-right">
            <h3 class="text-main text-sm uppercase tracking-wider font-bold mb-1">Destination Health</h3>
            <div class="text-4xl font-mono font-bold text-${insight.health_score > 80 ? 'green' : 'yellow'}-400">${insight.health_score}<span class="text-lg text-muted">/100</span></div>
        </div>
    </div>

    <!-- Active Alerts Banner -->
    <c:if test="${not empty alerts}">
        <div class="mb-8 flex flex-col gap-3 slide-up delay-1">
            <c:forEach var="alert" items="${alerts}">
                <div class="bg-red-500/10 border border-red-500/20 text-red-400 p-4 rounded-xl flex items-center gap-3">
                    <i class="ri-error-warning-fill text-2xl"></i>
                    <div>
                        <h4 class="font-bold text-sm">${alert.type} Alert (${alert.severity})</h4>
                        <p class="text-xs text-red-300">${alert.message}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- Grid Layout -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 slide-up delay-2">
        
        <!-- Weather Card (Span 2) -->
        <div class="glass-panel p-6 rounded-3xl lg:col-span-2 relative overflow-hidden bg-gradient-to-br from-[#0f172a] to-[#1e1b4b]">
            <div class="absolute right-0 top-0 w-64 h-64 bg-primary/20 blur-3xl rounded-full translate-x-1/2 -translate-y-1/2"></div>
            
            <div class="flex justify-between items-start mb-6 relative z-10">
                <div>
                    <h3 class="text-main font-bold mb-1 flex items-center gap-2"><i class="ri-sun-cloudy-line text-primary"></i> Real-time Weather</h3>
                    <p class="text-xs text-muted">Live sync via OpenWeather</p>
                </div>
                <div class="text-right">
                    <span class="text-green-400 text-xs font-bold px-2 py-1 bg-green-500/10 rounded-full border border-green-500/20">Score: ${weather.weather_score}/100</span>
                </div>
            </div>

            <div class="flex items-center justify-between relative z-10">
                <div class="flex items-center gap-4">
                    <i class="ri-sun-fill text-yellow-400" style="font-size: 4rem; filter: drop-shadow(0 0 20px rgba(250,204,21,0.4));"></i>
                    <div>
                        <h2 class="text-5xl font-mono font-bold text-main">${weather.temp}°C</h2>
                        <p class="text-muted">Sunny & Clear</p>
                    </div>
                </div>
                
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <p class="text-muted text-xs uppercase">Rain Prob</p>
                        <p class="text-main font-bold font-mono">${weather.rain_prob}%</p>
                    </div>
                    <div>
                        <p class="text-muted text-xs uppercase">Humidity</p>
                        <p class="text-main font-bold font-mono">${weather.humidity}%</p>
                    </div>
                    <div>
                        <p class="text-muted text-xs uppercase">Wind</p>
                        <p class="text-main font-bold font-mono">${weather.wind_speed} km/h</p>
                    </div>
                    <div>
                        <p class="text-muted text-xs uppercase">UV Index</p>
                        <p class="text-main font-bold font-mono">${weather.uv_index}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Crowd Prediction Card -->
        <div class="glass-panel p-6 rounded-3xl relative overflow-hidden">
            <h3 class="text-main font-bold mb-4 flex items-center gap-2"><i class="ri-group-line text-primary"></i> Crowd Forecast</h3>
            
            <div class="mb-4">
                <p class="text-xs text-muted mb-1">Current Crowd Level</p>
                <div class="flex items-center justify-between bg-white/5 border border-white/10 p-3 rounded-xl">
                    <span class="text-main font-bold">${crowd.current_crowd}</span>
                    <i class="ri-bar-chart-fill text-${crowd.current_crowd eq 'Moderate' ? 'yellow' : 'red'}-400"></i>
                </div>
            </div>

            <div class="mb-4">
                <p class="text-xs text-muted mb-1">Expected Tomorrow</p>
                <div class="flex items-center justify-between bg-white/5 border border-white/10 p-3 rounded-xl">
                    <span class="text-main font-bold">${crowd.expected_crowd}</span>
                    <i class="ri-line-chart-line text-red-400"></i>
                </div>
            </div>
            
            <div class="text-xs text-muted mt-4 p-3 bg-primary/10 rounded-lg border border-primary/20">
                Peak season is <strong>${crowd.peak_season}</strong>.
            </div>
        </div>

        <!-- Safety Engine Card -->
        <div class="glass-panel p-6 rounded-3xl">
            <h3 class="text-main font-bold mb-4 flex items-center gap-2"><i class="ri-shield-check-line text-primary"></i> Safety Engine</h3>
            
            <div class="text-center mb-6">
                <h2 class="text-4xl font-mono font-bold text-green-400 mb-1">${safety.overall_score}</h2>
                <p class="text-xs text-muted">Overall Safety Score</p>
            </div>

            <div class="flex flex-col gap-3 text-sm">
                <div class="flex justify-between items-center border-b border-white/10 pb-2">
                    <span class="text-muted">Night Safety</span>
                    <span class="text-main font-bold text-green-400">${safety.night_safety}</span>
                </div>
                <div class="flex justify-between items-center border-b border-white/10 pb-2">
                    <span class="text-muted">Medical Access</span>
                    <span class="text-main font-bold text-green-400">${safety.medical_access}</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-muted">Scam Risk</span>
                    <span class="text-main font-bold text-yellow-400">${safety.scam_risk}</span>
                </div>
            </div>
        </div>

        <!-- AI Insights & Gen-Z Features (Span 2) -->
        <div class="glass-panel p-6 rounded-3xl lg:col-span-2">
            <h3 class="text-main font-bold mb-4 flex items-center gap-2"><i class="ri-sparkling-line text-primary"></i> Destination Insights</h3>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="bg-white/5 border border-white/10 p-4 rounded-2xl">
                    <div class="text-primary mb-2"><i class="ri-camera-lens-line text-2xl"></i></div>
                    <h4 class="text-main font-bold text-sm mb-1">Best Time for Photos</h4>
                    <p class="text-2xl font-mono text-main">${insight.best_time_photos}</p>
                    <p class="text-xs text-muted mt-1">Golden hour lighting.</p>
                </div>
                
                <div class="bg-white/5 border border-white/10 p-4 rounded-2xl">
                    <div class="text-yellow-400 mb-2 flex gap-4">
                        <i class="ri-sunrise-line text-2xl"></i>
                        <i class="ri-sunset-line text-2xl"></i>
                    </div>
                    <div class="flex justify-between">
                        <div>
                            <h4 class="text-main font-bold text-sm mb-1">Sunrise</h4>
                            <p class="text-xl font-mono text-main">${insight.sunrise}</p>
                        </div>
                        <div>
                            <h4 class="text-main font-bold text-sm mb-1">Sunset</h4>
                            <p class="text-xl font-mono text-main">${insight.sunset}</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-4 p-4 bg-primary/5 border border-primary/20 rounded-2xl">
                <h4 class="text-primary font-bold text-sm mb-2"><i class="ri-robot-2-line mr-1"></i> AI Recommendation</h4>
                <p class="text-sm text-main">"If rain probability exceeds 40%, I recommend swapping your beach day for indoor historical museum tours or cafe hopping in the local area."</p>
            </div>
        </div>

        <!-- Health & AQI -->
        <div class="glass-panel p-6 rounded-3xl">
            <h3 class="text-main font-bold mb-4 flex items-center gap-2"><i class="ri-lungs-line text-primary"></i> Air Quality (AQI)</h3>
            <div class="flex flex-col items-center justify-center h-40">
                <div class="w-24 h-24 rounded-full border-4 border-green-400 flex items-center justify-center mb-3 relative">
                    <span class="text-2xl font-bold font-mono text-main">42</span>
                </div>
                <h4 class="text-main font-bold">${weather.aqi}</h4>
                <p class="text-xs text-muted text-center mt-1">Perfect conditions for outdoor activities.</p>
            </div>
        </div>

        <!-- Alternative Suggester -->
        <div class="glass-panel p-6 rounded-3xl border border-primary/30">
            <h3 class="text-main font-bold mb-4 flex items-center gap-2"><i class="ri-map-pin-add-line text-primary"></i> AI Alternatives</h3>
            <p class="text-sm text-muted mb-4">Weather score is good, but if you want less crowds, consider:</p>
            
            <div class="flex flex-col gap-3">
                <a href="${pageContext.request.contextPath}/command-center?destination=Gokarna" class="flex justify-between items-center p-3 bg-white/5 hover:bg-white/10 rounded-xl transition-all border border-white/10">
                    <span class="text-main font-bold text-sm">Gokarna</span>
                    <span class="text-xs text-primary px-2 py-1 bg-primary/10 rounded-full">Less Crowded</span>
                </a>
                <a href="${pageContext.request.contextPath}/command-center?destination=Varkala" class="flex justify-between items-center p-3 bg-white/5 hover:bg-white/10 rounded-xl transition-all border border-white/10">
                    <span class="text-main font-bold text-sm">Varkala</span>
                    <span class="text-xs text-green-400 px-2 py-1 bg-green-500/10 rounded-full">Better Weather</span>
                </a>
            </div>
        </div>

    </div>

</main>

<%@ include file="/components/footer.jsp" %>
