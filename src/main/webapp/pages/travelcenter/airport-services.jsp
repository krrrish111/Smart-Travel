<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Airport Services | Travel Center</title>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://api.fontshare.com/v2/css?f[]=clash-display@400,500,600,700&f[]=satoshi@400,500,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <style>
        .tc-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 1.5rem;
        }
    </style>
</head>
<body class="bg-[#050505] text-white font-['Satoshi']">
    <jsp:include page="/components/header.jsp" />

    <main class="pt-24 pb-20 max-w-6xl mx-auto px-4">
        <div class="mb-8 flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/travel-center" class="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"><i class="ri-arrow-left-line"></i></a>
            <h1 class="text-3xl font-['Clash_Display'] font-bold">Airport Services</h1>
        </div>

        <!-- Categories -->
        <div class="flex gap-4 overflow-x-auto pb-4 mb-8 snap-x">
            <button class="bg-primary text-white px-6 py-2 rounded-full text-sm font-medium whitespace-nowrap snap-start">All Services</button>
            <button class="bg-white/5 text-white px-6 py-2 rounded-full text-sm font-medium whitespace-nowrap snap-start hover:bg-white/10">Lounge Access</button>
            <button class="bg-white/5 text-white px-6 py-2 rounded-full text-sm font-medium whitespace-nowrap snap-start hover:bg-white/10">Meet & Greet</button>
            <button class="bg-white/5 text-white px-6 py-2 rounded-full text-sm font-medium whitespace-nowrap snap-start hover:bg-white/10">Fast Track</button>
            <button class="bg-white/5 text-white px-6 py-2 rounded-full text-sm font-medium whitespace-nowrap snap-start hover:bg-white/10">Airport Transfer</button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            
            <!-- Service 1 -->
            <div class="tc-card overflow-hidden group">
                <div class="h-48 bg-gray-800 relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1542296332-2e4473faf563?q=80&w=600&auto=format&fit=crop" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105">
                    <div class="absolute top-4 left-4 bg-black/60 backdrop-blur-md px-3 py-1 rounded text-xs font-bold text-white">Lounge</div>
                </div>
                <div class="p-6">
                    <h3 class="font-bold text-lg mb-2">Plaza Premium Lounge</h3>
                    <p class="text-xs text-muted mb-4"><i class="ri-map-pin-line mr-1"></i> BKK Airport, Bangkok</p>
                    <ul class="text-xs text-muted space-y-2 mb-6">
                        <li><i class="ri-restaurant-line mr-2 text-pink-400"></i> Hot Food & Beverages</li>
                        <li><i class="ri-wifi-line mr-2 text-pink-400"></i> Premium Wi-Fi</li>
                        <li><i class="ri-showers-line mr-2 text-pink-400"></i> Shower Facilities</li>
                    </ul>
                    <div class="flex items-center justify-between">
                        <span class="font-bold font-mono text-lg">₹2,499<span class="text-xs text-muted font-normal">/person</span></span>
                        <button class="bg-white/10 hover:bg-white/20 px-4 py-2 rounded-lg text-sm transition-colors">Book Now</button>
                    </div>
                </div>
            </div>

            <!-- Service 2 -->
            <div class="tc-card overflow-hidden group">
                <div class="h-48 bg-gray-800 relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=600&auto=format&fit=crop" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105">
                    <div class="absolute top-4 left-4 bg-black/60 backdrop-blur-md px-3 py-1 rounded text-xs font-bold text-white">Transfer</div>
                </div>
                <div class="p-6">
                    <h3 class="font-bold text-lg mb-2">Private Airport Transfer</h3>
                    <p class="text-xs text-muted mb-4"><i class="ri-map-pin-line mr-1"></i> BKK Airport to City Center</p>
                    <ul class="text-xs text-muted space-y-2 mb-6">
                        <li><i class="ri-car-line mr-2 text-pink-400"></i> Premium Sedan</li>
                        <li><i class="ri-user-star-line mr-2 text-pink-400"></i> Professional Chauffeur</li>
                        <li><i class="ri-time-line mr-2 text-pink-400"></i> 60 Mins Free Waiting</li>
                    </ul>
                    <div class="flex items-center justify-between">
                        <span class="font-bold font-mono text-lg">₹1,899<span class="text-xs text-muted font-normal">/car</span></span>
                        <button class="bg-white/10 hover:bg-white/20 px-4 py-2 rounded-lg text-sm transition-colors">Book Now</button>
                    </div>
                </div>
            </div>

            <!-- Service 3 -->
            <div class="tc-card overflow-hidden group">
                <div class="h-48 bg-gray-800 relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1569154941061-e231b4725ef1?q=80&w=600&auto=format&fit=crop" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105">
                    <div class="absolute top-4 left-4 bg-black/60 backdrop-blur-md px-3 py-1 rounded text-xs font-bold text-white">Fast Track</div>
                </div>
                <div class="p-6">
                    <h3 class="font-bold text-lg mb-2">VIP Meet & Greet</h3>
                    <p class="text-xs text-muted mb-4"><i class="ri-map-pin-line mr-1"></i> BKK Airport, Bangkok</p>
                    <ul class="text-xs text-muted space-y-2 mb-6">
                        <li><i class="ri-user-heart-line mr-2 text-pink-400"></i> Personal Assistant</li>
                        <li><i class="ri-speed-up-line mr-2 text-pink-400"></i> Fast Track Immigration</li>
                        <li><i class="ri-suitcase-2-line mr-2 text-pink-400"></i> Porter Service included</li>
                    </ul>
                    <div class="flex items-center justify-between">
                        <span class="font-bold font-mono text-lg">₹3,499<span class="text-xs text-muted font-normal">/person</span></span>
                        <button class="bg-white/10 hover:bg-white/20 px-4 py-2 rounded-lg text-sm transition-colors">Book Now</button>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <jsp:include page="/components/footer.jsp" />
</body>
</html>
