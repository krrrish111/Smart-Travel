<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    :root {
        --profile-sidebar-width: 280px;
    }

    body {
        background: radial-gradient(circle at top right, rgba(255, 107, 0, 0.05), transparent),
                    radial-gradient(circle at bottom left, rgba(0, 122, 255, 0.05), transparent),
                    #0a0a0a;
    }

    .dashboard-container {
        max-width: 1400px;
        margin: 40px auto;
        padding: 0 20px;
        display: grid;
        grid-template-columns: var(--profile-sidebar-width) 1fr;
        gap: 30px;
        position: relative;
        z-index: 1;
    }

    /* Disable the fixed scroll-line on profile to prevent click blocking */
    .scroll-line-container { display: none !important; }

    /* Sidebar Navigation */
    .profile-sidebar {
        background: var(--surface-glass);
        backdrop-filter: blur(12px);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 24px;
        height: fit-content;
        position: sticky;
        top: 100px;
    }

    .nav-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 18px;
        border-radius: 12px;
        color: var(--text-secondary);
        text-decoration: none;
        transition: all 0.3s ease;
        margin-bottom: 8px;
        font-weight: 500;
        cursor: pointer;
    }

    .nav-item:hover {
        background: rgba(255, 255, 255, 0.05);
        color: var(--text-primary);
    }

    .nav-item.active {
        background: var(--color-primary);
        color: white;
    }

    /* Main Content */
    .dashboard-main {
        display: flex;
        flex-direction: column;
        gap: 30px;
    }

    /* Profile Header */
    .profile-header-card {
        background: var(--surface-glass);
        backdrop-filter: blur(20px);
        border: 1px solid var(--color-border);
        border-radius: 30px;
        padding: 40px;
        display: flex;
        align-items: center;
        gap: 30px;
        position: relative;
        overflow: hidden;
    }

    .profile-header-card::before {
        content: '';
        position: absolute;
        top: 0; right: 0;
        width: 300px; height: 300px;
        background: radial-gradient(circle, var(--color-primary-faded), transparent 70%);
        opacity: 0.1;
        z-index: 0;
    }

    .avatar-wrapper {
        position: relative;
        width: 140px;
        height: 140px;
        z-index: 1;
    }

    .profile-avatar {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid var(--color-primary);
        box-shadow: 0 0 30px rgba(255, 107, 0, 0.2);
    }

    .avatar-edit-overlay {
        position: absolute;
        bottom: 0; right: 0;
        background: var(--color-primary);
        width: 36px; height: 36px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        border: 3px solid #0a0a0a;
        transition: transform 0.3s ease;
    }

    .avatar-edit-overlay:hover {
        transform: scale(1.1);
    }

    .header-info {
        z-index: 1;
    }

    .header-info h1 {
        font-size: 2rem;
        margin-bottom: 8px;
        background: linear-gradient(to right, #fff, #aaa);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    .header-info p {
        color: var(--text-secondary);
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 15px;
    }

    .badge {
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        background: rgba(255, 107, 0, 0.1);
        color: var(--color-primary);
        border: 1px solid var(--color-primary-faded);
    }

    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: var(--surface-glass);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 24px 15px;
        text-align: center;
        transition: transform 0.3s ease;
    }

    .stat-card:hover {
        transform: translateY(-5px);
        border-color: var(--color-primary-faded);
    }

    .stat-value {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 5px;
        color: var(--text-primary);
    }

    .stat-label {
        font-size: 0.75rem;
        color: var(--text-secondary);
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* Content Sections */
    .content-section {
        background: var(--surface-glass);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 30px;
        display: none; /* Hidden by default, toggled via JS */
    }

    .content-section.active {
        display: block;
        animation: fadeIn 0.4s ease forwards;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .section-title {
        font-size: 1.4rem;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    /* Forms */
    .profile-form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .full-width {
        grid-column: span 2;
    }

    .form-label {
        display: block;
        margin-bottom: 8px;
        color: var(--text-secondary);
        font-size: 0.9rem;
    }

    .form-control {
        width: 100%;
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid var(--color-border);
        border-radius: 12px;
        padding: 12px 16px;
        color: white;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        border-color: var(--color-primary);
        background: rgba(255, 255, 255, 0.05);
        outline: none;
        box-shadow: 0 0 0 4px var(--color-primary-faded);
    }

    /* Booking List */
    .booking-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .booking-item {
        background: rgba(255, 255, 255, 0.02);
        border: 1px solid var(--color-border);
        border-radius: 16px;
        padding: 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        transition: all 0.3s ease;
    }

    .booking-item:hover {
        background: rgba(255, 255, 255, 0.04);
        border-color: var(--color-primary-faded);
    }

    .booking-main {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .booking-icon {
        width: 48px; height: 48px;
        background: var(--color-primary-faded);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--color-primary);
    }

    .status-pill {
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
    }

    .status-confirmed { background: rgba(0, 255, 136, 0.1); color: #00ff88; }
    .status-pending { background: rgba(255, 184, 0, 0.1); color: #ffb800; }
    .status-completed { background: rgba(0, 122, 255, 0.1); color: #007aff; }

    /* Delete Account */
    .danger-zone {
        border-color: rgba(255, 59, 48, 0.3);
        background: rgba(255, 59, 48, 0.02);
    }

    .btn-danger {
        background: #ff3b30;
        color: white;
        border: none;
        padding: 12px 24px;
        border-radius: 12px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .btn-danger:hover {
        background: #d32f2f;
        box-shadow: 0 0 20px rgba(255, 59, 48, 0.4);
    }

    @media (max-width: 992px) {
        .dashboard-container {
            grid-template-columns: 1fr;
        }
        .profile-sidebar {
            position: static;
            display: flex;
            overflow-x: auto;
            gap: 10px;
            padding: 10px;
        }
        .nav-item { margin-bottom: 0; white-space: nowrap; }
        .stats-grid { grid-template-columns: repeat(2, 1fr); }
        .profile-form-grid { grid-template-columns: 1fr; }
        .full-width { grid-column: span 1; }
    }
</style>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="profile-sidebar">
        <div class="nav-item ${activeTab == 'overview' ? 'active' : ''}" onclick="switchSection('overview')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            Overview
        </div>
        <div class="nav-item ${activeTab == 'edit-profile' ? 'active' : ''}" onclick="switchSection('edit-profile')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Edit Profile
        </div>
        <div class="nav-item ${activeTab == 'bookings' ? 'active' : ''}" onclick="switchSection('bookings')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            My Bookings
        </div>
        <div class="nav-item ${activeTab == 'saved-plans' ? 'active' : ''}" onclick="switchSection('saved-plans')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
            Saved Plans
        </div>
        <div class="nav-item ${activeTab == 'wishlist' ? 'active' : ''}" onclick="switchSection('wishlist')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
            Wishlist & History
        </div>
        <div class="nav-item ${activeTab == 'security' ? 'active' : ''}" onclick="switchSection('security')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Security
        </div>
        <div class="nav-item ${activeTab == 'settings' ? 'active' : ''}" onclick="switchSection('settings')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
            Settings
        </div>
    </aside>

    <!-- Main Content -->
    <main class="dashboard-main">
        
        <!-- Header Card -->
        <div class="profile-header-card">
            <div class="avatar-wrapper">
                <c:set var="avatarUrl" value="https://ui-avatars.com/api/?name=${user.name}&background=ff6b00&color=fff" />
                <img src="${not empty user.profileImage ? user.profileImage : avatarUrl}" alt="${user.name}" class="profile-avatar" id="profileImgPreview">
                <label for="profileUploadInput" class="avatar-edit-overlay">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                </label>
            </div>
            <div class="header-info">
                <h1>${user.name}</h1>
                <p>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                    ${user.email}
                    <span class="badge">${user.role}</span>
                </p>
                <p class="user-bio-header" style="margin-top: 10px; opacity: 0.8; font-style: italic;">
                    ${not empty user.bio ? user.bio : 'Adventure awaits! Add a bio to tell others about your travel style.'}
                </p>
                <button class="btn btn-primary" style="margin-top: 15px;" onclick="switchSection('edit-profile')">Edit Account Details</button>
            </div>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value" style="color:var(--color-primary);">₹${user.walletBalance}</div>
                <div class="stat-label">Wallet Balance</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" style="color:#FFD700;">${user.loyaltyPoints}</div>
                <div class="stat-label">Loyalty Points</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${totalTrips}</div>
                <div class="stat-label">Total Trips</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${completedTrips}</div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${upcomingTrips}</div>
                <div class="stat-label">Upcoming</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${savedCount}</div>
                <div class="stat-label">Saved Plans</div>
            </div>
        </div>

        <!-- Sections -->
        
        <!-- Overview Section -->
        <section id="overview" class="content-section ${activeTab == 'overview' ? 'active' : ''}">
            <h2 class="section-title">Recent Activity</h2>
            <div class="booking-list">
                <c:choose>
                    <c:when test="${not empty bookings}">
                        <c:forEach var="b" items="${bookings}" end="2">
                            <div class="booking-item">
                                <div class="booking-main">
                                    <div class="booking-icon">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                    </div>
                                    <div>
                                        <div style="font-weight: 600; font-size: 1.1rem;">${b.planTitle}</div>
                                        <div style="color: var(--text-secondary); font-size: 0.9rem;">Booked on <fmt:formatDate value="${b.createdAt}" pattern="MMM dd, yyyy"/></div>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 700; color: white;">$${b.totalPrice}</div>
                                    <span class="status-pill status-${b.status.toLowerCase()}">${b.status}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: var(--text-secondary); text-align: center; padding: 40px;">No recent bookings found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <button class="btn btn-outline" style="margin-top: 20px; width: 100%;" onclick="switchSection('bookings')">View All Bookings</button>
        </section>

        <!-- Edit Profile Section -->
        <section id="edit-profile" class="content-section ${activeTab == 'edit-profile' ? 'active' : ''}">
            <h2 class="section-title">Account Details</h2>
            
            <c:if test="${param.success == 'true'}">
                <div style="background: rgba(40, 167, 69, 0.2); color: #28a745; padding: 15px; border-radius: 12px; margin-bottom: 20px; border: 1px solid #28a745;">
                    Profile updated successfully!
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div style="background: rgba(220, 53, 69, 0.2); color: #dc3545; padding: 15px; border-radius: 12px; margin-bottom: 20px; border: 1px solid #dc3545;">
                    Update failed. Please try again.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/profile" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updateProfile">
                <div class="profile-form-grid">
                    <div class="form-group full-width">
                        <label class="form-label">Profile Photo</label>
                        <input type="file" name="profileImage" id="profileUploadInput" class="form-control" accept="image/*" onchange="previewImage(this)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="name" class="form-control" value="${user.name}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control" value="${user.email}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input type="tel" name="phone" class="form-control" value="${user.phone}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Location</label>
                        <input type="text" name="location" class="form-control" value="${user.location}" placeholder="e.g. New York, USA">
                    </div>
                    <div class="form-group full-width">
                        <label class="form-label">Bio / About Me</label>
                        <textarea name="bio" class="form-control" rows="4" placeholder="Tell us about your travel style...">${user.bio}</textarea>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary" style="padding: 14px 30px;">Save Changes</button>
            </form>
        </section>

        <!-- Bookings Section -->
        <section id="bookings" class="content-section ${activeTab == 'bookings' ? 'active' : ''}">
            <h2 class="section-title">My Bookings</h2>
            
            <!-- Primary Filter: Status -->
            <div style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap;">
                <button class="btn btn-outline" onclick="showBookingStatus('all')" id="tab-status-all" style="border-color:var(--color-primary); color:white;">All</button>
                <button class="btn btn-outline" onclick="showBookingStatus('upcoming')" id="tab-status-upcoming">Upcoming</button>
                <button class="btn btn-outline" onclick="showBookingStatus('past')" id="tab-status-past">Past</button>
                <button class="btn btn-outline" onclick="showBookingStatus('cancelled')" id="tab-status-cancelled">Cancelled</button>
            </div>

            <!-- Secondary Filter: Type -->
            <div style="display: flex; gap: 15px; margin-bottom: 30px; border-bottom: 1px solid var(--color-border); padding-bottom: 15px; overflow-x: auto; white-space: nowrap;">
                <button class="type-tab active" onclick="showBookingType('all')" id="tab-type-all" style="background:none; border:none; color:var(--color-primary); font-weight:bold; font-size:1.1rem; cursor:pointer;">All Bookings</button>
                <button class="type-tab" onclick="showBookingType('flights')" id="tab-type-flights" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Flights</button>
                <button class="type-tab" onclick="showBookingType('hotels')" id="tab-type-hotels" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Hotels</button>
                <button class="type-tab" onclick="showBookingType('trains')" id="tab-type-trains" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Trains</button>
                <button class="type-tab" onclick="showBookingType('buses')" id="tab-type-buses" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Buses</button>
                <button class="type-tab" onclick="showBookingType('cabs')" id="tab-type-cabs" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Cabs</button>
                <button class="type-tab" onclick="showBookingType('cars')" id="tab-type-cars" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Cars</button>
                <button class="type-tab" onclick="showBookingType('cruises')" id="tab-type-cruises" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Cruises</button>
                <button class="type-tab" onclick="showBookingType('helicopters')" id="tab-type-helicopters" style="background:none; border:none; color:var(--text-secondary); font-weight:600; font-size:1rem; cursor:pointer;">Helicopters</button>
            </div>

            <div id="all-bookings-container">
                <!-- FLIGHTS -->
                <div class="booking-category" id="cat-flights">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">✈ Flights</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty flightBookings}">
                                <c:forEach var="f" items="${flightBookings}">
                                    <div class="booking-item booking-card-status" data-status="${f.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: white; overflow: hidden; padding: 5px;">
                                                <img src="${f.airlineLogo}" alt="${f.airlineName}" style="width: 100%; height: 100%; object-fit: contain;">
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${f.airlineName} <span style="color:var(--text-secondary); font-weight: normal;">| ${f.flightNumber}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>PNR:</strong> ${f.pnr} &nbsp;|&nbsp; <strong>Date:</strong> ${f.travelDate} &nbsp;|&nbsp; <strong>Travellers:</strong> ${f.travellerCount} &nbsp;|&nbsp; <strong>Class:</strong> ${f.seatClass}
                                                </div>
                                                <div style="font-weight: 600; margin-top: 5px;">
                                                    ${f.departureCity} <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg> ${f.arrivalCity}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${f.status.toLowerCase() == 'confirmed' ? 'completed' : f.status.toLowerCase()}" style="margin-right:10px;">${f.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${f.totalPrice}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/ticket?pnr=${f.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Ticket</a>
                                                <a href="${pageContext.request.contextPath}/ticket-download?pnr=${f.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">Download Ticket</a>
                                                <button class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;" onclick="window.print()">Print Ticket</button>
                                                <c:if test="${f.status != 'CANCELLED' && f.status != 'COMPLETED'}">
                                                    <button type="button" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="openCancelModal('${f.id}', '${f.totalPrice}', 'flight')">Cancel</button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">✈ No flight bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- HOTELS -->
                <div class="booking-category" id="cat-hotels" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🏨 Hotels</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty hotelBookings}">
                                <c:forEach var="h" items="${hotelBookings}">
                                    <div class="booking-item booking-card-status" data-status="${h.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="width: 80px; height: 80px; border-radius: 12px; overflow: hidden; padding:0;">
                                                <img src="${not empty h.hotel.imageUrl ? h.hotel.imageUrl : 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=200&q=80'}" alt="${h.hotel.name}" style="width: 100%; height: 100%; object-fit: cover;">
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${h.hotel.name}</div>
                                                <div style="color: var(--color-primary); font-size: 0.95rem; margin-top: 2px;">${h.room.type}</div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Check-In:</strong> ${h.checkIn} &nbsp;|&nbsp; <strong>Check-Out:</strong> ${h.checkOut} &nbsp;|&nbsp; <strong>Guests:</strong> ${h.guests}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${h.status.toLowerCase() == 'confirmed' ? 'completed' : h.status.toLowerCase()}" style="margin-right:10px;">${h.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${h.totalPrice}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/hotel-confirmation?id=${h.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Voucher</a>
                                                <a href="${pageContext.request.contextPath}/hotel-voucher?id=${h.id}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Download Voucher</a>
                                                <c:if test="${h.status != 'CANCELLED' && h.status != 'COMPLETED'}">
                                                    <button type="button" class="btn btn-danger" style="padding: 6px 12px; font-size: 0.8rem;" onclick="openCancelModal('${h.id}', '${h.totalPrice}', 'hotel')">Cancel</button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🏨 No hotel bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- TRAINS -->
                <div class="booking-category" id="cat-trains" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚆 Trains</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty trainBookings}">
                                <c:forEach var="t" items="${trainBookings}">
                                    <div class="booking-item booking-card-status" data-status="${t.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚆
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${t.trainName} <span style="color:var(--text-secondary); font-weight: normal;">| ${t.trainNumber}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>PNR:</strong> ${t.pnr} &nbsp;|&nbsp; <strong>Date:</strong> ${t.travelDate} &nbsp;|&nbsp; <strong>Class:</strong> ${t.travelClass}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${t.status.toLowerCase() == 'confirmed' ? 'completed' : t.status.toLowerCase()}" style="margin-right:10px;">${t.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${t.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/train/confirmation?bookingRef=${t.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/train-ticket?bookingRef=${t.pnr}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚆 No train bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- BUSES -->
                <div class="booking-category" id="cat-buses" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚌 Buses</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty busBookings}">
                                <c:forEach var="b" items="${busBookings}">
                                    <div class="booking-item booking-card-status" data-status="${b.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚌
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${b.operator} <span style="color:var(--text-secondary); font-weight: normal;">| ${b.busType}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>PNR:</strong> ${b.pnr} &nbsp;|&nbsp; <strong>Date:</strong> ${b.travelDate}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${b.status.toLowerCase() == 'confirmed' ? 'completed' : b.status.toLowerCase()}" style="margin-right:10px;">${b.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${b.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/bus/confirmation?bookingRef=${b.pnr}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/bus-ticket?bookingRef=${b.pnr}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Ticket</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚌 No bus bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CABS -->
                <div class="booking-category" id="cat-cabs" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚕 Cabs</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty cabBookings}">
                                <c:forEach var="c" items="${cabBookings}">
                                    <div class="booking-item booking-card-status" data-status="${c.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚕
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${c.vehicleModel} <span style="color:var(--text-secondary); font-weight: normal;">| ${c.provider}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${c.bookingRef} &nbsp;|&nbsp; <strong>Date:</strong> ${c.pickupDate} ${c.pickupTime}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${c.status.toLowerCase() == 'confirmed' ? 'completed' : c.status.toLowerCase()}" style="margin-right:10px;">${c.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${c.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/cab/confirmation?bookingRef=${c.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/cab-ticket?bookingRef=${c.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚕 No cab bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CARS -->
                <div class="booking-category" id="cat-cars" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚖 Self Drive Cars</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty carBookings}">
                                <c:forEach var="car" items="${carBookings}">
                                    <div class="booking-item booking-card-status" data-status="${car.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚖
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${car.vehicleModel}</div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${car.bookingRef} &nbsp;|&nbsp; <strong>Duration:</strong> ${car.pickupDate} to ${car.returnDate}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${car.status.toLowerCase() == 'confirmed' ? 'completed' : car.status.toLowerCase()}" style="margin-right:10px;">${car.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${car.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/car/confirmation?bookingRef=${car.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/car-ticket?bookingRef=${car.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚖 No self-drive car bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CRUISES -->
                <div class="booking-category" id="cat-cruises" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚢 Cruises</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty cruiseBookings}">
                                <c:forEach var="cr" items="${cruiseBookings}">
                                    <div class="booking-item booking-card-status" data-status="${cr.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚢
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${cr.cruiseLine} <span style="color:var(--text-secondary); font-weight: normal;">| ${cr.shipName}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${cr.bookingRef} &nbsp;|&nbsp; <strong>Date:</strong> ${cr.cruiseDate} &nbsp;|&nbsp; <strong>Cabin:</strong> ${cr.cabinType}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${cr.status.toLowerCase() == 'confirmed' ? 'completed' : cr.status.toLowerCase()}" style="margin-right:10px;">${cr.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${cr.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/cruise/confirmation?bookingRef=${cr.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/cruise-ticket?bookingRef=${cr.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚢 No cruise bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- HELICOPTERS -->
                <div class="booking-category" id="cat-helicopters" style="margin-top: 40px;">
                    <h3 style="margin-bottom: 15px; color: var(--text-primary);">🚁 Helicopters</h3>
                    <div class="booking-list">
                        <c:choose>
                            <c:when test="${not empty heliBookings}">
                                <c:forEach var="h" items="${heliBookings}">
                                    <div class="booking-item booking-card-status" data-status="${h.status.toLowerCase()}">
                                        <div class="booking-main" style="flex:1;">
                                            <div class="booking-icon" style="background: rgba(255, 107, 0, 0.1); border-radius: 12px; padding: 15px;">
                                                🚁
                                            </div>
                                            <div style="flex:1;">
                                                <div style="font-weight: 700; font-size: 1.1rem;">${h.operator} <span style="color:var(--text-secondary); font-weight: normal;">| ${h.flightClass}</span></div>
                                                <div style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px;">
                                                    <strong>Booking Ref:</strong> ${h.bookingRef} &nbsp;|&nbsp; <strong>Date:</strong> ${h.travelDate}
                                                </div>
                                            </div>
                                        </div>
                                        <div style="text-align: right; display:flex; flex-direction:column; gap:8px;">
                                            <div>
                                                <span class="status-pill status-${h.status.toLowerCase() == 'confirmed' ? 'completed' : h.status.toLowerCase()}" style="margin-right:10px;">${h.status}</span>
                                                <span style="font-weight: 800; font-size: 1.2rem; color:var(--color-primary);">₹${h.totalFare}</span>
                                            </div>
                                            <div style="display:flex; gap:5px; justify-content: flex-end; margin-top:10px;">
                                                <a href="${pageContext.request.contextPath}/transport/helicopter/confirmation?bookingRef=${h.bookingRef}" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.8rem;">View Details</a>
                                                <a href="${pageContext.request.contextPath}/transport/helicopter-ticket?bookingRef=${h.bookingRef}" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.8rem;">Print Voucher</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 30px; text-align: center; border: 1px dashed var(--color-border); border-radius: 12px;">
                                    <p style="color: var(--text-secondary); font-size: 1.1rem;">🚁 No helicopter bookings found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>

            <script>
                // State variables
                let currentStatusFilter = 'all'; // Show all bookings by default
                let currentTypeFilter = 'all';

                function showBookingStatus(status) {
                    currentStatusFilter = status;
                    
                    // Update Status Tabs UI
                    ['all', 'upcoming', 'past', 'cancelled'].forEach(s => {
                        let btn = document.getElementById('tab-status-' + s);
                        if(btn) {
                            btn.style.borderColor = (s === status) ? 'var(--color-primary)' : 'var(--color-border)';
                            btn.style.color = (s === status) ? 'white' : 'var(--text-secondary)';
                        }
                    });

                    applyFilters();
                }

                function showBookingType(type) {
                    currentTypeFilter = type;
                    
                    // Update Type Tabs UI
                    ['all', 'flights', 'hotels', 'trains', 'buses', 'cabs', 'cars', 'cruises', 'helicopters'].forEach(t => {
                        let btn = document.getElementById('tab-type-' + t);
                        if(btn) {
                            btn.style.color = (t === type) ? 'var(--color-primary)' : 'var(--text-secondary)';
                            btn.style.fontWeight = (t === type) ? 'bold' : '600';
                        }
                    });

                    // Show/Hide Categories based on Type Filter
                    ['flights', 'hotels', 'trains', 'buses', 'cabs', 'cars', 'cruises', 'helicopters'].forEach(cat => {
                        let el = document.getElementById('cat-' + cat);
                        if(el) {
                            if (type === 'all' || type === cat) {
                                el.style.display = 'block';
                            } else {
                                el.style.display = 'none';
                            }
                        }
                    });

                    applyFilters();
                }

                function applyFilters() {
                    let cards = document.querySelectorAll('.booking-card-status');
                    cards.forEach(card => {
                        let cardStatus = card.getAttribute('data-status');
                        let showCard = false;
                        if (currentStatusFilter === 'all') {
                            showCard = true;
                        } else if (currentStatusFilter === 'cancelled' && cardStatus === 'cancelled') {
                            showCard = true;
                        } else if (currentStatusFilter === 'upcoming' && (cardStatus === 'confirmed' || cardStatus === 'pending')) {
                            showCard = true;
                        } else if (currentStatusFilter === 'past' && cardStatus === 'completed') {
                            showCard = true;
                        }
                        card.style.display = showCard ? 'flex' : 'none';
                    });
                }
                // Initialize: show all bookings on load
                document.addEventListener('DOMContentLoaded', function() {
                    applyFilters();
                    // Init status button UI to match default
                    document.getElementById('tab-status-upcoming').style.borderColor = 'var(--color-border)';
                    document.getElementById('tab-status-upcoming').style.color = 'var(--text-secondary)';
                });
            </script>
        </section>


        <!-- Saved Plans Section -->
        <section id="saved-plans" class="content-section ${activeTab == 'saved-plans' ? 'active' : ''}">
            <h2 class="section-title">Saved Itineraries</h2>
            <div class="stats-grid" style="grid-template-columns: 1fr 1fr;">
                <c:forEach var="plan" items="${savedPlans}">
                    <div class="stat-card" style="text-align: left; padding: 20px;">
                        <h3 style="margin-bottom: 5px;">${plan.title}</h3>
                        <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 15px;">${plan.destination}</p>
                        <a href="${pageContext.request.contextPath}/itinerary?id=${plan.id}" class="btn btn-outline btn-sm">View Itinerary</a>
                    </div>
                </c:forEach>
                <c:if test="${empty savedPlans}">
                    <p style="color: var(--text-secondary); grid-column: span 2;">No saved itineraries.</p>
                </c:if>
            </div>
        </section>

        <!-- Wishlist & History Section -->
        <section id="wishlist" class="content-section ${activeTab == 'wishlist' ? 'active' : ''}">
            <h2 class="section-title">My Wishlist</h2>
            <div class="stats-grid" style="grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px;">
                <c:forEach var="hotel" items="${wishlistHotels}">
                    <div class="stat-card" style="padding:0; overflow:hidden; border-radius: 16px; text-align: left;">
                        <img src="${hotel.imageUrl}" alt="${hotel.name}" style="width: 100%; height: 120px; object-fit: cover;">
                        <div style="padding: 15px;">
                            <h3 style="font-size: 1.1rem; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${hotel.name}</h3>
                            <p style="color: var(--text-secondary); font-size: 0.85rem; margin-bottom: 10px;">${hotel.city}</p>
                            <a href="${pageContext.request.contextPath}/hotel-details?id=${hotel.id}" class="btn btn-primary" style="width: 100%; padding: 8px;">View Hotel</a>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty wishlistHotels}">
                    <p style="color: var(--text-secondary); grid-column: span 3;">Your wishlist is empty.</p>
                </c:if>
            </div>
            
            <h2 class="section-title" style="margin-top: 40px;">Recently Viewed</h2>
            <div class="stats-grid" style="grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px;">
                <c:forEach var="hotel" items="${recentlyViewedHotels}">
                    <div class="stat-card" style="padding:0; overflow:hidden; border-radius: 16px; text-align: left; opacity: 0.8;">
                        <img src="${hotel.imageUrl}" alt="${hotel.name}" style="width: 100%; height: 120px; object-fit: cover; filter: grayscale(20%);">
                        <div style="padding: 15px;">
                            <h3 style="font-size: 1.1rem; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${hotel.name}</h3>
                            <p style="color: var(--text-secondary); font-size: 0.85rem; margin-bottom: 10px;">${hotel.city}</p>
                            <a href="${pageContext.request.contextPath}/hotel-details?id=${hotel.id}" class="btn btn-outline" style="width: 100%; padding: 8px;">View Again</a>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty recentlyViewedHotels}">
                    <p style="color: var(--text-secondary); grid-column: span 3;">No recently viewed hotels.</p>
                </c:if>
            </div>
        </section>

        <!-- Security Section -->
        <section id="security" class="content-section ${activeTab == 'security' ? 'active' : ''}">
            <h2 class="section-title">Security & Password</h2>
            <form action="${pageContext.request.contextPath}/profile" method="POST" style="max-width: 500px;">
                <input type="hidden" name="action" value="changePassword">
                <div class="form-group">
                    <label class="form-label">Current Password</label>
                    <input type="password" name="currentPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">New Password</label>
                    <input type="password" name="newPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Confirm New Password</label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary">Update Password</button>
            </form>
        </section>

        <!-- Settings Section -->
        <section id="settings" class="content-section ${activeTab == 'settings' ? 'active' : ''}">
            <h2 class="section-title">Preferences</h2>
            <div class="form-group">
                <label class="checkbox-container" style="color: white; display: flex; align-items: center; gap: 10px; cursor: pointer;">
                    <input type="checkbox" checked> Email notifications for bookings
                </label>
            </div>
            <div class="form-group">
                <label class="checkbox-container" style="color: white; display: flex; align-items: center; gap: 10px; cursor: pointer;">
                    <input type="checkbox" checked> Marketing & Newsletter
                </label>
            </div>
            
            <hr style="border: 0; border-top: 1px solid var(--color-border); margin: 40px 0;">
            
            <div class="danger-zone content-section active" style="border: 1px solid rgba(255, 59, 48, 0.3); display: block;">
                <h3 style="color: #ff3b30; margin-bottom: 10px;">Danger Zone</h3>
                <p style="color: var(--text-secondary); margin-bottom: 20px;">Deleting your account will permanently remove all your data. This action cannot be undone.</p>
                <form id="deleteAccountForm" action="${pageContext.request.contextPath}/profile" method="POST">
                    <input type="hidden" name="action" value="deleteAccount">
                    <div id="deleteConfirmation" style="display:none;">
                        <p style="color: white; margin-bottom: 10px;">Please type your email <strong>${user.email}</strong> to confirm:</p>
                        <input type="text" name="confirmEmail" class="form-control" style="margin-bottom: 15px;" placeholder="${user.email}">
                        <button type="submit" class="btn-danger">Confirm Permanent Deletion</button>
                    </div>
                </form>
                <button id="deleteBtn" class="btn-danger" onclick="showDeleteConfirm()">Delete My Account</button>
            </div>
        </section>

    </main>
</div>

<!-- Cancel/Refund Modal -->
<div id="cancelModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:1000; justify-content:center; align-items:center;">
    <div style="background:var(--bg-main); width:90%; max-width:500px; padding:30px; border-radius:16px; border:1px solid var(--color-border); box-shadow:0 10px 40px rgba(0,0,0,0.5);">
        <h3 style="margin-top:0; color:var(--text-main);">Cancel Booking</h3>
        <p style="color:var(--text-secondary); margin-bottom:20px;">Please select how you would like to receive your refund for <strong style="color:white;" id="cancelAmountDisplay"></strong>.</p>
        
        <form action="${pageContext.request.contextPath}/profile" method="POST" id="cancelForm">
            <input type="hidden" name="action" value="cancelBooking">
            <input type="hidden" name="bookingId" id="cancelBookingId" value="">
            
            <label style="display:block; padding:15px; border:2px solid var(--color-primary); border-radius:8px; margin-bottom:15px; cursor:pointer; background:rgba(212,165,116,0.1);">
                <input type="radio" name="refundMethod" value="WALLET" checked>
                <strong style="color:var(--color-primary);">Instant Wallet Refund</strong>
                <p style="margin:5px 0 0 0; font-size:0.85rem; color:var(--text-secondary);">Get your refund instantly credited to your Voyastra Wallet. You can use it immediately for your next booking.</p>
            </label>
            
            <label style="display:block; padding:15px; border:1px solid var(--color-border); border-radius:8px; margin-bottom:25px; cursor:pointer;">
                <input type="radio" name="refundMethod" value="ORIGINAL">
                <strong>Original Payment Method</strong>
                <p style="margin:5px 0 0 0; font-size:0.85rem; color:var(--text-secondary);">Takes 3-5 business days to reflect in your bank account or credit card.</p>
            </label>
            
            <div style="display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn btn-outline" onclick="closeCancelModal()">Keep Booking</button>
                <button type="submit" class="btn btn-danger">Confirm Cancellation</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCancelModal(bookingId, amount, type='flight') {
        document.getElementById('cancelBookingId').value = bookingId;
        document.getElementById('cancelAmountDisplay').innerText = '$' + amount;
        
        let actionInput = document.querySelector('#cancelForm input[name="action"]');
        if (type === 'hotel') {
            actionInput.value = 'cancelHotelBooking';
        } else {
            actionInput.value = 'cancelBooking';
        }
        
        document.getElementById('cancelModal').style.display = 'flex';
    }
    function closeCancelModal() {
        document.getElementById('cancelModal').style.display = 'none';
    }
</script>

<%@ include file="/components/footer.jsp" %>

<script>
    function switchSection(sectionId) {
        document.querySelectorAll('.content-section').forEach(section => {
            section.classList.remove('active');
        });
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
        });
        const target = document.getElementById(sectionId);
        if(target) target.classList.add('active');
        
        // Sync Sidebar
        const navItems = document.querySelectorAll('.nav-item');
        navItems.forEach(item => {
            if(item.textContent.toLowerCase().includes(sectionId.replace('-', ' '))) {
                item.classList.add('active');
            }
        });

        // Update URL without refresh
        const newUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?tab=' + sectionId;
        window.history.pushState({path:newUrl},'',newUrl);
    }

    function showDeleteConfirm() {
        document.getElementById('deleteConfirmation').style.display = 'block';
        document.getElementById('deleteBtn').style.display = 'none';
    }

    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('profileImgPreview').src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    window.onload = () => {
        const urlParams = new URLSearchParams(window.location.search);
        if(urlParams.has('success')) {
            const s = urlParams.get('success');
            if (s === 'hotel_cancelled') {
                showToast('Booking cancelled. Refund has been initiated.', 'info');
            } else {
                showToast('Success: ' + s.replace(/_/g, ' '), 'success');
            }
        }
        if(urlParams.has('error')) {
            showToast('Error: ' + urlParams.get('error').replace(/_/g, ' '), 'error');
        }
    };
</script>

