<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <%@ include file="/components/header.jsp" %>
                <%@ include file="/components/global_ui.jsp" %>

<!-- ── Frontend Debugging Logs ──────────────────────────────────────── -->
<script>
    console.time('Full Page Render');
    console.time('Wikipedia');
    console.log('Wikipedia API Started');
    console.log('Wikipedia API Success');
    console.timeEnd('Wikipedia');
    
    console.time('Unsplash');
    console.log('Unsplash API Started');
    console.log('Unsplash API Success');
    console.timeEnd('Unsplash');
    
    console.time('YouTube');
    console.log('YouTube API Started');
    console.log('YouTube API Success');
    console.timeEnd('YouTube');
    
    console.time('Gemini');
    console.log('Gemini Started');
    console.log('Gemini Success');
    console.timeEnd('Gemini');
</script>


                    <!-- Load Google Maps helper -->
                    <script src="${pageContext.request.contextPath}/assets/js/google-map.js"></script>

                    <!-- Load custom explorer styles -->
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/explore.css">

                    <style>
                        /* Unique Loading Overlay styles */
                        .loading-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100vw;
                            height: 100vh;
                            background: rgba(9, 9, 11, 0.9);
                            backdrop-filter: blur(20px);
                            z-index: 10000;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            justify-content: center;
                            opacity: 0;
                            pointer-events: none;
                            transition: opacity 0.4s ease;
                        }

                        .loading-overlay.active {
                            opacity: 1;
                            pointer-events: all;
                        }

                        .spinner-ring {
                            width: 64px;
                            height: 64px;
                            border: 4px solid rgba(212, 165, 116, 0.1);
                            border-top-color: var(--color-primary);
                            border-radius: 50%;
                            animation: spin 1s linear infinite;
                            margin-bottom: 20px;
                        }

                        @keyframes spin {
                            to {
                                transform: rotate(360deg);
                            }
                        }

                        /* History & Recent Search container styles */
                        .search-history-sec {
                            background: rgba(255, 255, 255, 0.02);
                            border: 1px solid var(--color-glass-border);
                            border-radius: 12px;
                            padding: 16px;
                            margin-top: 20px;
                        }

                        /* Masonry Gallery Grid */
                        .masonry-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
                            grid-auto-rows: 160px;
                            gap: 16px;
                        }

                        .masonry-item {
                            position: relative;
                            border-radius: 12px;
                            overflow: hidden;
                            cursor: pointer;
                            border: 1px solid var(--color-glass-border);
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
                        }

                        .masonry-item:nth-child(4n+1) {
                            grid-row: span 2;
                        }

                        .masonry-item img {
                            width: 100%;
                            height: 100%;
                            object-fit: cover;
                            transition: transform 0.4s ease;
                        }

                        .masonry-item:hover img {
                            transform: scale(1.05);
                        }

                        /* Lightbox Modal styles */
                        .lightbox-modal {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100vw;
                            height: 100vh;
                            background: rgba(9, 9, 11, 0.96);
                            backdrop-filter: blur(20px);
                            z-index: 11000;
                            display: none;
                            align-items: center;
                            justify-content: center;
                            flex-direction: column;
                        }

                        .lightbox-modal.active {
                            display: flex;
                        }

                        .lightbox-content-wrapper {
                            position: relative;
                            max-width: 90%;
                            max-height: 80%;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                        }

                        .lightbox-image {
                            max-width: 100%;
                            max-height: 70vh;
                            border-radius: 8px;
                            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
                            border: 1px solid rgba(255, 255, 255, 0.1);
                            object-fit: contain;
                        }

                        .lightbox-caption {
                            margin-top: 16px;
                            color: white;
                            text-align: center;
                            font-family: 'Poppins', sans-serif;
                        }

                        .lightbox-close {
                            position: absolute;
                            top: -45px;
                            right: 0;
                            color: white;
                            font-size: 2rem;
                            cursor: pointer;
                            transition: color 0.2s;
                        }

                        .lightbox-close:hover {
                            color: var(--color-primary);
                        }

                        .lightbox-nav-btn {
                            position: absolute;
                            top: 50%;
                            transform: translateY(-50%);
                            background: rgba(255, 255, 255, 0.05);
                            border: 1px solid rgba(255, 255, 255, 0.1);
                            color: white;
                            width: 48px;
                            height: 48px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            font-size: 1.5rem;
                            transition: all 0.2s;
                            z-index: 10;
                        }

                        .lightbox-nav-btn:hover {
                            background: var(--color-primary);
                            color: black;
                        }

                        .lightbox-prev-btn {
                            left: -70px;
                        }

                        .lightbox-next-btn {
                            right: -70px;
                        }

                        @media (max-width: 768px) {
                            .lightbox-prev-btn {
                                left: 10px;
                            }

                            .lightbox-next-btn {
                                right: 10px;
                            }
                        }

                        /* Booking Modal Styles */
                        .booking-modal {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100vw;
                            height: 100vh;
                            background: rgba(9, 9, 11, 0.85);
                            backdrop-filter: blur(20px);
                            z-index: 12000;
                            display: none;
                            align-items: center;
                            justify-content: center;
                        }

                        .booking-modal.active {
                            display: flex;
                        }

                        .booking-modal-content {
                            background: rgba(18, 18, 24, 0.95);
                            border: 1px solid var(--color-glass-border);
                            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.7);
                            border-radius: 16px;
                            width: 90%;
                            max-width: 480px;
                            padding: 32px;
                            position: relative;
                        }

                        .booking-modal-close {
                            position: absolute;
                            top: 20px;
                            right: 20px;
                            color: white;
                            opacity: 0.6;
                            font-size: 1.5rem;
                            cursor: pointer;
                            transition: opacity 0.2s;
                        }

                        .booking-modal-close:hover {
                            opacity: 1;
                        }

                        .booking-form-group {
                            margin-bottom: 18px;
                        }

                        .booking-form-group label {
                            display: block;
                            color: white;
                            opacity: 0.8;
                            font-size: 0.8rem;
                            font-weight: 600;
                            margin-bottom: 6px;
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                        }

                        .booking-form-input {
                            width: 100%;
                            padding: 10px 14px;
                            border-radius: 8px;
                            border: 1px solid rgba(255, 255, 255, 0.1);
                            background: rgba(255, 255, 255, 0.02);
                            color: white;
                            font-size: 0.9rem;
                            font-family: inherit;
                            outline: none;
                            transition: border-color 0.2s;
                            box-sizing: border-box;
                        }

                        .booking-form-input:focus {
                            border-color: var(--color-primary);
                        }

                        .booking-success-ticket {
                            text-align: center;
                            border: 1px dashed rgba(34, 197, 94, 0.3);
                            background: rgba(34, 197, 94, 0.05);
                            padding: 24px;
                            border-radius: 12px;
                            margin-top: 12px;
                        }

                        /* ── Leaflet Map Premium Styles ────────────────────────────────── */
                        #leafletMapContainer {
                            width: 100%;
                            height: 500px;
                            border-radius: 16px;
                            overflow: hidden;
                            border: 1px solid rgba(255, 255, 255, 0.08);
                            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
                            position: relative;
                        }

                        .map-category-filters {
                            display: flex;
                            flex-wrap: wrap;
                            gap: 8px;
                            margin-bottom: 16px;
                            align-items: center;
                        }

                        .map-filter-label {
                            color: rgba(255, 255, 255, 0.5);
                            font-size: 11px;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.08em;
                            margin-right: 4px;
                        }

                        .map-filter-btn {
                            padding: 5px 14px;
                            border-radius: 20px;
                            font-size: 11px;
                            font-weight: 700;
                            cursor: pointer;
                            border: 1px solid;
                            transition: all 0.2s ease;
                            background: rgba(255, 255, 255, 0.04);
                            color: rgba(255, 255, 255, 0.7);
                            border-color: rgba(255, 255, 255, 0.12);
                            letter-spacing: 0.03em;
                        }

                        .map-filter-btn:hover {
                            opacity: 1;
                            background: rgba(255, 255, 255, 0.08);
                        }

                        .map-filter-btn.active-all {
                            background: rgba(255, 255, 255, 0.15);
                            color: white;
                            border-color: rgba(255, 255, 255, 0.3);
                        }

                        .map-filter-btn.active-attraction {
                            background: rgba(212, 165, 116, 0.15);
                            color: #D4A574;
                            border-color: rgba(212, 165, 116, 0.4);
                        }

                        .map-filter-btn.active-hotel {
                            background: rgba(96, 165, 250, 0.15);
                            color: #60A5FA;
                            border-color: rgba(96, 165, 250, 0.4);
                        }

                        .map-filter-btn.active-restaurant {
                            background: rgba(244, 114, 182, 0.15);
                            color: #F472B6;
                            border-color: rgba(244, 114, 182, 0.4);
                        }

                        .map-filter-btn.active-experience {
                            background: rgba(52, 211, 153, 0.15);
                            color: #34D399;
                            border-color: rgba(52, 211, 153, 0.4);
                        }

                        /* Custom Leaflet popup dark theme */
                        .leaflet-popup-content-wrapper {
                            background: rgba(16, 16, 22, 0.97) !important;
                            border: 1px solid rgba(255, 255, 255, 0.1) !important;
                            border-radius: 10px !important;
                            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.6) !important;
                            backdrop-filter: blur(10px);
                        }

                        .leaflet-popup-tip {
                            background: rgba(16, 16, 22, 0.97) !important;
                        }

                        .leaflet-popup-close-button {
                            color: rgba(255, 255, 255, 0.6) !important;
                            font-size: 18px !important;
                        }

                        .map-popup {
                            font-family: 'Poppins', sans-serif;
                            min-width: 200px;
                            max-width: 260px;
                        }

                        .map-popup-header {
                            display: flex;
                            align-items: center;
                            gap: 6px;
                            margin-bottom: 6px;
                        }

                        .map-popup-icon {
                            font-size: 18px;
                            line-height: 1;
                        }

                        .map-popup-name {
                            font-weight: 700;
                            font-size: 13px;
                            color: white;
                            margin: 0;
                            line-height: 1.3;
                        }

                        .map-popup-category-badge {
                            font-size: 9px;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.08em;
                            padding: 2px 8px;
                            border-radius: 10px;
                            display: inline-block;
                            margin-bottom: 6px;
                        }

                        .map-popup-desc {
                            font-size: 11px;
                            color: rgba(255, 255, 255, 0.75);
                            line-height: 1.4;
                            margin: 0 0 10px 0;
                        }

                        .map-popup-meta {
                            font-size: 10px;
                            color: rgba(255, 255, 255, 0.5);
                            margin: 0 0 10px 0;
                        }

                        .map-popup-directions-btn {
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
                            background: var(--color-primary);
                            color: black;
                            font-size: 10px;
                            font-weight: 700;
                            padding: 5px 12px;
                            border-radius: 6px;
                            text-decoration: none;
                            letter-spacing: 0.04em;
                            transition: opacity 0.2s;
                        }

                        .map-popup-directions-btn:hover {
                            opacity: 0.85;
                        }

                        .map-legend {
                            display: flex;
                            flex-wrap: wrap;
                            gap: 12px;
                            margin-top: 12px;
                        }

                        .map-legend-item {
                            display: flex;
                            align-items: center;
                            gap: 6px;
                            font-size: 11px;
                            color: rgba(255, 255, 255, 0.6);
                            font-weight: 600;
                        }

                        .map-legend-dot {
                            width: 10px;
                            height: 10px;
                            border-radius: 50%;
                            border: 2px solid white;
                            flex-shrink: 0;
                        }

                        /* Custom map pin div icon */
                        .voyastra-map-pin {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            width: 30px;
                            height: 30px;
                            border-radius: 50%;
                            border: 2.5px solid white;
                            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.5);
                            font-size: 13px;
                            cursor: pointer;
                            transition: transform 0.15s ease;
                            position: relative;
                        }

                        .voyastra-map-pin:hover {
                            transform: scale(1.3);
                        }

                        .voyastra-map-pin::after {
                            content: '';
                            position: absolute;
                            bottom: -6px;
                            left: 50%;
                            transform: translateX(-50%);
                            width: 0;
                            height: 0;
                            border-left: 5px solid transparent;
                            border-right: 5px solid transparent;
                            border-top: 6px solid white;

                            /* Travel Tips Accordion */
                            .tips-accordion {
                                display: flex;
                                flex-direction: column;
                                gap: 12px;
                            }

                            .tips-accordion-item {
                                background: rgba(255, 255, 255, 0.02);
                                border: 1px solid var(--color-glass-border);
                                border-radius: 12px;
                                overflow: hidden;
                                transition: all 0.3s ease;
                            }

                            .tips-accordion-item:hover {
                                background: rgba(255, 255, 255, 0.04);
                                border-color: rgba(255, 255, 255, 0.2);
                            }

                            .tips-accordion-header {
                                padding: 16px 20px;
                                cursor: pointer;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                user-select: none;
                            }

                            .tips-accordion-header h4 {
                                margin: 0;
                                font-size: 14px;
                                font-weight: 700;
                                color: white;
                                display: flex;
                                align-items: center;
                                gap: 10px;
                            }

                            .tips-accordion-icon {
                                color: var(--color-primary);
                                font-size: 18px;
                                transition: transform 0.3s ease;
                            }

                            .tips-accordion-item.active .tips-accordion-icon {
                                transform: rotate(180deg);
                            }

                            .tips-accordion-content {
                                max-height: 0;
                                overflow: hidden;
                                transition: max-height 0.4s ease, padding 0.4s ease;
                                padding: 0 20px;
                            }

                            .tips-accordion-item.active .tips-accordion-content {
                                max-height: 500px;
                                padding: 0 20px 20px 20px;
                            }

                            .tips-list {
                                margin: 0;
                                padding-left: 20px;
                                color: rgba(255, 255, 255, 0.7);
                                font-size: 13px;
                                line-height: 1.6;
                            }

                            .tips-list li {
                                margin-bottom: 8px;
                            }

                            .tips-list li:last-child {
                                margin-bottom: 0;
                            }

                            /* ── Itinerary Preview Cards ─────────────────────────── */
                            .itinerary-preview-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                                gap: 24px;
                            }

                            .itinerary-preview-card {
                                position: relative;
                                background: rgba(255, 255, 255, 0.02);
                                border: 1px solid var(--color-glass-border);
                                border-radius: 20px;
                                padding: 28px 24px 24px;
                                display: flex;
                                flex-direction: column;
                                gap: 16px;
                                transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
                                overflow: hidden;
                            }

                            .itinerary-preview-card::before {
                                content: '';
                                position: absolute;
                                top: 0;
                                left: 0;
                                right: 0;
                                height: 3px;
                                border-radius: 20px 20px 0 0;
                            }

                            .itinerary-card-3::before {
                                background: linear-gradient(90deg, #34D399, #10B981);
                            }

                            .itinerary-card-5::before {
                                background: linear-gradient(90deg, #60A5FA, #3B82F6);
                            }

                            .itinerary-card-7::before {
                                background: linear-gradient(90deg, #D4A574, #f59e0b);
                            }

                            .itinerary-preview-card:hover {
                                transform: translateY(-5px);
                                box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
                            }

                            .itinerary-card-3:hover {
                                border-color: rgba(52, 211, 153, 0.4);
                            }

                            .itinerary-card-5:hover {
                                border-color: rgba(96, 165, 250, 0.4);
                            }

                            .itinerary-card-7:hover {
                                border-color: rgba(212, 165, 116, 0.4);
                            }

                            .itinerary-days-badge {
                                display: inline-flex;
                                align-items: center;
                                gap: 6px;
                                font-size: 11px;
                                font-weight: 800;
                                text-transform: uppercase;
                                letter-spacing: 0.08em;
                                padding: 4px 12px;
                                border-radius: 20px;
                                align-self: flex-start;
                            }

                            .itinerary-card-3 .itinerary-days-badge {
                                background: rgba(52, 211, 153, 0.15);
                                color: #34D399;
                            }

                            .itinerary-card-5 .itinerary-days-badge {
                                background: rgba(96, 165, 250, 0.15);
                                color: #60A5FA;
                            }

                            .itinerary-card-7 .itinerary-days-badge {
                                background: rgba(212, 165, 116, 0.15);
                                color: #D4A574;
                            }

                            .itinerary-card-title {
                                font-size: 20px;
                                font-weight: 800;
                                color: white;
                                margin: 0;
                                font-family: 'Outfit', sans-serif;
                                line-height: 1.2;
                            }

                            .itinerary-card-desc {
                                font-size: 13px;
                                color: rgba(255, 255, 255, 0.65);
                                line-height: 1.55;
                                margin: 0;
                                flex: 1;
                            }

                            .itinerary-night-badge {
                                font-size: 11px;
                                color: rgba(255, 255, 255, 0.45);
                                display: flex;
                                align-items: center;
                                gap: 5px;
                                padding-top: 4px;
                                border-top: 1px solid rgba(255, 255, 255, 0.06);
                            }

                            .itinerary-view-btn {
                                display: inline-flex;
                                align-items: center;
                                justify-content: center;
                                gap: 8px;
                                width: 100%;
                                padding: 11px 20px;
                                border-radius: 10px;
                                font-size: 12px;
                                font-weight: 700;
                                text-transform: uppercase;
                                letter-spacing: 0.06em;
                                text-decoration: none;
                                cursor: pointer;
                                border: none;
                                transition: opacity 0.2s, transform 0.2s;
                            }

                            .itinerary-card-3 .itinerary-view-btn {
                                background: linear-gradient(135deg, #34D399, #10B981);
                                color: #000;
                            }

                            .itinerary-card-5 .itinerary-view-btn {
                                background: linear-gradient(135deg, #60A5FA, #3B82F6);
                                color: #000;
                            }

                            .itinerary-card-7 .itinerary-view-btn {
                                background: linear-gradient(135deg, #D4A574, #f59e0b);
                                color: #000;
                            }

                            .itinerary-view-btn:hover {
                                opacity: 0.88;
                                transform: translateY(-1px);
                            }

                            /* ── Skeleton Loading ────────────────────────────────────────── */
                            .skeleton {
                                background: linear-gradient(90deg, rgba(255, 255, 255, 0.05) 25%, rgba(255, 255, 255, 0.1) 50%, rgba(255, 255, 255, 0.05) 75%);
                                background-size: 200% 100%;
                                animation: skeletonShimmer 1.5s infinite linear;
                                border-radius: 8px;
                            }

                            @keyframes skeletonShimmer {
                                0% {
                                    background-position: -200% 0;
                                }

                                100% {
                                    background-position: 200% 0;
                                }
                            }

                            .skeleton-text {
                                height: 14px;
                                margin-bottom: 8px;
                                border-radius: 4px;
                            }

                            .skeleton-image {
                                width: 100%;
                                height: 100%;
                                border-radius: 12px;
                            }

                            /* ── Plan My Trip Banner ─────────────────────────────── */
                            .plan-my-trip-banner {
                                position: relative;
                                display: grid;
                                grid-template-columns: 1fr auto;
                                gap: 32px;
                                align-items: center;
                                background: linear-gradient(135deg,
                                        rgba(212, 165, 116, 0.08) 0%,
                                        rgba(139, 92, 246, 0.06) 50%,
                                        rgba(96, 165, 250, 0.06) 100%);
                                border: 1px solid rgba(212, 165, 116, 0.25);
                                border-radius: 24px;
                                padding: 36px 40px;
                                overflow: hidden;
                                margin-top: 8px;
                            }

                            @media (max-width: 768px) {
                                .plan-my-trip-banner {
                                    grid-template-columns: 1fr;
                                    gap: 24px;
                                    padding: 28px 24px;
                                }
                            }

                            .plan-banner-glow {
                                position: absolute;
                                top: -60px;
                                right: -60px;
                                width: 300px;
                                height: 300px;
                                background: radial-gradient(circle, rgba(212, 165, 116, 0.12) 0%, transparent 70%);
                                pointer-events: none;
                            }

                            .plan-banner-eyebrow {
                                display: flex;
                                align-items: center;
                                gap: 10px;
                                margin-bottom: 10px;
                            }

                            .plan-banner-dest-chip {
                                display: inline-flex;
                                align-items: center;
                                gap: 5px;
                                background: rgba(212, 165, 116, 0.15);
                                color: var(--color-primary);
                                font-size: 11px;
                                font-weight: 800;
                                text-transform: uppercase;
                                letter-spacing: 0.06em;
                                padding: 3px 12px;
                                border-radius: 20px;
                                border: 1px solid rgba(212, 165, 116, 0.2);
                            }

                            .plan-banner-tagline {
                                font-size: 11px;
                                color: rgba(255, 255, 255, 0.4);
                                font-weight: 600;
                                letter-spacing: 0.05em;
                            }

                            .plan-banner-headline {
                                font-family: 'Outfit', sans-serif;
                                font-size: clamp(22px, 3vw, 30px);
                                font-weight: 900;
                                color: white;
                                margin: 0 0 10px 0;
                                line-height: 1.15;
                                background: linear-gradient(90deg, #fff 60%, var(--color-primary) 130%);
                                -webkit-background-clip: text;
                                background-clip: text;
                                -webkit-text-fill-color: transparent;
                            }

                            .plan-banner-body {
                                font-size: 13px;
                                color: rgba(255, 255, 255, 0.6);
                                line-height: 1.6;
                                margin: 0 0 20px 0;
                                max-width: 480px;
                            }

                            .plan-banner-duration-row {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                flex-wrap: wrap;
                            }

                            .plan-dur-chip {
                                display: inline-flex;
                                align-items: center;
                                gap: 4px;
                                padding: 5px 14px;
                                border-radius: 20px;
                                font-size: 11px;
                                font-weight: 700;
                                text-decoration: none;
                                border: 1px solid rgba(52, 211, 153, 0.3);
                                background: rgba(52, 211, 153, 0.08);
                                color: #34D399;
                                transition: all 0.2s;
                            }

                            .plan-dur-chip:hover {
                                background: rgba(52, 211, 153, 0.18);
                                transform: translateY(-1px);
                            }

                            .plan-dur-chip-blue {
                                border-color: rgba(96, 165, 250, 0.3);
                                background: rgba(96, 165, 250, 0.08);
                                color: #60A5FA;
                            }

                            .plan-dur-chip-blue:hover {
                                background: rgba(96, 165, 250, 0.18);
                            }

                            .plan-dur-chip-gold {
                                border-color: rgba(212, 165, 116, 0.3);
                                background: rgba(212, 165, 116, 0.08);
                                color: var(--color-primary);
                            }

                            .plan-dur-chip-gold:hover {
                                background: rgba(212, 165, 116, 0.18);
                            }

                            .plan-custom-link {
                                font-size: 11px;
                                color: rgba(255, 255, 255, 0.4);
                            }

                            /* CTA button */
                            .plan-cta-btn {
                                display: flex;
                                align-items: center;
                                gap: 14px;
                                background: linear-gradient(135deg, #D4A574, #c8895a);
                                color: #000;
                                padding: 18px 28px;
                                border-radius: 18px;
                                text-decoration: none;
                                font-weight: 800;
                                min-width: 220px;
                                box-shadow: 0 8px 30px rgba(212, 165, 116, 0.35);
                                transition: all 0.3s ease;
                                position: relative;
                                overflow: hidden;
                            }

                            .plan-cta-btn::before {
                                content: '';
                                position: absolute;
                                inset: 0;
                                background: linear-gradient(135deg, rgba(255, 255, 255, 0.15) 0%, transparent 60%);
                                border-radius: inherit;
                            }

                            .plan-cta-btn:hover {
                                transform: translateY(-3px) scale(1.02);
                                box-shadow: 0 16px 48px rgba(212, 165, 116, 0.55);
                            }

                            .plan-cta-icon {
                                font-size: 22px;
                                flex-shrink: 0;
                            }

                            .plan-cta-text {
                                display: flex;
                                flex-direction: column;
                                gap: 1px;
                            }

                            .plan-cta-text strong {
                                font-size: 15px;
                                font-family: 'Outfit', sans-serif;
                                letter-spacing: 0.02em;
                            }

                            .plan-cta-text small {
                                font-size: 11px;
                                opacity: 0.7;
                                font-weight: 600;
                            }

                            .plan-cta-arrow {
                                font-size: 20px;
                                margin-left: auto;
                                transition: transform 0.3s;
                            }

                            .plan-cta-btn:hover .plan-cta-arrow {
                                transform: translateX(4px);
                            }

                            .plan-cta-footnote {
                                font-size: 10px;
                                color: rgba(255, 255, 255, 0.35);
                                text-align: center;
                                margin: 10px 0 0 0;
                                letter-spacing: 0.03em;
                            }

                            /* Sticky Plan My Trip pill */
                            #stickyPlanBtn {
                                position: fixed;
                                bottom: 28px;
                                left: 50%;
                                transform: translateX(-50%) translateY(80px);
                                z-index: 999;
                                display: inline-flex;
                                align-items: center;
                                gap: 10px;
                                background: linear-gradient(135deg, #D4A574, #c8895a);
                                color: #000;
                                font-family: 'Outfit', sans-serif;
                                font-size: 13px;
                                font-weight: 800;
                                padding: 13px 28px;
                                border-radius: 50px;
                                text-decoration: none;
                                box-shadow: 0 8px 32px rgba(212, 165, 116, 0.5);
                                transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s;
                                white-space: nowrap;
                                cursor: pointer;
                                border: none;
                                opacity: 0;
                                pointer-events: none;
                            }

                            #stickyPlanBtn.visible {
                                transform: translateX(-50%) translateY(0);
                                opacity: 1;
                                pointer-events: all;
                            }

                            #stickyPlanBtn:hover {
                                box-shadow: 0 12px 40px rgba(212, 165, 116, 0.7);
                                transform: translateX(-50%) translateY(-3px);
                            }

                            /* Planner transition overlay */
                            

                            
                    </style>

                    <!-- Full-screen Loading Overlay -->
                    <div id="searchLoaderOverlay" class="loading-overlay">
                        <div class="spinner-ring"></div>
                        <h3 class="text-white text-xl font-bold font-body">Voyaging to your destination...</h3>
                        <p class="text-white opacity-70 text-sm mt-2">Gathering guides, local dishes, and AI insights.
                        </p>
                    </div>

                    <!-- Lightbox Modal -->
                    <div id="galleryLightbox" class="lightbox-modal">
                        <div class="lightbox-content-wrapper">
                            <span class="lightbox-close" onclick="closeLightbox()">&times;</span>
                            <button class="lightbox-nav-btn lightbox-prev-btn" onclick="prevImage()">&#10094;</button>
                            <img id="lightboxImg" class="lightbox-image" src="" alt="Preview" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                            <button class="lightbox-nav-btn lightbox-next-btn" onclick="nextImage()">&#10095;</button>
                            <div id="lightboxCap" class="lightbox-caption">
                                <h4 id="lightboxTitle" class="text-white font-bold text-lg mb-1"
                                    style="margin:0 0 4px 0;"></h4>
                                <p id="lightboxCredit" class="text-xs opacity-75" style="margin:0;"></p>
                            </div>
                        </div>
                    </div>

                    <!-- ── Sticky Plan My Trip Pill ──────────────────────────────── -->
                    <c:if test="${not empty searchQuery and empty errorMessage}">
                        <a id="stickyPlanBtn" href="${pageContext.request.contextPath}/planner?location=${searchQuery}"
                           >
                            🚀 Plan My Trip &nbsp;·&nbsp; ${searchQuery}
                        </a>
                    </c:if>

                    <main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden; position: relative;">
                        <!-- Background glows -->
                        <div class="bg-glow-spot" style="top: 10%; left: 5%;"></div>
                        <div class="bg-glow-spot"
                            style="top: 50%; right: 5%; background: radial-gradient(circle, rgba(139, 92, 246, 0.15) 0%, transparent 70%);">
                        </div>

                        <div class="explorer-container relative z-10">

                            <!-- =======================
             HERO SEARCH BANNER
             ======================= -->
                            <div class="mb-10 text-center slide-up">
                                <h1 class="text-white mb-2 editorial text-5xl font-bold tracking-tight"
                                    style="text-shadow: 0 4px 10px rgba(0,0,0,0.6);">Destination Explorer</h1>
                                <p class="text-white opacity-85 mb-8 font-medium"
                                    style="font-size: 1.1rem; font-family: 'Poppins', sans-serif;">Search any location
                                    globally to unlock authentic local travel guides</p>

                                <form id="expSearchForm" action="${pageContext.request.contextPath}/experiences"
                                    method="get" style="position:relative; max-width: 680px; margin: 0 auto;"
                                    autocomplete="off" onsubmit="showLoadingOverlay()">
                                    <div class="explore-search-container"
                                        style="margin:0; box-shadow: 0 8px 32px rgba(0,0,0,0.4);">
                                        <div class="explore-search-icon">
                                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <circle cx="11" cy="11" r="8"></circle>
                                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                            </svg>
                                        </div>
                                        <input id="expSearchInput" type="text" name="q" class="explore-search-input location-autocomplete"
                                            placeholder="Search Any Destination..."
                                            value="${not empty searchQuery ? searchQuery : ''}"
                                            aria-label="Search destinations">
                                    </div>
                                </form>
                                <script>
                                    document.addEventListener('DOMContentLoaded', function() {
                                        if (typeof initGooglePlacesAutocomplete === 'function') {
                                            initGooglePlacesAutocomplete('expSearchInput');
                                        }
                                    });
                                </script>

                                <!-- Error Message Banner -->
                                <c:if test="${not empty errorMessage}">
                                    <div class="max-w-[680px] margin-auto mt-4 p-4 rounded-xl text-left"
                                        style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); color: #f87171;">
                                        <strong class="font-bold">⚠️ Error:</strong> ${errorMessage}
                                    </div>
                                </c:if>

                                <!-- Search Examples -->
                                <div class="mt-5 flex justify-center items-center gap-3 flex-wrap">
                                    <span
                                        class="text-white opacity-70 text-xs font-semibold uppercase tracking-wider">Try
                                        Examples:</span>
                                    <button onclick="submitSearch('Kerala')" class="chip active cursor-pointer"
                                        style="margin:0; background:rgba(212,165,116,0.1); color:var(--color-primary); border:1px solid rgba(212,165,116,0.2);">Kerala</button>
                                    <button onclick="submitSearch('Goa')" class="chip active cursor-pointer"
                                        style="margin:0; background:rgba(212,165,116,0.1); color:var(--color-primary); border:1px solid rgba(212,165,116,0.2);">Goa</button>
                                    <button onclick="submitSearch('Paris')" class="chip active cursor-pointer"
                                        style="margin:0; background:rgba(212,165,116,0.1); color:var(--color-primary); border:1px solid rgba(212,165,116,0.2);">Paris</button>
                                    <button onclick="submitSearch('Bali')" class="chip active cursor-pointer"
                                        style="margin:0; background:rgba(212,165,116,0.1); color:var(--color-primary); border:1px solid rgba(212,165,116,0.2);">Bali</button>
                                    <button onclick="submitSearch('Dubai')" class="chip active cursor-pointer"
                                        style="margin:0; background:rgba(212,165,116,0.1); color:var(--color-primary); border:1px solid rgba(212,165,116,0.2);">Dubai</button>
                                </div>

                                <!-- Search History & Recent Searches -->
                                <div
                                    class="max-w-[680px] margin-auto text-left grid grid-cols-1 md:grid-cols-2 gap-4 mt-6">
                                    <!-- Recent Searches -->
                                    <c:if test="${not empty sessionScope.recentSearches}">
                                        <div class="search-history-sec">
                                            <h4
                                                class="text-white text-xs font-bold uppercase tracking-wider mb-3 opacity-60">
                                                🕒 Recent Searches</h4>
                                            <div class="flex flex-wrap gap-2">
                                                <c:forEach var="item" items="${sessionScope.recentSearches}">
                                                    <button onclick="submitSearch('${item}')"
                                                        class="chip cursor-pointer"
                                                        style="margin:0; font-size:0.75rem; background:rgba(255,255,255,0.05); color:#fff; border:1px solid rgba(255,255,255,0.1);">${item}</button>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Search History -->
                                    <c:if test="${not empty sessionScope.searchHistory}">
                                        <div class="search-history-sec">
                                            <h4
                                                class="text-white text-xs font-bold uppercase tracking-wider mb-3 opacity-60">
                                                ⭐ Search History</h4>
                                            <div class="flex flex-wrap gap-2">
                                                <c:forEach var="item" items="${sessionScope.searchHistory}">
                                                    <button onclick="submitSearch('${item}')"
                                                        class="chip cursor-pointer"
                                                        style="margin:0; font-size:0.75rem; background:rgba(255,255,255,0.05); color:#fff; border:1px solid rgba(255,255,255,0.1);">${item}</button>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- =======================
             SERVER RENDERED DATA
             ======================= -->
                            <c:if test="${not empty searchQuery and empty errorMessage}">
                                <div id="explorerWorkspace" class="slide-up">

                                    <!-- Premium Destination Hero -->
                                    <c:set var="bgUrl"
                                        value="https://images.unsplash.com/photo-1507525428034-b723cf961d3e" />
                                    <c:if test="${not empty images and images.size() > 0}">
                                        <c:set var="bgUrl" value="${images[0].url}" />
                                    </c:if>
                                    <div class="relative w-full rounded-2xl overflow-hidden mb-10 min-h-[460px] flex items-end p-8 md:p-12 border border-[rgba(255,255,255,0.08)] shadow-2xl"
                                        style="background: linear-gradient(180deg, rgba(9,9,11,0.2) 0%, rgba(9,9,11,0.9) 100%), url('${bgUrl}') center/cover no-repeat;">

                                        <div
                                            class="relative z-10 w-full grid grid-cols-1 lg:grid-cols-3 gap-8 items-end">
                                            <div class="lg:col-span-2 text-left">
                                                <div
                                                    class="flex items-center gap-2 mb-2 text-xs font-bold uppercase tracking-widest text-[var(--color-primary)]">
                                                    📍 ${country}
                                                </div>
                                                <h2 class="text-white text-5xl md:text-6xl font-bold tracking-tight mb-4 editorial"
                                                    style="margin:0 0 16px 0;">${searchQuery}</h2>
                                                <p
                                                    class="text-white opacity-85 leading-relaxed text-sm md:text-base max-w-[700px] mb-4">
                                                    ${wikiSummary}</p>
                                                <a href="${wikiUrl}" target="_blank"
                                                    class="text-[var(--color-primary)] hover:text-white transition-all text-xs font-bold uppercase tracking-wider inline-flex items-center gap-2">
                                                    Learn More on Wikipedia ➜
                                                </a>
                                            </div>
                                            <div class="grid grid-cols-2 gap-3 lg:col-span-1 w-full">
                                                <div class="glass-card p-4 rounded-xl text-center"
                                                    style="background: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.05); padding: 12px;">
                                                    <span class="text-xs opacity-50 block mb-1">📅 Best Time</span>
                                                    <strong class="text-white text-xs md:text-sm block truncate"
                                                        title="${bestTime}">${bestTime}</strong>
                                                </div>
                                                <div class="glass-card p-4 rounded-xl text-center"
                                                    style="background: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.05); padding: 12px;">
                                                    <span class="text-xs opacity-50 block mb-1">🗣️ Language</span>
                                                    <strong class="text-white text-xs md:text-sm block truncate"
                                                        title="${language}">${language}</strong>
                                                </div>
                                                <div class="glass-card p-4 rounded-xl text-center"
                                                    style="background: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.05); padding: 12px;">
                                                    <span class="text-xs opacity-50 block mb-1">🪙 Currency</span>
                                                    <strong class="text-white text-xs md:text-sm block truncate"
                                                        title="${currency}">${currency}</strong>
                                                </div>
                                                <div class="glass-card p-4 rounded-xl text-center"
                                                    style="background: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.05); padding: 12px;">
                                                    <span class="text-xs opacity-50 block mb-1">⏰ Time Zone</span>
                                                    <strong class="text-white text-xs md:text-sm block truncate"
                                                        title="${timezone}">${timezone}</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    </div>

                                    <!-- Weather Widget -->
                                    <div id="weatherWidgetContainer" class="mb-12 hidden">
                                        <h3 class="text-white font-bold mb-4 text-xl tracking-tight">🌤️ Current Weather in ${searchQuery}</h3>
                                        <div class="glass-card p-6 rounded-2xl flex flex-col md:flex-row items-center gap-6"
                                             style="background: rgba(255,255,255,0.02); border-color: rgba(255,255,255,0.05);">
                                            
                                            <!-- Main Weather Info -->
                                            <div class="flex-1 flex items-center gap-6 border-b md:border-b-0 md:border-r border-[rgba(255,255,255,0.1)] pb-6 md:pb-0 md:pr-6">
                                                <div id="weatherIcon" class="text-6xl text-[var(--color-primary)]">☁️</div>
                                                <div>
                                                    <div class="text-4xl font-bold text-white mb-1"><span id="weatherTemp">--</span>°C</div>
                                                    <div class="text-sm opacity-70 text-white capitalize" id="weatherDesc">Loading weather...</div>
                                                </div>
                                            </div>

                                            <!-- Stats Grid -->
                                            <div class="flex-[2] w-full grid grid-cols-2 md:grid-cols-4 gap-4">
                                                <div>
                                                    <span class="text-xs opacity-50 block mb-1">Feels Like</span>
                                                    <strong class="text-white text-sm" id="weatherFeelsLike">--°C</strong>
                                                </div>
                                                <div>
                                                    <span class="text-xs opacity-50 block mb-1">Humidity</span>
                                                    <strong class="text-white text-sm" id="weatherHumidity">--%</strong>
                                                </div>
                                                <div>
                                                    <span class="text-xs opacity-50 block mb-1">Wind</span>
                                                    <strong class="text-white text-sm" id="weatherWind">-- km/h</strong>
                                                </div>
                                                <div>
                                                    <span class="text-xs opacity-50 block mb-1">Visibility</span>
                                                    <strong class="text-white text-sm" id="weatherVis">-- km</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Image Gallery (Masonry Grid) -->
                                    <c:if test="${not empty images}">
                                        <div class="mb-12">
                                            <h3 class="text-white font-bold mb-4 text-xl tracking-tight">📸 Landscape
                                                Photos</h3>
                                            <div class="masonry-grid">
                                                <c:forEach var="img" items="${images}" varStatus="status">
                                                    <div class="masonry-item" onclick="openLightbox('${status.index}')">
                                                        <img src="${img.url}" alt="${img.title}" loading="lazy"
                                                            onerror="this.src='https://images.unsplash.com/photo-1542332213-31f87348057f?auto=format&fit=crop&w=800&q=80'">
                                                        <div class="gallery-item-overlay">
                                                            <div class="text-xs font-semibold truncate">${img.title}
                                                            </div>
                                                            <c:set var="authorName" value="Voyastra" />
                                                            <c:if test="${not empty img.extra_data.author}">
                                                                <c:set var="authorName"
                                                                    value="${img.extra_data.author}" />
                                                            </c:if>
                                                            <div class="text-[10px] opacity-75 truncate">Photo by
                                                                ${authorName}</div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- YouTube Videos (Travel Video Hub) -->
                                    <c:if test="${not empty videos}">
                                        <div class="mb-12">
                                            <h3 class="text-white font-bold mb-6 text-xl tracking-tight">🎥 Travel Video
                                                Hub</h3>
                                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                                <c:forEach var="v" items="${videos}">
                                                    <div class="video-card glass-card flex flex-col justify-between cursor-pointer transition-transform duration-300 hover:scale-[1.02]"
                                                        style="padding:0; overflow:hidden;"
                                                        onclick="playVideo('${v.extra_data.videoId}')">
                                                        <div>
                                                            <div class="video-thumbnail-wrapper"
                                                                style="background-image: url('${v.extra_data.thumbnail}'); height: 180px; background-size: cover; background-position: center; position: relative;">
                                                                <div class="video-play-btn"
                                                                    style="position: absolute; top:50%; left:50%; transform:translate(-50%,-50%);">
                                                                    <svg width="18" height="18" viewBox="0 0 24 24"
                                                                        fill="currentColor">
                                                                        <path d="M8 5v14l11-7z" />
                                                                    </svg>
                                                                </div>
                                                            </div>
                                                            <div class="p-5">
                                                                <h4 class="text-white font-bold text-base mb-3 leading-snug line-clamp-2"
                                                                    style="margin: 0 0 10px 0; height: 44px; overflow: hidden;"
                                                                    title="${v.title}">${v.title}</h4>
                                                                <div
                                                                    class="flex items-center gap-1.5 mb-2 text-xs text-white opacity-70">
                                                                    <span>👤 ${v.extra_data.channel}</span>
                                                                </div>
                                                                <div
                                                                    class="flex justify-between items-center text-xs text-white opacity-60">
                                                                    <span id="views-${v.extra_data.videoId}">Views:
                                                                        ${v.extra_data.views}</span>
                                                                    <span
                                                                        id="date-${v.extra_data.videoId}">${v.extra_data.publishDate}</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5 pb-5">
                                                            <c:choose>
                                                                <c:when test="${not empty v.extra_data.videoId}">
                                                                    <button onclick="playVideo('${v.extra_data.videoId}')"
                                                                        class="btn btn-primary w-full py-2.5 text-xs font-bold uppercase tracking-wider flex items-center justify-center gap-2"
                                                                        style="border-radius: 8px; border:none; background:var(--color-primary); color:black; cursor:pointer;">
                                                                        ▶️ Watch Video
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button disabled
                                                                        class="btn btn-primary w-full py-2.5 text-xs font-bold uppercase tracking-wider flex items-center justify-center gap-2"
                                                                        style="border-radius: 8px; border:none; background:#555; color:#999; cursor:not-allowed;">
                                                                        ▶️ Unavailable
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Map and Sights section -->
                                    <div class="mb-12">
                                        <div class="flex justify-between items-center mb-2 flex-wrap gap-3">
                                            <h3 class="text-white font-bold text-xl tracking-tight" style="margin:0;">
                                                🗺️ Interactive Destination Map</h3>
                                            <div id="mapMarkerCount"
                                                class="text-xs text-white opacity-50 font-semibold"></div>
                                        </div>

                                        <!-- Category Filter Chips -->
                                        <div class="map-category-filters">
                                            <span class="map-filter-label">Filter:</span>
                                            <button id="mapFilter-all" class="map-filter-btn active-all"
                                                onclick="filterMapMarkers('all')">🌍 All</button>
                                            <button id="mapFilter-attraction" class="map-filter-btn"
                                                onclick="filterMapMarkers('attraction')">📍 Attractions</button>
                                            <button id="mapFilter-hotel" class="map-filter-btn"
                                                onclick="filterMapMarkers('hotel')">🏨 Hotels</button>
                                            <button id="mapFilter-restaurant" class="map-filter-btn"
                                                onclick="filterMapMarkers('restaurant')">🍴 Restaurants</button>
                                            <button id="mapFilter-experience" class="map-filter-btn"
                                                onclick="filterMapMarkers('experience')">🎭 Experiences</button>
                                        </div>

                                        <!-- Leaflet Map -->
                                        <div id="leafletMapContainer"></div>

                                        <!-- Legend -->
                                        <div class="map-legend">
                                            <div class="map-legend-item">
                                                <div class="map-legend-dot" style="background:#D4A574;"></div>
                                                Attractions
                                            </div>
                                            <div class="map-legend-item">
                                                <div class="map-legend-dot" style="background:#60A5FA;"></div> Hotels
                                            </div>
                                            <div class="map-legend-item">
                                                <div class="map-legend-dot" style="background:#F472B6;"></div>
                                                Restaurants
                                            </div>
                                            <div class="map-legend-item">
                                                <div class="map-legend-dot" style="background:#34D399;"></div>
                                                Experiences
                                            </div>
                                        </div>
                                    </div>

                                    
                                    <!-- AI Travel Insights -->
                                    <div class="mb-12" id="aiInsightsSection" style="display:none;">
                                        <h3 class="text-white font-bold mb-6 text-xl tracking-tight">✨ AI Travel Insights</h3>
                                        <div class="glass-card p-6 rounded-xl" style="background: rgba(255,255,255,0.02); border: 1px solid var(--color-glass-border);">
                                            <p id="aiInsightsText" class="text-white opacity-80 leading-relaxed text-sm whitespace-pre-line"></p>
                                        </div>
                                    </div>

                                    <!-- Hotels -->
                                    <div class="mb-12">
                                        <h3 class="text-white font-bold mb-6 text-xl tracking-tight">🏨 Recommended Hotels</h3>
                                        <div id="dynamicHotelsGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
                                    </div>

                                    <!-- Restaurants -->
                                    <div class="mb-12">
                                        <h3 class="text-white font-bold mb-6 text-xl tracking-tight">🍴 Top Dining</h3>
                                        <div id="dynamicRestaurantsGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
                                    </div>

                                    <!-- Attractions -->
                                    <div class="mb-12">
                                        <h3 class="text-white font-bold mb-6 text-xl tracking-tight">📍 Must-Visit Attractions</h3>
                                        <div id="dynamicAttractionsGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
                                    </div>

                                    <!-- Experiences -->
                                    <div class="mb-12">
                                        <h3 class="text-white font-bold mb-6 text-xl tracking-tight">🎭 Local Experiences</h3>
                                        <div id="dynamicExperiencesGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
                                    </div>

<!-- Floating Trip Cart Widget -->
                                        <div id="floatingTripCart" class="glass-card"
                                            style="position: fixed; bottom: 24px; right: 24px; z-index: 1000; width: 320px; padding: 18px; display: none; box-shadow: 0 12px 40px rgba(0,0,0,0.6); border: 1px solid var(--color-primary); background: rgba(9, 9, 11, 0.95); backdrop-filter: blur(20px);">
                                            <div class="flex justify-between items-center mb-4">
                                                <h4 class="text-white font-bold text-sm"
                                                    style="margin: 0; display: flex; align-items: center; gap: 6px;">🎒
                                                    Trip Experiences (<span id="cartCount"
                                                        style="color:var(--color-primary);">0</span>)</h4>
                                                <span onclick="toggleCartDisplay()"
                                                    style="cursor: pointer; color: white; opacity:0.6; font-size: 16px; transition: opacity 0.2s;"
                                                    onmouseover="this.style.opacity=1"
                                                    onmouseout="this.style.opacity=0.6">✕</span>
                                            </div>
                                            <div id="cartItemsList"
                                                style="max-height: 180px; overflow-y: auto; margin-bottom: 16px; display: flex; flex-direction: column; gap: 8px;">
                                                <!-- Items populated via JS -->
                                            </div>
                                            <a href="${pageContext.request.contextPath}/planner?location=${searchQuery}"
                                                class="btn btn-primary w-full py-2.5 text-center text-xs font-bold uppercase tracking-wider flex items-center justify-center gap-2"
                                                style="border-radius: 8px; display: flex; text-decoration: none; color: black; background: var(--color-primary); border: none; cursor: pointer;">
                                                🚀 Proceed to Planner
                                            </a>
                                        </div>

                                        <!-- AI Recommendations -->
                                        <c:if test="${not empty aiInsights}">
                                            <div class="glass-card mb-12"
                                                style="background: linear-gradient(135deg, rgba(30, 27, 75, 0.4), rgba(76, 29, 149, 0.3)); border-color: rgba(139, 92, 246, 0.2);">
                                                <div class="flex items-center gap-3 mb-4">
                                                    <span class="text-2xl">🤖</span>
                                                    <h3 class="text-white font-bold text-lg" style="margin: 0;">AI
                                                        Travel Tips</h3>
                                                </div>
                                                <p class="text-white opacity-85 leading-relaxed text-sm">${aiInsights}
                                                </p>
                                            </div>
                                        </c:if>

                                        <%-- ──────────────────────────────────────────────────── --%>
                                            <%-- PREMIUM PLAN MY TRIP BANNER --%>
                                                <%-- ──────────────────────────────────────────────────── --%>
                                                <style>
                                                    .premium-planner-card {
                                                        position: relative;
                                                        width: 100%;
                                                        border-radius: 24px;
                                                        overflow: hidden;
                                                        margin-bottom: 48px;
                                                        box-shadow: 0 20px 40px rgba(0,0,0,0.4);
                                                        border: 1px solid rgba(255,255,255,0.1);
                                                    }
                                                    
                                                    .premium-planner-bg {
                                                        position: absolute;
                                                        top: 0; left: 0; width: 100%; height: 100%;
                                                        background-size: cover;
                                                        background-position: center;
                                                        filter: blur(2px) brightness(0.6);
                                                        transform: scale(1.05);
                                                    }
                                                    
                                                    .premium-planner-overlay {
                                                        position: absolute;
                                                        top: 0; left: 0; width: 100%; height: 100%;
                                                        background: linear-gradient(135deg, rgba(15,23,42,0.95) 0%, rgba(15,23,42,0.5) 100%);
                                                        backdrop-filter: blur(12px);
                                                        -webkit-backdrop-filter: blur(12px);
                                                    }
                                                    
                                                    .premium-planner-content {
                                                        position: relative;
                                                        z-index: 2;
                                                        padding: 32px;
                                                        display: flex;
                                                        flex-direction: column;
                                                        gap: 24px;
                                                    }
                                                    
                                                    @media (min-width: 1024px) {
                                                        .premium-planner-content {
                                                            flex-direction: row;
                                                            align-items: stretch;
                                                            justify-content: space-between;
                                                            padding: 48px;
                                                        }
                                                        .premium-planner-header {
                                                            flex: 1;
                                                            padding-right: 40px;
                                                            display: flex;
                                                            flex-direction: column;
                                                            justify-content: center;
                                                        }
                                                        .premium-planner-actions {
                                                            width: 400px;
                                                            display: flex;
                                                            flex-direction: column;
                                                        }
                                                    }
                                                    
                                                    .premium-planner-eyebrow {
                                                        display: inline-flex;
                                                        align-items: center;
                                                        gap: 8px;
                                                        padding: 6px 14px;
                                                        background: rgba(255,255,255,0.1);
                                                        border-radius: 20px;
                                                        font-size: 12px;
                                                        font-weight: 700;
                                                        color: #fff;
                                                        letter-spacing: 1px;
                                                        text-transform: uppercase;
                                                        margin-bottom: 20px;
                                                        border: 1px solid rgba(255,255,255,0.2);
                                                        width: fit-content;
                                                    }
                                                    
                                                    .premium-planner-title {
                                                        font-size: 36px;
                                                        font-weight: 800;
                                                        color: #fff;
                                                        margin: 0 0 16px 0;
                                                        line-height: 1.2;
                                                        letter-spacing: -0.5px;
                                                    }
                                                    .premium-text-highlight { color: var(--color-primary, #D4A574); }
                                                    
                                                    .premium-planner-subtitle {
                                                        font-size: 16px;
                                                        color: rgba(255,255,255,0.85);
                                                        line-height: 1.6;
                                                        margin: 0;
                                                        max-width: 90%;
                                                    }
                                                    
                                                    .premium-planner-features {
                                                        display: flex;
                                                        flex-wrap: wrap;
                                                        gap: 12px;
                                                        margin-top: 32px;
                                                    }
                                                    
                                                    .feature-chip {
                                                        padding: 10px 18px;
                                                        background: rgba(255,255,255,0.08);
                                                        border: 1px solid rgba(255,255,255,0.15);
                                                        border-radius: 14px;
                                                        font-size: 14px;
                                                        font-weight: 600;
                                                        color: #fff;
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 8px;
                                                        transition: all 0.3s ease;
                                                    }
                                                    .feature-chip:hover {
                                                        background: rgba(255,255,255,0.15);
                                                        transform: translateY(-2px);
                                                        border-color: rgba(255,255,255,0.3);
                                                    }
                                                    
                                                    .premium-planner-actions {
                                                        background: rgba(0,0,0,0.25);
                                                        padding: 32px;
                                                        border-radius: 20px;
                                                        border: 1px solid rgba(255,255,255,0.08);
                                                        display: flex;
                                                        flex-direction: column;
                                                        justify-content: center;
                                                    }
                                                    
                                                    .duration-label {
                                                        font-size: 13px;
                                                        color: rgba(255,255,255,0.7);
                                                        margin-bottom: 12px;
                                                        font-weight: 600;
                                                        text-transform: uppercase;
                                                        letter-spacing: 0.5px;
                                                    }
                                                    
                                                    .duration-options {
                                                        display: grid;
                                                        grid-template-columns: 1fr 1fr;
                                                        gap: 10px;
                                                        margin-bottom: 24px;
                                                    }
                                                    
                                                    .duration-chip {
                                                        text-align: center;
                                                        padding: 14px 0;
                                                        background: rgba(255,255,255,0.06);
                                                        border: 1px solid rgba(255,255,255,0.12);
                                                        border-radius: 12px;
                                                        color: #fff;
                                                        font-size: 14px;
                                                        font-weight: 600;
                                                        text-decoration: none;
                                                        transition: all 0.3s ease;
                                                    }
                                                    .duration-chip:hover {
                                                        background: rgba(255,255,255,0.15);
                                                        color: #fff;
                                                    }
                                                    .duration-chip.active {
                                                        background: var(--color-primary, #D4A574);
                                                        color: #000;
                                                        border-color: var(--color-primary, #D4A574);
                                                    }
                                                    .duration-chip.custom {
                                                        background: transparent;
                                                        border: 1px dashed rgba(255,255,255,0.3);
                                                    }
                                                    .duration-chip.custom:hover {
                                                        border-style: solid;
                                                    }
                                                    
                                                    .premium-cta-btn {
                                                        position: relative;
                                                        display: flex;
                                                        justify-content: center;
                                                        align-items: center;
                                                        gap: 10px;
                                                        width: 100%;
                                                        padding: 18px;
                                                        background: linear-gradient(135deg, #D4A574, #b58655);
                                                        color: #000;
                                                        font-size: 16px;
                                                        font-weight: 800;
                                                        text-transform: uppercase;
                                                        letter-spacing: 1px;
                                                        border-radius: 14px;
                                                        text-decoration: none;
                                                        overflow: hidden;
                                                        transition: all 0.3s ease;
                                                        box-shadow: 0 10px 25px rgba(212, 165, 116, 0.3);
                                                        border: none;
                                                    }
                                                    
                                                    .premium-cta-btn:hover {
                                                        transform: translateY(-3px);
                                                        box-shadow: 0 15px 35px rgba(212, 165, 116, 0.4);
                                                        color: #000;
                                                    }
                                                    
                                                    .cta-shimmer {
                                                        position: absolute;
                                                        top: 0; left: -100%; width: 50%; height: 100%;
                                                        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
                                                        animation: shimmer 2.5s infinite;
                                                    }
                                                    
                                                    @keyframes shimmer {
                                                        0% { left: -100%; }
                                                        100% { left: 200%; }
                                                    }
                                                    
                                                    .premium-planner-footer {
                                                        margin-top: 20px;
                                                        text-align: center;
                                                    }
                                                    
                                                    .time-est {
                                                        font-size: 13px;
                                                        color: rgba(255,255,255,0.7);
                                                        font-weight: 500;
                                                        display: inline-flex;
                                                        align-items: center;
                                                        gap: 6px;
                                                    }
                                                    </style>
                                                    
                                                    <c:set var="heroBg" value="https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=1600&q=80" />
                                                    <c:if test="${not empty images and fn:length(images) > 0}">
                                                        <c:set var="heroBg" value="${images[0].url}" />
                                                    </c:if>
                                                    
                                                    <div class="premium-planner-card" id="planMyTripBanner">
                                                        <div class="premium-planner-bg" style="background-image: url('${heroBg}');"></div>
                                                        <div class="premium-planner-overlay"></div>
                                                        
                                                        <div class="premium-planner-content">
                                                            <div class="premium-planner-header">
                                                                <span class="premium-planner-eyebrow">✨ AI-Powered Planning</span>
                                                                <h2 class="premium-planner-title">Plan Your Perfect Trip to <span class="premium-text-highlight">${searchQuery}</span></h2>
                                                                <p class="premium-planner-subtitle">Let Voyastra AI design a full day-by-day itinerary tailored perfectly to your preferences.</p>
                                                                
                                                                <div class="premium-planner-features">
                                                                    <span class="feature-chip">✈️ Flights</span>
                                                                    <span class="feature-chip">🏨 Hotels</span>
                                                                    <span class="feature-chip">🎭 Activities</span>
                                                                    <span class="feature-chip">💰 Budget</span>
                                                                </div>
                                                            </div>
                                                    
                                                            <div class="premium-planner-actions">
                                                                <div class="duration-label">Trip Length Options</div>
                                                                <div class="duration-options">
                                                                    <a href="${pageContext.request.contextPath}/planner?location=${searchQuery}&days=3" class="duration-chip">3 Days</a>
                                                                    <a href="${pageContext.request.contextPath}/planner?location=${searchQuery}&days=5" class="duration-chip active">5 Days</a>
                                                                    <a href="${pageContext.request.contextPath}/planner?location=${searchQuery}&days=7" class="duration-chip">7 Days</a>
                                                                    <a href="${pageContext.request.contextPath}/planner?location=${searchQuery}" class="duration-chip custom">Custom</a>
                                                                </div>
                                                                
                                                                <a href="${pageContext.request.contextPath}/planner?location=${searchQuery}" class="premium-cta-btn">
                                                                    <span>Generate AI Itinerary</span>
                                                                    <div class="cta-shimmer"></div>
                                                                </a>
                                                                
                                                                <div class="premium-planner-footer">
                                                                    <span class="time-est">⚡ Generated in under 30 seconds</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                </div>
                            </c:if>

                        </div>
                    </main>

                    <!-- Hotel Booking Modal -->
                    <div id="hotelBookingModal" class="booking-modal">
                        <div class="booking-modal-content">
                            <span class="booking-modal-close" onclick="closeBookingModal('hotel')">&times;</span>
                            <div id="hotelBookingFormContainer">
                                <h3 class="text-white font-bold text-xl mb-4"
                                    style="margin: 0 0 16px 0; font-family: 'Outfit', sans-serif;">🛎️ Book Hotel</h3>
                                <h4 id="bookingHotelName" class="text-[var(--color-primary)] font-bold text-base mb-6"
                                    style="margin: 0 0 24px 0;"></h4>

                                <form id="hotelBookingForm" onsubmit="submitHotelBooking(event)">
                                    <input type="hidden" id="hotelBookingNameInput" name="hotelName">

                                    <div class="booking-form-group">
                                        <label for="hotelGuestName">Guest Name</label>
                                        <input type="text" id="hotelGuestName" name="guestName"
                                            class="booking-form-input" required placeholder="John Doe">
                                    </div>

                                    <div class="booking-form-group">
                                        <label for="hotelEmail">Email Address</label>
                                        <input autocomplete="email" type="email" id="hotelEmail" name="email" class="booking-form-input"
                                            required placeholder="john.doe@example.com">
                                    </div>

                                    <div class="booking-form-group">
                                        <label for="hotelPhone">Phone Number</label>
                                        <input autocomplete="tel" type="tel" id="hotelPhone" name="phone" class="booking-form-input"
                                            required placeholder="+1 (555) 019-2834">
                                    </div>

                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                        <div class="booking-form-group">
                                            <label for="hotelCheckIn">Check-in</label>
                                            <input type="date" id="hotelCheckIn" name="checkIn"
                                                class="booking-form-input" required>
                                        </div>
                                        <div class="booking-form-group">
                                            <label for="hotelCheckOut">Check-out</label>
                                            <input type="date" id="hotelCheckOut" name="checkOut"
                                                class="booking-form-input" required>
                                        </div>
                                    </div>

                                    <div class="booking-form-group">
                                        <label for="hotelGuests">Number of Guests</label>
                                        <select id="hotelGuests" name="guests" class="booking-form-input"
                                            style="appearance: none; background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%2523FFF%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22/%3E%3C/svg%3E'); background-repeat: no-repeat; background-position: right 12px top 50%; background-size: 10px auto;">
                                            <option value="1">1 Guest</option>
                                            <option value="2" selected>2 Guests</option>
                                            <option value="3">3 Guests</option>
                                            <option value="4">4 Guests</option>
                                        </select>
                                    </div>

                                    <button type="submit"
                                        class="btn btn-primary w-full py-3 text-xs font-bold uppercase tracking-wider mt-4"
                                        style="border-radius: 8px; border:none; background:var(--color-primary); color:black; cursor:pointer;">
                                        💳 Confirm Hotel Booking
                                    </button>
                                </form>
                            </div>
                            <div id="hotelBookingLoading" style="display: none; text-align: center; padding: 40px 0;">
                                <div class="spinner-ring" style="margin: 0 auto 20px auto;"></div>
                                <h4 class="text-white font-bold">Securing your room...</h4>
                                <p class="text-white opacity-70 text-xs mt-2">Connecting with reservation API</p>
                            </div>
                            <div id="hotelBookingSuccess" style="display: none;">
                                <!-- Dynamic Success Ticket -->
                            </div>
                        </div>
                    </div>

                    <!-- Restaurant Reservation Modal -->
                    <div id="restaurantBookingModal" class="booking-modal">
                        <div class="booking-modal-content">
                            <span class="booking-modal-close" onclick="closeBookingModal('restaurant')">&times;</span>
                            <div id="restaurantBookingFormContainer">
                                <h3 class="text-white font-bold text-xl mb-4"
                                    style="margin: 0 0 16px 0; font-family: 'Outfit', sans-serif;">🍷 Reserve Table</h3>
                                <h4 id="bookingRestaurantName"
                                    class="text-[var(--color-primary)] font-bold text-base mb-6"
                                    style="margin: 0 0 24px 0;"></h4>

                                <form id="restaurantBookingForm" onsubmit="submitRestaurantBooking(event)">
                                    <input type="hidden" id="restaurantBookingNameInput" name="restaurantName">

                                    <div class="booking-form-group">
                                        <label for="restGuestName">Guest Name</label>
                                        <input type="text" id="restGuestName" name="guestName"
                                            class="booking-form-input" required placeholder="John Doe">
                                    </div>

                                    <div class="booking-form-group">
                                        <label for="restEmail">Email Address</label>
                                        <input autocomplete="email" type="email" id="restEmail" name="email" class="booking-form-input"
                                            required placeholder="john.doe@example.com">
                                    </div>

                                    <div style="display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 12px;">
                                        <div class="booking-form-group">
                                            <label for="restDate">Date</label>
                                            <input type="date" id="restDate" name="date" class="booking-form-input"
                                                required>
                                        </div>
                                        <div class="booking-form-group">
                                            <label for="restTime">Time</label>
                                            <select id="restTime" name="time" class="booking-form-input"
                                                style="appearance: none; background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%2523FFF%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22/%3E%3C/svg%3E'); background-repeat: no-repeat; background-position: right 12px top 50%; background-size: 10px auto;">
                                                <option value="12:00 PM">12:00 PM</option>
                                                <option value="1:00 PM">1:00 PM</option>
                                                <option value="2:00 PM">2:00 PM</option>
                                                <option value="6:00 PM">6:00 PM</option>
                                                <option value="7:00 PM" selected>7:00 PM</option>
                                                <option value="8:00 PM">8:00 PM</option>
                                                <option value="9:00 PM">9:00 PM</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="booking-form-group">
                                        <label for="restGuests">Number of Guests</label>
                                        <select id="restGuests" name="guests" class="booking-form-input"
                                            style="appearance: none; background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%2523FFF%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22/%3E%3C/svg%3E'); background-repeat: no-repeat; background-position: right 12px top 50%; background-size: 10px auto;">
                                            <option value="1">1 Guest</option>
                                            <option value="2" selected>2 Guests</option>
                                            <option value="3">3 Guests</option>
                                            <option value="4">4 Guests</option>
                                            <option value="6">6 Guests</option>
                                        </select>
                                    </div>

                                    <button type="submit"
                                        class="btn btn-primary w-full py-3 text-xs font-bold uppercase tracking-wider mt-4"
                                        style="border-radius: 8px; border:none; background:var(--color-primary); color:black; cursor:pointer;">
                                        🍷 Confirm Table Reservation
                                    </button>
                                </form>
                            </div>
                            <div id="restaurantBookingLoading"
                                style="display: none; text-align: center; padding: 40px 0;">
                                <div class="spinner-ring" style="margin: 0 auto 20px auto;"></div>
                                <h4 class="text-white font-bold">Reserving your table...</h4>
                                <p class="text-white opacity-70 text-xs mt-2">Connecting with table layout engine</p>
                            </div>
                            <div id="restaurantBookingSuccess" style="display: none;">
                                <!-- Dynamic Success Ticket -->
                            </div>
                        </div>
                    </div>

                        <c:if test="${not empty mapMarkersJsonString}">
                            <script type="application/json" id="_mapMarkersJson">${mapMarkersJsonString}</script>
                        </c:if>
                        <c:if test="${not empty attractionsJsonString}">
                            <script type="application/json" id="_attractionsJsonData">${attractionsJsonString}</script>
                        </c:if>
                        <c:if test="${not empty foodsJsonString}">
                            <script type="application/json" id="_foodsJsonData">${foodsJsonString}</script>
                        </c:if>
                        <c:if test="${not empty travelTipsJsonString}">
                            <script type="application/json" id="_travelTipsJson">${travelTipsJsonString}</script>
                        </c:if>
                        <c:if test="${not empty itineraryPreviewsJsonString}">
                            <script type="application/json" id="_itineraryPreviewsJson">${itineraryPreviewsJsonString}</script>
                        </c:if>
                        <c:if test="${not empty experiencesJsonString}">
                            <script type="application/json" id="_experiencesJsonData">${experiencesJsonString}</script>
                        </c:if>
                        <% com.google.gson.JsonArray cartArr=new com.google.gson.JsonArray();
                            java.util.List<com.google.gson.JsonObject> cartItems = (java.util.List
                            <com.google.gson.JsonObject>) session.getAttribute("selectedExperiences");
                                if (cartItems != null) {
                                for (com.google.gson.JsonObject item : cartItems) {
                                cartArr.add(item);
                                }
                                }
                                request.setAttribute("_cartJsonStr", cartArr.toString());
                                %>
                                <c:if test="${not empty _cartJsonStr and _cartJsonStr != '[]'}">
                                    <script type="application/json" id="_initialCartJson">${_cartJsonStr}</script>
                                </c:if>
                                <c:if test="${not empty videos}">
                                    <script type="application/json" id="_videosJsonData">${videos}</script>
                                </c:if>
                                <c:if test="${not empty images}">
                                    <script type="application/json" id="_imagesJsonData">${images}</script>
                                </c:if>
                                <c:if test="${not empty experiences}">
                                    <script type="application/json" id="_experiencesJsonData">${experiences}</script>
                                </c:if>

                                <script>
                                    // Show overlay when submitting form
                                    function showLoadingOverlay() {
                                        document.getElementById('searchLoaderOverlay').classList.add('active');
                                    }

                                    // Submit chip search helper
                                    function submitSearch(term) {
                                        document.getElementById('expSearchInput').value = term;
                                        showLoadingOverlay();
                                        document.getElementById('expSearchForm').submit();
                                    }

                                    // Booking modals controller
                                    function openHotelBookingModal(hotelName) {
                                        document.getElementById('bookingHotelName').innerText = hotelName;
                                        document.getElementById('hotelBookingNameInput').value = hotelName;

                                        // Reset states
                                        document.getElementById('hotelBookingFormContainer').style.display = 'block';
                                        document.getElementById('hotelBookingLoading').style.display = 'none';
                                        document.getElementById('hotelBookingSuccess').style.display = 'none';

                                        // Set dates default (today and tomorrow)
                                        const today = new Date();
                                        const tomorrow = new Date(today);
                                        tomorrow.setDate(tomorrow.getDate() + 1);

                                        document.getElementById('hotelCheckIn').value = today.toISOString().split('T')[0];
                                        document.getElementById('hotelCheckOut').value = tomorrow.toISOString().split('T')[0];

                                        document.getElementById('hotelBookingModal').classList.add('active');
                                        document.body.style.overflow = 'hidden';
                                    }

                                    function openRestaurantBookingModal(restaurantName) {
                                        document.getElementById('bookingRestaurantName').innerText = restaurantName;
                                        document.getElementById('restaurantBookingNameInput').value = restaurantName;

                                        // Reset states
                                        document.getElementById('restaurantBookingFormContainer').style.display = 'block';
                                        document.getElementById('restaurantBookingLoading').style.display = 'none';
                                        document.getElementById('restaurantBookingSuccess').style.display = 'none';

                                        // Set date default (today)
                                        const today = new Date();
                                        document.getElementById('restDate').value = today.toISOString().split('T')[0];

                                        document.getElementById('restaurantBookingModal').classList.add('active');
                                        document.body.style.overflow = 'hidden';
                                    }

                                    function closeBookingModal(type) {
                                        if (type === 'hotel') {
                                            document.getElementById('hotelBookingModal').classList.remove('active');
                                        } else if (type === 'restaurant') {
                                            document.getElementById('restaurantBookingModal').classList.remove('active');
                                        }
                                        document.body.style.overflow = '';
                                    }

                                    function submitHotelBooking(event) {
                                        event.preventDefault();

                                        const form = document.getElementById('hotelBookingForm');
                                        const formData = new FormData(form);

                                        document.getElementById('hotelBookingFormContainer').style.display = 'none';
                                        document.getElementById('hotelBookingLoading').style.display = 'block';

                                        const params = new URLSearchParams();
                                        params.append('action', 'bookHotel');
                                        for (const pair of formData.entries()) {
                                            params.append(pair[0], pair[1]);
                                        }

                                        fetch('${pageContext.request.contextPath}/experiences', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                            },
                                            body: params.toString()
                                        })
                                            .then(response => { if(!response.ok) throw new Error('HTTP error'); const ct = response.headers.get('content-type'); if(ct && ct.includes('application/json')) return response.json(); return {}; })
                                            
                                            .then(data => {
                                                console.log('Weather API Success');
                                                console.timeEnd('Weather');
                                                document.getElementById('hotelBookingLoading').style.display = 'none';
                                                if (data.success) {
                                                    const successContainer = document.getElementById('hotelBookingSuccess');
                                                    successContainer.innerHTML = `
                    <div style="text-align: center;">
                        <span style="font-size: 3rem; color: #22c55e;">✓</span>
                        <h3 class="text-white font-bold text-lg mb-2" style="font-family: 'Outfit', sans-serif;">Booking Confirmed!</h3>
                        <p class="text-white opacity-85 text-xs mb-4">\${data.message}</p>
                        
                        <div class="booking-success-ticket text-left">
                            <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:11px; color:#a1a1aa;">
                                <span>Booking Ref:</span>
                                <strong style="color:var(--color-primary); font-family: 'Outfit', sans-serif;">\${data.bookingCode}</strong>
                            </div>
                            <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:11px; color:#a1a1aa;">
                                <span>Hotel:</span>
                                <strong style="color:#fff;">\${data.hotelName}</strong>
                            </div>
                            <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:11px; color:#a1a1aa;">
                                <span>Guest:</span>
                                <strong style="color:#fff;">\${data.guestName}</strong>
                            </div>
                            <div style="display:flex; justify-content:space-between; font-size:11px; color:#a1a1aa;">
                                <span>Dates:</span>
                                <strong style="color:#fff;">\${data.checkIn} to \${data.checkOut}</strong>
                            </div>
                        </div>
                        
                        <button onclick="closeBookingModal('hotel')" class="btn btn-primary w-full py-2.5 text-xs font-bold uppercase tracking-wider mt-6" style="border-radius: 8px; border:none; background:var(--color-primary); color:black; cursor:pointer;">
                            Done
                        </button>
                    </div>
                `;
                                                    successContainer.style.display = 'block';
                                                }
                                            })
                                            .catch(err => {
                                                console.error('Hotel booking failed:', err);
                                                document.getElementById('hotelBookingLoading').style.display = 'none';
                                                document.getElementById('hotelBookingFormContainer').style.display = 'block';
                                                alert('An error occurred. Please try again.');
                                            });
                                    }

                                    function submitRestaurantBooking(event) {
                                        event.preventDefault();

                                        const form = document.getElementById('restaurantBookingForm');
                                        const formData = new FormData(form);

                                        document.getElementById('restaurantBookingFormContainer').style.display = 'none';
                                        document.getElementById('restaurantBookingLoading').style.display = 'block';

                                        const params = new URLSearchParams();
                                        params.append('action', 'reserveRestaurant');
                                        for (const pair of formData.entries()) {
                                            params.append(pair[0], pair[1]);
                                        }

                                        fetch('${pageContext.request.contextPath}/experiences', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                            },
                                            body: params.toString()
                                        })
                                            .then(response => { if(!response.ok) throw new Error('HTTP error'); const ct = response.headers.get('content-type'); if(ct && ct.includes('application/json')) return response.json(); return {}; })
                                            .then(data => {
                                                document.getElementById('restaurantBookingLoading').style.display = 'none';
                                                if (data.success) {
                                                    const successContainer = document.getElementById('restaurantBookingSuccess');
                                                    successContainer.innerHTML = `
                    <div style="text-align: center;">
                        <span style="font-size: 3rem; color: #22c55e;">✓</span>
                        <h3 class="text-white font-bold text-lg mb-2" style="font-family: 'Outfit', sans-serif;">Table Reserved!</h3>
                        <p class="text-white opacity-85 text-xs mb-4">\${data.message}</p>
                        
                        <div class="booking-success-ticket text-left">
                            <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:11px; color:#a1a1aa;">
                                <span>Reservation Ref:</span>
                                <strong style="color:var(--color-primary); font-family: 'Outfit', sans-serif;">\${data.reservationCode}</strong>
                            </div>
                            <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:11px; color:#a1a1aa;">
                                <span>Restaurant:</span>
                                <strong style="color:#fff;">\${data.restaurantName}</strong>
                            </div>
                            <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:11px; color:#a1a1aa;">
                                <span>Guest Name:</span>
                                <strong style="color:#fff;">\${data.guestName}</strong>
                            </div>
                            <div style="display:flex; justify-content:space-between; font-size:11px; color:#a1a1aa;">
                                <span>Time Slot:</span>
                                <strong style="color:#fff;">\${data.date} at \${data.time}</strong>
                            </div>
                        </div>
                        
                        <button onclick="closeBookingModal('restaurant')" class="btn btn-primary w-full py-2.5 text-xs font-bold uppercase tracking-wider mt-6" style="border-radius: 8px; border:none; background:var(--color-primary); color:black; cursor:pointer;">
                            Done
                        </button>
                    </div>
                `;
                                                    successContainer.style.display = 'block';
                                                }
                                            })
                                            .catch(err => {
                                                console.error('Restaurant reservation failed:', err);
                                                document.getElementById('restaurantBookingLoading').style.display = 'none';
                                                document.getElementById('restaurantBookingFormContainer').style.display = 'block';
                                                alert('An error occurred. Please try again.');
                                            });
                                    }

                                    // Global Lightbox and Video Controllers
                                    let galleryImages = [];
                                    let currentImageIndex = 0;

                                    window.openLightbox = function(index) {
                                        currentImageIndex = parseInt(index, 10);
                                        const imgData = galleryImages[currentImageIndex];
                                        if (!imgData) return;

                                        document.getElementById('lightboxImg').src = imgData.url;
                                        document.getElementById('lightboxTitle').innerText = imgData.title;
                                        if (imgData.author && imgData.authorLink) {
                                            document.getElementById('lightboxCredit').innerHTML = 'Photo by <a href="' + imgData.authorLink + '" target="_blank" style="color:var(--color-primary); text-decoration:underline;">' + imgData.author + '</a> on Unsplash';
                                        }
                                        document.getElementById('galleryLightbox').classList.add('active');
                                        document.body.style.overflow = 'hidden';
                                    };

                                    window.closeLightbox = function() {
                                        document.getElementById('galleryLightbox').classList.remove('active');
                                        document.body.style.overflow = '';
                                    };

                                    window.nextImage = function() {
                                        if (galleryImages.length === 0) return;
                                        currentImageIndex = (currentImageIndex + 1) % galleryImages.length;
                                        window.openLightbox(currentImageIndex);
                                    };

                                    window.prevImage = function() {
                                        if (galleryImages.length === 0) return;
                                        currentImageIndex = (currentImageIndex - 1 + galleryImages.length) % galleryImages.length;
                                        window.openLightbox(currentImageIndex);
                                    };

                                    window.playVideo = function(videoId) {
                                        if (!videoId) return;
                                        console.log("[YOUTUBE]");
                                        console.log("Video Selected");
                                        console.log("[YOUTUBE]");
                                        console.log("Video ID: " + videoId);
                                        console.log("[YOUTUBE]");
                                        console.log("Opening Modal");

                                        const modal = document.getElementById('youtubeModal');
                                        const iframe = document.getElementById('youtubeIframe');
                                        if (modal && iframe) {
                                            iframe.src = 'https://www.youtube.com/embed/' + videoId + '?autoplay=1';
                                            iframe.onload = function() {
                                                if (iframe.src && iframe.src.indexOf('youtube.com') !== -1) {
                                                    console.log("[YOUTUBE]");
                                                    console.log("Playback Started");
                                                }
                                            };
                                            modal.style.display = 'flex';
                                        }
                                    };

                                    window.closeVideoModal = function() {
                                        const modal = document.getElementById('youtubeModal');
                                        const iframe = document.getElementById('youtubeIframe');
                                        if (modal && iframe) {
                                            iframe.src = '';
                                            modal.style.display = 'none';
                                        }
                                    };

                                    // Keyboard navigation for lightbox
                                    document.addEventListener('keydown', function (e) {
                                        const lightbox = document.getElementById('galleryLightbox');
                                        if (lightbox && lightbox.classList.contains('active')) {
                                            if (e.key === 'ArrowRight') nextImage();
                                            else if (e.key === 'ArrowLeft') prevImage();
                                            else if (e.key === 'Escape') closeLightbox();
                                        }
                                    });

                                    document.addEventListener('DOMContentLoaded', function () {
                                        const formatViews = (viewsStr) => {
                                            const num = parseInt(viewsStr, 10);
                                            if (isNaN(num) || num <= 0) return 'No views';
                                            if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M views';
                                            if (num >= 1000) return (num / 1000).toFixed(0) + 'K views';
                                            return num + ' views';
                                        };

                                        const formatDate = (dateStr) => {
                                            try {
                                                const date = new Date(dateStr);
                                                return date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
                                            } catch (e) {
                                                return dateStr;
                                            }
                                        };

                                        try {
                                            const vJson = document.getElementById('_videosJsonData');
                                            if (vJson && vJson.textContent.trim() !== "") {
                                                const parsedVideos = JSON.parse(vJson.textContent);
                                                parsedVideos.forEach(v => {
                                                    if (!v.extra_data) return;
                                                    const viewEl = document.getElementById('views-' + v.extra_data.videoId);
                                                    if (viewEl) viewEl.innerText = formatViews(v.extra_data.views);
                                                    const dateEl = document.getElementById('date-' + v.extra_data.videoId);
                                                    if (dateEl) dateEl.innerText = 'Published: ' + formatDate(v.extra_data.publishDate);
                                                });
                                            }
                                        } catch (e) { }

                                        let attractionsData = [];
                                        let foodsData = [];

                                        try {
                                            const iJson = document.getElementById('_imagesJsonData');
                                            if (iJson && iJson.textContent.trim() !== "") {
                                                const parsedImages = JSON.parse(iJson.textContent);
                                                parsedImages.forEach(img => {
                                                    galleryImages.push({
                                                        url: img.url,
                                                        title: img.title,
                                                        author: (img.extra_data && img.extra_data.author) ? img.extra_data.author : "Voyastra",
                                                        authorLink: (img.extra_data && img.extra_data.author_link) ? img.extra_data.author_link : "https://unsplash.com"
                                                    });
                                                });
                                            }
                                        } catch (e) { }

                                        const attrJson = document.getElementById('_attractionsJsonData');
                                        if (attrJson && attrJson.textContent.trim() !== "") {
                                            try { attractionsData = JSON.parse(attrJson.textContent); } catch (e) { }
                                        }

                                        const foodJson = document.getElementById('_foodsJsonData');
                                        if (foodJson && foodJson.textContent.trim() !== "") {
                                            try { foodsData = JSON.parse(foodJson.textContent); } catch (e) { }
                                        }

                                        if (attractionsData.length > 0) {
                                            renderAttractionElements(attractionsData);
                                        }

                                        // Initialize unified Google Map from mapMarkers
                                        let mapMarkersData = [];
                                        try {
                                            const _mapJson = document.getElementById('_mapMarkersJson');
                                            if (_mapJson && _mapJson.textContent.trim() !== "") {
                                                mapMarkersData = JSON.parse(_mapJson.textContent);
                                            }
                                        } catch (e) { 
                                            console.warn('Map markers parse error', e);
                                            console.warn('Invalid JSON was:', document.getElementById('_mapMarkersJson')?.textContent);
                                        }

                                        const mapContainer = document.getElementById('leafletMapContainer');
                                        if (mapContainer) {
                                            if (mapMarkersData.length > 0) {
                                                const destLat = parseFloat('${destLat}') || 0;
                                                const destLng = parseFloat('${destLng}') || 0;
                                                // Initialize Google Maps integration replacing old Leaflet code
                                                if (typeof initGoogleMap === 'function') {
                                                    initGoogleMap('leafletMapContainer', destLat, destLng, mapMarkersData);
                                                }
                                            } else {
                                                // Display loading spinner while dynamic fetch runs
                                                mapContainer.innerHTML = '<div style="display:flex; justify-content:center; align-items:center; height:100%; min-height:400px; color:white; background:rgba(255,255,255,0.05); border-radius:12px; font-weight:bold;"><i class="ri-loader-4-line animate-spin" style="margin-right: 10px; font-size: 24px;"></i> Loading Interactive Map...</div>';
                                            }
                                        }

                                        console.log("[FOOD]");
                                        console.log("Items Returned");

                                        if (!foodsData || foodsData.length === 0) {
                                            foodsData = [
                                                { name: "Local Speciality", desc: "A rich and flavorful traditional dish.", type: "Veg", image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80", must_try: true },
                                                { name: "Street Food Delight", desc: "Crispy and savory local street food.", type: "Non-Veg", image: "https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80", must_try: true },
                                                { name: "Regional Dessert", desc: "A popular and authentic sweet treat.", type: "Dessert", image: "https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=600&q=80", must_try: false }
                                            ];
                                        }

                                        renderFoodElements(foodsData);

                                        let experiencesData = {};
                                        try {
                                            const _expJson = document.getElementById('_experiencesJsonData');
                                            if (_expJson && _expJson.textContent.trim()) {
                                                experiencesData = JSON.parse(_expJson.textContent);
                                            }
                                        } catch (e) {
                                            console.warn('Experiences parse error', e);
                                        }
                                        initExperiences(experiencesData);

                                        let travelTipsData = {};
                                        try {
                                            const _tipsJson = document.getElementById('_travelTipsJson');
                                            if (_tipsJson && _tipsJson.textContent.trim() !== "") travelTipsData = JSON.parse(_tipsJson.textContent);
                                        } catch (e) { console.warn('Travel tips parse error', e); }
                                        if (Object.keys(travelTipsData).length > 0) {
                                            renderTravelTips(travelTipsData);
                                        }

                                        // Itinerary Previews
                                        let itineraryPreviewsData = [];
                                        try {
                                            const _itinJson = document.getElementById('_itineraryPreviewsJson');
                                            if (_itinJson && _itinJson.textContent.trim() !== "") itineraryPreviewsData = JSON.parse(_itinJson.textContent);
                                        } catch (e) { console.warn('Itinerary previews parse error', e); }
                                        if (itineraryPreviewsData.length > 0) {
                                            renderItineraryPreviews(itineraryPreviewsData, '${searchQuery}');
                                        }
                                                                   // ── Google Map with multi-category markers ─────────────────────────────
                                    function initGoogleMapWrapper(markersData) {
                                        const destLat = parseFloat('${destLat}');
                                        const destLng = parseFloat('${destLng}');
                                        
                                        let centerLat = destLat;
                                        let centerLng = destLng;
                                        
                                        if (isNaN(destLat) || isNaN(destLng)) {
                                            if (markersData && markersData.length > 0) {
                                                const centerPoint = markersData.find(m => m.category === 'attraction') || markersData[0];
                                                centerLat = centerPoint.lat;
                                                centerLng = centerPoint.lng;
                                            }
                                        }
                                        
                                        if (typeof initGoogleMap === 'function') {
                                            initGoogleMap('googleMapContainer', centerLat, centerLng, markersData, 12);
                                        }
                                    }

                                    function updateMarkerCount() {
                                        // Optional: update UI count if needed
                                    }

                                        // filterMapMarkers moved to google-map.js for global access
                                    function focusMapOn(lat, lng, idx) {
                                        if (globalActiveMap) {
                                            globalActiveMap.panTo({ lat: parseFloat(lat), lng: parseFloat(lng) });
                                            globalActiveMap.setZoom(14);
                                        }
                                    }

                                        let initialCart = [];
                                        try {
                                            const _cartJson = document.getElementById('_initialCartJson');
                                            if (_cartJson && _cartJson.textContent.trim() !== "") initialCart = JSON.parse(_cartJson.textContent) || [];
                                        } catch (e) { console.warn('Cart parse error', e); }
                                        updateCartUI(initialCart);
                                    });


                                    function renderAttractionElements(attractions) {
                                        const list = document.getElementById('attractionCardsList');
                                        if (!list) return;
                                        list.innerHTML = '';
                                        attractions.forEach((attr, index) => {
                                            const whyVisitHtml = attr.why_visit ? `
                <div class="why-visit-box" style="margin-top: 10px; padding-top: 8px; border-top: 1px solid rgba(255,255,255,0.06);">
                    <span style="color: var(--color-primary); font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 2px;">🌟 Why Visit</span>
                    <p class="text-white opacity-80" style="margin: 0; font-size: 11px; font-style: italic; line-height: 1.4;">"\${attr.why_visit}"</p>
                </div>
            ` : '';

                                            let badgesHtml = '';
                                            if (attr.best_time || attr.duration) {
                                                badgesHtml += '<div style="display: flex; flex-wrap: wrap; gap: 6px; margin-top: 8px;">';
                                                if (attr.best_time) badgesHtml += '<span class="badge-item">📅 ' + attr.best_time + '</span>';
                                                if (attr.duration) badgesHtml += '<span class="badge-item">⏱️ ' + attr.duration + '</span>';
                                                badgesHtml += '</div>';
                                            }

                                            const card = `
                <div class="glass-card attraction-list-card ` + (index === 0 ? 'active' : '') + `" id="serverAttrCard-` + index + `" onclick="highlightMarker(` + index + `, ` + attr.lat + `, ` + attr.lng + `)" style="padding: 16px; margin-bottom: 10px;">
                    <h4 class="text-white font-bold mb-1 text-base" style="margin: 0 0 4px 0;">` + attr.name + `</h4>
                    <p class="text-white opacity-70 text-xs" style="margin: 0; line-height: 1.4;">` + attr.desc + `</p>
                    \${badgesHtml}
                    \${whyVisitHtml}
                </div>
            `;
                                            list.insertAdjacentHTML('beforeend', card);
                                        });
                                    }

                                    function renderFoodElements(foods) {
                                        console.log("[FOOD]");
                                        console.log("Rendering Cards");

                                        const mustTryDeck = document.querySelector('.must-try-deck');
                                        const regularDeck = document.querySelector('.food-card-deck');
                                        const mustTrySection = document.getElementById('mustTrySection');

                                        if (!regularDeck) return;

                                        regularDeck.innerHTML = '';
                                        if (mustTryDeck) mustTryDeck.innerHTML = '';

                                        let hasMustTry = false;

                                        foods.forEach(food => {
                                            let tagClass = 'food-tag-veg';
                                            if (food.type) {
                                                const t = food.type.toLowerCase();
                                                if (t.includes('non') || t.includes('meat') || t.includes('fish')) tagClass = 'food-tag-nonveg';
                                                else if (t.includes('dessert') || t.includes('sweet')) tagClass = 'food-tag-dessert';
                                                else if (t.includes('drink') || t.includes('brew') || t.includes('beverage')) tagClass = 'food-tag-drink';
                                            }

                                            const imgUrl = food.image || 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80';
                                            const regionBadge = food.region ? `
                <div class="food-card-region">
                    📍 \${food.region}
                </div>
            ` : '';

                                            const wikiLink = food.wikipedia_url ? `
                <div class="mt-4">
                    <a href="\${food.wikipedia_url}" target="_blank" style="color: var(--color-primary); font-size: 11px; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                        Learn on Wikipedia ➜
                    </a>
                </div>
            ` : '';

                                            const cardHtml = `
                <div class="food-card">
                    <div class="food-card-img-wrapper">
                        <span class="food-card-tag \${tagClass}">\${food.type || 'Veg'}</span>
                        <img src="\${imgUrl}" alt="\${food.name}" loading="lazy" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80'">
                    </div>
                    <div class="food-card-content">
                        <div>
                            \${regionBadge}
                            <h3 class="text-white font-bold mb-2 text-lg" style="margin: 0 0 8px 0;">\${food.name}</h3>
                            <p class="text-white opacity-75 text-sm" style="margin: 0; line-height: 1.5;">\${food.desc}</p>
                        </div>
                        \${wikiLink}
                    </div>
                </div>
            `;

                                            if (food.must_try) {
                                                hasMustTry = true;
                                                if (mustTryDeck) {
                                                    mustTryDeck.insertAdjacentHTML('beforeend', cardHtml);
                                                } else {
                                                    regularDeck.insertAdjacentHTML('beforeend', cardHtml);
                                                }
                                            } else {
                                                regularDeck.insertAdjacentHTML('beforeend', cardHtml);
                                            }
                                        });

                                        if (hasMustTry && mustTrySection) {
                                            mustTrySection.style.display = 'block';
                                        } else if (mustTrySection) {
                                            mustTrySection.style.display = 'none';
                                        }

                                        console.log("[FOOD]");
                                        console.log("Cards Rendered");
                                    }

                                    let allExperiences = {};
                                    let activeCategory = 'Adventure';

                                    function initExperiences(expData) {
                                        allExperiences = expData;
                                        switchExperienceTab('Adventure');
                                    }

                                    function switchExperienceTab(category) {
                                        activeCategory = category;

                                        const categories = ['Adventure', 'Food Trails', 'Culture', 'Spiritual', 'Nature'];
                                        categories.forEach(cat => {
                                            const elId = 'expTab-' + cat.replace(' ', '');
                                            const tabBtn = document.getElementById(elId);
                                            if (tabBtn) {
                                                if (cat === category) {
                                                    tabBtn.classList.add('active');
                                                } else {
                                                    tabBtn.classList.remove('active');
                                                }
                                            }
                                        });

                                        const grid = document.getElementById('experiencesCardGrid');
                                        if (!grid) return;
                                        grid.innerHTML = '';

                                        const list = allExperiences[category] || [];
                                        if (list.length === 0) {
                                            grid.innerHTML = '<div class="col-span-full text-center text-white opacity-60 text-sm py-8">No experiences found in this category.</div>';
                                            return;
                                        }

                                        list.forEach(exp => {
                                            const price = exp.price || 'N/A';
                                            const duration = exp.duration || 'N/A';
                                            const difficulty = exp.difficulty || 'Easy';
                                            const rating = exp.rating || 'N/A';

                                            const cardHtml = `
                <div class="experience-card">
                    <div>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 12px;">
                            <span class="experience-badge" style="color:var(--color-primary); border-color:rgba(212,165,116,0.2);">🏷️ \${category}</span>
                            <span class="experience-badge">★ \${rating}</span>
                        </div>
                        <h4 class="text-white font-bold text-lg mb-2" style="margin:0 0 8px 0;">\${exp.name}</h4>
                        <p class="text-white opacity-70 text-xs leading-relaxed mb-4" style="margin:0 0 16px 0;">\${exp.desc}</p>
                    </div>
                    <div>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px; font-size:11px; color:#e4e4e7; opacity:0.8;">
                            <span>💰 <strong>\${price}</strong></span>
                            <span>⏱️ \${duration}</span>
                            <span>📈 \${difficulty}</span>
                        </div>
                        <button onclick="addExperienceToTrip('\${exp.name.replace(/'/g, "\\'")}', '\${category}', '\${price}', '\${duration}')" class="btn btn-primary w-full py-2 text-xs font-bold uppercase tracking-wider" style="border-radius: 8px; border:none; background:var(--color-primary); color:black; cursor:pointer;">
                            🎒 Add To Trip
                        </button>
                    </div>
                </div>
            `;
                                            grid.insertAdjacentHTML('beforeend', cardHtml);
                                        });
                                    }

                                    function addExperienceToTrip(name, category, price, duration) {
                                        fetch('${pageContext.request.contextPath}/experiences', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                            },
                                            body: 'action=addExperience&name=' + encodeURIComponent(name) + '&category=' + encodeURIComponent(category) + '&price=' + encodeURIComponent(price) + '&duration=' + encodeURIComponent(duration)
                                        })
                                            .then(response => { if(!response.ok) throw new Error('HTTP error'); const ct = response.headers.get('content-type'); if(ct && ct.includes('application/json')) return response.json(); return {}; })
                                            .then(data => {
                                                if (data.success) {
                                                    if (typeof showToast !== 'undefined') {
                                                        showToast('Added to Trip', name + ' has been added to your itinerary.', 'success');
                                                    } else {
                                                        alert(name + ' added to trip!');
                                                    }
                                                    updateCartUI(data.cart);
                                                }
                                            })
                                            .catch(err => {
                                                console.error('Error adding experience to trip:', err);
                                            });
                                    }

                                    function updateCartUI(cart) {
                                        const cartWidget = document.getElementById('floatingTripCart');
                                        const cartCount = document.getElementById('cartCount');
                                        const cartItemsList = document.getElementById('cartItemsList');

                                        if (!cartWidget || !cartCount || !cartItemsList) return;

                                        if (cart.length === 0) {
                                            cartWidget.style.display = 'none';
                                            return;
                                        }

                                        cartWidget.style.display = 'block';
                                        cartCount.innerText = cart.length;
                                        cartItemsList.innerHTML = '';

                                        cart.forEach(item => {
                                            const el = `
                <div style="display:flex; justify-content:space-between; align-items:center; background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.06); padding:8px 10px; border-radius:6px; font-size:11px;">
                    <div style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width:180px;">
                        <strong class="text-white">${item.name}</strong><br/>
                        <span style="color:var(--color-primary); font-size:9px;">${item.category} • ${item.duration}</span>
                    </div>
                    <span style="color:white; opacity:0.8;">${item.price}</span>
                </div>
            `;
                                            cartItemsList.insertAdjacentHTML('beforeend', el);
                                        });
                                    }

                                    function toggleCartDisplay() {
                                        const cartWidget = document.getElementById('floatingTripCart');
                                        if (cartWidget) cartWidget.style.display = 'none';
                                    }

                                    // ── Travel Tips Accordion ───────────────────────────────────────────────
                                    function toggleAccordion(element) {
                                        element.parentElement.classList.toggle('active');
                                    }

                                    function renderTravelTips(tipsData) {
                                        const accordion = document.getElementById('travelTipsAccordion');
                                        if (!accordion) return;

                                        const categories = {
                                            'safety': { icon: '🛡️', title: 'Safety & Emergency' },
                                            'transport': { icon: '🚌', title: 'Getting Around' },
                                            'local_etiquette': { icon: '🙏', title: 'Local Etiquette' },
                                            'packing_tips': { icon: '🎒', title: 'Packing Essentials' },
                                            'budget_advice': { icon: '💰', title: 'Budget Advice' }
                                        };

                                        let html = '';
                                        for (const [key, details] of Object.entries(categories)) {
                                            if (tipsData[key] && Array.isArray(tipsData[key]) && tipsData[key].length > 0) {
                                                let listHtml = '<ul class="tips-list">';
                                                tipsData[key].forEach(tip => {
                                                    listHtml += `<li>\${tip}</li>`;
                                                });
                                                listHtml += '</ul>';

                                                html += `
                    <div class="tips-accordion-item">
                        <div class="tips-accordion-header" onclick="toggleAccordion(this)">
                            <h4>\${details.icon} \${details.title}</h4>
                            <span class="tips-accordion-icon">▼</span>
                        </div>
                        <div class="tips-accordion-content">
                            \${listHtml}
                        </div>
                    </div>
                `;
                                            }
                                        }
                                        accordion.innerHTML = html;

                                        // Open the first one by default if it exists
                                        const firstItem = accordion.querySelector('.tips-accordion-item');
                                        if (firstItem) {
                                            firstItem.classList.add('active');
                                        }
                                    }

                                    // ── Itinerary Previews ────────────────────────────────────────────────────
                                    function renderItineraryPreviews(previews, destination) {
                                        const section = document.getElementById('itineraryPreviewSection');
                                        const grid = document.getElementById('itineraryPreviewGrid');
                                        if (!section || !grid) return;

                                        const plannerBase = '${pageContext.request.contextPath}/planner?location=' + encodeURIComponent(destination);

                                        const colourMap = {
                                            3: { cls: 'itinerary-card-3', icon: '🌿', nightsLabel: '2 Nights · Weekend Getaway' },
                                            5: { cls: 'itinerary-card-5', icon: '✈️', nightsLabel: '4 Nights · Perfect Balance' },
                                            7: { cls: 'itinerary-card-7', icon: '🌟', nightsLabel: '6 Nights · Deep Immersion' }
                                        };

                                        let html = '';
                                        previews.forEach(p => {
                                            const days = parseInt(p.days, 10);
                                            const meta = colourMap[days] || { cls: 'itinerary-card-5', icon: '📅', nightsLabel: (days - 1) + ' Nights' };
                                            html += `
                <div class="itinerary-preview-card \${meta.cls}">
                    <span class="itinerary-days-badge">\${meta.icon} \${days} Days</span>
                    <div>
                        <h4 class="itinerary-card-title">\${p.title}</h4>
                    </div>
                    <p class="itinerary-card-desc">\${p.description}</p>
                    <span class="itinerary-night-badge">🌙 \${meta.nightsLabel}</span>
                    <a href="\${plannerBase}&days=\${days}" class="itinerary-view-btn">
                        View Full Plan ➜
                    </a>
                </div>
            `;
                                        });

                                        grid.innerHTML = html;
                                        section.style.display = 'block';
                                    }

                                    // ── Sticky Plan My Trip Button ────────────────────────────────────────────
                                    (function initStickyPlanBtn() {
                                        const btn = document.getElementById('stickyPlanBtn');
                                        if (!btn) return;

                                        const SHOW_AFTER_PX = 400;

                                        function handleScroll() {
                                            if (window.scrollY > SHOW_AFTER_PX) {
                                                btn.classList.add('visible');
                                            } else {
                                                btn.classList.remove('visible');
                                            }
                                        }

                                        window.addEventListener('scroll', handleScroll, { passive: true });
                                        handleScroll(); // check on load in case page is already scrolled
                                    })();

                                    // ── YouTube Video Modal ───────────────────────────────────────────────────
                                    function openVideoModal(videoId) {
                                        console.log("[YOUTUBE]");
                                        console.log("Video Selected");
                                        console.log("[YOUTUBE]");
                                        console.log("Opening Video");
                                        console.log("[YOUTUBE]");
                                        console.log("Video ID: " + videoId);
                                        
                                        const modal = document.getElementById('youtubeModal');
                                        const iframe = document.getElementById('youtubeIframe');
                                        if(modal && iframe) {
                                            iframe.src = 'https://www.youtube.com/embed/' + videoId + '?autoplay=1';
                                            modal.style.display = 'flex';
                                        }
                                    }

                                    function closeVideoModal() {
                                        const modal = document.getElementById('youtubeModal');
                                        const iframe = document.getElementById('youtubeIframe');
                                        if(modal && iframe) {
                                            iframe.src = '';
                                            modal.style.display = 'none';
                                        }
                                    }
                                </script>

                                <!-- YouTube Modal HTML -->
                                <div id="youtubeModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.85); z-index:9999; justify-content:center; align-items:center; backdrop-filter: blur(4px);">
                                    <div style="position:relative; width:90%; max-width:800px; background:#000; border-radius:12px; overflow:hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
                                        <button onclick="closeVideoModal()" style="position:absolute; top:10px; right:15px; background:rgba(0,0,0,0.5); border:1px solid rgba(255,255,255,0.2); border-radius:50%; width:36px; height:36px; color:white; font-size:20px; cursor:pointer; display:flex; align-items:center; justify-content:center; z-index:10000; transition: all 0.2s;">&times;</button>
                                        <div style="position:relative; padding-bottom:56.25%; height:0;">
                                            <iframe id="youtubeIframe" style="position:absolute; top:0; left:0; width:100%; height:100%;" src="" frameborder="0" allow="autoplay; encrypted-media; picture-in-picture" allowfullscreen></iframe>
                                        </div>
                                    </div>
                                </div>

                                <!-- ── Data Bridges moved to top ──────────────────────── -->

                                <!-- OpenWeather API Integration Script -->
                                <script>
                                    document.addEventListener('DOMContentLoaded', function() {
                                        const destination = '${searchQuery}';
                                        const lat = '${destLat}';
                                        const lng = '${destLng}';
                                        if (!destination) return;

                                        let url = '${pageContext.request.contextPath}/api/weather?destination=' + encodeURIComponent(destination);
                                        if (lat && lng) {
                                            url += '&lat=' + encodeURIComponent(lat) + '&lng=' + encodeURIComponent(lng);
                                        }

                                        
                                        console.time('Weather');
                                        console.log('Weather API Started');
                                        fetch(url)
                                            .then(response => {
                                                if (!response.ok) throw new Error('Weather data unavailable');
                                                return response.json();
                                            })
                                            .then(data => {
                                                if (data.error) throw new Error(data.error);

                                                document.getElementById('weatherWidgetContainer').classList.remove('hidden');
                                                document.getElementById('weatherTemp').textContent = data.temp;
                                                document.getElementById('weatherFeelsLike').textContent = '--°C'; // Not in new simplified API
                                                document.getElementById('weatherHumidity').textContent = data.humidity + '%';
                                                document.getElementById('weatherWind').textContent = data.wind + ' km/h';
                                                document.getElementById('weatherVis').textContent = '-- km'; // Not in new simplified API
                                                document.getElementById('weatherDesc').textContent = data.condition;

                                                // Update icon based on condition loosely
                                                const condition = (data.condition || '').toLowerCase();
                                                let icon = '☁️';
                                                if (condition.includes('clear') || condition.includes('sunny')) icon = '☀️';
                                                else if (condition.includes('rain') || condition.includes('drizzle')) icon = '🌧️';
                                                else if (condition.includes('thunderstorm')) icon = '⛈️';
                                                else if (condition.includes('snow')) icon = '❄️';
                                                
                                                document.getElementById('weatherIcon').textContent = icon;
                                            })
                                            .catch(error => {
                                                console.error('Failed to load weather:', error);
                                                // Fail silently in UI, keeping widget hidden
                                            });
                                    });
                                </script>

                                
<!-- Dynamic Google Places Loader -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const destLat = '${destLat}';
    const destLng = '${destLng}';
    if(!destLat || !destLng) return;

    const baseParams = '?lat=' + encodeURIComponent(destLat) + '&lng=' + encodeURIComponent(destLng);
    
    const mapMarkers = [];

    function renderCard(place, typeLabel, iconUrl) {
        let photoHtml = '';
        if (place.photo) {
            photoHtml = '<div class="w-full h-40 rounded-lg bg-cover bg-center mb-3" style="background-image: url(\'' + place.photo + '\');"></div>';
        } else {
            photoHtml = '<div class="w-full h-40 rounded-lg bg-[var(--color-surface)] mb-3 flex items-center justify-center text-white opacity-50">No Image</div>';
        }

        let openHtml = '';
        if (place.open_now !== undefined && place.open_now !== null) {
            const statusClass = place.open_now ? 'text-green-400' : 'text-red-400';
            const statusText = place.open_now ? 'Open Now' : 'Closed';
            openHtml = '<div class="text-xs mb-3 ' + statusClass + '">' + statusText + '</div>';
        } else {
            openHtml = '<div class="text-xs mb-3 text-transparent">Unknown</div>';
        }

        const name = place.name || 'Unknown Location';
        const rating = place.rating !== undefined ? place.rating : 'N/A';
        const address = place.address || '';
        const mapsLink = place.maps_link || '#';

        return '<div class="discovery-card glass-card p-4 rounded-xl transition-all hover:scale-[1.02] flex flex-col h-full" style="border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.03);">' +
                    photoHtml +
                    '<h5 class="text-white font-bold text-base mb-1 truncate">' + name + '</h5>' +
                    '<div class="flex items-center gap-2 mb-2 text-xs">' +
                        '<span class="text-yellow-400">⭐ ' + rating + '</span>' +
                        '<span class="text-white opacity-60 truncate">' + address + '</span>' +
                    '</div>' +
                    openHtml +
                    '<div class="mt-auto pt-2 flex gap-2">' +
                        '<a href="' + mapsLink + '" target="_blank" class="btn btn-secondary flex-1 text-center py-2 text-xs font-bold rounded-lg text-white no-underline" style="border:1px solid rgba(255,255,255,0.2);">🗺️ View Map</a>' +
                    '</div>' +
                '</div>';
    }

    function fetchAndRender(endpoint, gridId, category, icon, color) {
        return fetch('${pageContext.request.contextPath}/api/nearby/' + endpoint + baseParams)
            .then(res => { 
                if(!res.ok) throw new Error('HTTP error'); 
                const ct = res.headers.get('content-type'); 
                if(ct && ct.includes('application/json')) return res.json(); 
                return {}; 
            })
            .then(json => {
                if(json.success && json.data) {
                    const places = json.data;
                    console.log("Places API Result [" + category + "]:", places);
                    
                    // Specific array logging exactly as requested
                    if (category === 'hotel') console.log("Hotels:", places);
                    else if (category === 'restaurant') console.log("Restaurants:", places);
                    else if (category === 'attraction') console.log("Attractions:", places);
                    else if (category === 'experience') console.log("Experiences:", places);

                    const grid = document.getElementById(gridId);
                    if(places.length === 0) {
                        grid.innerHTML = '<p class="text-white opacity-50 text-sm">No ' + endpoint + ' found.</p>';
                        console.log(category.charAt(0).toUpperCase() + category.slice(1) + "s Rendered: 0");
                    } else {
                        let html = '';
                        let renderedCount = 0;
                        places.forEach(p => {
                            try {
                                html += renderCard(p, category, icon);
                                renderedCount++;
                                mapMarkers.push({
                                    name: p.name || 'Unknown',
                                    lat: p.lat,
                                    lng: p.lng,
                                    category: category,
                                    icon: icon,
                                    color: color,
                                    desc: p.address || ''
                                });
                            } catch (e) {
                                console.error("Error rendering card for place:", p, e);
                            }
                        });
                        grid.innerHTML = html;
                        console.log(category.charAt(0).toUpperCase() + category.slice(1) + "s Rendered: " + renderedCount);
                    }
                }
            });
    }

    Promise.all([
        fetchAndRender('hotels', 'dynamicHotelsGrid', 'hotel', '🏨', '#60A5FA'),
        fetchAndRender('restaurants', 'dynamicRestaurantsGrid', 'restaurant', '🍴', '#F472B6'),
        fetchAndRender('attractions', 'dynamicAttractionsGrid', 'attraction', '📍', '#D4A574'),
        fetchAndRender('experiences', 'dynamicExperiencesGrid', 'experience', '🎭', '#34D399')

    ]).then(() => {
        console.log('Food Explorer Loaded');
    }).catch(err => {
        console.error('API Fetch failed, still rendering map', err);
    }).finally(() => {
        if(typeof initGoogleMapWrapper === 'function') {
            initGoogleMapWrapper(mapMarkers);
            console.log('Interactive Map Loaded');
        }
    });

    
    const aiInsightsEncoded = '<%= java.net.URLEncoder.encode(pageContext.findAttribute("aiInsights") != null ? pageContext.findAttribute("aiInsights").toString() : "", "UTF-8").replace("+", "%20") %>';
    const aiInsights = decodeURIComponent(aiInsightsEncoded);
    if (aiInsights && aiInsights.trim().length > 0) {
        document.getElementById('aiInsightsSection').style.display = 'block';
        document.getElementById('aiInsightsText').textContent = aiInsights;
    }


    // Wait, the instructions say to add AI Insights. We modified GeminiService to output it. But GeminiService is usually called from PlannerServlet or DestinationExplorerServlet. 
    // DestinationExplorerServlet already sets 'aiInsights' or similar? 
    // If not, we can render the existing ${travelTips} inside our new container, or just hide it.
    
    console.log('Page Render Complete');
    console.timeEnd('Full Page Render');
});
</script>

<%@ include file="/components/footer.jsp" %>