<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Travel Center | Voyastra</title>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://api.fontshare.com/v2/css?f[]=clash-display@400,500,600,700&f[]=satoshi@400,500,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animations.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        .travel-center-bg {
            background: radial-gradient(circle at 50% 0%, rgba(30, 58, 138, 0.15) 0%, rgba(0, 0, 0, 0) 50%),
                        radial-gradient(circle at 100% 100%, rgba(88, 28, 135, 0.1) 0%, rgba(0, 0, 0, 0) 50%);
            min-height: 100vh;
        }
        .tc-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 1.5rem;
            transition: all 0.3s ease;
        }
        .tc-card:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }
        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        .gradient-text {
            background: linear-gradient(to right, #60a5fa, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
    </style>
</head>
<body class="bg-[#050505] text-white font-['Satoshi'] travel-center-bg">

    <jsp:include page="/components/header.jsp" />

    <main class="pt-24 pb-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            
            <!-- Header -->
            <div class="mb-12 text-center fade-up">
                <span class="px-3 py-1 text-xs font-bold uppercase tracking-widest text-blue-400 bg-blue-400/10 border border-blue-400/20 rounded-full mb-4 inline-block">Premium Hub</span>
                <h1 class="text-4xl md:text-5xl font-['Clash_Display'] font-bold mb-4">Travel <span class="gradient-text">Center</span></h1>
                <p class="text-muted max-w-2xl mx-auto">Your comprehensive hub for travel preparation, rewards, and international support.</p>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                
                <!-- Travel Readiness Score -->
                <div class="tc-card p-6 fade-up" style="animation-delay: 0.1s;">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="font-bold text-lg"><i class="ri-shield-check-fill text-green-400 mr-2"></i> Readiness Score</h2>
                        <span class="text-xs text-muted">Thailand Trip</span>
                    </div>
                    
                    <div class="flex items-end justify-center mb-6">
                        <span class="text-5xl font-bold font-['Clash_Display'] text-white">92</span>
                        <span class="text-xl text-muted mb-1">%</span>
                    </div>
                    <p class="text-center text-sm text-green-400 mb-6 font-medium">Ready For Travel</p>
                    
                    <div class="space-y-3">
                        <div class="flex items-center justify-between text-sm">
                            <span class="text-muted"><i class="ri-passport-line mr-2"></i>Visa</span>
                            <span class="text-green-400"><i class="ri-check-line"></i></span>
                        </div>
                        <div class="flex items-center justify-between text-sm">
                            <span class="text-muted"><i class="ri-article-line mr-2"></i>Insurance</span>
                            <span class="text-green-400"><i class="ri-check-line"></i></span>
                        </div>
                        <div class="flex items-center justify-between text-sm">
                            <span class="text-muted"><i class="ri-exchange-dollar-line mr-2"></i>Forex</span>
                            <span class="text-amber-400 text-xs">Pending</span>
                        </div>
                        <div class="flex items-center justify-between text-sm">
                            <span class="text-muted"><i class="ri-sim-card-2-line mr-2"></i>eSIM</span>
                            <span class="text-amber-400 text-xs">Pending</span>
                        </div>
                    </div>
                    
                    <button class="w-full mt-6 py-2 bg-white/5 hover:bg-white/10 rounded-xl text-sm font-medium transition-colors">View Checklist</button>
                </div>

                <!-- Voyastra Rewards -->
                <div class="tc-card p-6 fade-up" style="animation-delay: 0.2s;">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="font-bold text-lg"><i class="ri-vip-crown-fill text-amber-400 mr-2"></i> Voyastra Rewards</h2>
                        <span class="px-2 py-1 text-xs font-bold text-amber-400 bg-amber-400/10 rounded border border-amber-400/20">${rewards.tier}</span>
                    </div>
                    
                    <div class="mb-6">
                        <p class="text-sm text-muted mb-1">Available Points</p>
                        <h3 class="text-4xl font-bold font-['Clash_Display']">${rewards.currentPoints} <span class="text-lg text-muted font-normal">pts</span></h3>
                    </div>
                    
                    <div class="bg-white/5 rounded-xl p-4 mb-6">
                        <div class="flex justify-between text-xs mb-2">
                            <span class="text-muted">Lifetime: ${rewards.lifetimePoints} pts</span>
                            <span class="text-amber-400">Next Tier: Gold</span>
                        </div>
                        <div class="w-full h-1.5 bg-black/50 rounded-full overflow-hidden">
                            <div class="h-full bg-gradient-to-r from-amber-400 to-amber-200" style="width: 45%;"></div>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-3">
                        <button class="py-2 bg-primary hover:bg-primary-dark rounded-xl text-sm font-medium transition-colors">Redeem</button>
                        <button class="py-2 bg-white/5 hover:bg-white/10 rounded-xl text-sm font-medium transition-colors">Refer & Earn</button>
                    </div>
                </div>

                <!-- Voyastra Wallet -->
                <div class="tc-card p-6 fade-up" style="animation-delay: 0.3s;">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="font-bold text-lg"><i class="ri-wallet-3-fill text-blue-400 mr-2"></i> Voyastra Wallet</h2>
                        <span class="text-xs text-muted">Secure <i class="ri-shield-keyhole-line ml-1"></i></span>
                    </div>
                    
                    <div class="mb-6">
                        <p class="text-sm text-muted mb-1">Current Balance</p>
                        <h3 class="text-4xl font-bold font-['Clash_Display']">₹${wallet.balance}</h3>
                    </div>
                    
                    <div class="space-y-3 mb-6">
                        <div class="flex justify-between items-center text-sm p-3 bg-white/5 rounded-xl">
                            <div class="flex items-center"><i class="ri-arrow-right-up-line text-green-400 mr-2"></i> Refund #492</div>
                            <span class="text-green-400">+₹4,500</span>
                        </div>
                        <div class="flex justify-between items-center text-sm p-3 bg-white/5 rounded-xl">
                            <div class="flex items-center"><i class="ri-arrow-left-down-line text-red-400 mr-2"></i> Flight Booking</div>
                            <span class="text-white">-₹2,000</span>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-3">
                        <button class="py-2 bg-white/10 hover:bg-white/20 rounded-xl text-sm font-medium transition-colors"><i class="ri-add-line"></i> Add Funds</button>
                        <button class="py-2 bg-white/5 hover:bg-white/10 rounded-xl text-sm font-medium transition-colors">History</button>
                    </div>
                </div>

            </div>

            <!-- Services Grid -->
            <h3 class="font-['Clash_Display'] font-bold text-xl mb-6 fade-up">Travel Services</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-4 fade-up" style="animation-delay: 0.4s;">
                
                <a href="${pageContext.request.contextPath}/travel-center/visa" class="tc-card p-5 group">
                    <div class="icon-box bg-blue-500/10 text-blue-400 mb-4 group-hover:scale-110 transition-transform">
                        <i class="ri-passport-line"></i>
                    </div>
                    <h4 class="font-bold mb-1">Visa Assistant</h4>
                    <p class="text-xs text-muted">Check requirements & apply</p>
                </a>
                
                <a href="${pageContext.request.contextPath}/travel-center/insurance" class="tc-card p-5 group">
                    <div class="icon-box bg-purple-500/10 text-purple-400 mb-4 group-hover:scale-110 transition-transform">
                        <i class="ri-shield-cross-line"></i>
                    </div>
                    <h4 class="font-bold mb-1">Travel Insurance</h4>
                    <p class="text-xs text-muted">Comprehensive coverage plans</p>
                </a>
                
                <a href="${pageContext.request.contextPath}/travel-center/forex" class="tc-card p-5 group">
                    <div class="icon-box bg-green-500/10 text-green-400 mb-4 group-hover:scale-110 transition-transform">
                        <i class="ri-exchange-dollar-line"></i>
                    </div>
                    <h4 class="font-bold mb-1">Forex Center</h4>
                    <p class="text-xs text-muted">Live rates & currency exchange</p>
                </a>
                
                <a href="${pageContext.request.contextPath}/travel-center/esim" class="tc-card p-5 group">
                    <div class="icon-box bg-amber-500/10 text-amber-400 mb-4 group-hover:scale-110 transition-transform">
                        <i class="ri-sim-card-2-line"></i>
                    </div>
                    <h4 class="font-bold mb-1">eSIM Center</h4>
                    <p class="text-xs text-muted">Global data plans</p>
                </a>
                
                <a href="${pageContext.request.contextPath}/travel-center/airport-services" class="tc-card p-5 group">
                    <div class="icon-box bg-pink-500/10 text-pink-400 mb-4 group-hover:scale-110 transition-transform">
                        <i class="ri-flight-takeoff-line"></i>
                    </div>
                    <h4 class="font-bold mb-1">Airport Services</h4>
                    <p class="text-xs text-muted">Lounges, meet & greet</p>
                </a>

            </div>

        </div>
    </main>

    <jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
