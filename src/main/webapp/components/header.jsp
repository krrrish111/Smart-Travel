<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Travel Planner India</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;0,700;1,400;1,600&family=Poppins:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,700;0,800;1,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/components.css">
    <link rel="stylesheet" href="css/theme.css">
    <!-- Prevent flash of wrong theme on load -->
    <script>
        (function(){
            var t = localStorage.getItem('theme');
            if (t) document.documentElement.setAttribute('data-theme', t);
        })();
    </script>
<%@include file="components/config.jsp"%>
</head>
<body>
    <nav class="navbar">
        <div class="container nav-container">
            <a href="index.jsp" class="nav-brand">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="3 11 22 2 13 21 11 13 3 11"></polygon>
                </svg>
                Smart Travel
            </a>
            <div class="nav-actions">
                <div class="nav-links" id="navLinks">
                    <a href="index.jsp" class="nav-link">Home</a>
                    <a href="explore.jsp" class="nav-link">Explore</a>
                    <a href="community.jsp" class="nav-link">Community</a>
                    <a href="planner.jsp" class="nav-link">Planner</a>
                    <a href="booking.jsp" class="nav-link">Bookings</a>
                    <a href="dashboard.jsp" class="btn btn-outline nav-dashboard-btn" style="padding:6px 18px;border-radius:30px;font-size:0.82rem;letter-spacing:0.06em;text-transform:uppercase;transition:all 0.3s ease,color 1s ease,border-color 1s ease;">Dashboard</a>
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
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const menuBtn = document.getElementById('mobileMenuBtn');
            const navLinks = document.getElementById('navLinks');
            const navOverlay = document.getElementById('navOverlay');
            
            if(menuBtn && navLinks) {
                const toggleMenu = () => {
                    navLinks.classList.toggle('active');
                    if(navOverlay) navOverlay.classList.toggle('active');
                };
                menuBtn.addEventListener('click', toggleMenu);
                if(navOverlay) navOverlay.addEventListener('click', toggleMenu);
            }
        });
    </script>
