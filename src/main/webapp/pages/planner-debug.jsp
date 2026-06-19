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
    </div>

    <script>
        var globalAiJson = {};

        async function refreshDashboard() {
            try {
                var url = (contextPath || '') + '/api/planner/debug';
                var res = await fetch(url);
                if (res.ok) {
                    var data = await res.json();
                    renderDashboard(data);
                }
            } catch (e) {
                console.error("Dashboard error:", e);
            }
        }

        function renderDashboard(data) {
            if (!data || !data.logs) return;
            globalAiJson = data.ai_output || {};

            // Calculate card states based on logs
            var getCardState = function(key) {
                var hasError = data.logs.some(function(l) { return l.operation && l.operation.indexOf(key) !== -1 && l.status === 'ERROR'; });
                if (hasError) return { color: 'text-red-500', bg: 'bg-red-500/10', border: 'border-red-500/30', icon: 'ri-close-circle-fill', text: 'FAILED' };
                
                var hasWarning = data.logs.some(function(l) { return l.operation && l.operation.indexOf(key) !== -1 && l.status === 'WARNING'; });
                if (hasWarning) return { color: 'text-yellow-400', bg: 'bg-yellow-400/10', border: 'border-yellow-400/30', icon: 'ri-error-warning-fill', text: 'WARNING' };
                
                var hasSuccess = data.logs.some(function(l) { return l.operation && l.operation.indexOf(key) !== -1 && l.status === 'SUCCESS'; });
                if (hasSuccess) return { color: 'text-green-400', bg: 'bg-green-400/10', border: 'border-green-400/30', icon: 'ri-checkbox-circle-fill', text: 'SUCCESS' };
                
                var hasStarted = data.logs.some(function(l) { return l.operation && l.operation.indexOf(key) !== -1 && l.status === 'STARTED'; });
                if (hasStarted) return { color: 'text-blue-400', bg: 'bg-blue-400/10', border: 'border-blue-400/30', icon: 'ri-loader-4-line animate-spin', text: 'LOADING' };
                
                var hasHit = data.logs.some(function(l) { return l.operation && l.operation.indexOf(key) !== -1 && l.status === 'HIT'; });
                if (hasHit) return { color: 'text-purple-400', bg: 'bg-purple-400/10', border: 'border-purple-400/30', icon: 'ri-flashlight-fill', text: 'CACHE HIT' };
                
                return { color: 'text-gray-500', bg: 'bg-white/5', border: 'border-white/10', icon: 'ri-time-line', text: 'PENDING' };
            };

            var renderCard = function(title, key) {
                var state = getCardState(key);
                return '<div class="p-3 rounded border ' + state.border + ' ' + state.bg + ' flex flex-col justify-between h-24">' +
                       '  <div class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">' + title + '</div>' +
                       '  <div class="text-sm font-bold ' + state.color + ' flex items-center gap-2 mt-auto">' +
                       '    <i class="' + state.icon + ' text-lg"></i> ' + state.text +
                       '  </div>' +
                       '</div>';
            };

            var cardsContainer = document.getElementById('debugStatusCards');
            if (cardsContainer) {
                cardsContainer.innerHTML = 
                    renderCard('Input Validation', 'Input Validation') +
                    renderCard('Destination Data', 'Destination') +
                    renderCard('YouTube API', 'YouTube') +
                    renderCard('Unsplash API', 'Unsplash') +
                    renderCard('Budget Engine', 'Budget') +
                    renderCard('Itinerary Engine', 'Gemini') +
                    renderCard('Database Cache', 'Cache');
            }

            // 1. Terminal Logs
            var terminal = document.getElementById('debugConsoleTerminal');
            if (terminal) {
                terminal.innerHTML = data.logs.map(function(l) {
                    var time = '';
                    try {
                        time = new Date(l.timestamp).toISOString().split('T')[1].slice(0,-1);
                    } catch(e) {
                        time = '00:00:00';
                    }
                    var statusColor = "text-green-400";
                    if(l.status === 'ERROR') statusColor = "text-red-500";
                    if(l.status === 'WARNING') statusColor = "text-yellow-400";
                    
                    return '<div class="mb-4">' +
                           '  <div class="text-gray-500">[' + time + ']</div>' +
                           '  <div class="' + statusColor + ' font-bold">' + (l.operation || 'Unknown') + ' <span class="text-gray-400 font-normal">(' + (l.status || '') + ')</span></div>' +
                           '  <div class="text-white">' + (l.message || '') + '</div>' +
                           '</div>';
                }).join('');
            }

            // 2. Performance Metrics Calculation
            var totalTime = 0;
            var apiTimeTotal = 0, apiCount = 0;
            var cacheTime = 0;
            
            var unsplashLogs = data.logs.filter(function(l) { return l.operation && l.operation.indexOf('Unsplash') !== -1; });
            var youtubeLogs = data.logs.filter(function(l) { return l.operation && l.operation.indexOf('YouTube') !== -1; });

            data.logs.forEach(function(l) {
                totalTime += l.duration || 0;
                if(l.operation && l.operation.indexOf('API') !== -1 && l.duration > 0) {
                    apiTimeTotal += l.duration;
                    apiCount++;
                }
                if(l.operation && l.operation.indexOf('Cache') !== -1 && l.duration > 0) {
                    cacheTime += l.duration;
                }
            });

            var totalEl = document.getElementById('perfTotal');
            if (totalEl) totalEl.innerText = totalTime + "ms";
            
            var apiEl = document.getElementById('perfApi');
            if (apiEl) apiEl.innerText = apiCount ? Math.round(apiTimeTotal/apiCount) + "ms" : "-";
            
            var cacheEl = document.getElementById('perfCache');
            if (cacheEl) cacheEl.innerText = cacheTime + "ms";
            
            var dbEl = document.getElementById('perfDb');
            if (dbEl) dbEl.innerText = "<1ms";
            
            var renderEl = document.getElementById('perfRender');
            if (renderEl) renderEl.innerText = typeof window.performanceRenderTime !== 'undefined' ? window.performanceRenderTime + "ms" : "Pending";

            // 3. API Panels
            if(unsplashLogs.length > 0) {
                var apiLog = unsplashLogs.find(function(l) { return l.operation === 'Unsplash API'; });
                var unsplashApiEl = document.getElementById('debugUnsplashApi');
                if(apiLog && unsplashApiEl) {
                    var codeClass = apiLog.status === 'ERROR' ? 'text-red-500' : 'text-green-400';
                    var codeText = apiLog.status === 'ERROR' ? '4XX' : '200 OK';
                    unsplashApiEl.innerHTML = 
                        '<tr><td class="py-1 w-1/3">Status Code</td><td class="' + codeClass + ' font-bold">' + codeText + '</td></tr>' +
                        '<tr><td class="py-1">Response Time</td><td class="text-white">' + apiLog.duration + 'ms</td></tr>' +
                        '<tr><td class="py-1">Image Count</td><td class="text-white">Fetched</td></tr>';
                }
            }

            if(youtubeLogs.length > 0) {
                var apiLog = youtubeLogs.find(function(l) { return l.operation === 'YouTube API'; });
                var youtubeApiEl = document.getElementById('debugYoutubeApi');
                if(apiLog && youtubeApiEl) {
                    var codeClass = apiLog.status === 'ERROR' ? 'text-red-500' : 'text-green-400';
                    var codeText = apiLog.status === 'ERROR' ? '4XX' : '200 OK';
                    youtubeApiEl.innerHTML = 
                        '<tr><td class="py-1 w-1/3">Status Code</td><td class="' + codeClass + ' font-bold">' + codeText + '</td></tr>' +
                        '<tr><td class="py-1">Response Time</td><td class="text-white">' + apiLog.duration + 'ms</td></tr>' +
                        '<tr><td class="py-1">Video Count</td><td class="text-white">Fetched</td></tr>';
                }
            }

            // 4. Duplicate Detection
            var dupWarning = document.getElementById('debugDuplicateWarning');
            var dupList = document.getElementById('debugDuplicateList');
            if (dupList) dupList.innerHTML = '';
            var hasDups = false;

            var checkDups = function(arr, name) {
                if(!arr || !Array.isArray(arr)) return;
                var titles = arr.map(function(i) { return i.name || i.title || i; });
                var duplicates = titles.filter(function(item, index) { return titles.indexOf(item) !== index; });
                if(duplicates.length > 0) {
                    hasDups = true;
                    duplicates.forEach(function(d) {
                        if (dupList) {
                            dupList.innerHTML += '<li>Duplicate ' + name + ': <strong>' + d + '</strong></li>';
                        }
                    });
                }
            };

            if(globalAiJson) {
                checkDups(globalAiJson.hidden_gems, 'Hidden Gem');
                checkDups(globalAiJson.local_food_recommendations, 'Food');
                checkDups(globalAiJson.must_visit_places, 'Place');
            }

            if(dupWarning) {
                if(hasDups) {
                    dupWarning.classList.remove('hidden');
                } else {
                    dupWarning.classList.add('hidden');
                }
            }

            // 5. Trace update
            var traceContainer = document.getElementById('debugGenerationTrace');
            if (traceContainer) {
                var traces = traceContainer.children;
                if(traces && traces.length > 5 && data.logs.length > 0) {
                    traces[0].className = "p-2 border border-green-500/30 bg-green-900/20 text-green-400 rounded font-bold shadow-[0_0_10px_rgba(34,197,94,0.2)]";
                    traces[1].className = "p-2 border border-green-500/30 bg-green-900/20 text-green-400 rounded font-bold shadow-[0_0_10px_rgba(34,197,94,0.2)]";
                    if(globalAiJson && globalAiJson.title) {
                        traces[5].className = "p-2 border border-green-500/30 bg-green-900/20 text-green-400 rounded font-bold shadow-[0_0_10px_rgba(34,197,94,0.2)]";
                    }
                }
            }
        }

        function exportPlannerJson() {
            if(!globalAiJson || Object.keys(globalAiJson).length === 0) return alert('No JSON data available yet.');
            var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(globalAiJson, null, 2));
            var downloadAnchorNode = document.createElement('a');
            downloadAnchorNode.setAttribute("href", dataStr);
            downloadAnchorNode.setAttribute("download", "planner-debug.json");
            document.body.appendChild(downloadAnchorNode);
            downloadAnchorNode.click();
            downloadAnchorNode.remove();
        }

        var logPoller = null;

        function startLogPolling() {
            logPoller = setInterval(async function() {
                try {
                    var url = (CONTEXT_PATH || '') + '/api/planner/debug';
                    var res = await fetch(url, {
                        credentials: 'include',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                    });

                    if (res.ok) {
                        var data = await res.json();
                        renderDashboard(data);
                    }
                } catch (err) {
                    console.error("Polling error:", err);
                }
            }, 2000); // poll every 2 seconds
        }

        document.addEventListener('DOMContentLoaded', startLogPolling);
        // Initial fetch
        refreshDashboard();
    </script>

    <%@ include file="/components/footer.jsp" %>
</body>
</html>
