<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Overview Section -->
<section id="dashboard" class="admin-section active">
    <h2>Dashboard Overview</h2>
    <p class="text-muted mb-6">Welcome back, Admin. Here's what's happening today.</p>
    
    <div class="grid grid-stats gap-6" style="grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));">
        
        <!-- Total Users -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Total Users</div>
                <div class="stat-value mt-2" id="statUsers">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(16,185,129,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #10b981;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            </div>
        </div>

        <!-- Premium Users -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Premium Users</div>
                <div class="stat-value mt-2" id="statPremiumUsers">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(236,72,153,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #ec4899;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            </div>
        </div>

        <!-- Total Bookings -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Total Bookings</div>
                <div class="stat-value mt-2" id="statBookings">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(59, 130, 246, 0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #3b82f6;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            </div>
        </div>

        <!-- Today's Bookings -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Today's Bookings</div>
                <div class="stat-value mt-2" id="statTodaysBookings">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(249,115,22,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #f97316;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            </div>
        </div>

        <!-- Completed Bookings -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Completed Bookings</div>
                <div class="stat-value mt-2" id="statCompletedBookings">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(16,185,129,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #10b981;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            </div>
        </div>

        <!-- Pending Bookings -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Pending Bookings</div>
                <div class="stat-value mt-2" id="statPendingBookings">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(251,191,36,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #fbbf24;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            </div>
        </div>

        <!-- Cancelled Bookings -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Cancelled Bookings</div>
                <div class="stat-value mt-2" id="statCancelledBookings">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(239,68,68,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #ef4444;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
            </div>
        </div>

        <!-- Total Revenue -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Total Revenue</div>
                <div class="stat-value mt-2" id="statRevenue">$0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(251,191,36,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #fbbf24;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            </div>
        </div>

        <!-- This Month Revenue -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">This Month Revenue</div>
                <div class="stat-value mt-2" id="statThisMonthRevenue">$0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(139,92,246,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #8b5cf6;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg>
            </div>
        </div>

        <!-- Total Plans -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Total Plans</div>
                <div class="stat-value mt-2" id="statPlans">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(79,70,229,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #4f46e5;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
            </div>
        </div>

        <!-- Destinations -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Destinations</div>
                <div class="stat-value mt-2" id="statDests">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(6,182,212,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #06b6d4;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            </div>
        </div>

        <!-- Total Reviews -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Total Reviews</div>
                <div class="stat-value mt-2" id="statReviews">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(99,102,241,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #6366f1;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
            </div>
        </div>

        <!-- Total Activities -->
        <div class="stat-card flex flex-row items-center justify-between">
            <div>
                <div class="stat-label">Total Activities</div>
                <div class="stat-value mt-2" id="statActivities">0</div>
            </div>
            <div style="width: 48px; height: 48px; background: rgba(14,165,233,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #0ea5e9;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            </div>
        </div>

    </div>
    
    <!-- Dashboard Analytics -->
    <div class="mt-8">
        <h3 class="mb-6 text-xs font-bold" style="color: var(--text-muted); text-transform:uppercase; letter-spacing:0.05em;">Platform Analytics</h3>
        <div class="grid grid-cols-2 gap-6">

            <div class="stat-card">
                <div class="font-semibold mb-4">Destination Popularity</div>
                <div id="destBarChart" class="flex flex-col gap-2"></div>
            </div>

            <div class="stat-card">
                <div class="font-semibold mb-4">Review Activity</div>
                <div class="flex flex-col gap-3">
                    <div>
                        <div class="flex justify-between mb-2 text-sm"><span>Approved</span><span id="approvedPct">-</span></div>
                        <div class="progress-bar-wrap"><div id="approvedBar" class="progress-bar-fill" style="background: #10b981;"></div></div>
                    </div>
                    <div>
                        <div class="flex justify-between mb-2 text-sm"><span>Pending</span><span id="pendingPct">-</span></div>
                        <div class="progress-bar-wrap"><div id="pendingBar" class="progress-bar-fill" style="background: #fbbf24;"></div></div>
                    </div>
                    <div class="mt-2">
                        <div class="flex justify-between mb-2 text-sm"><span>Active Users (UI)</span><span class="font-semibold" style="color:#4f46e5;">2,854</span></div>
                        <div class="progress-bar-wrap"><div class="progress-bar-fill" style="width:72%; background: #4f46e5;"></div></div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/analytics.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadAnalytics === 'function') loadAnalytics();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
