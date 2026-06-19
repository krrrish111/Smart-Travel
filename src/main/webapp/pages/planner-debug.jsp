<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Planner Debug Console | Voyastra</title>
    <script>
        // CRITICAL: must be defined before any other script runs
        const CONTEXT_PATH = '${pageContext.request.contextPath}';
        const contextPath  = CONTEXT_PATH; // alias for legacy references
    </script>
    <%@ include file="/components/global_ui.jsp" %>
</head>
<body class="bg-[#0a0a0a] text-white font-sans antialiased">
    <%@ include file="/components/header.jsp" %>

    <div class="container mx-auto px-4 pt-24 pb-12">
        <!-- Developer Debug Dashboard -->
        <div id="plannerDebugDashboard" class="border-t-4 border-red-500 bg-[#0a0a0a] text-white p-8 font-mono text-sm shadow-2xl rounded-b">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-3xl font-bold text-red-500 tracking-widest uppercase flex items-center gap-3">
                <i class="ri-bug-2-line"></i> VOYASTRA PLANNER DEBUG DASHBOARD
            </h2>
            <p class="text-gray-400 mt-2">Live generation pipeline X-Ray (Developer Only)</p>
        </div>
        <div class="flex gap-4">
            <button onclick="refreshDashboard()" class="bg-blue-600 hover:bg-blue-700 px-6 py-2 rounded font-bold uppercase tracking-wide transition-colors flex items-center gap-2">
                <i class="ri-refresh-line"></i> Refresh Metrics
            </button>
            <button onclick="exportPlannerJson()" class="bg-red-600 hover:bg-red-700 px-6 py-2 rounded font-bold uppercase tracking-wide transition-colors flex items-center gap-2">
                <i class="ri-download-2-line"></i> Export Planner JSON
            </button>
        </div>
    </div>

    <!-- Live Status Cards -->
    <div class="grid grid-cols-2 md:grid-cols-4 xl:grid-cols-7 gap-4 mb-8" id="debugStatusCards">
        <!-- Rendered via JS -->
    </div>

    <!-- Main Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Live Console Logs -->
        <div class="lg:col-span-1 bg-black border border-white/10 rounded flex flex-col h-[600px]">
            <div class="bg-white/5 px-4 py-2 border-b border-white/10 font-bold tracking-widest text-xs flex justify-between">
                <span>LIVE CONSOLE LOGS</span>
                <span class="text-green-500 animate-pulse">● REC</span>
            </div>
            <div id="debugConsoleTerminal" class="flex-1 overflow-y-auto p-4 space-y-4 text-xs text-green-400">
                <div class="text-gray-600">Waiting for telemetry...</div>
            </div>
        </div>

        <!-- API Debug Response & Generation Trace -->
        <div class="lg:col-span-2 space-y-8">
            
            <!-- Generation Trace -->
            <div class="bg-black border border-white/10 rounded p-6">
                <h3 class="font-bold tracking-widest text-xs border-b border-white/10 pb-2 mb-4 text-gray-400">GENERATION TRACE (EXECUTION ORDER)</h3>
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 text-center text-xs" id="debugGenerationTrace">
                    <div class="p-2 border border-white/5 rounded text-gray-500">1 Input Validation</div>
                    <div class="p-2 border border-white/5 rounded text-gray-500">2 Destination Processing</div>
                    <div class="p-2 border border-white/5 rounded text-gray-500">3 Budget Calculation</div>
                    <div class="p-2 border border-white/5 rounded text-gray-500">4 Image Search</div>
                    <div class="p-2 border border-white/5 rounded text-gray-500">5 Video Search</div>
                    <div class="p-2 border border-white/5 rounded text-gray-500">6 Recommendation Generation</div>
                    <div class="p-2 border border-white/5 rounded text-gray-500">7 Itinerary Build</div>
                    <div class="p-2 border border-white/5 rounded text-gray-500">8 Render Page</div>
                </div>
            </div>

            <!-- API Status Tables -->
            <div class="grid grid-cols-2 gap-4">
                <div class="bg-black border border-white/10 rounded p-4">
                    <h3 class="font-bold tracking-widest text-xs text-blue-400 mb-3"><i class="ri-camera-lens-line"></i> UNSPLASH API</h3>
                    <table class="w-full text-xs text-left text-gray-400">
                        <tbody id="debugUnsplashApi">
                            <tr><td class="py-1 w-1/3">Status Code</td><td class="text-white">-</td></tr>
                            <tr><td class="py-1">Response Time</td><td class="text-white">-</td></tr>
                            <tr><td class="py-1">Image Count</td><td class="text-white">-</td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="bg-black border border-white/10 rounded p-4">
                    <h3 class="font-bold tracking-widest text-xs text-red-400 mb-3"><i class="ri-youtube-line"></i> YOUTUBE API</h3>
                    <table class="w-full text-xs text-left text-gray-400">
                        <tbody id="debugYoutubeApi">
                            <tr><td class="py-1 w-1/3">Status Code</td><td class="text-white">-</td></tr>
                            <tr><td class="py-1">Response Time</td><td class="text-white">-</td></tr>
                            <tr><td class="py-1">Video Count</td><td class="text-white">-</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Performance Metrics -->
            <div class="bg-black border border-white/10 rounded p-4">
                 <h3 class="font-bold tracking-widest text-xs text-yellow-400 mb-3"><i class="ri-timer-line"></i> PERFORMANCE METRICS</h3>
                 <div class="grid grid-cols-5 gap-4 text-center">
                     <div class="p-3 bg-white/5 rounded">
                         <div class="text-[10px] text-gray-500 mb-1">TOTAL TIME</div>
                         <div class="text-lg font-bold text-white" id="perfTotal">-</div>
                     </div>
                     <div class="p-3 bg-white/5 rounded">
                         <div class="text-[10px] text-gray-500 mb-1">API AVG TIME</div>
                         <div class="text-lg font-bold text-blue-400" id="perfApi">-</div>
                     </div>
                     <div class="p-3 bg-white/5 rounded">
                         <div class="text-[10px] text-gray-500 mb-1">DB QUERY TIME</div>
                         <div class="text-lg font-bold text-green-400" id="perfDb">-</div>
                     </div>
                     <div class="p-3 bg-white/5 rounded">
                         <div class="text-[10px] text-gray-500 mb-1">CACHE TIME</div>
                         <div class="text-lg font-bold text-yellow-400" id="perfCache">-</div>
                     </div>
                     <div class="p-3 bg-white/5 rounded">
                         <div class="text-[10px] text-gray-500 mb-1">PAGE RENDER TIME</div>
                         <div class="text-lg font-bold text-purple-400" id="perfRender">-</div>
                     </div>
                 </div>
            </div>

            <!-- Duplicate Warning Area -->
            <div id="debugDuplicateWarning" class="hidden bg-red-900/50 border border-red-500 rounded p-4 text-red-200">
                <h3 class="font-bold mb-2 flex items-center gap-2"><i class="ri-alert-line text-xl"></i> ⚠ Duplicate Content Detected</h3>
                <ul id="debugDuplicateList" class="list-disc pl-5 text-sm space-y-1"></ul>
            </div>

        </div>
    </div>
</div>

<script>
    let globalAiJson = {};

    async function refreshDashboard() {
        try {
            const res = await fetch(contextPath + '/api/planner/debug');
            if (res.ok) {
                const data = await res.json();
                renderDashboard(data);
            }
        } catch (e) {
            console.error("Dashboard error:", e);
        }
    }

    function renderDashboard(data) {
        if(!data.logs) return;
        
        globalAiJson = data.ai_output || {};

        // Calculate card states based on logs
        const getCardState = (key) => {
            if(data.logs.some(l => l.operation.includes(key) && l.status === 'ERROR')) return { color: 'text-red-500', bg: 'bg-red-500/10', border: 'border-red-500/30', icon: 'ri-close-circle-fill', text: 'FAILED' };
            if(data.logs.some(l => l.operation.includes(key) && l.status === 'WARNING')) return { color: 'text-yellow-400', bg: 'bg-yellow-400/10', border: 'border-yellow-400/30', icon: 'ri-error-warning-fill', text: 'WARNING' };
            if(data.logs.some(l => l.operation.includes(key) && l.status === 'SUCCESS')) return { color: 'text-green-400', bg: 'bg-green-400/10', border: 'border-green-400/30', icon: 'ri-checkbox-circle-fill', text: 'SUCCESS' };
            if(data.logs.some(l => l.operation.includes(key) && l.status === 'STARTED')) return { color: 'text-blue-400', bg: 'bg-blue-400/10', border: 'border-blue-400/30', icon: 'ri-loader-4-line animate-spin', text: 'LOADING' };
            if(data.logs.some(l => l.operation.includes(key) && l.status === 'HIT')) return { color: 'text-purple-400', bg: 'bg-purple-400/10', border: 'border-purple-400/30', icon: 'ri-flashlight-fill', text: 'CACHE HIT' };
            return { color: 'text-gray-500', bg: 'bg-white/5', border: 'border-white/10', icon: 'ri-time-line', text: 'PENDING' };
        };

        const renderCard = (title, key) => {
            const state = getCardState(key);
            return `<div class="p-3 rounded border \${state.border} \${state.bg} flex flex-col justify-between h-24">
                <div class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">\${title}</div>
                <div class="text-sm font-bold \${state.color} flex items-center gap-2 mt-auto">
                    <i class="\${state.icon} text-lg"></i> \${state.text}
                </div>
            </div>`;
        };

        const cardsContainer = document.getElementById('debugStatusCards');
        cardsContainer.innerHTML = 
            renderCard('Input Validation', 'Input Validation') +
            renderCard('Destination Data', 'Destination') +
            renderCard('YouTube API', 'YouTube') +
            renderCard('Unsplash API', 'Unsplash') +
            renderCard('Budget Engine', 'Budget') +
            renderCard('Itinerary Engine', 'Gemini') +
            renderCard('Database Cache', 'Cache');

        // 1. Terminal Logs
        const terminal = document.getElementById('debugConsoleTerminal');
        terminal.innerHTML = data.logs.map(l => {
            const time = new Date(l.timestamp).toISOString().split('T')[1].slice(0,-1);
            let color = "text-green-400";
            if(l.status === 'ERROR') color = "text-red-500";
            if(l.status === 'WARNING') color = "text-yellow-400";
            
            return `<div class="mb-4">
                <div class="text-gray-500">[\${time}]</div>
                <div class="\${color} font-bold">\${l.operation} <span class="text-gray-400 font-normal">(\${l.status})</span></div>
                <div class="text-white">\${l.message}</div>
            </div>`;
        }).join('');

        // 2. Performance Metrics Calculation
        let totalTime = 0;
        let apiTimeTotal = 0, apiCount = 0;
        let cacheTime = 0;
        
        const unsplashLogs = data.logs.filter(l => l.operation.includes('Unsplash'));
        const youtubeLogs = data.logs.filter(l => l.operation.includes('YouTube'));

        data.logs.forEach(l => {
            totalTime += l.duration;
            if(l.operation.includes('API') && l.duration > 0) {
                apiTimeTotal += l.duration;
                apiCount++;
            }
            if(l.operation.includes('Cache') && l.duration > 0) {
                cacheTime += l.duration;
            }
        });

        document.getElementById('perfTotal').innerText = totalTime + "ms";
        document.getElementById('perfApi').innerText = apiCount ? Math.round(apiTimeTotal/apiCount) + "ms" : "-";
        document.getElementById('perfCache').innerText = cacheTime + "ms";
        document.getElementById('perfDb').innerText = "<1ms"; // Mock for DB since we use JDBC batch insert
        document.getElementById('perfRender').innerText = typeof window.performanceRenderTime !== 'undefined' ? window.performanceRenderTime + "ms" : "Pending";

        // 3. API Panels
        if(unsplashLogs.length > 0) {
            const apiLog = unsplashLogs.find(l => l.operation === 'Unsplash API');
            if(apiLog) {
                document.getElementById('debugUnsplashApi').innerHTML = `
                    <tr><td class="py-1 w-1/3">Status Code</td><td class="\${apiLog.status === 'ERROR' ? 'text-red-500' : 'text-green-400'} font-bold">\${apiLog.status === 'ERROR' ? '4XX' : '200 OK'}</td></tr>
                    <tr><td class="py-1">Response Time</td><td class="text-white">\${apiLog.duration}ms</td></tr>
                    <tr><td class="py-1">Image Count</td><td class="text-white">Fetched</td></tr>
                `;
            }
        }

        if(youtubeLogs.length > 0) {
            const apiLog = youtubeLogs.find(l => l.operation === 'YouTube API');
            if(apiLog) {
                document.getElementById('debugYoutubeApi').innerHTML = `
                    <tr><td class="py-1 w-1/3">Status Code</td><td class="\${apiLog.status === 'ERROR' ? 'text-red-500' : 'text-green-400'} font-bold">\${apiLog.status === 'ERROR' ? '4XX' : '200 OK'}</td></tr>
                    <tr><td class="py-1">Response Time</td><td class="text-white">\${apiLog.duration}ms</td></tr>
                    <tr><td class="py-1">Video Count</td><td class="text-white">Fetched</td></tr>
                `;
            }
        }

        // 4. Duplicate Detection
        const dupWarning = document.getElementById('debugDuplicateWarning');
        const dupList = document.getElementById('debugDuplicateList');
        dupList.innerHTML = '';
        let hasDups = false;

        const checkDups = (arr, name) => {
            if(!arr) return;
            const titles = arr.map(i => i.name || i.title || i);
            const duplicates = titles.filter((item, index) => titles.indexOf(item) !== index);
            if(duplicates.length > 0) {
                hasDups = true;
                duplicates.forEach(d => {
                    dupList.innerHTML += `<li>Duplicate \${name}: <strong>\${d}</strong></li>`;
                });
            }
        };

        if(globalAiJson) {
            checkDups(globalAiJson.hidden_gems, 'Hidden Gem');
            checkDups(globalAiJson.local_food_recommendations, 'Food');
            checkDups(globalAiJson.must_visit_places, 'Place');
        }

        if(hasDups) {
            dupWarning.classList.remove('hidden');
        } else {
            dupWarning.classList.add('hidden');
        }

        // 5. Trace update
        const traces = document.getElementById('debugGenerationTrace').children;
        if(data.logs.length > 0) {
            traces[0].className = "p-2 border border-green-500/30 bg-green-900/20 text-green-400 rounded font-bold shadow-[0_0_10px_rgba(34,197,94,0.2)]";
            traces[1].className = "p-2 border border-green-500/30 bg-green-900/20 text-green-400 rounded font-bold shadow-[0_0_10px_rgba(34,197,94,0.2)]";
            if(globalAiJson && globalAiJson.title) traces[5].className = "p-2 border border-green-500/30 bg-green-900/20 text-green-400 rounded font-bold shadow-[0_0_10px_rgba(34,197,94,0.2)]";
        }
    }

    function exportPlannerJson() {
        if(!globalAiJson) return alert('No JSON data available yet.');
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(globalAiJson, null, 2));
        const downloadAnchorNode = document.createElement('a');
        downloadAnchorNode.setAttribute("href", dataStr);
        downloadAnchorNode.setAttribute("download", "planner-debug.json");
        document.body.appendChild(downloadAnchorNode);
        downloadAnchorNode.click();
        downloadAnchorNode.remove();
    }

    // Safe polling with null-guard and error display
    const logPanel = document.getElementById('live-log-panel');
    let logPoller = null;

    function startLogPolling() {
        if (!CONTEXT_PATH) {
            if (logPanel) logPanel.innerHTML = '<span style="color:#f87171">contextPath not defined — cannot poll logs.</span>';
            return;
        }

        logPoller = setInterval(async () => {
            try {
                const res = await fetch(CONTEXT_PATH + '/api/planner/debug', {
                    credentials: 'include',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                });

                if (!res.ok) {
                    if (logPanel) logPanel.innerHTML += `<div style="color:#f87171">[\${new Date().toLocaleTimeString()}] Log endpoint returned \${res.status}</div>`;
                    clearInterval(logPoller);
                    return;
                }

                const data = await res.json();
                renderDashboard(data);
                
                if (logPanel && data.logs) {
                    logPanel.innerHTML = data.logs
                        .map(log => `<div class="log-entry log-\${log.level?.toLowerCase() || 'info'}">
                            <span class="log-time">\${log.timestamp || new Date().toISOString()}</span>
                            <span class="log-msg">\${log.operation}: \${log.status}</span>
                        </div>`)
                        .join('');
                    logPanel.scrollTop = logPanel.scrollHeight;
                }
            } catch (err) {
                if (logPanel) logPanel.innerHTML += `<div style="color:#f87171">[ERR] \${err.message}</div>`;
            }
        }, 2000); // poll every 2 seconds
    }

    document.addEventListener('DOMContentLoaded', startLogPolling);
    // Initial fetch
    refreshDashboard();
</script>

    </div> <!-- End container -->
    <%@ include file="/components/footer.jsp" %>
</body>
</html>
