/* =========================================================
   SYSTEM LOGGING & MONITORING MODULE
========================================================= */

function loadSystemHealth() {
    fetch(CONTEXT_PATH + '/admin/system/health')
        .then(response => response.json())
        .then(data => {
            // Server Status
            const valStatus = document.getElementById('valStatus');
            const dotStatus = document.getElementById('dotStatus');
            const cardStatus = document.getElementById('cardStatus');
            if (data.status === 'ONLINE') {
                valStatus.innerText = 'Operational';
                valStatus.style.color = '#10b981';
                dotStatus.style.color = '#10b981';
                dotStatus.style.background = '#10b981';
                cardStatus.style.borderLeftColor = '#10b981';
            } else {
                valStatus.innerText = 'Offline';
                valStatus.style.color = '#ef4444';
                dotStatus.style.color = '#ef4444';
                dotStatus.style.background = '#ef4444';
                cardStatus.style.borderLeftColor = '#ef4444';
            }
            
            document.getElementById('valUptime').innerText = 'Uptime: ' + data.uptime;
            document.getElementById('valLatency').innerText = data.databaseLatency >= 0 ? data.databaseLatency + ' ms' : '--';
            
            document.getElementById('valMemory').innerHTML = `${data.memoryUsedMB} MB <span class="text-muted" style="font-size: 0.8rem; font-weight: 400;">/ ${data.memoryMaxMB} MB</span>`;
            document.getElementById('barMemory').style.width = data.memoryPercent + '%';
            
            document.getElementById('valCpu').innerText = data.cpuUsage + ' %';
            document.getElementById('barCpu').style.width = data.cpuUsage + '%';
            
            document.getElementById('valDisk').innerText = data.diskUsage + ' %';
            document.getElementById('barDisk').style.width = data.diskUsage + '%';
            
            document.getElementById('valSessions').innerText = data.activeSessions;
        })
        .catch(err => console.error("Failed to load system health", err));
}

function loadActivityLog() {
    const container = document.getElementById('activityTimelineBox');
    if (!container) return;
    
    // indicator pulse
    const indicator = document.getElementById('logLiveIndicator');
    if (indicator) {
        indicator.style.opacity = '0.3';
        setTimeout(() => indicator.style.opacity = '1', 300);
    }

    const search = document.getElementById('searchFilter') ? document.getElementById('searchFilter').value : '';
    const module = document.getElementById('logModuleFilter') ? document.getElementById('logModuleFilter').value : '';
    const type = document.getElementById('logTypeFilter') ? document.getElementById('logTypeFilter').value : '';
    
    const params = new URLSearchParams();
    if (search) params.append("search", search);
    if (module) params.append("module", module);
    if (type) params.append("type", type);

    fetch(CONTEXT_PATH + '/admin/api/logs?' + params.toString())
        .then(response => response.json())
        .then(logs => {
            renderLogs(logs);
        })
        .catch(err => {
            console.error('Failed to load logs', err);
            container.innerHTML = '<div style="padding:40px; text-align:center; color:#ef4444;">Unable to load logs</div>';
        });
}

function renderLogs(logs) {
    const container = document.getElementById('activityTimelineBox');
    if (!container) return;

    if (!logs || logs.length === 0) {
        container.innerHTML = '<div style="padding:40px; text-align:center; color:var(--text-muted);">No activity logs found.</div>';
        return;
    }

    container.innerHTML = logs.map(log => {
        const time = new Date(log.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
        const date = new Date(log.createdAt).toLocaleDateString();
        const action = log.action ? log.action.toUpperCase() : 'UNKNOWN';
        const colorClass = getLogColorClass(action);
        const icon = getLogIcon(action);

        return `
            <div style="padding: 16px 20px; border-bottom: 1px solid var(--color-border); display: flex; align-items: start; gap: 16px; animation: fadeIn 0.4s ease-out;">
                <div style="padding: 8px; border-radius: 8px; background: ${colorClass.bg}; color: ${colorClass.text};">
                    ${icon}
                </div>
                <div style="flex: 1;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                        <span style="font-weight: 600; font-size: 0.9rem;">Admin ID: ${log.adminId || 'System'} <span style="font-size:0.8rem; color:var(--text-muted); font-weight:normal;">(${log.ipAddress})</span></span>
                        <span style="font-size: 0.75rem; color: var(--text-muted);">${date} ${time}</span>
                    </div>
                    <div style="font-size: 0.85rem; color: var(--text-main);">${log.details || ''}</div>
                    <div style="margin-top: 8px; display: flex; gap: 8px;">
                        <span style="font-size: 0.7rem; padding: 2px 8px; border-radius: 10px; background: rgba(255,255,255,0.05); color: var(--text-muted); border: 1px solid var(--color-border);">
                            ${log.module || 'SYSTEM'}
                        </span>
                        <span style="font-size: 0.7rem; padding: 2px 8px; border-radius: 10px; background: ${colorClass.bg}; color: ${colorClass.text}; border: 1px solid ${colorClass.bg};">
                            ${action}
                        </span>
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

function getLogColorClass(action) {
    switch (action) {
        case 'DELETE': return { bg: 'rgba(239, 68, 68, 0.1)', text: '#ef4444' };
        case 'UPDATE': return { bg: 'rgba(245, 158, 11, 0.1)', text: '#f59e0b' };
        case 'LOGIN': return { bg: 'rgba(59, 130, 246, 0.1)', text: '#3b82f6' };
        case 'ADD': return { bg: 'rgba(16, 185, 129, 0.1)', text: '#10b981' };
        default: return { bg: 'rgba(107, 114, 128, 0.1)', text: '#9ca3af' };
    }
}

function getLogIcon(action) {
    if (action === 'DELETE') return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>';
    if (action === 'UPDATE') return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>';
    if (action === 'LOGIN') return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>';
    return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>';
}

function clearLogs() {
    if (typeof advancedConfirm === 'function') {
        advancedConfirm('Are you sure you want to clear all system logs?', () => {
            performClearLogs();
        });
    } else if (confirm('Are you sure you want to clear all system logs?')) {
        performClearLogs();
    }
}

function performClearLogs() {
    fetch(CONTEXT_PATH + '/admin/api/logs?action=clear', { method: 'POST' })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                if (typeof showToast === 'function') showToast('All logs cleared successfully.', 'success');
                else alert('All logs cleared successfully.');
                loadActivityLog();
            } else {
                if (typeof showToast === 'function') showToast('Failed to clear logs.', 'error');
                else alert('Failed to clear logs.');
            }
        });
}

function exportLogsCSV() {
    window.location.href = CONTEXT_PATH + '/admin/logs?action=export_csv';
}
