<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eSIM Center | Travel Center</title>
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

    <main class="pt-24 pb-20 max-w-5xl mx-auto px-4">
        <div class="mb-8 flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/travel-center" class="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"><i class="ri-arrow-left-line"></i></a>
            <h1 class="text-3xl font-['Clash_Display'] font-bold">eSIM Center</h1>
        </div>

        <div class="bg-black/50 border border-white/10 rounded-2xl p-4 flex items-center gap-4 mb-8">
            <i class="ri-search-line text-muted text-xl ml-2"></i>
            <input type="text" placeholder="Search destination country (e.g. Thailand)" class="bg-transparent border-none outline-none text-white w-full">
            <button class="btn btn-primary px-6 py-2 rounded-xl">Search</button>
        </div>

        <h3 class="font-bold mb-6">Popular Plans for Thailand</h3>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <!-- Plan 1 -->
            <div class="tc-card p-6 border-amber-400/30 relative overflow-hidden">
                <div class="absolute -right-10 -top-10 w-32 h-32 bg-amber-400/10 rounded-full blur-2xl pointer-events-none"></div>
                <span class="px-2 py-1 text-[0.6rem] font-bold uppercase tracking-wider bg-amber-400/20 text-amber-400 rounded-md mb-4 inline-block">Best Value</span>
                <h4 class="text-xl font-bold font-['Clash_Display'] mb-1">10 GB Data</h4>
                <p class="text-xs text-muted mb-6">Valid for 30 Days</p>
                
                <ul class="space-y-3 mb-8 text-sm">
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> Instant Delivery</li>
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> 4G / 5G Speeds</li>
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> Data Only</li>
                </ul>
                
                <div class="flex items-center justify-between mt-auto">
                    <div>
                        <span class="text-xs text-muted line-through mr-1">₹899</span>
                        <span class="text-xl font-bold font-mono">₹599</span>
                    </div>
                    <button class="btn btn-primary px-4 py-2 rounded-xl text-sm">Buy Now</button>
                </div>
            </div>

            <!-- Plan 2 -->
            <div class="tc-card p-6 relative overflow-hidden">
                <h4 class="text-xl font-bold font-['Clash_Display'] mb-1">50 GB Data</h4>
                <p class="text-xs text-muted mb-6">Valid for 15 Days</p>
                
                <ul class="space-y-3 mb-8 text-sm">
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> Instant Delivery</li>
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> 4G Speeds</li>
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> Data + Voice</li>
                </ul>
                
                <div class="flex items-center justify-between mt-auto">
                    <div>
                        <span class="text-xl font-bold font-mono">₹999</span>
                    </div>
                    <button class="bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-xl text-sm transition-colors">Buy Now</button>
                </div>
            </div>

            <!-- Plan 3 -->
            <div class="tc-card p-6 relative overflow-hidden">
                <h4 class="text-xl font-bold font-['Clash_Display'] mb-1">Unlimited Data</h4>
                <p class="text-xs text-muted mb-6">Valid for 7 Days</p>
                
                <ul class="space-y-3 mb-8 text-sm">
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> Instant Delivery</li>
                    <li class="flex items-center text-muted"><i class="ri-check-line text-green-400 mr-2"></i> 5G Speeds</li>
                    <li class="flex items-center text-muted"><i class="ri-close-line text-red-400 mr-2"></i> No Hotspot</li>
                </ul>
                
                <div class="flex items-center justify-between mt-auto">
                    <div>
                        <span class="text-xl font-bold font-mono">₹1,299</span>
                    </div>
                    <button class="bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-xl text-sm transition-colors">Buy Now</button>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/ai-buddy.jsp" />
</body>
</html>
