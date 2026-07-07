<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visa Assistant | Travel Center</title>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://api.fontshare.com/v2/css?f[]=clash-display@400,500,600,700&f[]=satoshi@400,500,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
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
            <h1 class="text-3xl font-['Clash_Display'] font-bold">Visa Assistant</h1>
        </div>

        <div class="tc-card p-8 mb-8">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <div>
                    <label class="block text-xs text-muted mb-2 uppercase tracking-wider">I have a passport from</label>
                    <select class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-blue-500">
                        <option>India (IND)</option>
                        <option>United States (USA)</option>
                        <option>United Kingdom (GBR)</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs text-muted mb-2 uppercase tracking-wider">I am traveling to</label>
                    <select class="w-full bg-black/50 border border-white/10 rounded-xl px-4 py-3 text-white outline-none focus:border-blue-500">
                        <option>Thailand (THA)</option>
                        <option>United Arab Emirates (ARE)</option>
                        <option>France (FRA)</option>
                    </select>
                </div>
            </div>
            
            <div class="p-6 bg-green-500/10 border border-green-500/20 rounded-xl mb-6">
                <div class="flex items-start">
                    <i class="ri-checkbox-circle-fill text-green-400 text-2xl mr-4 mt-1"></i>
                    <div>
                        <h3 class="text-lg font-bold text-green-400 mb-1">Visa Free / Visa on Arrival</h3>
                        <p class="text-sm text-green-400/80">Indian passport holders can visit Thailand without a pre-approved visa for tourism purposes up to 30 days.</p>
                    </div>
                </div>
            </div>

            <h4 class="font-bold mb-4">Required Documents</h4>
            <ul class="space-y-3 mb-8">
                <li class="flex items-center text-sm bg-white/5 p-3 rounded-lg"><i class="ri-passport-line text-muted mr-3 text-lg"></i> Passport valid for at least 6 months</li>
                <li class="flex items-center text-sm bg-white/5 p-3 rounded-lg"><i class="ri-plane-line text-muted mr-3 text-lg"></i> Confirmed return ticket</li>
                <li class="flex items-center text-sm bg-white/5 p-3 rounded-lg"><i class="ri-hotel-bed-line text-muted mr-3 text-lg"></i> Proof of accommodation</li>
                <li class="flex items-center text-sm bg-white/5 p-3 rounded-lg"><i class="ri-money-dollar-circle-line text-muted mr-3 text-lg"></i> Proof of funds (10,000 THB per person)</li>
            </ul>

            <button class="btn btn-primary w-full py-3 rounded-xl font-bold"><i class="ri-robot-2-line mr-2"></i> Ask AI Visa Guide</button>
        </div>
    </main>

    <jsp:include page="/components/footer.jsp" />
</body>
</html>
