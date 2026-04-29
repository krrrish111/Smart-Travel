<%@ page import="java.util.*" %>
<%
    String currentUri = request.getRequestURI();
    boolean isDashboard = currentUri.contains("/admin/index") || currentUri.endsWith("/admin") || currentUri.endsWith("/admin/");
    boolean isUsers = currentUri.contains("/admin/users");
    boolean isBookings = currentUri.contains("/admin/bookings");
    boolean isPlans = currentUri.contains("/admin/plans");
    boolean isDestinations = currentUri.contains("/admin/destinations");
    boolean isReviews = currentUri.contains("/admin/reviews");
    boolean isCommunity = currentUri.contains("/admin/community");
    boolean isContent = currentUri.contains("/admin/content");
    boolean isActivities = currentUri.contains("/admin/activities");
    boolean isActivityLog = currentUri.contains("/admin/logs");
    boolean isSettings = currentUri.contains("/admin/settings");
%>

<aside class="admin-sidebar" id="adminSidebar">
    <!-- Voyastra Branding -->
    <div class="voyastra-branding">
        <svg class="voyastra-icon" width="28" height="28" viewBox="0 -1 26 26" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--color-primary);">
            <path d="M 22 2 L 15 22 L 11 13 L 2 9 L 22 2 L 11 13" />
            <path d="M -4 -3 L 5 0 L -4 3 L -2 0 Z" fill="#06b6d4" stroke="none" />
        </svg>
        <span class="voyastra-logo-text">Voyastra</span>
    </div>

    <a href="${pageContext.request.contextPath}/admin" class="admin-nav-item <%= isDashboard ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
        Dashboard
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/users" class="admin-nav-item <%= isUsers ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
        Manage Users
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/bookings" class="admin-nav-item <%= isBookings ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
        Manage Bookings
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/plans" class="admin-nav-item <%= isPlans ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
        Manage Plans
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/destinations" class="admin-nav-item <%= isDestinations ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
        Destinations
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/reviews" class="admin-nav-item <%= isReviews ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
        Reviews
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/community" class="admin-nav-item <%= isCommunity ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
        Community
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/content" class="admin-nav-item <%= isContent ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="9" y1="21" x2="9" y2="9"/></svg>
        Content
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/activities" class="admin-nav-item <%= isActivities ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 2v20M2 12h20M12 2l5 5M12 2L7 7M12 22l5-5M12 22l-5-5"/></svg>
        Activities
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/logs" class="admin-nav-item <%= isActivityLog ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
        Activity Log
    </a>
    
    <a href="${pageContext.request.contextPath}/admin/settings" class="admin-nav-item <%= isSettings ? "active" : "" %>">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
        Settings
    </a>
</aside>
