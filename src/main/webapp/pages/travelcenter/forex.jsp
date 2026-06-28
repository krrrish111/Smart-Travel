<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forex Center | Travel Center</title>
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
            <h1 class="text-3xl font-['Clash_Display'] font-bold">Forex Center</h1>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div class="lg:col-span-2 space-y-6">
                <!-- Currency Converter -->
                <div class="tc-card p-6">
                    <h2 class="font-bold mb-6">Currency Converter</h2>
                    <div class="flex items-center gap-4 mb-4">
                        <div class="flex-1">
                            <label class="block text-xs text-muted mb-2">You Send (INR)</label>
                            <input type="number" value="10000" class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white text-xl font-mono outline-none">
                        </div>
                        <div class="w-10 h-10 mt-6 rounded-full bg-white/10 flex items-center justify-center text-white">
                            <i class="ri-arrow-left-right-line"></i>
                        </div>
                        <div class="flex-1">
                            <label class="block text-xs text-muted mb-2">You Get (THB)</label>
                            <input type="number" value="4352.18" readonly class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-green-400 text-xl font-mono outline-none">
                        </div>
                    </div>
                    <p class="text-xs text-muted text-center mb-6">1 INR = 0.4352 THB • Live Rate</p>
                    <button class="btn btn-primary w-full py-3 rounded-xl font-bold">Order Forex Card</button>
                </div>

                <!-- Live Rates -->
                <div class="tc-card p-6">
                    <h2 class="font-bold mb-4">Live Exchange Rates</h2>
                    <div class="space-y-3">
                        <div class="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-blue-500/20 text-blue-400 flex items-center justify-center text-xs font-bold">USD</div>
                                <span>US Dollar</span>
                            </div>
                            <div class="text-right">
                                <div class="font-mono text-white">₹83.42</div>
                                <div class="text-[0.6rem] text-green-400">+0.12% <i class="ri-arrow-up-line"></i></div>
                            </div>
                        </div>
                        <div class="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-blue-800/20 text-blue-400 flex items-center justify-center text-xs font-bold">EUR</div>
                                <span>Euro</span>
                            </div>
                            <div class="text-right">
                                <div class="font-mono text-white">₹89.75</div>
                                <div class="text-[0.6rem] text-red-400">-0.05% <i class="ri-arrow-down-line"></i></div>
                            </div>
                        </div>
                        <div class="flex justify-between items-center p-3 bg-white/5 rounded-xl">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-red-500/20 text-red-400 flex items-center justify-center text-xs font-bold">AED</div>
                                <span>UAE Dirham</span>
                            </div>
                            <div class="text-right">
                                <div class="font-mono text-white">₹22.71</div>
                                <div class="text-[0.6rem] text-green-400">+0.01% <i class="ri-arrow-up-line"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- AI Recommendations -->
            <div class="tc-card p-6 bg-gradient-to-b from-blue-900/20 to-transparent border-blue-500/20">
                <h2 class="font-bold mb-6 flex items-center"><i class="ri-sparkling-fill text-blue-400 mr-2"></i> AI Recommendation</h2>
                <div class="mb-6">
                    <h3 class="text-sm text-blue-400 font-bold mb-2 uppercase tracking-wider">Thailand Trip</h3>
                    <p class="text-sm text-muted/90 mb-4">For a 5-day trip to Thailand, we recommend carrying a mix of cash and a Forex card.</p>
                    
                    <div class="bg-black/40 rounded-xl p-4 mb-4 border border-white/5">
                        <div class="flex justify-between text-xs mb-1">
                            <span class="text-muted">Recommended Cash</span>
                            <span class="font-bold text-white">10,000 THB</span>
                        </div>
                        <div class="flex justify-between text-xs">
                            <span class="text-muted">Recommended Card</span>
                            <span class="font-bold text-white">15,000 THB</span>
                        </div>
                    </div>
                    
                    <ul class="text-xs text-muted/80 space-y-2">
                        <li>• Street food and local markets require cash.</li>
                        <li>• Malls, hotels, and Grab accept cards.</li>
                        <li>• Avoid airport exchange counters for best rates.</li>
                    </ul>
                </div>
                <button class="w-full py-2 bg-white/10 hover:bg-white/20 rounded-xl text-sm font-medium transition-colors">Chat with AI</button>
            </div>
        </div>
    </main>

    <jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/ai-buddy.jsp" />
</body>
</html>
