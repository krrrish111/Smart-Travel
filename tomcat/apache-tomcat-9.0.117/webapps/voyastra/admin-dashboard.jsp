<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Backend session and role validation
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("user_id") == null || !"admin".equals(adminSession.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=adminRequired");
        return;
    }
%>

<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

<style>
/* ADMIN LAYOUT Styles */
body {
    overflow-x: hidden;
}
.admin-layout-wrapper {
    display: flex;
    min-height: 100vh;
    padding-top: 0 !important; /* Standalone layout */
    background: var(--bg-base);
    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
}

/* Hide Redundant Global Navbar & Breadcrumbs for Standalone Admin Feel */
.navbar, .nav-overlay { display: none !important; }
main > .container.relative.z-20 { display: none !important; } 
h1, h2, h3, h4, h5 { font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; letter-spacing: -0.02em; }

.admin-sidebar {
    width: 260px;
    background: var(--surface-glass);
    border-right: 1px solid var(--color-border);
    padding: 0 0 20px 0;
    display: flex;
    flex-direction: column;
    position: sticky;
    top: 0 !important;
    height: 100vh !important;
    z-index: 100;
    transition: transform 0.3s ease;
}

.admin-nav-item {
    padding: 14px 24px;
    display: flex;
    align-items: center;
    gap: 12px;
    color: var(--text-muted);
    font-weight: 600;
    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
    cursor: pointer;
    transition: all 0.2s;
    border-left: 4px solid transparent;
}
.admin-nav-item:hover {
    background: rgba(0,0,0,0.02);
    color: var(--text-main);
}
[data-theme="dark"] .admin-nav-item:hover { background: rgba(255,255,255,0.02); }
.admin-nav-item.active {
    background: linear-gradient(90deg, rgba(79, 70, 229, 0.08) 0%, transparent 100%);
    color: var(--color-primary);
    border-left-color: var(--color-primary);
    text-shadow: 0 0 1px rgba(79, 70, 229, 0.2);
}

.admin-content {
    flex: 1;
    padding: 30px 40px;
    overflow-y: auto;
}

.admin-section {
    display: none;
    animation: fadeUp 0.4s ease forwards;
}
.admin-section.active {
    display: block;
}

/* OVERVIEW CARDS */
.stat-card {
    background: var(--surface-light);
    border: 1px solid var(--color-border);
    border-radius: 12px;
    padding: 24px;
    box-shadow: var(--shadow-sm);
    display: flex;
    flex-direction: column;
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.stat-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 30px rgba(0,0,0,0.06);
}
.stat-value {
    font-size: 2rem;
    font-weight: 800;
    color: var(--text-main);
}
.stat-label {
    font-size: 0.85rem;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.05em;
    font-weight: 700;
}

/* ACTIVITY TIMELINE STYLES */
.activity-timeline {
    position: relative;
    padding-left: 32px;
}
.activity-timeline::before {
    content: '';
    position: absolute;
    left: 7px;
    top: 5px;
    bottom: 5px;
    width: 2px;
    background: var(--color-border);
}
.activity-item {
    position: relative;
    margin-bottom: 24px;
}
.activity-dot {
    position: absolute;
    left: -32px;
    top: 5px;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    background: var(--color-primary);
    border: 3px solid var(--surface-light);
    box-shadow: 0 0 0 2px var(--color-border);
    z-index: 2;
}
.activity-content {
    background: rgba(0,0,0,0.01);
    border: 1px solid var(--color-border);
    border-radius: 12px;
    padding: 16px;
    transition: 0.2s;
}
[data-theme="dark"] .activity-content { background: rgba(255,255,255,0.01); }
.activity-content:hover {
    border-color: var(--color-primary);
    transform: translateX(4px);
}
.activity-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 8px;
}
.activity-badge {
    font-size: 0.7rem;
    font-weight: 800;
    padding: 2px 8px;
    border-radius: 4px;
    text-transform: uppercase;
}
.activity-time {
    font-size: 0.75rem;
    color: var(--text-muted);
}
.activity-msg {
    font-size: 0.9rem;
    color: var(--text-main);
    line-height: 1.5;
}
.activity-admin {
    font-weight: 600;
    color: var(--color-primary);
}

/* RECENT ACTIVITY LIST (Overview) */
.recent-log-row {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 16px 24px;
    border-bottom: 1px solid var(--color-border);
    transition: 0.2s;
}
.recent-log-row:last-child { border-bottom: none; }
.recent-log-row:hover { background: rgba(0,0,0,0.02); }
[data-theme="dark"] .recent-log-row:hover { background: rgba(255,255,255,0.02); }
.recent-log-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    flex-shrink: 0;
}
.recent-log-info { flex: 1; }
.recent-log-title { font-size: 0.9rem; font-weight: 600; }
.recent-log-sub { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; }


/* TABLE STYLES */
.admin-table-container {
    background: var(--surface-light);
    border: 1px solid var(--color-border);
    border-radius: 12px;
    overflow-x: auto;
    margin-top: 24px;
}
.admin-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
}
.admin-table th {
    background: var(--surface-glass);
    padding: 16px 20px;
    font-size: 0.85rem;
    color: var(--text-muted);
    text-transform: uppercase;
    font-weight: 700;
    border-bottom: 2px solid var(--color-border);
}
.admin-table td {
    padding: 16px 20px;
    border-bottom: 1px solid var(--color-border);
    color: var(--text-main);
    font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
    font-size: 0.95rem;
}
.admin-table tr:hover {
    background: rgba(0,0,0,0.02);
}
[data-theme="dark"] .admin-table tr:hover {
    background: rgba(255,255,255,0.02);
}
.action-btn {
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 0.8rem;
    font-weight: 600;
    cursor: pointer;
    border: none;
    transition: all 0.25s ease-out;
    margin-right: 8px;
}
.action-btn:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
.btn-edit { background: rgba(59, 130, 246, 0.08); color: #3b82f6; border: 1px solid rgba(59, 130, 246, 0.15); }
.btn-edit:hover { background: #3b82f6; color: white; border-color: #3b82f6; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2); }
.btn-delete { background: rgba(239, 68, 68, 0.08); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.15); }
.btn-delete:hover { background: #ef4444; color: white; border-color: #ef4444; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2); }

/* MODAL STYLES */
.admin-modal-overlay {
    position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
    background: rgba(0,0,0,0.5); backdrop-filter: blur(8px);
    z-index: 2000; display: none; align-items: center; justify-content: center;
    opacity: 0; transition: opacity 0.3s;
}
.admin-modal-overlay.active { display: flex; opacity: 1; }
.admin-modal {
    background: var(--surface-light);
    border: 1px solid var(--color-border);
    border-radius: 16px;
    width: 95%; 
    max-width: 500px;
    
    /* ABSOLUTE CONSTRAINTS */
    max-height: 90vh !important; 
    height: auto;
    
    display: flex;
    flex-direction: column;
    
    box-shadow: 0 20px 50px rgba(0,0,0,0.3);
    position: relative;
    transform: translateY(20px); transition: transform 0.3s;
    overflow: hidden !important; 
    box-sizing: border-box;
}
.admin-modal-overlay.active .admin-modal { transform: translateY(0); }

.admin-modal-header {
    padding: 24px 30px;
    border-bottom: 1px solid var(--color-border);
    background: var(--surface-light);
    z-index: 10;
    box-sizing: border-box;
}
.admin-modal-body {
    padding: 24px 30px; 
    overflow-y: auto !important; 
    min-height: 0;
    box-sizing: border-box;
    flex: 1; /* Expand to fill space */
}
.admin-modal-footer {
    padding: 20px 30px;
    border-top: 1px solid var(--color-border);
    background: var(--surface-light); /* Ensure opaque background for stickiness */
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    z-index: 20;
    box-sizing: border-box;
    position: sticky;
    bottom: 0;
    flex-shrink: 0;
}
#destForm, #activityForm, #contentForm {
    display: flex;
    flex-direction: column;
    height: 100%;
    margin: 0;
}
/* Ensure preview image is never too tall */
.image-preview-box {
    margin-top: 12px;
    width: 100%;
    max-height: 150px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid var(--color-border);
    display: none;
}

/* AUTH DENIED SCREEN */
.access-denied-screen {
    position: fixed; z-index: 10000; top: 0; left: 0; width: 100vw; height: 100vh;
    background: var(--bg-base); display: flex; align-items: center; justify-content: center;
    flex-direction: column; text-align: center; display: none;
}
.access-denied-screen h2 { color: #ef4444; font-size: 2rem; margin-bottom: 12px; }
.access-denied-screen p { color: var(--text-muted); margin-bottom: 24px; font-size: 1.1rem; }

/* TOOLBARS & SEARCH */
.admin-toolbar {
    display: flex; gap: 12px; margin-bottom: 24px; padding: 12px;
    background: var(--surface-light); border: 1px solid var(--color-border); border-radius: 12px;
    align-items: center; flex-wrap: wrap;
}
.search-wrapper { position: relative; flex: 1; min-width: 200px; }
.search-wrapper svg { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
.search-wrapper input { width: 100%; padding: 10px 10px 10px 38px; border: 1px solid var(--color-border); border-radius: 8px; background: var(--bg-base); color: var(--text-main); font-size: 0.9rem; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.search-wrapper input:focus { border-color: var(--color-primary); box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.15) !important; outline: none; }
.filter-select { padding: 10px; border: 1px solid var(--color-border); border-radius: 8px; background: var(--bg-base); color: var(--text-main); font-size: 0.9rem; outline: none; cursor: pointer; transition: all 0.2s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.filter-select:focus { border-color: var(--color-primary); box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.15); }

/* INLINE EDITING */
.editable-cell { cursor: text; padding: 4px; border-radius: 4px; border: 1px solid transparent; transition: all 0.2s; position: relative; }
.editable-cell:hover { background: rgba(0,0,0,0.03); border-color: rgba(0,0,0,0.1); }
[data-theme="dark"] .editable-cell:hover { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.1); }
.editable-input { width: 100%; padding: 4px; border: 1px solid var(--color-primary); border-radius: 4px; background: var(--bg-base); color: var(--text-main); font-size: inherit; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; font-weight: inherit; outline: none; box-shadow: 0 0 0 2px rgba(79,70,229,0.2); }

/* BULK ACTIONS BAR */
.bulk-action-bar {
    position: fixed; bottom: -80px; left: 50%; transform: translateX(-50%);
    background: var(--surface-light); border: 1px solid var(--color-border); box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    border-radius: 12px; padding: 12px 24px; display: flex; align-items: center; gap: 20px; z-index: 1000;
    transition: bottom 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.bulk-action-bar.visible { bottom: 30px; }
.bulk-count { font-weight: 700; color: var(--color-primary); }
.checkbox-custom { width: 18px; height: 18px; cursor: pointer; accent-color: var(--color-primary); margin: 0; padding: 0; vertical-align: middle; }

/* MOBILE SIDEBAR OVERLAY */
.admin-sidebar-overlay { display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); z-index: 1040; opacity: 0; transition: opacity 0.3s; backdrop-filter: blur(4px); }
.admin-sidebar-overlay.active { display: block; opacity: 1; }

/* RESPONSIVENESS */
@media(max-width: 768px) {
    .admin-layout-wrapper { flex-direction: column; overflow-x: hidden; width: 100%; }
    .admin-sidebar { position: fixed; left: -280px; top: 0 !important; width: 260px; height: 100vh !important; z-index: 1050; transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1); padding: 20px 0; flex-direction: column; box-shadow: 10px 0 30px rgba(0,0,0,0.2); }
    .admin-sidebar.open { left: 0; }
    .admin-nav-item { border-left: 4px solid transparent; justify-content: flex-start; }
    .mobile-menu-toggle { display: flex !important; }
    .admin-topbar { flex-wrap: wrap; gap: 16px; padding-bottom: 15px; }
    .admin-topbar-search { width: 100% !important; order: 3; margin-top: 8px; }
    .admin-content { padding: 16px; width: 100%; max-width: 100vw; }
    
    .admin-table-container { overflow-x: auto; -webkit-overflow-scrolling: touch; border-radius: 8px; }
    .admin-table th, .admin-table td { white-space: nowrap; padding: 12px 16px; }
}
/* ADMIN TOPBAR & EXTRAS */
.admin-topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid var(--color-border); }
.admin-topbar-search { position: relative; width: 280px; max-width: 100%; }
.admin-topbar-search input { width: 100%; padding: 10px 16px 10px 42px; border: 1px solid var(--color-border); border-radius: 30px; background: var(--surface-light); color: var(--text-main); transition: box-shadow 0.3s ease, border-color 0.3s ease; outline:none; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; }
.admin-topbar-search input:focus { border-color: var(--color-primary); box-shadow: 0 4px 12px rgba(79,70,229,0.15); }
.admin-topbar-search svg { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); pointer-events: none; }
.admin-profile { display: flex; align-items: center; gap: 12px; }
.admin-avatar { width: 40px; height: 40px; border-radius: 50%; background: var(--color-primary); color: white; display:flex; align-items:center; justify-content:center; font-weight:700; }

/* DRAG & DROP */
.draggable-card { cursor: grab; transition: transform 0.2s, box-shadow 0.2s; border: 2px solid transparent; }
.draggable-card.dragging { opacity: 0.5; border: 2px dashed var(--color-primary); cursor: grabbing; transform: scale(1.02); }
.drag-over { border: 2px dashed var(--color-primary) !important; padding-bottom: 20px; }

/* ACTIVITY LOG */
.activity-timeline { position: relative; padding-left: 20px; }
.activity-timeline::before { content: ''; position: absolute; left: 0; top: 5px; height: 100%; width: 2px; background: var(--color-border); }
.activity-item { position: relative; margin-bottom: 20px; padding-left: 20px; }
.activity-item::before { content: ''; position: absolute; left: -25px; top: 5px; width: 12px; height: 12px; border-radius: 50%; background: var(--color-primary); border: 2px solid var(--bg-base); }

/* EMPTY STATE */
.empty-state { text-align: center; padding: 60px 20px; color: var(--text-muted); }
.empty-state svg { width: 48px; height: 48px; color: var(--color-border); margin-bottom: 16px; }

/* OVERLAYS & AUTOCOMPLETE */
.search-results-dropdown { position:absolute; top:110%; left:0; width:100%; background:var(--surface-light); border:1px solid var(--color-border); border-radius:12px; box-shadow:0 10px 30px rgba(0,0,0,0.1); display:none; z-index:100; max-height: 400px; overflow-y:auto; }
.search-results-dropdown.active { display:block; }
.search-result-item { padding: 12px 16px; border-bottom: 1px solid var(--color-border); cursor:pointer; }
.search-result-item:hover { background: rgba(0,0,0,0.02); }
[data-theme="dark"] .search-result-item:hover { background: rgba(255,255,255,0.02); }
</style>

<!-- AUTHENTICATION WRAPPER -->
<div id="adminAccessDenied" class="access-denied-screen">
    <h2>Access Denied</h2>
    <p>You must be an authorized administrator to view this page.</p>
    <a href="index.jsp" class="btn btn-primary">Return to Home</a>
</div>

<div class="admin-sidebar-overlay" id="adminSidebarOverlay" onclick="toggleAdminSidebar()"></div>
<div class="admin-layout-wrapper" id="adminDashboardLayout" style="display:none;">
    
    <!-- SIDEBAR -->
    <aside class="admin-sidebar" id="adminSidebar">
        <!-- Voyastra Branding -->
        <div style="padding: 24px 24px 20px; border-bottom: 1px solid var(--color-border); margin-bottom: 16px; display:flex; align-items:center; gap:10px;">
            <svg class="voyastra-icon" width="28" height="28" viewBox="0 -1 26 26" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--color-primary);">
                <path d="M 22 2 L 15 22 L 11 13 L 2 9 L 22 2 L 11 13" />
                <path d="M -4 -3 L 5 0 L -4 3 L -2 0 Z" fill="#06b6d4" stroke="none" />
            </svg>
            <span style="font-size:1.4rem; font-weight:800; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; letter-spacing:-0.03em; color:var(--text-main);">Voyastra</span>
        </div>

        <div class="admin-nav-item active" data-target="dashboard">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
        </div>
        <div class="admin-nav-item" data-target="manageUsers">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            Manage Users
        </div>
        <div class="admin-nav-item" data-target="managePlans">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
            Manage Plans
        </div>
        <div class="admin-nav-item" data-target="manageDestinations">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            Destinations
        </div>
        <div class="admin-nav-item" data-target="manageReviews">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
            Reviews
        </div>
        <div class="admin-nav-item" data-target="manageCommunity">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            Community
        </div>
        <div class="admin-nav-item" data-target="manageContent">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="9" y1="21" x2="9" y2="9"/></svg>
            Content
        </div>
        <div class="admin-nav-item" data-target="manageActivities">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 2v20M2 12h20M12 2l5 5M12 2L7 7M12 22l5-5M12 22l-5-5"/></svg>
            Activities
        </div>
        <div class="admin-nav-item" data-target="manageActivity">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
            Activity Log
        </div>
        <div class="admin-nav-item" data-target="adminSettings">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
            Settings
        </div>
    </aside>

    <!-- CONTENT AREA -->
    <main class="admin-content">
        
        <!-- ADMIN TOPBAR -->
        <div class="admin-topbar">
            <!-- Mobile Menu Toggle Button -->
            <button class="mobile-menu-toggle" onclick="toggleAdminSidebar()" style="display:none; align-items:center; justify-content:center; background:var(--surface-light); border:1px solid var(--color-border); color:var(--text-main); border-radius:8px; cursor:pointer; width:40px; height:40px; transition:0.2s;" aria-label="Open Mobile Menu">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            <div class="admin-topbar-search">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="text" id="globalAdminSearch" placeholder="Quick search..." autocomplete="off">
                <div class="search-results-dropdown" id="globalSearchResults"></div>
            </div>
            <div class="admin-profile">
                <button class="theme-toggle" onclick="document.getElementById('themeToggle').click()" 
                        style="background:var(--surface-light); border:1px solid var(--color-border); color:var(--text-muted); cursor:pointer; margin-right:8px; width:40px; height:40px; border-radius:50%; display:flex; align-items:center; justify-content:center; transition:0.2s;"
                        onmouseover="this.style.background='rgba(79,70,229,0.1)';this.style.color='var(--color-primary)';"
                        onmouseout="this.style.background='var(--surface-light)';this.style.color='var(--text-muted)';">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
                </button>
                <div style="text-align:right;">
                    <div style="font-weight:600; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">Systems Admin</div>
                    <div style="font-size:0.75rem; color:var(--text-muted);">Master Access</div>
                </div>
                <div class="admin-avatar" style="box-shadow: 0 4px 12px rgba(79,70,229,0.2);">SA</div>
            </div>
        </div>

        <!-- Overview Section -->
        <section id="dashboard" class="admin-section active">
            <h2>Dashboard Overview</h2>
            <p class="text-muted" style="margin-bottom: 24px;">Welcome back, Admin. Here's what's happening today.</p>
            
            <div class="grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 24px;">
                
                <!-- Total Users -->
                <div class="stat-card" style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
                    <div>
                        <div class="stat-label">Total Users</div>
                        <div class="stat-value" id="statUsers" style="margin-top: 4px;">0</div>
                    </div>
                    <div style="width: 48px; height: 48px; background: rgba(16,185,129,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #10b981;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                </div>

                <!-- Total Bookings -->
                <div class="stat-card" style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
                    <div>
                        <div class="stat-label">Total Bookings</div>
                        <div class="stat-value" id="statBookings" style="margin-top: 4px;">0</div>
                    </div>
                    <div style="width: 48px; height: 48px; background: rgba(59, 130, 246, 0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #3b82f6;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    </div>
                </div>

                <!-- Total Revenue -->
                <div class="stat-card" style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
                    <div>
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value" id="statRevenue" style="margin-top: 4px;">$0</div>
                    </div>
                    <div style="width: 48px; height: 48px; background: rgba(251,191,36,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #fbbf24;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    </div>
                </div>

                <!-- Total Plans -->
                <div class="stat-card" style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
                    <div>
                        <div class="stat-label">Total Plans</div>
                        <div class="stat-value" id="statPlans" style="margin-top: 4px;">0</div>
                    </div>
                    <div style="width: 48px; height: 48px; background: rgba(79,70,229,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #4f46e5;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                    </div>
                </div>

                <!-- Destinations -->
                <div class="stat-card" style="display: flex; flex-direction: row; align-items: center; justify-content: space-between;">
                    <div>
                        <div class="stat-label">Destinations</div>
                        <div class="stat-value" id="statDests" style="margin-top: 4px;">0</div>
                    </div>
                    <div style="width: 48px; height: 48px; background: rgba(6,182,212,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #06b6d4;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    </div>
                </div>

            </div>
            
            <!-- Dashboard Analytics -->
            <div style="margin-top: 32px;">
                <h3 style="margin-bottom: 20px; font-size: 1rem; color: var(--text-muted); text-transform:uppercase; letter-spacing:0.05em;">Platform Analytics</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">

                    <div class="stat-card">
                        <div style="font-weight: 600; margin-bottom: 16px;">Destination Popularity</div>
                        <div id="destBarChart" style="display: flex; flex-direction: column; gap: 10px;"></div>
                    </div>

                    <div class="stat-card">
                        <div style="font-weight: 600; margin-bottom: 16px;">Review Activity</div>
                        <div style="display: flex; flex-direction: column; gap: 10px;">
                            <div>
                                <div style="display:flex; justify-content:space-between; margin-bottom:6px; font-size:0.85rem;"><span>Approved</span><span id="approvedPct">-</span></div>
                                <div style="background:var(--color-border); border-radius:8px; overflow:hidden; height:10px;"><div id="approvedBar" style="height:10px; background: #10b981; border-radius:8px; transition: width 0.6s ease;"></div></div>
                            </div>
                            <div>
                                <div style="display:flex; justify-content:space-between; margin-bottom:6px; font-size:0.85rem;"><span>Pending</span><span id="pendingPct">-</span></div>
                                <div style="background:var(--color-border); border-radius:8px; overflow:hidden; height:10px;"><div id="pendingBar" style="height:10px; background: #fbbf24; border-radius:8px; transition: width 0.6s ease;"></div></div>
                            </div>
                            <div style="margin-top:4px;">
                                <div style="display:flex; justify-content:space-between; margin-bottom:6px; font-size:0.85rem;"><span>Active Users (UI)</span><span style="color:#4f46e5; font-weight:600;">2,854</span></div>
                                <div style="background:var(--color-border); border-radius:8px; overflow:hidden; height:10px;"><div style="width:72%; height:10px; background: #4f46e5; border-radius:8px;"></div></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- Manage Plans Section -->
        <section id="managePlans" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <h2>Manage Plans</h2>
                <button class="btn btn-primary" onclick="openPlanModal()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    Add New Plan
                </button>
            </div>
            
            <div class="admin-toolbar">
                <div class="search-wrapper">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input type="search" id="searchPlans" placeholder="Search plans by title or location..." onkeyup="loadPlans()">
                </div>
                <div style="display:flex; gap:12px;">
                    <select class="filter-select" id="filterPriceRange" onchange="loadPlans()">
                        <option value="">All Prices</option>
                        <option value="under1000">Under $1,000</option>
                        <option value="1000to2000">$1,000 - $2,000</option>
                        <option value="over2000">Over $2,000</option>
                    </select>
                    <select class="filter-select" id="sortPlans" onchange="loadPlans()">
                        <option value="newest">Newest First</option>
                        <option value="price_asc">Price: Low to High</option>
                        <option value="price_desc">Price: High to Low</option>
                    </select>
                </div>
            </div>
            
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th style="width:40px;"><input type="checkbox" class="checkbox-custom" onclick="toggleAllBulk('plans', this)"></th>
                            <th>Plan Name</th>
                            <th>Location</th>
                            <th>Days</th>
                            <th>Price</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="plansTableBody">
                        <!-- Rendered by JS -->
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Manage Destinations Section -->
        <section id="manageDestinations" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <h2>Manage Destinations</h2>
                <button class="btn btn-primary" onclick="openDestModal()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    Add Destination
                </button>
            </div>
            
            <div class="admin-toolbar">
                <div class="search-wrapper">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input type="search" id="searchDests" placeholder="Search destinations..." onkeyup="loadDests()">
                </div>
                <select class="filter-select" id="sortDests" onchange="loadDests()">
                    <option value="newest">Newest First</option>
                    <option value="az">A-Z Name</option>
                    <option value="za">Z-A Name</option>
                </select>
            </div>
            
            <div style="margin-bottom: 12px; display:flex; align-items:center; gap:8px;">
                <input type="checkbox" class="checkbox-custom" onclick="toggleAllBulk('dests', this)"> <span style="font-size:0.9rem; color:var(--text-muted)">Select All Destinations</span>
            </div>
            
            <div class="grid grid-cols-3 gap-4" id="destinationsGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 24px;">
                <!-- Rendered by JS -->
            </div>
        </section>

        <!-- Manage Reviews Section -->
        <section id="manageReviews" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <h2>Manage Reviews <span style="font-size:1rem; font-weight:500; color:var(--text-muted);"> (Moderation Queue)</span></h2>
            </div>
            
            <div class="admin-toolbar" style="margin-bottom: 24px;">
                <div class="search-wrapper">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input type="search" id="searchReviews" placeholder="Search reviews by user or location..." onkeyup="loadReviewsRenderer()">
                </div>
                <select class="filter-select" id="sortReviews" onchange="loadReviewsRenderer()">
                    <option value="newest">Newest First</option>
                    <option value="rating_high">Highest Rating</option>
                    <option value="rating_low">Lowest Rating</option>
                </select>
            </div>
            
            <div class="grid grid-cols-2 gap-4" id="reviewsGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 24px;">
                <!-- Rendered by JS -->
            </div>
        </section>

        <!-- ══════════════ Manage Community Posts Section ══════════════ -->
        <section id="manageCommunity" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <div>
                    <h2>Community Posts <span style="font-size:1rem; font-weight:500; color:var(--text-muted);"> (Moderation)</span></h2>
                    <p class="text-muted" style="margin-top: 4px; font-size: 0.875rem;">Review, moderate and remove user-generated content from the community feed.</p>
                </div>
                <button class="btn btn-outline" onclick="loadCommunityPosts()" style="display:flex;align-items:center;gap:8px;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg>
                    Refresh
                </button>
            </div>

            <!-- Stats Bar -->
            <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(160px,1fr)); gap:16px; margin-bottom:28px;">
                <div class="stat-card" style="padding:16px 20px;">
                    <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Total Posts</div>
                    <div id="communityStatTotal" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">—</div>
                </div>
                <div class="stat-card" style="padding:16px 20px;">
                    <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Visible</div>
                    <div id="communityStatVisible" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; color:#10b981;">—</div>
                </div>
                <div class="stat-card" style="padding:16px 20px;">
                    <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Hidden</div>
                    <div id="communityStatHidden" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; color:#f59e0b;">—</div>
                </div>
                <div class="stat-card" style="padding:16px 20px;">
                    <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Deleted Today</div>
                    <div id="communityStatDeleted" style="font-size:1.8rem; font-weight:700; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; color:#ef4444;">0</div>
                </div>
            </div>

            <!-- Toolbar -->
            <div class="admin-toolbar" style="margin-bottom:20px;">
                <div class="search-wrapper">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input type="search" id="searchCommunityPosts" placeholder="Search by user, content or location..." oninput="filterCommunityPosts()">
                </div>
                <select class="filter-select" id="filterCommunityStatus" onchange="filterCommunityPosts()">
                    <option value="all">All Posts</option>
                    <option value="visible">Visible Only</option>
                    <option value="hidden">Hidden Only</option>
                </select>
            </div>

            <!-- Loading state -->
            <div id="communityPostsLoading" style="text-align:center;padding:50px 20px;display:none;">
                <div style="width:36px;height:36px;border:3px solid var(--color-border);border-top-color:var(--color-primary);border-radius:50%;animation:spin 0.8s linear infinite;margin:0 auto 16px;"></div>
                <p style="color:var(--text-muted); font-size:0.9rem;">Loading community posts...</p>
            </div>

            <!-- Empty state -->
            <div id="communityPostsEmpty" style="text-align:center;padding:60px 20px;display:none;">
                <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5" style="margin-bottom:16px;"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                <h3 style="margin-bottom:8px; color:var(--text-muted);">No Community Posts Found</h3>
                <p style="color:var(--text-muted); font-size:0.875rem;">The community feed is empty. Posts will appear here once users start sharing.</p>
            </div>

            <!-- Posts table -->
            <div class="admin-table-container" id="communityPostsTableWrap">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Post Content</th>
                            <th>Image</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th style="text-align:right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="communityPostsTableBody">
                        <!-- Rendered by JS -->
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Manage Content Section -->
        <section id="manageContent" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <h2>Content Management <span style="font-size:1rem; font-weight:500; color:var(--text-muted);"> (Homepage Layout)</span></h2>
            </div>
            <div class="grid grid-cols-3 gap-4" id="contentGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 24px; margin-top: 24px;">
                <!-- Rendered by JS -->
            </div>
        </section>

        <!-- Manage Activities Section -->
        <section id="manageActivities" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <h2>Manage Activities</h2>
                <button class="btn btn-primary" onclick="openActivityModal()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    Add Activity
                </button>
            </div>
            
            <div class="admin-toolbar">
                <div class="search-wrapper">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input type="search" id="searchActivities" placeholder="Search activities..." onkeyup="loadActivities()">
                </div>
            </div>
            
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Activity Name</th>
                            <th>ID</th>
                            <th>Dest. ID</th>
                            <th>Price</th>
                            <th>Rating</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="activitiesTableBody">
                        <!-- Loaded by JS -->
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Manage Users Section -->
        <section id="manageUsers" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <h2>Registered Users</h2>
            </div>
            
            <div class="admin-toolbar">
                <div class="search-wrapper">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input type="search" id="searchUsers" placeholder="Search by name or email..." onkeyup="loadUsers()">
                </div>
            </div>
            
            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="usersTableBody">
                        <!-- Rendered by JS -->
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Activity Log Section -->
        <section id="manageActivity" class="admin-section">
            <div class="flex justify-between items-center" style="margin-bottom: 24px;">
                <h2>System Activity Log</h2>
                <form action="admin/logs" method="POST" style="margin:0;" onsubmit="return confirm('Permanently clear all system logs? This cannot be undone.')">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="btn btn-outline" style="color:#ef4444; border-color:rgba(239,68,68,0.2); background:rgba(239,68,68,0.05); display: flex; align-items: center; gap: 8px;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Clear All Logs
                    </button>
                </form>
            </div>
            
            <div class="stat-card">
                <div class="activity-timeline" id="activityTimelineBox" data-skeleton="list" data-skeleton-count="8">
                    <!-- Rendered by JS -->
                </div>
            </div>
        </section>

        <!-- Settings Section -->
        <section id="adminSettings" class="admin-section">
            <h2 style="margin-bottom: 8px;">Settings</h2>
            <p class="text-muted" style="margin-bottom: 28px;">Customize your admin panel preferences.</p>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px;">

                <div class="stat-card">
                    <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Appearance</div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <span style="font-size:0.9rem;">Dark Mode</span>
                        <label style="position: relative; display: inline-block; width: 44px; height: 24px;">
                            <input type="checkbox" id="settingsTheme" style="opacity:0; width:0; height:0;" onchange="applySettingsTheme(this.checked)">
                            <span style="position:absolute; cursor:pointer; top:0; left:0; right:0; bottom:0; background:#ccc; border-radius:24px; transition:.3s;" id="themeSlider"></span>
                        </label>
                    </div>
                    <p style="font-size:0.8rem; color:var(--text-muted);">Toggle between dark and light interface mode.</p>
                </div>

                <div class="stat-card">
                    <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Currency</div>
                    <select class="filter-select" id="settingsCurrency" style="width:100%; margin-bottom:12px; border: 1px solid var(--color-border); border-radius: 8px;" onchange="showToast('Currency updated to ' + this.options[this.selectedIndex].text, 'success')">
                        <option value="USD">USD — US Dollar ($)</option>
                        <option value="EUR">EUR — Euro (€)</option>
                        <option value="GBP">GBP — British Pound (£)</option>
                        <option value="INR">INR — Indian Rupee (₹)</option>
                        <option value="AUD">AUD — Australian Dollar (A$)</option>
                    </select>
                    <p style="font-size:0.8rem; color:var(--text-muted);">Sets the default currency displayed across the platform.</p>
                </div>

                <div class="stat-card">
                    <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Language</div>
                    <select class="filter-select" id="settingsLanguage" style="width:100%; margin-bottom:12px; border: 1px solid var(--color-border); border-radius: 8px;" onchange="showToast('Language set to ' + this.options[this.selectedIndex].text, 'success')">
                        <option value="en">English</option>
                        <option value="es">Español</option>
                        <option value="fr">Français</option>
                        <option value="de">Deutsch</option>
                        <option value="hi">Hindi</option>
                        <option value="ja">日本語</option>
                    </select>
                    <p style="font-size:0.8rem; color:var(--text-muted);">Language preference for the admin interface.</p>
                </div>

                <div class="stat-card">
                    <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Data Management</div>
                    <button class="btn btn-outline" style="width:100%; margin-bottom: 12px; border-color:#ef4444; color:#ef4444;" onclick="advancedConfirm('Reset ALL admin data to factory defaults? This cannot be undone.', resetAllData)">Reset All Data</button>
                    <p style="font-size:0.8rem; color:var(--text-muted);">Clears all localStorage data and restores initial mock data.</p>
                </div>

            </div>
        </section>
    </main>
</div>

<!-- Add/Edit Plan Modal -->
<div class="admin-modal-overlay" id="planModal">
    <div class="admin-modal">
        <h3 id="modalTitle" style="margin-bottom: 20px;">Add New Plan</h3>
        <form id="planForm">
            <input type="hidden" id="planId">
            <div class="form-group">
                <label class="form-label">Plan Title</label>
                <input type="text" class="form-control" id="planTitle" required placeholder="e.g. Majestic Alps Retreat">
            </div>
            <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                <div>
                    <label class="form-label">Location</label>
                    <input type="text" class="form-control" id="planLocation" required placeholder="e.g. Switzerland">
                </div>
                <div>
                    <label class="form-label">Duration</label>
                    <input type="text" class="form-control" id="planDuration" required placeholder="e.g. 7 Days">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Price</label>
                <input type="text" class="form-control" id="planPrice" required placeholder="e.g. $1,499">
            </div>
            <div class="form-group">
                <label class="form-label">Description / Highlight tags</label>
                <input type="text" class="form-control" id="planDesc" required placeholder="e.g. Mountains, Skiing, Luxury">
            </div>
            
            <div class="flex justify-end" style="gap: 12px; margin-top: 30px;">
                <button type="button" class="btn btn-outline" onclick="closePlanModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Plan</button>
            </div>
        </form>
    </div>
</div>

<!-- Add/Edit Destination Modal -->
<!-- Add/Edit Destination Modal -->
<div class="admin-modal-overlay" id="destModal">
    <div class="admin-modal">
        <form id="destForm" action="${pageContext.request.contextPath}/destinations" method="POST" enctype="multipart/form-data">
            <div class="admin-modal-header">
                <h3 id="destModalTitle" style="margin: 0;">Add Destination</h3>
            </div>
            
            <div class="admin-modal-body">
                <input type="hidden" id="destId" name="id">
                <input type="hidden" id="destAction" name="action" value="add">
                <div class="form-group">
                    <label class="form-label" for="destName">Destination Name</label>
                    <input type="text" class="form-control" id="destName" name="name" required placeholder="e.g. Santorini">
                </div>
                <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                    <div>
                        <label class="form-label" for="destLocation">Location (State, Country)</label>
                        <input type="text" class="form-control" id="destLocation" name="location" required placeholder="e.g. Cyclades, Greece">
                    </div>
                    <div>
                        <label class="form-label" for="destCategory">Category</label>
                        <select class="form-control" id="destCategory" name="category" required style="padding-right:32px;">
                            <option value="Beach & Island">Beach & Island</option>
                            <option value="Mountain Retreat">Mountain Retreat</option>
                            <option value="City Escape">City Escape</option>
                            <option value="Heritage & Culture">Heritage & Culture</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Destination Image</label>
                    <div style="border:2px dashed var(--color-border); border-radius:8px; padding:20px; text-align:center; position:relative; overflow:hidden; background:var(--surface-light); transition:border-color 0.2s;" id="destImageUploadBox">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" style="color:var(--text-muted); margin-bottom:8px; display:inline-block;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                        <div style="font-size:0.9rem; color:var(--text-muted); margin-bottom:8px;">Upload image or paste URL below</div>
                        <input type="text" class="form-control" id="destImage" name="image" placeholder="Paste an image URL..." style="position:relative; z-index:10; margin-bottom: 10px;" autocomplete="off" oninput="previewImg('destImage','destImagePreview')">
                        <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:5px;">— OR —</div>
                        <input type="file" id="destImageFile" name="destImageFile" accept="image/*" class="form-control" style="font-size: 0.8rem;">
                    </div>
                    <img id="destImagePreview" class="image-preview-box" src="" alt="Preview">
                </div>

                <div class="form-group" style="padding-bottom: 20px;">
                    <label class="form-label" for="destDesc">Description</label>
                    <textarea class="form-control" id="destDesc" name="desc" required placeholder="A beautiful island in Greece..." rows="4" style="resize: vertical;"></textarea>
                </div>
            </div>
            
            <div class="admin-modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeDestModal()">Cancel</button>
                <button type="submit" class="btn btn-primary" id="saveDestBtn">Save Destination</button>
            </div>
        </form>
    </div>
</div>

<!-- Add/Edit Activity Modal -->
<div class="admin-modal-overlay" id="activityModal">
    <div class="admin-modal">
        <h3 id="activityModalTitle" style="margin-bottom: 20px;">Add Activity</h3>
        <form id="activityForm">
            <input type="hidden" id="activityId" name="id">
            <input type="hidden" id="activityAction" name="action" value="add">
            
            <div class="form-group">
                <label class="form-label">Activity Name</label>
                <input type="text" class="form-control" id="activityName" name="name" required placeholder="e.g. Scuba Diving">
            </div>
            
            <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                <div>
                    <label class="form-label">Destination</label>
                    <select class="form-control" id="activityDestId" name="destination_id" required style="padding-right:32px;">
                        <!-- Populated by JS -->
                    </select>
                </div>
                <div>
                    <label class="form-label">Price</label>
                    <input type="number" step="0.01" class="form-control" id="activityPrice" name="price" required placeholder="1200">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Activity Image URL</label>
                <input type="text" class="form-control" id="activityImage" name="image_url" required placeholder="Paste an image URL..." oninput="previewImg('activityImage','activityImagePreview')">
                <img id="activityImagePreview" src="" alt="Preview" style="display:none; margin-top:10px; width:100%; height:120px; object-fit:cover; border-radius:8px; border:1px solid var(--color-border);">
            </div>
            
            <!-- These are usually hidden as they are updated by user reviews, but for admin edit we show them -->
            <div class="grid" id="activityExtraInfo" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; display:none;">
                <div>
                    <label class="form-label">Rating</label>
                    <input type="number" step="0.1" class="form-control" id="activityRating" name="rating" placeholder="4.5">
                </div>
                <div>
                    <label class="form-label">Reviews Count</label>
                    <input type="number" class="form-control" id="activityReviewsCount" name="reviews_count" placeholder="10">
                </div>
            </div>

            <div class="flex justify-end" style="gap: 12px; margin-top: 30px;">
                <button type="button" class="btn btn-outline" onclick="closeActivityModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Activity</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Content Modal -->
<div class="admin-modal-overlay" id="contentModal">
    <div class="admin-modal">
        <h3 style="margin-bottom: 20px;">Edit Content Card</h3>
        <form id="contentForm">
            <input type="hidden" id="contentId">
            <div class="form-group">
                <label class="form-label">Title / Name</label>
                <input type="text" class="form-control" id="contentTitle" required>
            </div>
            <div class="form-group">
                <label class="form-label">Image URL</label>
                <input type="text" class="form-control" id="contentImage" required oninput="previewImg('contentImage','contentImagePreview')">
                <img id="contentImagePreview" src="" alt="Preview" style="display:none; margin-top:10px; width:100%; height:100px; object-fit:cover; border-radius:8px; border:1px solid var(--color-border);">
            </div>
            <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                <div>
                    <label class="form-label">Price (Optional)</label>
                    <input type="text" class="form-control" id="contentPrice">
                </div>
                <div>
                    <label class="form-label">Section</label>
                    <select class="form-control" id="contentSection" required style="padding-right:32px;">
                        <option value="Trending Places">Trending Places</option>
                        <option value="Top Travel Plans">Top Travel Plans</option>
                        <option value="Featured Cards">Featured Cards</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Tags (Comma separated)</label>
                <input type="text" class="form-control" id="contentTags" required placeholder="e.g. Nature, Beach">
            </div>
            
            <div class="flex justify-end" style="gap: 12px; margin-top: 30px;">
                <button type="button" class="btn btn-outline" onclick="closeContentModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Content</button>
            </div>
        </form>
    </div>
</div>

<!-- Custom Confirm Modal -->
<div class="admin-modal-overlay" id="confirmModal">
    <div class="admin-modal" style="text-align: center; max-width: 400px; border-top: 4px solid #ef4444;">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" style="margin: 0 auto 16px auto;"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        <h3 id="confirmTitle" style="margin-bottom: 12px; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">Are you sure?</h3>
        <p id="confirmMessage" class="text-muted" style="margin-bottom: 24px;">This action cannot be undone.</p>
        <div class="flex justify-center" style="gap: 12px;">
            <button class="btn btn-outline" onclick="closeConfirmModal()">Cancel</button>
            <button class="btn btn-primary" id="confirmActionBtn" style="background: #ef4444; border-color: #ef4444;">Yes, Delete</button>
        </div>
    </div>
</div>

<!-- Bulk Action Bar -->
<div class="bulk-action-bar" id="bulkActionBar">
    <div class="bulk-count"><span id="bulkCountTxt">0</span> Selected</div>
    <select class="filter-select" id="bulkActionSelect" style="border: 1px solid var(--color-border);">
        <option value="">Choose action...</option>
        <option value="delete">Delete Selected</option>
    </select>
    <button class="btn btn-primary" onclick="executeBulkAction()">Execute</button>
</div>

<script>
const CONTEXT_PATH = '${pageContext.request.contextPath}';

// State Accessor Helpers
function getDests() { return activeDests; }
function getReviews() { return activeReviews; }
function getUsers() { return activeUsers; }
function getContent() { return activeContent || []; }


/* =========================================================
   AUTH & GUARD SCRIPT
========================================================= */
document.addEventListener('DOMContentLoaded', () => {
    // Primary check: use Java server-side session (most reliable)
    if (window.javaSession && window.javaSession.userId && window.javaSession.userId.length > 0) {
        if (window.javaSession.role === 'admin') {
            document.getElementById('adminAccessDenied').style.display = 'none';
            document.getElementById('adminDashboardLayout').style.display = 'flex';
            setTimeout(() => showToast('Welcome back, ' + (window.javaSession.name || 'Admin') + '.', 'success'), 800);
            initAdminDashboard();
        } else {
            document.getElementById('adminAccessDenied').style.display = 'flex';
        }
        return;
    }
    // Fallback: if no Java session found, redirect to login
    window.location.href = 'login?redirect=admin-dashboard.jsp';
});

/* =========================================================
   UI CORE: CONFIRMATION & BULK ACTIONS
========================================================= */
window.pendingConfirmCallback = null;
function advancedConfirm(message, callback) {
    document.getElementById('confirmMessage').innerText = message;
    window.pendingConfirmCallback = callback;
    document.getElementById('confirmModal').classList.add('active');
}
function closeConfirmModal() {
    document.getElementById('confirmModal').classList.remove('active');
    window.pendingConfirmCallback = null;
}
document.getElementById('confirmActionBtn').addEventListener('click', () => {
    if(window.pendingConfirmCallback) window.pendingConfirmCallback();
    closeConfirmModal();
});

let bulkSelectedIds = [];
let currentBulkContext = ''; // 'plans', 'dests', 'reviews', 'content'

function toggleBulkItem(id, context, checkboxElem) {
    if (currentBulkContext !== context) {
        bulkSelectedIds = []; 
        document.querySelectorAll('.checkbox-custom').forEach(cb => cb.checked = false);
        checkboxElem.checked = true;
        currentBulkContext = context;
    }
    
    if (checkboxElem.checked) {
        if(!bulkSelectedIds.includes(id)) bulkSelectedIds.push(id);
    } else {
        bulkSelectedIds = bulkSelectedIds.filter(i => i !== id);
    }
    updateBulkActionBar();
}

function toggleAllBulk(context, masterCheckbox) {
    currentBulkContext = context;
    const isChecked = masterCheckbox.checked;
    bulkSelectedIds = [];
    
    const checkboxes = document.querySelectorAll(`[data-bulk-context="\${context}"]`);
    checkboxes.forEach(cb => {
        cb.checked = isChecked;
        if(isChecked) bulkSelectedIds.push(parseInt(cb.value));
    });
    updateBulkActionBar();
}

function updateBulkActionBar() {
    const bar = document.getElementById('bulkActionBar');
    if (bulkSelectedIds.length > 0) {
        document.getElementById('bulkCountTxt').innerText = bulkSelectedIds.length;
        bar.classList.add('visible');
    } else {
        bar.classList.remove('visible');
        currentBulkContext = '';
    }
}

function executeBulkAction() {
    const action = document.getElementById('bulkActionSelect').value;
    if (!action) return;
    
    if (action === 'delete') {
        advancedConfirm(`Are you sure you want to delete \${bulkSelectedIds.length} item(s)?`, () => {
            if (currentBulkContext === 'plans') {
                savePlans(getPlans().filter(p => !bulkSelectedIds.includes(p.id)));
                loadPlans();
            } else if (currentBulkContext === 'dests') {
                saveDests(getDests().filter(d => !bulkSelectedIds.includes(d.id)));
                loadDests();
            } else if (currentBulkContext === 'reviews') {
                saveReviews(getReviews().filter(r => !bulkSelectedIds.includes(r.id)));
                loadReviews();
            } else if (currentBulkContext === 'content') {
                saveContent(getContent().filter(c => !bulkSelectedIds.includes(c.id)));
                loadContent();
            }
            VoyastraToast.show(`\${bulkSelectedIds.length} items deleted permanently.`, 'warning');
            bulkSelectedIds = [];
            updateBulkActionBar();
            document.getElementById('bulkActionSelect').value = '';
        });
    }
}


/* =========================================================
   DASHBOARD UI & CRUD LOGIC (localStorage)
========================================================= */
const LS_PLANS_KEY = 'voyastra_admin_plans';

// Seed initial mockup data if empty
const initialPlans = [
    { id: 1, title: 'Bali Beach Escapade', location: 'Indonesia', duration: '5 Days', price: '$899', desc: 'Beach, Spa, Sunset' },
    { id: 2, title: 'Swiss Alps Adventure', location: 'Switzerland', duration: '7 Days', price: '$2,450', desc: 'Skiing, Mountains' },
    { id: 3, title: 'Kyoto Cultural Immersion', location: 'Japan', duration: '10 Days', price: '$1,800', desc: 'Temples, Cherry Blossoms' }
];

function initAdminDashboard() {
    // Nav tabs
    document.querySelectorAll('.admin-nav-item').forEach(item => {
        item.addEventListener('click', () => {
            const target = item.getAttribute('data-target');
            if(!target) return;
            
            document.querySelectorAll('.admin-nav-item').forEach(el => el.classList.remove('active'));
            item.classList.add('active');
            
            document.querySelectorAll('.admin-section').forEach(sec => sec.classList.remove('active'));
            document.getElementById(target).classList.add('active');

            // Lazy-load data
            if (target === 'manageCommunity' && allCommunityPosts.length === 0) {
                fetchCommunityPostsFromDB();
            }
            if (target === 'manageActivities' && allActivities.length === 0) {
                loadActivities();
            }
            if (target === 'manageActivity') {
                loadActivityLog();
            }
        });
    });

    // Form submit binder
    const planForm = document.getElementById('planForm');
    if (planForm) planForm.addEventListener('submit', handleFormSubmit);

    // Initial render
    loadPlans();
    loadDests();
    loadReviews();
    loadContent();
    loadUsers();
    loadActivityLog(); 
    loadRecentActivityOverview(); 
    setupGlobalSearch();
    setTimeout(function() { loadAnalytics(); initSettings(); initContentDragDrop(); }, 200);
}

/* =========================================================
   ACTIVITIES MANAGEMENT LOGIC (Servlet-backed)
========================================================= */
let allActivities = [];

async function loadActivities() {
    try {
        const response = await fetch(CONTEXT_PATH + '/activities?format=json');
        if (!response.ok) throw new Error('Failed to load activities');
        allActivities = await response.json();
        renderActivitiesTable();
    } catch (err) {
        console.error('Activities fetch error:', err);
    }
}

function renderActivitiesTable() {
    const query = (document.getElementById('searchActivities')?.value || '').toLowerCase();
    const tbody = document.getElementById('activitiesTableBody');
    if (!tbody) return;

    let filtered = [...allActivities];
    if (query) {
        filtered = filtered.filter(a => 
            a.name.toLowerCase().includes(query) || 
            a.destinationId.toString().includes(query)
        );
    }

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding: 30px; color:#888;">No activities found.</td></tr>';
        return;
    }

    tbody.innerHTML = filtered.map(a => `
        <tr>
            <td style="font-weight:600;">\${a.name}</td>
            <td style="color:var(--text-muted); font-size:0.8rem;">#\${a.id}</td>
            <td><span class="result-badge" style="background:var(--color-primary);">\${a.destinationId}</span></td>
            <td class="font-bold text-primary">₹\${a.price}</td>
            <td>⭐ \${a.rating} <span style="font-size:0.7rem; color:var(--text-muted)">(\${a.reviewsCount})</span></td>
            <td style="text-align: right;">
                <button type="button" class="action-btn btn-edit" onclick="editActivity(\${a.id})">Edit</button>
                <button type="button" class="action-btn btn-delete" onclick="deleteActivity(\${a.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

function openActivityModal(mode='add', id=null) {
    const form = document.getElementById('activityForm');
    const title = document.getElementById('activityModalTitle');
    const extra = document.getElementById('activityExtraInfo');
    const destSelect = document.getElementById('activityDestId');
    
    form.reset();
    document.getElementById('activityId').value = '';
    document.getElementById('activityAction').value = 'add';
    document.getElementById('activityImagePreview').style.display = 'none';
    extra.style.display = 'none';

    // Populate Destinations
    const dests = getDests(); // From localStorage or global state
    destSelect.innerHTML = dests.map(d => `<option value="\${d.id}">\${d.name} (#\${d.id})</option>`).join('');

    if (mode === 'edit' && id !== null) {
        title.innerText = 'Edit Activity';
        const act = allActivities.find(a => a.id === id);
        if (act) {
            document.getElementById('activityId').value = act.id;
            document.getElementById('activityAction').value = 'update';
            document.getElementById('activityName').value = act.name;
            document.getElementById('activityDestId').value = act.destinationId;
            document.getElementById('activityPrice').value = act.price;
            document.getElementById('activityImage').value = act.imageUrl;
            document.getElementById('activityRating').value = act.rating;
            document.getElementById('activityReviewsCount').value = act.reviewsCount;
            previewImg('activityImage', 'activityImagePreview');
            extra.style.display = 'grid';
        }
    } else {
        title.innerText = 'Add New Activity';
    }

    document.getElementById('activityModal').classList.add('active');
}

function closeActivityModal() {
    document.getElementById('activityModal').classList.remove('active');
}

document.getElementById('activityForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    const body = new URLSearchParams(formData);

    try {
        const response = await fetch(CONTEXT_PATH + '/activities', {
            method: 'POST',
            body: body
        });
        
        // ActivityServlet currently redirects, so we check the response URL or just reload
        showToast('Activity saved successfully.', 'success');
        closeActivityModal();
        loadActivities();
    } catch (err) {
        console.error('Save error:', err);
        showToast('Error saving activity.', 'error');
    }
});

function deleteActivity(id) {
    advancedConfirm('Delete this activity permanently?', async () => {
        const body = new URLSearchParams();
        body.append('action', 'delete');
        body.append('id', id);

        try {
            await fetch(`${CONTEXT_PATH}/activities`, {
                method: 'POST',
                body: body
            });
            showToast('Activity deleted.', 'warning');
            loadActivities();
        } catch (err) {
            showToast('Failed to delete activity.', 'error');
        }
    });
}

function getPlans() {
    let raw = localStorage.getItem(LS_PLANS_KEY);
    if (!raw) {
        localStorage.setItem(LS_PLANS_KEY, JSON.stringify(initialPlans));
        return initialPlans;
    }
    return JSON.parse(raw);
}

function savePlans(plans) {
    localStorage.setItem(LS_PLANS_KEY, JSON.stringify(plans));
}

function loadPlans() {
    let plans = getPlans();
    document.getElementById('statPlans').innerText = plans.length;
    
    // Sort and Search Filtering
    const query = document.getElementById('searchPlans') ? document.getElementById('searchPlans').value.toLowerCase() : '';
    const priceRange = document.getElementById('filterPriceRange') ? document.getElementById('filterPriceRange').value : '';
    const sort = document.getElementById('sortPlans') ? document.getElementById('sortPlans').value : 'newest';
    
    if (query) {
        plans = plans.filter(p => p.title.toLowerCase().includes(query) || p.location.toLowerCase().includes(query) || p.price.toString().toLowerCase().includes(query));
    }

    if (priceRange) {
        plans = plans.filter(p => {
            const numPrice = parseFloat(p.price.replace(/[^0-9.]/g,''));
            if (priceRange === 'under1000') return numPrice < 1000;
            if (priceRange === '1000to2000') return numPrice >= 1000 && numPrice <= 2000;
            if (priceRange === 'over2000') return numPrice > 2000;
            return true;
        });
    }
    
    if (sort === 'price_asc') {
        plans.sort((a,b) => parseFloat(a.price.replace(/[^0-9.]/g,'')) - parseFloat(b.price.replace(/[^0-9.]/g,'')));
    } else if (sort === 'price_desc') {
        plans.sort((a,b) => parseFloat(b.price.replace(/[^0-9.]/g,'')) - parseFloat(a.price.replace(/[^0-9.]/g,'')));
    } else {
        plans.sort((a,b) => b.id - a.id); // Newest First (Sort by ID desc)
    }
    
    const tbody = document.getElementById('plansTableBody');
    if (plans.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding: 30px; color:#888;">No plans found matching criteria.</td></tr>';
        return;
    }

    tbody.innerHTML = plans.map(p => `
        <tr>
            <td><input type="checkbox" class="checkbox-custom" value="\${p.id}" data-bulk-context="plans" onclick="toggleBulkItem(\${p.id}, 'plans', this)"></td>
            <td style="font-weight:700; width:30%;">
                <div class="editable-cell" onclick="enableInlineEdit(this, \${p.id}, 'title')">\${p.title}</div>
            </td>
            <td>
                <div class="editable-cell" onclick="enableInlineEdit(this, \${p.id}, 'location')">\${p.location}</div>
            </td>
            <td>
                <div class="editable-cell" onclick="enableInlineEdit(this, \${p.id}, 'duration')">\${p.duration}</div>
            </td>
            <td class="text-primary font-bold">
                <div class="editable-cell" onclick="enableInlineEdit(this, \${p.id}, 'price')">\${p.price}</div>
            </td>
            <td style="text-align: right; white-space: nowrap;">
                <button type="button" class="action-btn btn-edit" onclick="editPlan(\${p.id})">Edit</button>
                <button type="button" class="action-btn btn-delete" onclick="deletePlan(\${p.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

function enableInlineEdit(cell, id, field) {
    if (cell.querySelector('input')) return;
    var currentValue = cell.innerText.trim();
    var inp = document.createElement('input');
    inp.type = 'text';
    inp.className = 'editable-input';
    inp.value = currentValue;
    inp.addEventListener('blur', function() { saveInlineEdit(inp, id, field, currentValue); });
    inp.addEventListener('keypress', function(e) { if (e.key === 'Enter') inp.blur(); });
    cell.innerHTML = '';
    cell.appendChild(inp);
    inp.focus();
    inp.select();
}

function saveInlineEdit(input, id, field, oldValue) {
    const newValue = input.value.trim();
    if (newValue && newValue !== oldValue) {
        const plans = getPlans();
        const index = plans.findIndex(p => p.id === id);
        if (index > -1) {
            plans[index][field] = newValue;
            savePlans(plans);
            typeof showToast === 'function' ? showToast('Row updated quickly via inline edit.', 'success') : false;
        }
    }
    loadPlans();
}

/* Modals */
const modalOverlay = document.getElementById('planModal');

function openPlanModal(mode='add', id=null) {
    document.getElementById('planForm').reset();
    document.getElementById('planId').value = '';
    
    if (mode === 'edit' && id !== null) {
        document.getElementById('modalTitle').innerText = 'Edit Plan';
        const plan = getPlans().find(p => p.id === id);
        if (plan) {
            document.getElementById('planId').value = plan.id;
            document.getElementById('planTitle').value = plan.title;
            document.getElementById('planLocation').value = plan.location;
            document.getElementById('planDuration').value = plan.duration;
            document.getElementById('planPrice').value = plan.price;
            document.getElementById('planDesc').value = plan.desc;
        }
    } else {
        document.getElementById('modalTitle').innerText = 'Add New Plan';
    }
    
    modalOverlay.classList.add('active');
}

function closePlanModal() {
    modalOverlay.classList.remove('active');
}

function handleFormSubmit(e) {
    e.preventDefault();
    
    const idField = document.getElementById('planId').value;
    const isEdit = !!idField;
    const plans = getPlans();
    
    const newPlan = {
        id: isEdit ? parseInt(idField) : Date.now(),
        title: document.getElementById('planTitle').value,
        location: document.getElementById('planLocation').value,
        duration: document.getElementById('planDuration').value,
        price: document.getElementById('planPrice').value,
        desc: document.getElementById('planDesc').value,
    };
    
    if (isEdit) {
        const index = plans.findIndex(p => p.id === newPlan.id);
        if(index > -1) plans[index] = newPlan;
        VoyastraToast.show('Plan updated successfully.', 'success');
    } else {
        plans.push(newPlan);
        VoyastraToast.show('New plan added to catalog!', 'success');
    }
    
    savePlans(plans);
    closePlanModal();
    loadPlans();
}

function editPlan(id) {
    openPlanModal('edit', id);
}

function deletePlan(id) {
    advancedConfirm('Are you sure you want to delete this trip plan?', () => {
        const plans = getPlans();
        const filtered = plans.filter(p => p.id !== id);
        savePlans(filtered);
        VoyastraToast.show('Plan deleted permanently.', 'warning');
        loadPlans();
    });
}

/* =========================================================
   DESTINATIONS CRUD LOGIC
========================================================= */
let activeDests = []; // Local state caching exactly what the database has

async function fetchDestsFromDB() {
    try {
        const response = await fetch(CONTEXT_PATH + '/destinations');
        const data = await response.json();
        activeDests = data;
        loadDestsRenderer();
    } catch (error) {
        console.error('Failed to fetch destinations:', error);
        VoyastraToast.show('Error loading destinations.', 'error');
    }
}

// Ensure initial load calls fetch
function loadDests() {
    if (activeDests.length === 0) {
        fetchDestsFromDB();
    } else {
        loadDestsRenderer();
    }
}

function loadDestsRenderer() {
    let dests = [...activeDests];
    document.getElementById('statDests').innerText = dests.length;
    
    // Sort and Search Filtering
    const query = document.getElementById('searchDests') ? document.getElementById('searchDests').value.toLowerCase() : '';
    const sort = document.getElementById('sortDests') ? document.getElementById('sortDests').value : 'newest';
    
    if (query) {
        dests = dests.filter(d => d.name.toLowerCase().includes(query) || (d.location && d.location.toLowerCase().includes(query)) || (d.category && d.category.toLowerCase().includes(query)));
    }
    
    if (sort === 'az') {
        dests.sort((a,b) => a.name.localeCompare(b.name));
    } else if (sort === 'za') {
        dests.sort((a,b) => b.name.localeCompare(a.name));
    } else {
        dests.sort((a,b) => b.id - a.id);
    }
    
    const grid = document.getElementById('destinationsGrid');
    if (dests.length === 0) {
        grid.style.display = 'block';
        grid.innerHTML = '<div style="text-align:center; padding: 40px; color:#888; background:var(--surface-light); border-radius:12px; border:1px dashed var(--color-border);">No destinations found matching criteria.</div>';
        return;
    }

    grid.style.display = 'grid';
    grid.innerHTML = dests.map(function(d) {
        return '<div class="stat-card" style="padding: 0; overflow: hidden; display:flex; flex-direction:column; position: relative;">'
            + '<input type="checkbox" class="checkbox-custom" value="' + d.id + '" data-bulk-context="dests" onclick="toggleBulkItem(' + d.id + ', \'dests\', this)" style="position: absolute; top: 12px; left: 12px; z-index: 10;">'
            + '<div style="height: 180px; background: url(\'' + d.image + '\') center/cover; position:relative;">'
            + '<span style="position:absolute; top:12px; right:12px; background:rgba(0,0,0,0.65); backdrop-filter:blur(4px); color:#fff; padding:4px 10px; border-radius:20px; font-size:0.7rem; font-weight:600;">' + (d.category || 'Destination') + '</span>'
            + '</div>'
            + '<div style="padding: 20px; flex: 1; display:flex; flex-direction: column;">'
            + '<h3 style="margin-bottom: 4px; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">' + d.name + '</h3>'
            + '<div style="color:var(--text-muted); font-size:0.85rem; margin-bottom: 12px; display:flex; align-items:center; gap:4px;">'
            + '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg> ' + (d.location || 'Global')
            + '</div>'
            + '<div style="display:flex; justify-content:space-between; margin-top:auto; border-top:1px solid var(--color-border); padding-top:16px;">'
            + '<button type="button" class="action-btn btn-edit" style="margin:0;" onclick="editDest(' + d.id + ')">Edit</button>'
            + '<button type="button" class="action-btn btn-delete" style="margin:0;" onclick="deleteDest(' + d.id + ')">Delete</button>'
            + '</div></div></div>';
    }).join('');
}

const destModal = document.getElementById('destModal');

function openDestModal(mode='add', id=null) {
    document.getElementById('destForm').reset();
    document.getElementById('destId').value = '';
    document.getElementById('destAction').value = mode;
    
    if (mode === 'edit' && id !== null) {
        document.getElementById('destModalTitle').innerText = 'Edit Destination';
        document.getElementById('destAction').value = 'update';
        const dest = activeDests.find(d => d.id === id);
        if (dest) {
            document.getElementById('destId').value = dest.id;
            document.getElementById('destName').value = dest.name;
            document.getElementById('destLocation').value = dest.location || '';
            document.getElementById('destCategory').value = dest.category || '';
            document.getElementById('destImage').value = dest.image || '';
            document.getElementById('destDesc').value = dest.desc || '';
        }
    } else {
        document.getElementById('destModalTitle').innerText = 'Add Destination';
    }
    
    destModal.classList.add('active');
}

function closeDestModal() {
    destModal.classList.remove('active');
}

// Removed AJAX listener for destForm to allow standard form submission with redirect.
// Functionality is now handled by native browser form post to /destinations.

function editDest(id) { openDestModal('edit', id); }

async function deleteDest(id) {
    advancedConfirm('Delete this destination permanently?', async () => {
        try {
            const formData = new URLSearchParams();
            formData.append('action', 'delete');
            formData.append('id', id);
            
            const response = await fetch(CONTEXT_PATH + '/destinations', {

                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData.toString()
            });
            const data = await response.json();
            
            if (data.status === 'success') {
                typeof showToast === 'function' ? showToast(data.message, 'warning') : false;
                fetchDestsFromDB();
            } else {
                VoyastraToast.show(data.message, 'error');
            }
        } catch (error) {
            console.error('Delete Error:', error);
            typeof showToast === 'function' ? showToast('Network error while deleting.', 'error') : false;
        }
    });
}


/* =========================================================
   REVIEWS CRUD LOGIC (Moderation)
========================================================= */
let activeReviews = []; // Local state caching DB reviews

async function fetchReviewsFromDB() {
    try {
        const response = await fetch(`${pageContext.request.contextPath}/review?action=list`);
        if (!response.ok) throw new Error('Failed to load reviews');
        const data = await response.json();
        activeReviews = data;
        loadReviewsRenderer();
    } catch (error) {
        console.error('Failed to fetch reviews:', error);
        VoyastraToast.show('Error loading reviews.', 'error');
    }
}

// Ensure initial load calls fetch
function loadReviews() {
    if (activeReviews.length === 0) {
        fetchReviewsFromDB();
    } else {
        loadReviewsRenderer();
    }
}

function getStars(score) {
    let stars = '';
    for(let i=0; i<5; i++) {
        stars += (i < score) ? '&#9733;' : '&#9734;'; 
    }
    return stars;
}

function loadReviewsRenderer() {
    let revs = [...activeReviews];
    const grid = document.getElementById('reviewsGrid');
    document.getElementById('statReviews').innerText = revs.length;
    
    // 1. Search Filtering
    const kw = document.getElementById('searchReviews') ? document.getElementById('searchReviews').value.toLowerCase().trim() : '';
    if (kw) {
        revs = revs.filter(r => 
            (r.userName && r.userName.toLowerCase().includes(kw)) || 
            (r.location && r.location.toLowerCase().includes(kw)) ||
            (r.comment && r.comment.toLowerCase().includes(kw))
        );
    }

    // 2. Sorting
    const sortVal = document.getElementById('sortReviews') ? document.getElementById('sortReviews').value : 'newest';
    if (sortVal === 'rating_high') {
        revs.sort((a,b) => b.rating - a.rating);
    } else if (sortVal === 'rating_low') {
        revs.sort((a,b) => a.rating - b.rating);
    } else {
        // newest first (using ID as primary sort, createdAt if available)
        revs.sort((a,b) => b.id - a.id);
    }

    if (revs.length === 0) {
        grid.style.display = 'block';
        grid.innerHTML = `<div style="text-align:center; padding: 40px; color:#888; background:var(--surface-light); border-radius:12px; border:1px dashed var(--color-border);">\${kw ? 'No reviews match your search.' : 'No reviews found.'}</div>`;
        return;
    }

    grid.style.display = 'grid';
    grid.innerHTML = revs.map(r => `
        <div class="stat-card" style="position:relative; display:flex; flex-direction:column; gap:12px;">
            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                <div>
                    <h4 style="margin:0; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">\${r.userName}</h4>
                    <div style="font-size:0.75rem; color:var(--text-muted); display:flex; gap:6px; align-items:center; margin-top:4px;">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                        \${r.location}
                    </div>
                </div>
                <div style="color:#fbbf24; font-size:1.2rem; filter:drop-shadow(0 0 4px rgba(251,191,36,0.3)); letter-spacing: 2px;">
                     \${getStars(r.rating)}
                </div>
            </div>
            <p style="font-size:0.9rem; line-height:1.6; color:var(--text-main); font-style:italic; margin-top:4px; padding: 12px; background: rgba(0,0,0,0.02); border-radius: 8px;">"\${r.comment}"</p>
            
            <div style="margin-top:auto; padding-top:16px; border-top:1px solid var(--color-border); display:flex; gap:12px;">
                <button class="action-btn" style="flex:1; margin:0; background:rgba(16,185,129,0.1); color:#10b981; border:1px solid rgba(16,185,129,0.2); pointer-events:none;">
                    ✓ Approved
                </button>
                <button class="action-btn btn-delete" style="flex:1; margin:0;" onclick="deleteReview(\${r.id})">Delete</button>
            </div>
        </div>
    `).join('');
}

function deleteReview(id) {
    advancedConfirm('Delete this review permanently?', async () => {
         try {
            const formData = new URLSearchParams();
            formData.append('action', 'delete');
            formData.append('id', id);
            
            const response = await fetch(`${pageContext.request.contextPath}/review`, {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData.toString()
            });
            const data = await response.json();
            
            if (data.status === 'success') {
                typeof showToast === 'function' ? showToast('Review deleted safely.', 'warning') : false;
                fetchReviewsFromDB();
            } else {
                VoyastraToast.show(data.message, 'error');
            }
        } catch (error) {
            console.error('Delete Error:', error);
            typeof showToast === 'function' ? showToast('Network error while deleting.', 'error') : false;
        }
    });
}

/* =========================================================
   COMMUNITY POSTS MANAGEMENT (Admin Moderation)
========================================================= */
let allCommunityPosts = [];   // Full DB-fetched post list
let deletedTodayCount = 0;    // Track deletes this session

async function fetchCommunityPostsFromDB() {
    const loading  = document.getElementById('communityPostsLoading');
    const empty    = document.getElementById('communityPostsEmpty');
    const tableWrap = document.getElementById('communityPostsTableWrap');

    if (loading)  loading.style.display  = 'block';
    if (tableWrap) tableWrap.style.display = 'none';
    if (empty)    empty.style.display    = 'none';

    try {
        const response = await fetch(`${pageContext.request.contextPath}/community?action=list`);
        if (!response.ok) throw new Error('Failed to load community posts');
        const data = await response.json();
        allCommunityPosts = data.map(p => ({ ...p, _hidden: false }));
        renderCommunityPostsTable();
    } catch (err) {
        console.error('Community fetch error:', err);
        typeof showToast === 'function'
            ? showToast('Error loading community posts.', 'error')
            : console.warn(err);
    } finally {
        if (loading) loading.style.display = 'none';
    }
}

function loadCommunityPosts() {
    allCommunityPosts = [];
    fetchCommunityPostsFromDB();
}

function renderCommunityPostsTable() {
    const searchVal  = (document.getElementById('searchCommunityPosts')?.value || '').toLowerCase();
    const statusFilt = document.getElementById('filterCommunityStatus')?.value || 'all';
    const tbody      = document.getElementById('communityPostsTableBody');
    const empty      = document.getElementById('communityPostsEmpty');
    const tableWrap  = document.getElementById('communityPostsTableWrap');

    let posts = [...allCommunityPosts];

    // Apply search filter
    if (searchVal) {
        posts = posts.filter(p =>
            (p.userName   || '').toLowerCase().includes(searchVal) ||
            (p.text       || '').toLowerCase().includes(searchVal) ||
            (p.location   || '').toLowerCase().includes(searchVal)
        );
    }

    // Apply status filter
    if (statusFilt === 'hidden')  posts = posts.filter(p =>  p._hidden);
    if (statusFilt === 'visible') posts = posts.filter(p => !p._hidden);

    // Update stats
    const totalAll   = allCommunityPosts.length;
    const visibleAll = allCommunityPosts.filter(p => !p._hidden).length;
    const hiddenAll  = allCommunityPosts.filter(p =>  p._hidden).length;
    document.getElementById('communityStatTotal').textContent   = totalAll;
    document.getElementById('communityStatVisible').textContent = visibleAll;
    document.getElementById('communityStatHidden').textContent  = hiddenAll;
    document.getElementById('communityStatDeleted').textContent = deletedTodayCount;

    if (posts.length === 0) {
        if (tableWrap) tableWrap.style.display = 'none';
        if (empty)     empty.style.display     = 'block';
        return;
    }

    if (empty)    empty.style.display     = 'none';
    if (tableWrap) tableWrap.style.display = 'block';

    tbody.innerHTML = posts.map(p => {
        const previewText = (p.text || '').length > 80 ? p.text.substring(0, 80) + '…' : (p.text || '—');
        const dateStr     = p.createdAt ? p.createdAt.split('T')[0] : '—';
        const hasImage    = p.imageUrl && p.imageUrl.trim() !== '';
        const isHidden    = p._hidden;

        return `<tr id="communityRow_\\${p.id}" style="\\${isHidden ? 'opacity:0.5;' : ''}">
            <td>
                <div style="display:flex; align-items:center; gap:10px;">
                    <img src="https://ui-avatars.com/api/?name=\\${encodeURIComponent(p.userName || 'U')}&background=d4a574&color=1a0f08&size=40"
                         alt="\\${p.userName}" style="width:36px;height:36px;border-radius:50%;object-fit:cover;flex-shrink:0;">
                    <span style="font-weight:600;">\\${p.userName || '—'}</span>
                </div>
            </td>
            <td style="max-width:240px;">
                <span style="font-size:0.875rem; color:var(--text-main); line-height:1.5;">\\${previewText}</span>
            </td>
            <td>
                \\${hasImage
                    ? \`<img src="\\${p.imageUrl}" alt="Post" style="width:52px;height:40px;object-fit:cover;border-radius:6px;border:1px solid var(--color-border);" onerror="this.style.display='none'">\`
                    : '<span style="color:var(--text-muted);font-size:0.8rem;">None</span>'}
            </td>
            <td>
                \\${p.location
                    ? \`<span style="font-size:0.8rem; background:rgba(79,70,229,0.08); color:var(--color-primary); padding:3px 8px; border-radius:20px;">\\${p.location}</span>\`
                    : '<span style="color:var(--text-muted);">—</span>'}
            </td>
            <td style="font-size:0.8rem; color:var(--text-muted); white-space:nowrap;">\\${dateStr}</td>
            <td>
                <span style="
                    display:inline-flex; align-items:center; gap:5px;
                    font-size:0.75rem; font-weight:600; padding:4px 10px; border-radius:20px;
                    background:\${isHidden ? 'rgba(245,158,11,0.12)' : 'rgba(16,185,129,0.12)'};
                    color:\${isHidden ? '#d97706' : '#059669'};
                ">
                    <span style="width:6px;height:6px;border-radius:50%;background:\${isHidden ? '#d97706' : '#059669'};display:inline-block;"></span>
                    \${isHidden ? 'Hidden' : 'Visible'}
                </span>
            </td>
            <td style="text-align:right;">
                <div style="display:flex;gap:8px;justify-content:flex-end;">
                    <button class="action-btn btn-edit" style="margin:0;"
                            onclick="toggleHideCommunityPost(\${p.id})">
                        \${isHidden ? 'Unhide' : 'Hide'}
                    </button>
                    <button class="action-btn btn-delete" style="margin:0;"
                            onclick="deleteCommunityPost(\${p.id})">
                        Delete
                    </button>
                </div>
            </td>
        </tr>`;
    }).join('');
}

function filterCommunityPosts() {
    renderCommunityPostsTable();
}

function toggleHideCommunityPost(id) {
    const post = allCommunityPosts.find(p => p.id === id);
    if (!post) return;
    post._hidden = !post._hidden;
    renderCommunityPostsTable();
    const action = post._hidden ? 'hidden from' : 'restored to';
    typeof showToast === 'function'
        ? showToast(`Post \${action} community feed.`, post._hidden ? 'warning' : 'success')
        : false;
}

function deleteCommunityPost(id) {
    advancedConfirm('Permanently delete this community post? This action cannot be undone.', async () => {
        try {
            const body = new URLSearchParams();
            body.append('action', 'delete');
            body.append('id', id);

            const response = await fetch('`${pageContext.request.contextPath}/community', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString()
            });

            const data = await response.json();

            if (data.status === 'success') {
                // Animate row out
                const row = document.getElementById('communityRow_' + id);
                if (row) {
                    row.style.transition = 'all 0.3s ease';
                    row.style.opacity = '0';
                    row.style.transform = 'translateX(20px)';
                    setTimeout(() => row.remove(), 320);
                }
                // Remove from local state
                allCommunityPosts = allCommunityPosts.filter(p => p.id !== id);
                deletedTodayCount++;
                renderCommunityPostsTable();
                typeof showToast === 'function'
                    ? showToast('Community post deleted successfully.', 'warning')
                    : false;
            } else {
                typeof showToast === 'function'
                    ? showToast(data.message || 'Failed to delete post.', 'error')
                    : VoyastraToast.show(data.message || 'Error.', 'error');
            }
        } catch (err) {
            console.error('Community delete error:', err);
            typeof showToast === 'function'
                ? showToast('Network error while deleting post.', 'error')
                : false;
        }
    });
}


/* =========================================================
   CONTENT MANAGEMENT LOGIC
========================================================= */
const LS_CONTENT_KEY = 'voyastra_admin_content';

const initialContent = [
    { id: 1, section: 'Trending Places', title: 'Santorini Escapes', image: 'https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?auto=format&fit=crop&w=600&q=80', price: 'From $1,200', tags: 'Beach, Romantic' },
    { id: 2, section: 'Top Travel Plans', title: 'Kyoto Autumn', image: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=600&q=80', price: '$2,300', tags: 'Culture, Nature' },
    { id: 3, section: 'Featured Cards', title: 'Swiss Alps Skiing', image: 'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?auto=format&fit=crop&w=600&q=80', price: 'From $900', tags: 'Adventure, Snow' }
];

function getContent() {
    let raw = localStorage.getItem(LS_CONTENT_KEY);
    if (!raw) {
        localStorage.setItem(LS_CONTENT_KEY, JSON.stringify(initialContent));
        return initialContent;
    }
    return JSON.parse(raw);
}

function saveContent(data) {
    localStorage.setItem(LS_CONTENT_KEY, JSON.stringify(data));
}

function loadContent() {
    const data = getContent();
    const grid = document.getElementById('contentGrid');
    
    if (data.length === 0) {
        grid.style.display = 'block';
        grid.innerHTML = '<div style="text-align:center; padding: 40px; color:#888;">No content loaded.</div>';
        return;
    }

    grid.style.display = 'grid';
    grid.innerHTML = data.map(function(c) {
        var tagHtml = c.tags.split(',').map(function(tag) {
            return '<span style="display:inline-block; font-size:0.7rem; padding:3px 8px; background:rgba(79,70,229,0.1); color:#4f46e5; border-radius:12px; margin-right:4px;">' + tag.trim() + '</span>';
        }).join('');
        return '<div class="stat-card" style="padding: 0; overflow: hidden; display:flex; flex-direction:column;">'
            + '<div style="height: 160px; background: url(\'' + c.image + '\') center/cover; position:relative;">'
            + '<span style="position:absolute; top:12px; right:12px; background:rgba(0,0,0,0.65); backdrop-filter:blur(4px); color:#ebaa54; padding:4px 10px; border-radius:20px; font-size:0.75rem; font-weight:700;">' + c.section + '</span>'
            + '</div>'
            + '<div style="padding: 20px; flex: 1; display:flex; flex-direction: column;">'
            + '<h3 style="margin-bottom: 4px; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">' + c.title + '</h3>'
            + '<div style="color:var(--color-primary); font-size:0.95rem; margin-bottom: 12px; font-weight:600;">' + c.price + '</div>'
            + '<div style="margin-bottom:16px;">' + tagHtml + '</div>'
            + '<div style="display:flex; justify-content:space-between; margin-top:auto; border-top:1px solid var(--color-border); padding-top:16px;">'
            + '<button type="button" class="action-btn btn-edit" style="margin:0; width:100%; text-align:center;" onclick="editContent(' + c.id + ')">Edit Card</button>'
            + '</div></div></div>';
    }).join('');
}

const contentModal = document.getElementById('contentModal');

function openContentModal(id) {
    document.getElementById('contentForm').reset();
    const c = getContent().find(x => x.id === id);
    if (c) {
        document.getElementById('contentId').value = c.id;
        document.getElementById('contentTitle').value = c.title;
        document.getElementById('contentImage').value = c.image;
        document.getElementById('contentPrice').value = c.price;
        document.getElementById('contentSection').value = c.section;
        document.getElementById('contentTags').value = c.tags;
        contentModal.classList.add('active');
    }
}

function closeContentModal() {
    contentModal.classList.remove('active');
}

document.getElementById('contentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const id = parseInt(document.getElementById('contentId').value);
    const data = getContent();
    const index = data.findIndex(x => x.id === id);
    
    if (index > -1) {
        data[index] = {
            id: id,
            title: document.getElementById('contentTitle').value,
            image: document.getElementById('contentImage').value,
            price: document.getElementById('contentPrice').value,
            section: document.getElementById('contentSection').value,
            tags: document.getElementById('contentTags').value
        };
        saveContent(data);
        VoyastraToast.show('Content block updated dynamically.', 'success');
        closeContentModal();
        loadContent();
    }
});

function editContent(id) { openContentModal(id); }

/* =========================================================
   IMAGE PREVIEW
========================================================= */
function previewImg(inputId, previewId) {
    var url = document.getElementById(inputId).value.trim();
    var img = document.getElementById(previewId);
    if (url) {
        img.src = url;
        img.style.display = 'block';
        img.onerror = function() { img.style.display = 'none'; };
    } else {
        img.style.display = 'none';
    }
}

// Bind drag and drop file upload mockup
setTimeout(() => {
    const fileInput = document.getElementById('destImageFile');
    const urlInput = document.getElementById('destImage');
    const box = document.getElementById('destImageUploadBox');
    
    if (fileInput && urlInput) {
        fileInput.addEventListener('change', function(e) {
            if(e.target.files && e.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    urlInput.value = e.target.result;
                    previewImg('destImage', 'destImagePreview');
                    showToast('Local image ready for upload mockup.', 'success');
                }
                reader.readAsDataURL(e.target.files[0]);
            }
        });
        
        box.addEventListener('dragover', () => box.style.borderColor = '#4f46e5');
        box.addEventListener('dragleave', () => box.style.borderColor = '');
        box.addEventListener('drop', () => box.style.borderColor = '');
    }
}, 500);

/* =========================================================
   DASHBOARD ANALYTICS
========================================================= */
function loadAnalytics() {
    // 1. Fetch real-time statistics from DB via AdminAnalyticsServlet
    fetch(CONTEXT_PATH + '/admin/stats')
        .then(response => response.json())
        .then(data => {
            // Update Dashboard Overview Cards
            if (document.getElementById('statUsers')) document.getElementById('statUsers').innerText = data.users.toLocaleString();
            if (document.getElementById('statBookings')) document.getElementById('statBookings').innerText = data.bookings.toLocaleString();
            if (document.getElementById('statPlans')) document.getElementById('statPlans').innerText = data.plans.toLocaleString();
            if (document.getElementById('statDests')) document.getElementById('statDests').innerText = data.destinations.toLocaleString();
            
            if (document.getElementById('statRevenue')) {
                const formatter = new Intl.NumberFormat('en-US', {
                    style: 'currency',
                    currency: 'USD',
                });
                document.getElementById('statRevenue').innerText = formatter.format(data.revenue);
            }
        })
        .catch(err => {
            console.error('Analytics Error:', err);
            // Fallback UI or silent fail
        });

    // 2. Existing chart/activity logic (Optional: migrate to DB as well)
    var dests = getDests();
    var chart = document.getElementById('destBarChart');
    if (chart) {
        var colors = ['#4f46e5','#06b6d4','#fbbf24','#10b981','#ef4444'];
        chart.innerHTML = dests.slice(0,5).map(function(d, i) {
            var pct = Math.max(20, Math.round(Math.random() * 60 + 30));
            return '<div>'
                + '<div style="display:flex; justify-content:space-between; margin-bottom:5px; font-size:0.82rem;">'
                + '<span>' + d.name + '</span><span style="color:' + colors[i % colors.length] + '; font-weight:600;">' + pct + '%</span>'
                + '</div>'
                + '<div style="background:var(--color-border); border-radius:8px; overflow:hidden; height:8px;">'
                + '<div style="width:' + pct + '%; height:8px; background:' + colors[i % colors.length] + '; border-radius:8px; transition: width 0.6s ease;"></div>'
                + '</div></div>';
        }).join('');
    }

    var revs = getReviews();
    if (revs.length > 0) {
        var approved = revs.filter(function(r) { return r.approved; }).length;
        var approvedPct = Math.round((approved / revs.length) * 100);
        var pendingPct = 100 - approvedPct;
        if (document.getElementById('approvedPct')) document.getElementById('approvedPct').innerText = approvedPct + '%';
        if (document.getElementById('pendingPct')) document.getElementById('pendingPct').innerText = pendingPct + '%';
        if (document.getElementById('approvedBar')) document.getElementById('approvedBar').style.width = approvedPct + '%';
        if (document.getElementById('pendingBar')) document.getElementById('pendingBar').style.width = pendingPct + '%';
    }
}

/* =========================================================
   SETTINGS PANEL
========================================================= */
function applySettingsTheme(isDark) {
    var slider = document.getElementById('themeSlider');
    if (isDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        if (slider) slider.style.background = '#4f46e5';
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        if (slider) slider.style.background = '#ccc';
    }
    localStorage.setItem('voyastra_admin_theme', isDark ? 'dark' : 'light');
    showToast('Theme switched to ' + (isDark ? 'Dark' : 'Light') + ' mode.', 'success');
}

function initSettings() {
    var saved = localStorage.getItem('voyastra_admin_theme');
    var isDark = saved === 'dark';
    var cb = document.getElementById('settingsTheme');
    if (cb) cb.checked = isDark;
    var slider = document.getElementById('themeSlider');
    if (slider) slider.style.background = isDark ? '#4f46e5' : '#ccc';
}

function resetAllData() {
    localStorage.removeItem('voyastra_admin_plans');
    localStorage.removeItem('voyastra_admin_dests');
    localStorage.removeItem('voyastra_admin_reviews');
    localStorage.removeItem('voyastra_admin_content');
    loadPlans(); loadDests(); loadReviews(); loadContent(); loadAnalytics();
    showToast('All data reset to factory defaults.', 'warning');
}

/* =========================================================
   USER MANAGEMENT LOGIC
========================================================= */
const LS_USERS_KEY = 'voyastra_admin_users';
const initialUsers = [
    { id: 1, name: 'Alice Jenkins', email: 'alice@example.com', role: 'User', status: 'Active' },
    { id: 2, name: 'Bob Smith', email: 'bob@example.com', role: 'Premium', status: 'Active' },
    { id: 3, name: 'Charlie Doe', email: 'charlie@example.com', role: 'User', status: 'Suspended' }
];

function getUsers() {
    let raw = localStorage.getItem(LS_USERS_KEY);
    if (!raw) { localStorage.setItem(LS_USERS_KEY, JSON.stringify(initialUsers)); return initialUsers; }
    return JSON.parse(raw);
}
   USERS MANAGEMENT LOGIC (Servlet-backed)
 ========================================================= */
let activeUsers = [];

async function fetchUsersFromDB() {
    try {
        const response = await fetch(CONTEXT_PATH + '/users?action=list');
        if (!response.ok) throw new Error('Failed to fetch users');
        activeUsers = await response.json();
        renderUsersTable();
    } catch (error) {
        console.error('Users load error:', error);
    }
}

function loadUsers() {
    if (activeUsers.length === 0) {
        fetchUsersFromDB();
    } else {
        renderUsersTable();
    }
}

function renderUsersTable() {
    const query = (document.getElementById('searchUsers')?.value || '').toLowerCase();
    const tbody = document.getElementById('usersTableBody');
    if (!tbody) return;

    let filtered = [...activeUsers];
    if (query) {
        filtered = filtered.filter(u => 
            (u.name && u.name.toLowerCase().includes(query)) || 
            (u.email && u.email.toLowerCase().includes(query))
        );
    }

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding: 30px; color:#888;">No users found.</td></tr>';
        return;
    }

    tbody.innerHTML = users.map(u => `
        <tr>
            <td style="font-weight:600;">\${u.name}</td>
            <td style="color:var(--text-muted);">\${u.email}</td>
            <td><span style="padding:4px 8px; border-radius:12px; font-size:0.75rem; background: \${u.role==='Premium'?'rgba(251,191,36,0.1)':'rgba(59,130,246,0.1)'}; color: \${u.role==='Premium'?'#fbbf24':'#3b82f6'};">\${u.role}</span></td>
            <td style="text-align: right;">
                <button type="button" class="action-btn btn-edit" style="margin-right:8px;" onclick="suspendUser(\${u.id})">\${u.status==='Suspended' ? 'Unsuspend' : 'Suspend'}</button>
                <button type="button" class="action-btn btn-delete" onclick="deleteUser(\${u.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

function suspendUser(id) {
    const users = getUsers();
    const u = users.find(x => x.id === id);
    if(u) {
        u.status = u.status === 'Suspended' ? 'Active' : 'Suspended';
        saveUsers(users);
        logActivity(`Admin \${u.status === 'Suspended' ? 'suspended' : 'unsuspended'} user \${u.name}`);
        loadUsers();
    }
}
function deleteUser(id) {
    advancedConfirm('Permanently delete this user?', () => {
        saveUsers(getUsers().filter(u => u.id !== id));
        logActivity(`Admin deleted a user account`);
        loadUsers();
    });
}

/* =========================================================
   ACTIVITY LOG LOGIC
========================================================= */
const LS_ACTIVITY_KEY = 'voyastra_admin_activity';
const initialActivity = [
    { id: 1, text: 'System initialized successfully', time: new Date().toISOString() }
];

function getActivity() {
    let raw = localStorage.getItem(LS_ACTIVITY_KEY);
    if (!raw) { localStorage.setItem(LS_ACTIVITY_KEY, JSON.stringify(initialActivity)); return initialActivity; }
    return JSON.parse(raw);
}
function saveActivity(acts) { localStorage.setItem(LS_ACTIVITY_KEY, JSON.stringify(acts)); }

function logActivity(text) {
    const acts = getActivity();
    acts.unshift({ id: Date.now(), text, time: new Date().toISOString() });
    if(acts.length > 50) acts.pop();
    saveActivity(acts);
    loadActivityLog();
}

function loadActivityLog() {
    const box = document.getElementById('activityTimelineBox');
    if (!box) return;
    
    fetch('admin/logs?format=json')
        .then(response => response.json())
        .then(logs => {
            if (!logs || logs.length === 0) {
                box.innerHTML = '<div style="text-align:center; padding: 40px; color:#888;">No system activity recorded yet.</div>';
                return;
            }
            
            box.innerHTML = `<div class="activity-timeline">` + logs.map(log => `
                <div class="activity-item">
                    <div class="activity-dot" style="background: \${log.color}"></div>
                    <div class="activity-content">
                        <div class="activity-header">
                            <span class="activity-badge" style="background: \${log.color}22; color: \${log.color}">\${log.action}</span>
                            <span class="activity-time">\${log.timestamp}</span>
                        </div>
                        <div class="activity-msg">
                            <span class="activity-admin">@\${log.adminUsername}</span> \${log.details}
                        </div>
                    </div>
                </div>
            `).join('') + `</div>`;
        })
        .catch(err => {
            console.error('Failed to load logs:', err);
            box.innerHTML = '<div style="color:var(--color-primary); padding:20px; text-align:center;">Failed to connect to activity service.</div>';
        });
}

function loadRecentActivityOverview() {
    const list = document.getElementById('recentActivityList');
    if (!list) return;
    
    fetch('admin/logs?limit=5&format=json')
        .then(response => response.json())
        .then(logs => {
            if (!logs || logs.length === 0) {
                list.innerHTML = '<div style="padding:40px; text-align:center; color:var(--text-muted);">No recent actions found.</div>';
                return;
            }
            
            list.innerHTML = logs.map(log => `
                <div class="recent-log-row">
                    <div class="recent-log-dot" style="background: \${log.color}"></div>
                    <div class="recent-log-info">
                        <div class="recent-log-title">@\${log.adminUsername} \${log.action}d <span style="color:var(--text-muted); font-weight:400">\${log.targetTable}</span></div>
                        <div class="recent-log-sub">\${log.details}</div>
                    </div>
                    <div style="font-size:0.75rem; color:var(--text-muted);">\${log.timestamp.split('T')[1].substring(0,5)}</div>
                </div>
            `).join('');
        });
}

/* =========================================================
   DRAG AND DROP FOR CONTENT MANAGEMENT
========================================================= */
function initContentDragDrop() {
    const cards = document.querySelectorAll('#contentGrid .stat-card');
    let draggedCard = null;

    cards.forEach(card => {
        card.setAttribute('draggable', true);
        card.classList.add('draggable-card');

        card.addEventListener('dragstart', function(e) {
            draggedCard = card;
            setTimeout(() => card.classList.add('dragging'), 0);
            e.dataTransfer.effectAllowed = 'move';
        });

        card.addEventListener('dragend', function() {
            draggedCard.classList.remove('dragging');
            draggedCard = null;
            document.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over'));
            
            // Auto update order based on DOM position
            const newOrderIds = Array.from(document.querySelectorAll('#contentGrid .stat-card')).map(c => parseInt(c.getAttribute('data-id')));
            const allContent = getContent();
            const reorderedContent = newOrderIds.map(id => allContent.find(c => c.id === id)).filter(Boolean);
            if (reorderedContent.length === allContent.length) {
                saveContent(reorderedContent);
                logActivity('Admin reordered content cards');
                typeof showToast === 'function' && showToast('Content order saved automatically', 'success');
            }
        });

        card.addEventListener('dragover', function(e) {
            e.preventDefault();
            e.dataTransfer.dropEffect = 'move';
            if (card !== draggedCard) card.classList.add('drag-over');
        });

        card.addEventListener('dragleave', function() {
            card.classList.remove('drag-over');
        });

        card.addEventListener('drop', function(e) {
            e.preventDefault();
            if (card !== draggedCard && draggedCard) {
                const grid = document.getElementById('contentGrid');
                const dragIndex = Array.from(grid.children).indexOf(draggedCard);
                const dropIndex = Array.from(grid.children).indexOf(card);
                if (dragIndex < dropIndex) {
                    card.after(draggedCard);
                } else {
                    card.before(draggedCard);
                }
            }
            card.classList.remove('drag-over');
        });
    });
}

function overrideLoadContentWithDataId() {
    // Modify existing loadContent temporarily to add data-id and call initContentDragDrop
    const originalLoadContent = window.loadContent;
    window.loadContent = function() {
        originalLoadContent.call(window);
        // Inject data-id into the generated cards
        const data = getContent();
        const grid = document.getElementById('contentGrid');
        if(grid && data.length > 0) {
            const cards = grid.children;
            for(let i=0; i<data.length; i++){
                if(cards[i]) cards[i].setAttribute('data-id', data[i].id);
            }
        }
        initContentDragDrop();
    };
}
// Automatically hook the override
overrideLoadContentWithDataId();

/* =========================================================
   GLOBAL SEARCH LOGIC
========================================================= */
function setupGlobalSearch() {
    const input = document.getElementById('globalAdminSearch');
    const dropdown = document.getElementById('globalSearchResults');
    if (!input || !dropdown) return;
    
    input.addEventListener('input', function(e) {
        const query = e.target.value.toLowerCase().trim();
        if (!query) { dropdown.classList.remove('active'); return; }
        
        let resultsHTML = '';
        
        getPlans().forEach(p => {
            if (p.title.toLowerCase().includes(query) || p.location.toLowerCase().includes(query)) {
                resultsHTML += `<div class="search-result-item" onclick="jumpToSection('managePlans', \${p.id})">
                    <strong>Plan:</strong> \${p.title} <span class="text-muted" style="font-size:0.8rem">(\${p.location})</span>
                </div>`;
            }
        });
        
        getDests().forEach(d => {
            if (d.name.toLowerCase().includes(query) || d.location.toLowerCase().includes(query)) {
                resultsHTML += `<div class="search-result-item" onclick="jumpToSection('manageDestinations', \${d.id})">
                    <strong>Dest:</strong> \${d.name} <span class="text-muted" style="font-size:0.8rem">(\${d.location})</span>
                </div>`;
            }
        });
        
        getUsers().forEach(u => {
            if (u.name.toLowerCase().includes(query) || u.email.toLowerCase().includes(query)) {
                resultsHTML += `<div class="search-result-item" onclick="jumpToSection('manageUsers', \${u.id})">
                    <strong>User:</strong> \${u.name} <span class="text-muted" style="font-size:0.8rem">(\${u.email})</span>
                </div>`;
            }
        });
        
        if (resultsHTML === '') resultsHTML = '<div class="search-result-item text-muted">No matches found.</div>';
        dropdown.innerHTML = resultsHTML;
        dropdown.classList.add('active');
    });
    
    document.addEventListener('click', function(e) {
        if (!input.contains(e.target) && !dropdown.contains(e.target)) dropdown.classList.remove('active');
    });
}

function jumpToSection(sectionId, itemId) {
    document.querySelectorAll('.admin-nav-item').forEach(el => el.classList.remove('active'));
    document.querySelector(`.admin-nav-item[data-target="\${sectionId}"]`).classList.add('active');
    document.querySelectorAll('.admin-section').forEach(sec => sec.classList.remove('active'));
    
    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
        targetSection.classList.add('active');
        // Refresh appropriate data
        if (sectionId === 'manageActivity') loadActivityLog();
        if (sectionId === 'dashboard') loadRecentActivityOverview();
    }

    document.getElementById('globalSearchResults').classList.remove('active');
    document.getElementById('globalAdminSearch').value = '';
}

// --- Responsive Sidebar Toggle ---
function toggleAdminSidebar() {
    const sidebar = document.getElementById('adminSidebar');
    const overlay = document.getElementById('adminSidebarOverlay');
    
    if (sidebar.classList.contains('open')) {
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
        document.body.style.overflow = '';
    } else {
        sidebar.classList.add('open');
        overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

// --- Handle Redirect Status Messages ---
window.addEventListener('DOMContentLoaded', () => {
    const params = new URLSearchParams(window.location.search);
    const status = params.get('status');
    const message = params.get('message');
    
    if (status) {
        if (status === 'add_success') {
            VoyastraToast.show('New destination created successfully!', 'success');
        } else if (status === 'update_success') {
            VoyastraToast.show('Destination details updated.', 'success');
        } else if (status === 'error') {
            VoyastraToast.show(message || 'An error occurred while saving.', 'error');
        }
        
        // Clean the URL so the toast doesn't reappear on manual refresh
        window.history.replaceState({}, document.title, window.location.pathname);
    }
    
    setupGlobalSearch();
});
</script>

