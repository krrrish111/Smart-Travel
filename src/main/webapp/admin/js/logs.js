/* =========================================================
   SYSTEM LOGGING & MONITORING MODULE
========================================================= */

function loadActivityLog() {
    const container = document.getElementById('activityTimelineBox');
    if (!container) return;

    fetch(CONTEXT_PATH + '/admin/logs')
        .then(response => response.json())
        .then(logs => {
            renderLogs(logs);
        })
        .catch(err => {
            console.warn('Backend logs not available, using mock logs.');
            renderLogs(getMockLogs());
        });
}

function renderLogs(logs) {
    const container = document.getElementById('activityTimelineBox');
    if (!container) return;

    if (!logs || logs.length === 0) {
        container.innerHTML = '<div style="padding:40px; text-align:center; color:var(--text-muted);">No activity logs found.</div>';
        return;
    }

    const filter = document.getElementById('logLevelFilter') ? document.getElementById('logLevelFilter').value : 'all';

    container.innerHTML = logs
        .filter(log => filter === 'all' || log.type.toLowerCase() === filter)
        .map(log => {
            const time = new Date(log.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            const date = new Date(log.timestamp).toLocaleDateString();
            const colorClass = getLogColorClass(log.type);
            const icon = getLogIcon(log.action);

            return `
                <div style="padding: 16px 20px; border-bottom: 1px solid var(--color-border); display: flex; align-items: start; gap: 16px; animation: fadeIn 0.4s ease-out;">
                    <div style="padding: 8px; border-radius: 8px; background: ${colorClass.bg}; color: ${colorClass.text};">
                        ${icon}
                    </div>
                    <div style="flex: 1;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                            <span style="font-weight: 600; font-size: 0.9rem;">${log.user || 'System'}</span>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">${date} ${time}</span>
                        </div>
                        <div style="font-size: 0.85rem; color: var(--text-main);">${log.details}</div>
                        <div style="margin-top: 8px; display: flex; gap: 8px;">
                            <span style="font-size: 0.7rem; padding: 2px 8px; border-radius: 10px; background: rgba(255,255,255,0.05); color: var(--text-muted); border: 1px solid var(--color-border);">
                                ${log.type.toUpperCase()}
                            </span>
                            <span style="font-size: 0.7rem; color: var(--text-muted);">ID: ${log.id}</span>
                        </div>
                    </div>
                </div>
            `;
        }).join('');
}

function getLogColorClass(type) {
    switch (type.toLowerCase()) {
        case 'error': return { bg: 'rgba(239, 68, 68, 0.1)', text: '#ef4444' };
        case 'warning': return { bg: 'rgba(245, 158, 11, 0.1)', text: '#f59e0b' };
        case 'info': return { bg: 'rgba(59, 130, 246, 0.1)', text: '#3b82f6' };
        default: return { bg: 'rgba(16, 185, 129, 0.1)', text: '#10b981' };
    }
}

function getLogIcon(action) {
    if (action.includes('delete')) return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>';
    if (action.includes('update') || action.includes('edit')) return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>';
    if (action.includes('login')) return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>';
    return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>';
}

function clearLogs() {
    advancedConfirm('Are you sure you want to clear all system logs?', () => {
        fetch(CONTEXT_PATH + '/admin/logs?action=clear', { method: 'POST' })
            .then(() => {
                showToast('All logs cleared successfully.', 'success');
                loadActivityLog();
            });
    });
}

function getMockLogs() {
    return [
        { id: 1045, user: 'Admin (Krrrish)', type: 'info', action: 'login', details: 'User logged in from IP 192.168.1.1', timestamp: new Date().getTime() },
        { id: 1044, user: 'System', type: 'warning', action: 'backup', details: 'Automated database backup completed with minor warnings.', timestamp: new Date().getTime() - 1000 * 60 * 45 },
        { id: 1043, user: 'Admin (Krrrish)', type: 'error', action: 'delete_user', details: 'Failed to delete user ID 405 (Integrity constraint violation).', timestamp: new Date().getTime() - 1000 * 60 * 120 },
        { id: 1042, user: 'System', type: 'info', action: 'update', details: 'Updated trip pricing for "Swiss Alps" plan (+5%).', timestamp: new Date().getTime() - 1000 * 60 * 300 }
    ];
}
