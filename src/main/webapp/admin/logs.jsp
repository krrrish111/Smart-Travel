<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/admin/common/layout_start.jsp" />

<div class="flex justify-between items-center mb-6">
    <div>
        <h2>System Monitoring & Logs</h2>
        <p class="text-muted">Real-time health check and audit logs for the Voyastra platform.</p>
    </div>
    <div class="flex gap-3">
        <button class="btn btn-outline" onclick="exportLogsCSV()">Export CSV</button>
        <button class="btn btn-outline" style="border-color:#ef4444; color:#ef4444;" onclick="clearLogs()">Clear All</button>
    </div>
</div>

<!-- System Health Cards -->
<div class="grid grid-cards gap-6 mb-8" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));">
    
    <div class="stat-card health-card" id="cardStatus" style="border-left-color: #10b981;">
        <div class="flex justify-between items-start">
            <div>
                <div class="stat-label">Server Status</div>
                <div class="font-bold mt-2 text-primary" id="valStatus" style="font-size: 1.25rem; color: #10b981;">Checking...</div>
                <div class="text-xs text-muted mt-2" id="valUptime">Uptime: --</div>
            </div>
            <div class="health-status-dot" id="dotStatus" style="color: #10b981; background: #10b981;"></div>
        </div>
    </div>

    <div class="stat-card health-card" style="border-left-color: #3b82f6;">
        <div class="stat-label">Database Latency</div>
        <div class="font-bold mt-2" id="valLatency" style="font-size: 1.25rem;">-- ms</div>
    </div>

    <div class="stat-card health-card" style="border-left-color: #fbbf24;">
        <div class="stat-label">Memory Usage</div>
        <div class="font-bold mt-2" id="valMemory" style="font-size: 1.25rem;">-- MB <span class="text-muted" style="font-size: 0.8rem; font-weight: 400;">/ -- MB</span></div>
        <div class="progress-bar-wrap">
            <div class="progress-bar-fill" id="barMemory" style="width: 0%; background: #fbbf24;"></div>
        </div>
    </div>

    <div class="stat-card health-card" style="border-left-color: #8b5cf6;">
        <div class="stat-label">CPU Usage</div>
        <div class="font-bold mt-2" id="valCpu" style="font-size: 1.25rem;">-- %</div>
        <div class="progress-bar-wrap">
            <div class="progress-bar-fill" id="barCpu" style="width: 0%; background: #8b5cf6;"></div>
        </div>
    </div>

    <div class="stat-card health-card" style="border-left-color: #0ea5e9;">
        <div class="stat-label">Disk Usage</div>
        <div class="font-bold mt-2" id="valDisk" style="font-size: 1.25rem;">-- %</div>
        <div class="progress-bar-wrap">
            <div class="progress-bar-fill" id="barDisk" style="width: 0%; background: #0ea5e9;"></div>
        </div>
    </div>

    <div class="stat-card health-card" style="border-left-color: #ec4899;">
        <div class="stat-label">Active Sessions</div>
        <div class="font-bold mt-2" id="valSessions" style="font-size: 1.25rem;">--</div>
    </div>
</div>

<!-- Real-time Logs -->
<div class="stat-card p-0" style="overflow: hidden;">
    <div class="p-4 flex flex-wrap justify-between items-center gap-4" style="border-bottom: 1px solid var(--color-border); background: rgba(255,255,255,0.02);">
        <h3 class="text-sm">System Audit Log</h3>
        <div class="flex gap-3 items-center flex-wrap">
            <input type="text" class="form-control" id="searchFilter" placeholder="Search logs..." onkeyup="loadActivityLog()" style="max-width: 150px; padding: 4px 12px; font-size: 0.8rem;">
            
            <select class="filter-select" id="logModuleFilter" onchange="loadActivityLog()" style="padding: 4px 12px; font-size: 0.8rem;">
                <option value="">All Modules</option>
                <option value="LOGIN">LOGIN</option>
                <option value="BOOKINGS">BOOKINGS</option>
                <option value="USERS">USERS</option>
                <option value="DESTINATIONS">DESTINATIONS</option>
                <option value="PAYMENTS">PAYMENTS</option>
                <option value="COMMUNITY">COMMUNITY</option>
                <option value="REVIEWS">REVIEWS</option>
            </select>
            
            <select class="filter-select" id="logTypeFilter" onchange="loadActivityLog()" style="padding: 4px 12px; font-size: 0.8rem;">
                <option value="">All Actions</option>
                <option value="ADD">ADD</option>
                <option value="UPDATE">UPDATE</option>
                <option value="DELETE">DELETE</option>
                <option value="LOGIN">LOGIN</option>
            </select>
            
            <span class="text-xs text-muted flex items-center gap-2" id="logLiveIndicator">
                <span class="health-status-dot" style="width:8px; height:8px; background:#10b981; color:#10b981;"></span> Live Update
            </span>
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
        if (typeof loadSystemHealth === 'function') loadSystemHealth();
        if (typeof loadActivityLog === 'function') loadActivityLog();
        
        setInterval(() => {
            if (typeof loadSystemHealth === 'function') loadSystemHealth();
        }, 5000);
        
        setInterval(() => {
            if (typeof loadActivityLog === 'function') loadActivityLog();
        }, 10000);
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
