<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Experiences Debug Console | Voyastra</title>
    <script>
        const CONTEXT_PATH = '${pageContext.request.contextPath}';
        const contextPath = CONTEXT_PATH;
    </script>
    <%@ include file="/components/global_ui.jsp" %>
</head>

<body class="bg-[#0a0a0a] text-white font-sans antialiased">
    <%@ include file="/components/header.jsp" %>

    <div class="container mx-auto px-4 pt-24 pb-12">
        <div id="plannerDebugDashboard"
            class="border-t-4 border-red-500 bg-[#0a0a0a] text-white p-8 font-mono text-sm shadow-2xl rounded-b">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2
                        class="text-3xl font-bold text-red-500 tracking-widest uppercase flex items-center gap-3">
                        <i class="ri-bug-2-line"></i> VOYASTRA EXPERIENCES DEBUG
                    </h2>
                    <p class="text-gray-400 mt-2 flex items-center gap-2">Live generation pipeline X-Ray (Developer Only) <span id="pipelineStatusBadge" class="px-2 py-0.5 rounded text-xs font-bold bg-zinc-800 text-zinc-400">PENDING</span></p>
                </div>
                <div class="flex gap-4">
                    <button onclick="refreshDashboard()"
                        class="bg-blue-600 hover:bg-blue-700 px-6 py-2 rounded font-bold uppercase tracking-wide transition-colors flex items-center gap-2">
                        <i class="ri-refresh-line"></i> Refresh Metrics
                    </button>
                    <button onclick="exportPlannerJson()"
                        class="bg-red-600 hover:bg-red-700 px-6 py-2 rounded font-bold uppercase tracking-wide transition-colors flex items-center gap-2">
                        <i class="ri-download-2-line"></i> Export Data
                    </button>
                </div>
            </div>

            <!-- Live Status Cards -->
            <div class="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-6 gap-4 mb-8" id="debugStatusCards">
                <!-- Rendered via JS -->
            </div>

            <!-- Main Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Live Console Logs -->
                <div class="lg:col-span-1 bg-black border border-white/10 rounded flex flex-col h-[600px]">
                    <div
                        class="bg-white/5 px-4 py-2 border-b border-white/10 font-bold tracking-widest text-xs flex justify-between">
                        <span>LIVE CONSOLE LOGS</span>
                        <span class="text-green-500 animate-pulse">● REC</span>
                    </div>
                    <div id="debugConsoleTerminal"
                        class="flex-1 overflow-y-auto p-4 space-y-4 text-xs text-green-400">
                        <div class="text-gray-600">Waiting for telemetry...</div>
                    </div>
                </div>

                <!-- API Debug Response & Generation Trace -->
                <div class="lg:col-span-2 space-y-8">

                    <!-- Generation Trace -->
                    <div class="bg-black border border-white/10 rounded p-6">
                        <h3
                            class="font-bold tracking-widest text-xs border-b border-white/10 pb-2 mb-4 text-gray-400">
                            GENERATION TRACE (EXECUTION ORDER)</h3>
                        <div class="grid grid-cols-2 sm:grid-cols-5 gap-4 text-center text-xs"
                            id="debugGenerationTrace">
                            <div class="p-2 border border-white/5 rounded text-gray-500">1 Input Validation</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">2 Wikipedia Fetch</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">3 Destination Processing</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">4 Image Search</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">5 Video Search</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">6 Gemini Recommendations</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">7 Food Suggestions</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">8 Hotel Suggestions</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">9 Experience Suggestions</div>
                            <div class="p-2 border border-white/5 rounded text-gray-500">10 Page Rendering</div>
                        </div>
                    </div>

                    <!-- API Status Tables -->
                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-black border border-white/10 rounded p-4">
                            <h3 class="font-bold tracking-widest text-xs text-blue-400 mb-3"><i
                                    class="ri-camera-lens-line"></i> UNSPLASH API</h3>
                            <table class="w-full text-xs text-left text-gray-400">
                                <tbody id="debugUnsplashApi">
                                    <tr>
                                        <td class="py-1 w-1/3">Status Code</td>
                                        <td class="text-white">-</td>
                                    </tr>
                                    <tr>
                                        <td class="py-1">Response Time</td>
                                        <td class="text-white">-</td>
                                    </tr>
                                    <tr>
                                        <td class="py-1">Image Count</td>
                                        <td class="text-white">-</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="bg-black border border-white/10 rounded p-4">
                            <h3 class="font-bold tracking-widest text-xs text-red-400 mb-3"><i
                                    class="ri-youtube-line"></i> YOUTUBE API</h3>
                            <table class="w-full text-xs text-left text-gray-400">
                                <tbody id="debugYoutubeApi">
                                    <tr>
                                        <td class="py-1 w-1/3">Status Code</td>
                                        <td class="text-white">-</td>
                                    </tr>
                                    <tr>
                                        <td class="py-1">Response Time</td>
                                        <td class="text-white">-</td>
                                    </tr>
                                    <tr>
                                        <td class="py-1">Video Count</td>
                                        <td class="text-white">-</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Performance Metrics -->
                    <div class="bg-black border border-white/10 rounded p-4">
                        <h3 class="font-bold tracking-widest text-xs text-yellow-400 mb-3"><i
                                class="ri-timer-line"></i> PERFORMANCE METRICS</h3>
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

                </div>
            </div>
        </div>

        <script>
            let globalAiJson = {};

            async function refreshDashboard() {
                try {
                    const res = await fetch(contextPath + '/api/experiences/debug');
                    if (res.ok) {
                        const data = await res.json();
                        renderDashboard(data);
                    }
                } catch (e) {
                    console.error("Dashboard error:", e);
                }
            }

            function renderDashboard(data) {
                if (!data.logs) return;

                globalAiJson = data.ai_output || {};

                const badge = document.getElementById('pipelineStatusBadge');
                if (badge && data.logs.length > 0) {
                    let hasError = data.logs.some(l => l.status === 'ERROR');
                    if (hasError) {
                        badge.innerText = "FAILED";
                        badge.className = "px-2 py-0.5 rounded text-xs font-bold bg-red-950 text-red-400 border border-red-500/20";
                    } else if (data.logs.some(l => l.operation === 'Page Rendering')) {
                        badge.innerText = "COMPLETED";
                        badge.className = "px-2 py-0.5 rounded text-xs font-bold bg-green-950 text-green-400 border border-green-500/20";
                    } else {
                        badge.innerText = "IN PROGRESS";
                        badge.className = "px-2 py-0.5 rounded text-xs font-bold bg-blue-950 text-blue-400 border border-blue-500/20";
                    }
                }

                const getCardState = (key) => {
                    if (data.logs.some(l => l.operation.includes(key) && l.status === 'ERROR')) return { color: 'text-red-500', bg: 'bg-red-500/10', border: 'border-red-500/30', icon: 'ri-close-circle-fill', text: 'FAILED' };
                    if (data.logs.some(l => l.operation.includes(key) && l.status === 'WARNING')) return { color: 'text-yellow-400', bg: 'bg-yellow-400/10', border: 'border-yellow-400/30', icon: 'ri-error-warning-fill', text: 'WARNING' };
                    if (data.logs.some(l => l.operation.includes(key) && l.status === 'SUCCESS')) return { color: 'text-green-400', bg: 'bg-green-400/10', border: 'border-green-400/30', icon: 'ri-checkbox-circle-fill', text: 'SUCCESS' };
                    if (data.logs.some(l => l.operation.includes(key) && l.status === 'STARTED')) return { color: 'text-blue-400', bg: 'bg-blue-400/10', border: 'border-blue-400/30', icon: 'ri-loader-4-line animate-spin', text: 'LOADING' };
                    if (data.logs.some(l => l.operation.includes(key) && l.status === 'HIT')) return { color: 'text-purple-400', bg: 'bg-purple-400/10', border: 'border-purple-400/30', icon: 'ri-flashlight-fill', text: 'CACHE HIT' };
                    if (data.logs.some(l => l.operation.includes(key) && l.status === 'SKIPPED')) return { color: 'text-gray-400', bg: 'bg-white/5', border: 'border-white/10', icon: 'ri-skip-forward-line', text: 'SKIPPED' };
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
                    renderCard('Places API', 'Places API') +
                    renderCard('Wikipedia API', 'Wikipedia Fetch') +
                    renderCard('Unsplash API', 'Image Search') +
                    renderCard('YouTube API', 'Video Search') +
                    renderCard('Gemini API', 'Gemini Recommendations') +
                    renderCard('Database', 'Destination Processing') +
                    renderCard('Cache', 'Cache');

                const terminal = document.getElementById('debugConsoleTerminal');
                terminal.innerHTML = data.logs.map(l => {
                    const time = new Date(l.timestamp).toISOString().split('T')[1].slice(0, -1);
                    let color = "text-green-400";
                    if (l.status === 'ERROR') color = "text-red-500";
                    if (l.status === 'WARNING') color = "text-yellow-400";

                    return `<div class="mb-4">
        <div class="text-gray-500">[\${time}]</div>
        <div class="\${color} font-bold">\${l.operation} <span class="text-gray-400 font-normal">(\${l.status})</span></div>
        <div class="text-white">\${l.message}</div>
    </div>`;
                }).join('');

                let totalTime = 0;
                let apiTimeTotal = 0, apiCount = 0;
                let cacheTime = 0;

                const unsplashLogs = data.logs.filter(l => l.operation.includes('Image Search'));
                const youtubeLogs = data.logs.filter(l => l.operation.includes('Video Search'));

                data.logs.forEach(l => {
                    totalTime += l.duration;
                    if (l.operation.includes('Fetch') || l.operation.includes('Search') || l.operation.includes('Recommendations')) {
                        if (l.duration > 0 && l.status !== 'CACHE') {
                            apiTimeTotal += l.duration;
                            apiCount++;
                        }
                    }
                    if (l.status === 'CACHE' && l.duration > 0) {
                        cacheTime += l.duration;
                    }
                });

                document.getElementById('perfTotal').innerText = totalTime + "ms";
                document.getElementById('perfApi').innerText = apiCount ? Math.round(apiTimeTotal / apiCount) + "ms" : "-";
                document.getElementById('perfCache').innerText = cacheTime + "ms";
                document.getElementById('perfDb').innerText = "<1ms";
                document.getElementById('perfRender').innerText = typeof window.performanceRenderTime !== 'undefined' ? window.performanceRenderTime + "ms" : "Pending";

                if (unsplashLogs.length > 0) {
                    const apiLog = unsplashLogs[unsplashLogs.length - 1];
                    document.getElementById('debugUnsplashApi').innerHTML = `
            <tr><td class="py-1 w-1/3">Status Code</td><td class="\${apiLog.status === 'ERROR' ? 'text-red-500' : 'text-green-400'} font-bold">\${apiLog.status === 'ERROR' ? '4XX' : '200 OK'}</td></tr>
            <tr><td class="py-1">Response Time</td><td class="text-white">\${apiLog.duration}ms</td></tr>
            <tr><td class="py-1">Image Count</td><td class="text-white">Fetched</td></tr>
        `;
                }

                if (youtubeLogs.length > 0) {
                    const apiLog = youtubeLogs[youtubeLogs.length - 1];
                    document.getElementById('debugYoutubeApi').innerHTML = `
            <tr><td class="py-1 w-1/3">Status Code</td><td class="\${apiLog.status === 'ERROR' ? 'text-red-500' : 'text-green-400'} font-bold">\${apiLog.status === 'ERROR' ? '4XX' : '200 OK'}</td></tr>
            <tr><td class="py-1">Response Time</td><td class="text-white">\${apiLog.duration}ms</td></tr>
            <tr><td class="py-1">Video Count</td><td class="text-white">Fetched</td></tr>
        `;
                }

                const traces = document.getElementById('debugGenerationTrace').children;
                if (data.logs.length > 0 && traces && traces.length >= 10) {
                    const activeClass = "p-2 border border-green-500/30 bg-green-900/20 text-green-400 rounded font-bold shadow-[0_0_10px_rgba(34,197,94,0.2)]";
                    const inactiveClass = "p-2 border border-white/5 rounded text-gray-500";
                    
                    const hasLogSuccess = (op) => data.logs.some(l => l.operation === op && (l.status === 'SUCCESS' || l.status === 'CACHE'));
                    
                    traces[0].className = hasLogSuccess('Input Validation') ? activeClass : inactiveClass;
                    traces[1].className = hasLogSuccess('Wikipedia Fetch') ? activeClass : inactiveClass;
                    traces[2].className = hasLogSuccess('Destination Processing') ? activeClass : inactiveClass;
                    traces[3].className = hasLogSuccess('Image Search') ? activeClass : inactiveClass;
                    traces[4].className = hasLogSuccess('Video Search') ? activeClass : inactiveClass;
                    traces[5].className = hasLogSuccess('Gemini Recommendations') ? activeClass : inactiveClass;
                    traces[6].className = hasLogSuccess('Food Suggestions') ? activeClass : inactiveClass;
                    traces[7].className = hasLogSuccess('Hotel Suggestions') ? activeClass : inactiveClass;
                    traces[8].className = hasLogSuccess('Experience Suggestions') ? activeClass : inactiveClass;
                    traces[9].className = hasLogSuccess('Page Rendering') ? activeClass : inactiveClass;
                }
            }

            function exportPlannerJson() {
                if (!globalAiJson) return alert('No JSON data available yet.');
                const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(globalAiJson, null, 2));
                const downloadAnchorNode = document.createElement('a');
                downloadAnchorNode.setAttribute("href", dataStr);
                downloadAnchorNode.setAttribute("download", "experiences-debug.json");
                document.body.appendChild(downloadAnchorNode);
                downloadAnchorNode.click();
                downloadAnchorNode.remove();
            }

            let logPoller = null;

            function startLogPolling() {
                if (!CONTEXT_PATH) return;

                logPoller = setInterval(async () => {
                    try {
                        const res = await fetch(CONTEXT_PATH + '/api/experiences/debug', {
                            credentials: 'include',
                            headers: { 'X-Requested-With': 'XMLHttpRequest' }
                        });

                        if (!res.ok) {
                            clearInterval(logPoller);
                            return;
                        }

                        const data = await res.json();
                        renderDashboard(data);
                    } catch (err) {
                    }
                }, 2000);
            }

            document.addEventListener('DOMContentLoaded', startLogPolling);
            refreshDashboard();
        </script>
    </div>
    <%@ include file="/components/footer.jsp" %>
</body>

</html>
