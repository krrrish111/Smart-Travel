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
    }

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
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
    }

    .stat-card {
        background: var(--surface-glass);
        border: 1px solid var(--color-border);
        border-radius: 24px;
        padding: 24px;
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
        font-size: 0.85rem;
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
        <div class="nav-item active" onclick="switchSection('overview')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            Overview
        </div>
        <div class="nav-item" onclick="switchSection('edit-profile')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Edit Profile
        </div>
        <div class="nav-item" onclick="switchSection('bookings')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            My Bookings
        </div>
        <div class="nav-item" onclick="switchSection('saved-plans')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
            Saved Plans
        </div>
        <div class="nav-item" onclick="switchSection('security')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Security
        </div>
        <div class="nav-item" onclick="switchSection('settings')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
            Settings
        </div>
    </aside>

    <!-- Main Content -->
    <main class="dashboard-main">
        
        <!-- Header Card -->
        <div class="profile-header-card">
            <div class="avatar-wrapper">
                <img src="${not empty user.profileImage ? user.profileImage : 'https://ui-avatars.com/api/?name=' + user.name + '&background=ff6b00&color=fff'}" alt="${user.name}" class="profile-avatar" id="profileImgPreview">
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
                <button class="btn btn-primary" onclick="switchSection('edit-profile')">Edit Account Details</button>
            </div>
        </div>

        <!-- Stats -->
        <div class="stats-grid">
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
        <section id="overview" class="content-section active">
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
        <section id="edit-profile" class="content-section">
            <h2 class="section-title">Account Details</h2>
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
                        <label class="form-label">Email (Read-only)</label>
                        <input type="email" class="form-control" value="${user.email}" readonly style="opacity: 0.7;">
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
        <section id="bookings" class="content-section">
            <h2 class="section-title">My Bookings</h2>
            <div class="booking-list">
                <c:forEach var="b" items="${bookings}">
                    <div class="booking-item">
                        <div class="booking-main">
                            <div class="booking-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                            </div>
                            <div>
                                <div style="font-weight: 600;">${b.planTitle}</div>
                                <div style="color: var(--text-secondary); font-size: 0.85rem;">Booking ID: #${b.id}</div>
                            </div>
                        </div>
                        <div style="text-align: right;">
                            <div style="font-weight: 700;">$${b.totalPrice}</div>
                            <span class="status-pill status-${b.status.toLowerCase()}">${b.status}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Saved Plans Section -->
        <section id="saved-plans" class="content-section">
            <h2 class="section-title">Saved Itineraries</h2>
            <div class="stats-grid" style="grid-template-columns: 1fr 1fr;">
                <c:forEach var="plan" items="${savedPlans}">
                    <div class="stat-card" style="text-align: left; padding: 20px;">
                        <h3 style="margin-bottom: 5px;">${plan.title}</h3>
                        <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 15px;">${plan.destination}</p>
                        <a href="${pageContext.request.contextPath}/itinerary?id=${plan.id}" class="btn btn-outline btn-sm">View Itinerary</a>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Security Section -->
        <section id="security" class="content-section">
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
        <section id="settings" class="content-section">
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
        const navItems = document.querySelectorAll('.nav-item');
        navItems.forEach(item => {
            if(item.textContent.toLowerCase().includes(sectionId.replace('-', ' '))) {
                item.classList.add('active');
            }
        });
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
            showToast('Success: ' + urlParams.get('success').replace('_', ' '), 'success');
        }
        if(urlParams.has('error')) {
            showToast('Error: ' + urlParams.get('error').replace('_', ' '), 'error');
        }
    };
</script>

