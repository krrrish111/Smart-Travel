<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voyastra - Travel Smarter</title>
    <link rel="icon" type="image/svg+xml" href="images/favicon.svg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400;1,600&family=Poppins:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,700;0,800;1,700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/theme.css">
    <link rel="stylesheet" href="css/animations.css">
    <link rel="stylesheet" href="css/responsive.css">
    <script src="js/loader.js"></script>
    <script src="js/auth-guard.js"></script>
    <script src="js/toast.js"></script>
    <script src="js/validate.js"></script>
    <script>
        (function(){
            var t = localStorage.getItem('theme') || 'dark';
            document.documentElement.setAttribute('data-theme', t);
            /* Also apply to body when it exists — handles selectors targeting body[data-theme] */
            document.addEventListener('DOMContentLoaded', function() {
                document.body.setAttribute('data-theme', t);
            });
        })();
        
        // Expose Java HttpSession state to Frontend JS Context
        window.javaSession = {
            userId: "${sessionScope.user_id}",
            role: "${sessionScope.role}",
            name: "${sessionScope.name}",
            email: "${sessionScope.email}"
        };
    </script>
<%@include file="config.jsp"%>
</head>
<body>
    <nav class="navbar">
        <div class="container nav-container">
            <a href="index.jsp" class="nav-brand voyastra-logo">
                <svg class="voyastra-icon" viewBox="0 -1 26 26" fill="none" stroke="url(#voyastraGradient)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <defs>
                        <linearGradient id="voyastraGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="#4f46e5" />
                            <stop offset="100%" stop-color="#06b6d4" />
                        </linearGradient>
                    </defs>
                    <path class="voyastra-adv-path" d="M 22 2 L 15 22 L 11 13 L 2 9 L 22 2 L 11 13" />
                    <!-- Moving airplane icon -->
                    <path class="voyastra-adv-plane" d="M -4 -3 L 5 0 L -4 3 L -2 0 Z" fill="#06b6d4" stroke="none" />
                </svg>
                <span class="voyastra-text">Voyastra</span>
            </a>
            <div class="nav-actions">
                <div class="nav-links" id="navLinks">
                    <!-- Sidebar header: brand label + close button -->
                    <button class="sidebar-close-btn hide-desktop" id="sidebarCloseBtn" aria-label="Close Menu">
                        <span class="sidebar-brand-label">Voyastra</span>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                    </button>
                    <a href="index.jsp" class="nav-link">Home</a>
                    <a href="explore.jsp" class="nav-link">Explore</a>
                    <a href="community.jsp" class="nav-link">Community</a>
                    <a href="planner.jsp" class="nav-link">Planner</a>
                    <a href="booking" class="nav-link">Bookings</a>
                    <!-- ── Auth widget (Login btn OR avatar menu) ──
                         Hidden by default; JS renders the correct state -->
                    <div id="navAuthWidget" class="nav-auth-widget" style="display:none;"></div>
                </div>

                <!-- Theme toggle -->
                <button class="theme-toggle" id="themeToggle" aria-label="Toggle dark / light mode" title="Toggle theme">
                    <span class="theme-toggle-knob">
                        <!-- Sun icon -->
                        <svg class="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="5"/>
                            <line x1="12" y1="1"  x2="12" y2="3"/>
                            <line x1="12" y1="21" x2="12" y2="23"/>
                            <line x1="4.22" y1="4.22"  x2="5.64" y2="5.64"/>
                            <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
                            <line x1="1"  y1="12" x2="3"  y2="12"/>
                            <line x1="21" y1="12" x2="23" y2="12"/>
                            <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/>
                            <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
                        </svg>
                        <!-- Moon icon -->
                        <svg class="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
                        </svg>
                    </span>
                </button>

                <!-- Mobile Menu Hamburger -->
                <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Toggle navigation">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="3" y1="12" x2="21" y2="12"></line>
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <line x1="3" y1="18" x2="21" y2="18"></line>
                    </svg>
                </button>
            </div>
        </div>
    </nav>
    <div class="nav-overlay" id="navOverlay"></div>

    <!-- ══════════════════════════════════════════════════════════
         NAV AUTH STYLES  (scoped here so they load with the head)
    ══════════════════════════════════════════════════════════════ -->
    <style>
        /* Login button (logged-out state) */
        .nav-login-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 20px;
            border-radius: 30px;
            border: 1.5px solid var(--color-primary);
            background: transparent;
            color: var(--color-primary);
            font-family: 'Poppins', sans-serif;
            font-size: 0.8rem;
            font-weight: 700;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.25s ease, color 0.25s ease,
                        transform 0.2s cubic-bezier(0.34,1.56,0.64,1),
                        box-shadow 0.25s ease;
            white-space: nowrap;
        }
        .nav-login-btn:hover {
            background: var(--color-primary);
            color: #fff;
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 6px 20px rgba(212,165,116,0.35);
        }

        /* Avatar trigger button (logged-in state) */
        .nav-avatar-trigger {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 4px 4px 4px 4px;
            border-radius: 40px;
            border: none;
            background: var(--surface-glass);
            border: 1px solid var(--color-border);
            cursor: pointer;
            transition: background 0.2s ease, box-shadow 0.25s ease,
                        transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }
        .nav-avatar-trigger:hover {
            background: rgba(212,165,116,0.08);
            box-shadow: 0 4px 16px rgba(212,165,116,0.18);
            transform: translateY(-1px);
        }

        .nav-avatar-img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--color-primary);
            flex-shrink: 0;
        }

        .nav-avatar-name {
            font-family: 'Poppins', sans-serif;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-main);
            max-width: 100px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            padding-right: 6px;
        }

        .nav-avatar-chevron {
            color: var(--text-muted);
            flex-shrink: 0;
            margin-right: 4px;
            transition: transform 0.25s ease;
        }
        .nav-avatar-trigger[aria-expanded="true"] .nav-avatar-chevron {
            transform: rotate(180deg);
        }

        /* Dropdown menu */
        .nav-user-dropdown {
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            min-width: 220px;
            background: var(--bg-base);
            border: 1px solid var(--color-border);
            border-radius: 14px;
            padding: 8px;
            box-shadow: 0 16px 48px rgba(0,0,0,0.22), 0 4px 12px rgba(0,0,0,0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            z-index: 2000;
            transform-origin: top right;
            animation: va-pop 0.25s cubic-bezier(0.34,1.56,0.64,1) both;
        }

        .nav-dropdown-header {
            padding: 10px 12px 12px;
            border-bottom: 1px solid var(--color-border);
            margin-bottom: 6px;
        }
        .nav-dropdown-uname {
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--text-main);
        }
        .nav-dropdown-email {
            font-family: 'Inter', sans-serif;
            font-size: 0.74rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .nav-dropdown-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 12px;
            border-radius: 9px;
            text-decoration: none;
            color: var(--text-main);
            font-family: 'Inter', sans-serif;
            font-size: 0.84rem;
            font-weight: 500;
            cursor: pointer;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            transition: background 0.18s ease, color 0.18s ease,
                        transform 0.18s ease;
        }
        .nav-dropdown-item:hover {
            background: rgba(212,165,116,0.08);
            color: var(--color-primary);
            transform: translateX(2px);
        }
        .nav-dropdown-item svg {
            flex-shrink: 0;
            opacity: 0.7;
        }
        .nav-dropdown-item:hover svg { opacity: 1; }

        .nav-dropdown-divider {
            height: 1px;
            background: var(--color-border);
            margin: 6px 0;
        }

        .nav-dropdown-item.logout-item {
            color: #ef4444;
        }
        .nav-dropdown-item.logout-item:hover {
            background: rgba(239,68,68,0.08);
            color: #ef4444;
        }

        /* Wrap for positioning context */
        .nav-auth-widget { position: relative; }

        /* Mobile: hide name on very small screens */
        @media (max-width: 480px) {
            .nav-avatar-name { display: none; }
        }
    </style>

    <script>
        /* ════════════════════════════════════════════════════════
           NAV SCRIPT — runs on every page
           Depends on VoyastraAuth (loaded in <head>)
        ════════════════════════════════════════════════════════ */
        document.addEventListener('DOMContentLoaded', function () {

            /* ── Refs ──────────────────────────────────────────── */
            var menuBtn    = document.getElementById('mobileMenuBtn');
            var navLinks   = document.getElementById('navLinks');
            var navOverlay = document.getElementById('navOverlay');
            var widget     = document.getElementById('navAuthWidget');
            var dropdown   = null;   // created on demand

            /* ── Mobile Sidebar (admin-panel style) ────────────── */
            function openMenu() {
                if (!navLinks) return;
                navLinks.classList.add('active');
                if (navOverlay) navOverlay.classList.add('active');
                document.body.style.overflow = 'hidden';
            }
            function closeMenu() {
                if (!navLinks) return;
                navLinks.classList.remove('active');
                if (navOverlay) navOverlay.classList.remove('active');
                document.body.style.overflow = '';
            }
            function toggleMenu() {
                navLinks.classList.contains('active') ? closeMenu() : openMenu();
            }

            if (menuBtn && navLinks) {
                menuBtn.addEventListener('click', toggleMenu);
            }

            /* Click outside (overlay) closes sidebar */
            if (navOverlay) navOverlay.addEventListener('click', closeMenu);

            /* Close via sidebar ✕ button */
            var sidebarClose = document.getElementById('sidebarCloseBtn');
            if (sidebarClose) sidebarClose.addEventListener('click', closeMenu);

            /* Close on any nav link click (auto-navigate) */
            if (navLinks) {
                navLinks.querySelectorAll('.nav-link').forEach(function(link) {
                    link.addEventListener('click', closeMenu);
                });
            }

            /* Close with Escape key */
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') closeMenu();
            });

            /* ── Auth Widget Renderer ──────────────────────────── */
            function renderAuthWidget() {
                if (!widget) return;
                var session = VoyastraAuth.getSession();
                widget.innerHTML = '';
                dropdown = null;

                if (!session) {
                    /* ── Logged OUT: show Login button ── */
                    var loginBtn = document.createElement('a');
                    loginBtn.href      = 'login'; // Go through Servlet
                    loginBtn.className = 'nav-login-btn';
                    loginBtn.innerHTML =
                        '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>' +
                        'Login';
                    widget.appendChild(loginBtn);
                    widget.style.display = 'block';

                } else {
                    /* ── Logged IN: show avatar trigger ── */
                    var firstName = (session.name || 'User').split(' ')[0];
                    var initials  = (session.name || 'U').slice(0, 2).toUpperCase();
                    var avatarUrl = 'https://ui-avatars.com/api/?name=' +
                                   encodeURIComponent(session.name || 'User') +
                                   '&background=d4a574&color=1a0f08&bold=true&size=64';

                    var trigger = document.createElement('button');
                    trigger.className    = 'nav-avatar-trigger';
                    trigger.setAttribute('aria-haspopup', 'true');
                    trigger.setAttribute('aria-expanded', 'false');
                    trigger.setAttribute('aria-label', 'User menu');
                    trigger.innerHTML =
                        '<img src="' + avatarUrl + '" alt="' + initials + '" class="nav-avatar-img" ' +
                             'onerror="this.style.display=\'none\'">' +
                        '<span class="nav-avatar-name">' + firstName + '</span>' +
                        '<svg class="nav-avatar-chevron" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="6 9 12 15 18 9"/></svg>';

                    widget.appendChild(trigger);
                    widget.style.display = 'block';

                    /* ── Build Dropdown ── */
                    function buildDropdown() {
                        var isAdmin = (session.role === 'admin');
                        var adminLink = isAdmin ? 
                            '<a href="admin-dashboard.jsp" class="nav-dropdown-item" role="menuitem" style="color:var(--color-primary);">' +
                                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>' +
                                'Admin Panel' +
                            '</a>' : '';

                        var dd = document.createElement('div');
                        dd.className = 'nav-user-dropdown';
                        dd.setAttribute('role', 'menu');
                        dd.innerHTML =
                            '<div class="nav-dropdown-header">' +
                                '<div class="nav-dropdown-uname">' + (session.name || 'Traveller') + '</div>' +
                                '<div class="nav-dropdown-email">' + (session.email || '') + '</div>' +
                            '</div>' +
                            adminLink +
                            '<a href="booking?action=history" class="nav-dropdown-item" role="menuitem">' +
                                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>' +
                                'Dashboard' +
                            '</a>' +
                            '<a href="planner.jsp" class="nav-dropdown-item" role="menuitem">' +
                                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M17 3a2 2 0 0 1 4 0v1H3V3a2 2 0 0 1 4 0"/><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="8" y1="10" x2="16" y2="10"/><line x1="8" y1="14" x2="16" y2="14"/></svg>' +
                                'My Plans' +
                            '</a>' +
                            '<a href="booking" class="nav-dropdown-item" role="menuitem">' +
                                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.15 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.06 1h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.09 8.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 21 16v.92z"/></svg>' +
                                'My Bookings' +
                            '</a>' +
                            '<a href="settings.jsp" class="nav-dropdown-item" role="menuitem">' +
                                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>' +
                                'Settings' +
                            '</a>' +
                            '<div class="nav-dropdown-divider"></div>' +
                            '<button class="nav-dropdown-item logout-item" id="navLogoutBtn" role="menuitem">' +
                                '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>' +
                                'Log Out' +
                            '</button>';

                        dd.querySelector('#navLogoutBtn').addEventListener('click', function () {
                            VoyastraAuth.logout();
                        });
                        return dd;
                    }

                    /* ── Toggle dropdown ── */
                    trigger.addEventListener('click', function (e) {
                        e.stopPropagation();
                        if (dropdown) {
                            closeDropdown();
                        } else {
                            dropdown = buildDropdown();
                            widget.appendChild(dropdown);
                            trigger.setAttribute('aria-expanded', 'true');
                        }
                    });

                    function closeDropdown() {
                        if (dropdown) {
                            dropdown.remove();
                            dropdown = null;
                        }
                        trigger.setAttribute('aria-expanded', 'false');
                    }

                    /* Close on outside click */
                    document.addEventListener('click', function onDocClick(e) {
                        if (!widget.contains(e.target)) {
                            closeDropdown();
                            document.removeEventListener('click', onDocClick);
                        }
                    });

                    /* Close on Escape */
                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') closeDropdown();
                    });
                }
            }

            /* ── Initial render + live updates ────────────────── */
            renderAuthWidget();
            window.addEventListener('va:authChange', renderAuthWidget);

            /* ── Active Nav Highlight ──────────────────────────── */
            var fullPath = window.location.pathname;
            var page = fullPath.split('/').pop() || 'index.jsp';
            if (!page.includes('.')) page += '.jsp'; // handle extensionless routers if any
            
            document.querySelectorAll('.nav-link').forEach(function (link) {
                var href = link.getAttribute('href');
                if (href === page || (page === 'index.jsp' && href === 'index.jsp')) {
                    link.classList.add('active');
                }
            });

            /* ── Breadcrumbs ───────────────────────────────────── */
            var mainEl = document.querySelector('main');
            var skipBC = ['index.jsp', 'login.jsp', ''];
            if (mainEl && !skipBC.includes(currentPath)) {
                var pageName = currentPath.replace('.jsp', '');
                var formatted = pageName.split('-').map(function (w) {
                    return w.charAt(0).toUpperCase() + w.slice(1);
                }).join(' ');
                mainEl.insertAdjacentHTML('afterbegin',
                    '<div class="container relative z-20 slide-up" style="padding-top:10px;margin-bottom:25px;animation-delay:0.1s;">' +
                    '<nav aria-label="Breadcrumb"><ol class="flex items-center gap-2 text-sm" style="font-family:\'Inter\',sans-serif;">' +
                    '<li><a href="index.jsp" class="text-muted breadcrumb-link" style="transition:color 0.2s;">Home</a></li>' +
                    '<li class="text-muted" style="opacity:0.5;"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="9 18 15 12 9 6"/></svg></li>' +
                    '<li class="text-primary font-medium" aria-current="page">' + formatted + '</li>' +
                    '</ol></nav></div>');
            }

        }); // DOMContentLoaded
    </script>
