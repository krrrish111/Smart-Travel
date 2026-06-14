<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Center | Travel Center</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://api.fontshare.com/v2/css?f[]=clash-display@400,500,600,700&f[]=satoshi@400,500,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
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
            <h1 class="text-3xl font-['Clash_Display'] font-bold">Travel Insurance</h1>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-12">
            <!-- Details Form -->
            <div class="tc-card p-6">
                <h3 class="font-bold mb-4">Trip Details</h3>
                <div class="space-y-4">
                    <div>
                        <label class="block text-xs text-muted mb-2">Destination</label>
                        <input type="text" value="Thailand" class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-purple-500">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs text-muted mb-2">Start Date</label>
                            <input type="date" class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-purple-500">
                        </div>
                        <div>
                            <label class="block text-xs text-muted mb-2">End Date</label>
                            <input type="date" class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-purple-500">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs text-muted mb-2">Travelers</label>
                        <select class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-purple-500">
                            <option>1 Adult</option>
                            <option>2 Adults</option>
                            <option>Family (2 Adults, 2 Children)</option>
                        </select>
                    </div>
                    <button class="btn btn-primary w-full py-3 rounded-xl font-bold mt-4">Update Quotes</button>
                </div>
            </div>

            <!-- Recommended Plan -->
            <div class="tc-card p-8 bg-gradient-to-br from-purple-900/20 to-transparent border-purple-500/20 relative overflow-hidden">
                <div class="absolute -right-10 -top-10 w-32 h-32 bg-purple-500/20 rounded-full blur-3xl pointer-events-none"></div>
                <span class="px-3 py-1 text-[0.65rem] font-bold uppercase tracking-widest bg-purple-500/20 text-purple-400 rounded-md mb-4 inline-block">Recommended</span>
                <h2 class="text-3xl font-bold font-['Clash_Display'] mb-2">Voyastra Premium Cover</h2>
                <p class="text-sm text-muted mb-6">Comprehensive protection for international travel.</p>
                
                <div class="grid grid-cols-2 gap-4 mb-8">
                    <div>
                        <span class="block text-xs text-muted mb-1">Medical Cover</span>
                        <span class="font-mono font-bold text-white">$250,000</span>
                    </div>
                    <div>
                        <span class="block text-xs text-muted mb-1">Trip Cancellation</span>
                        <span class="font-mono font-bold text-white">$5,000</span>
                    </div>
                    <div>
                        <span class="block text-xs text-muted mb-1">Baggage Delay</span>
                        <span class="font-mono font-bold text-white">$500</span>
                    </div>
                    <div>
                        <span class="block text-xs text-muted mb-1">Covid-19 Cover</span>
                        <span class="font-mono font-bold text-green-400">Included</span>
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div>
                        <span class="block text-xs text-muted mb-1">Premium</span>
                        <span class="text-2xl font-bold font-mono">₹1,249</span>
                    </div>
                    <button class="bg-purple-600 hover:bg-purple-500 text-white px-8 py-3 rounded-xl font-bold transition-colors">Select Plan</button>
                </div>
            </div>
        </div>
        
    </main>

    <jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/ai-buddy.jsp" />
</body>
</html>
