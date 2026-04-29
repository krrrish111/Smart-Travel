<jsp:include page="/admin/common/layout_start.jsp" />

<div class="flex justify-between items-center mb-6">
    <div>
        <h2>System Monitoring & Logs</h2>
        <p class="text-muted">Real-time health check and audit logs for the Voyastra platform.</p>
    </div>
    <div class="flex gap-3">
        <button class="btn btn-outline" onclick="loadActivityLog()">Refresh Logs</button>
        <button class="btn btn-outline" style="border-color:#ef4444; color:#ef4444;" onclick="clearLogs()">Clear All</button>
    </div>
</div>

<!-- System Health Cards -->
<div class="grid grid-cards gap-6 mb-8">
    
    <div class="stat-card health-card" style="border-left-color: #10b981;">
        <div class="flex justify-between items-start">
            <div>
                <div class="stat-label">Server Status</div>
                <div class="font-bold mt-2 text-primary" style="font-size: 1.25rem; color: #10b981;">Operational</div>
                <div class="text-xs text-muted mt-2">Uptime: 14d 6h 22m</div>
            </div>
            <div class="health-status-dot" style="color: #10b981; background: #10b981;"></div>
        </div>
    </div>

    <div class="stat-card health-card" style="border-left-color: #3b82f6;">
        <div class="stat-label">Database Latency</div>
        <div class="font-bold mt-2" style="font-size: 1.25rem;">24ms</div>
        <div class="progress-bar-wrap">
            <div class="progress-bar-fill" style="width: 15%; background: #3b82f6;"></div>
        </div>
    </div>

    <div class="stat-card health-card" style="border-left-color: #fbbf24;">
        <div class="stat-label">Memory Usage</div>
        <div class="font-bold mt-2" style="font-size: 1.25rem;">1.4 GB <span class="text-muted" style="font-size: 0.8rem; font-weight: 400;">/ 4.0 GB</span></div>
        <div class="progress-bar-wrap">
            <div class="progress-bar-fill" style="width: 35%; background: #fbbf24;"></div>
        </div>
    </div>

</div>

<!-- Real-time Logs -->
<div class="stat-card p-0" style="overflow: hidden;">
    <div class="p-4 flex justify-between items-center" style="border-bottom: 1px solid var(--color-border); background: rgba(255,255,255,0.02);">
        <h3 class="text-sm">System Audit Log</h3>
        <div class="flex gap-3 items-center">
            <span class="text-xs text-muted flex items-center gap-2">
                <span class="health-status-dot" style="width:8px; height:8px; background:#10b981; color:#10b981;"></span> Live Update Active
            </span>
            <select class="filter-select" id="logLevelFilter" onchange="loadActivityLog()" style="padding: 4px 12px; font-size: 0.8rem;">
                <option value="all">All Levels</option>
                <option value="info">Info</option>
                <option value="warning">Warning</option>
                <option value="error">Error</option>
            </select>
        </div>
    </div>
    
    <div style="max-height: 500px; overflow-y: auto;">
        <div class="activity-timeline" id="activityTimelineBox" style="padding: 0;">
            <!-- Logs will be rendered here -->
        </div>
    </div>
</div>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/logs.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadActivityLog === 'function') loadActivityLog();
        // Mock live update
        setInterval(() => {
            if (Math.random() > 0.8 && typeof loadActivityLog === 'function') loadActivityLog();
        }, 5000);
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
