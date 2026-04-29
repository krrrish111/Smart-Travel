/**
 * VOYASTRA PREMIUM AUTO-SCROLL ENGINE v8
 * ─────────────────────────────────────
 * A single, reusable engine for all auto-scrolling sections.
 * Uses requestAnimationFrame + transform: translateX() for 60fps buttery motion.
 *
 * Features:
 *   - Infinite seamless loop via cloned elements
 *   - Smart cursor control (left=faster left, center=normal, right=scroll right)
 *   - Touch/swipe support for mobile
 *   - Hover pause/slow on individual cards
 *   - Configurable speed per section
 *   - No design changes — pure behavioral JS
 */

(function () {
    'use strict';

    /**
     * VoyastraScroller — reusable infinite auto-scroll engine
     * @param {Object} config
     *   - outerSelector: CSS selector for the overflow container
     *   - trackSelector: CSS selector for the flex track
     *   - itemSelector:  CSS selector for items to clone
     *   - speed:         default px/frame speed (negative = scroll left)
     *   - hoverPause:    if true, hovering an item pauses auto-scroll
     *   - cursorControl: if true, enables left/center/right speed zones
     *   - sectionSelector: CSS selector for the parent section (for cursor zones)
     *   - cloneSets:     number of times to duplicate items (default 2 for 3 total)
     *   - touchEnabled:  enable touch/drag (default true)
     *   - direction:     1 for right-to-left, -1 for left-to-right
     */
    function VoyastraScroller(config) {
        var outer = document.querySelector(config.outerSelector);
        var track = document.querySelector(config.trackSelector);
        if (!outer || !track) return null;

        var items = Array.prototype.slice.call(track.querySelectorAll(config.itemSelector));
        if (items.length < 1) return null;

        // Config defaults
        var baseSpeed = config.speed || -0.6;
        var hoverPause = config.hoverPause !== false;
        var cursorControl = config.cursorControl || false;
        var cloneSets = config.cloneSets || 2;
        var touchEnabled = config.touchEnabled !== false;
        var sectionEl = config.sectionSelector ? document.querySelector(config.sectionSelector) : outer;

        // State
        var currentX = 0;
        var setWidth = 0;
        var currentSpeed = baseSpeed;
        var targetSpeed = baseSpeed;
        var isDragging = false;
        var isCardHovered = false;
        var startX = 0;
        var dragStartX = 0;
        var animId = null;
        var isVisible = true;

        // 1. Clone items for seamless loop
        function buildClones() {
            // Remove old clones
            track.querySelectorAll('[data-vclone]').forEach(function (el) { el.remove(); });

            for (var s = 0; s < cloneSets; s++) {
                items.forEach(function (item) {
                    var clone = item.cloneNode(true);
                    clone.setAttribute('data-vclone', 'true');
                    track.appendChild(clone);
                });
            }
        }

        // 2. Calculate set width
        function measureSetWidth() {
            var allItems = track.querySelectorAll(config.itemSelector + ', [data-vclone]');
            var n = items.length;
            if (allItems.length >= n * 2 && allItems[n]) {
                setWidth = allItems[n].offsetLeft - allItems[0].offsetLeft;
            } else {
                setWidth = track.scrollWidth / (1 + cloneSets);
            }
            if (setWidth <= 0) setWidth = track.scrollWidth / 2;
            // Start centered on first set
            if (currentX === 0) currentX = 0;
        }

        // 3. Core animation loop
        function animate() {
            if (!isDragging && isVisible) {
                // Smooth lerp toward target speed
                currentSpeed += (targetSpeed - currentSpeed) * 0.05;

                // Pause when card is hovered
                if (isCardHovered && hoverPause) {
                    currentSpeed *= 0.15;
                }

                currentX += currentSpeed;

                // Seamless loop
                if (setWidth > 0) {
                    if (currentX <= -setWidth) currentX += setWidth;
                    if (currentX >= 0) currentX -= setWidth;
                }

                track.style.transform = 'translateX(' + currentX + 'px)';
            }
            animId = requestAnimationFrame(animate);
        }

        // 4. Cursor zone control
        if (cursorControl && sectionEl) {
            sectionEl.addEventListener('mousemove', function (e) {
                var rect = sectionEl.getBoundingClientRect();
                var pct = (e.clientX - rect.left) / rect.width;

                if (pct < 0.2) {
                    // Left 20% — scroll left faster
                    var factor = 1 + (1 - pct / 0.2) * 5;
                    targetSpeed = baseSpeed * factor;
                } else if (pct > 0.8) {
                    // Right 20% — reverse direction (scroll right)
                    var intensity = (pct - 0.8) / 0.2;
                    targetSpeed = Math.abs(baseSpeed) * 2.5 * intensity;
                } else {
                    // Center — normal speed
                    targetSpeed = baseSpeed;
                }
            });

            sectionEl.addEventListener('mouseleave', function () {
                targetSpeed = baseSpeed;
            });
        }

        // 5. Card hover detection
        if (hoverPause) {
            track.addEventListener('mouseenter', function () { isCardHovered = true; }, true);
            track.addEventListener('mouseleave', function () { isCardHovered = false; }, true);
        }

        // 6. Touch/drag support
        if (touchEnabled) {
            var onStart = function (e) {
                isDragging = true;
                startX = e.pageX || (e.touches && e.touches[0].pageX) || 0;
                dragStartX = currentX;
                track.style.transition = 'none';
            };
            var onMove = function (e) {
                if (!isDragging) return;
                var x = e.pageX || (e.touches && e.touches[0].pageX) || 0;
                currentX = dragStartX + (x - startX);
                if (setWidth > 0) {
                    if (currentX <= -setWidth) currentX += setWidth;
                    if (currentX >= 0) currentX -= setWidth;
                }
                track.style.transform = 'translateX(' + currentX + 'px)';
            };
            var onEnd = function () {
                isDragging = false;
            };

            outer.addEventListener('mousedown', onStart);
            window.addEventListener('mousemove', onMove);
            window.addEventListener('mouseup', onEnd);
            outer.addEventListener('touchstart', onStart, { passive: true });
            outer.addEventListener('touchmove', onMove, { passive: true });
            outer.addEventListener('touchend', onEnd);
        }

        // 7. Visibility observer — pause when off-screen
        if (window.IntersectionObserver) {
            var observer = new IntersectionObserver(function (entries) {
                isVisible = entries[0].isIntersecting;
            }, { threshold: 0.1 });
            observer.observe(outer);
        }

        // 8. Resize handler
        var resizeTimer;
        window.addEventListener('resize', function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function () {
                measureSetWidth();
            }, 200);
        });

        // Init
        buildClones();
        measureSetWidth();
        // Recalc after images load
        setTimeout(measureSetWidth, 600);
        animate();

        return {
            destroy: function () { cancelAnimationFrame(animId); },
            setSpeed: function (s) { baseSpeed = s; targetSpeed = s; }
        };
    }

    // ═══════════════════════════════════════════════
    // SECTION INITIALIZATIONS
    // ═══════════════════════════════════════════════

    function initAllScrollers() {

        // ── 1. POPULAR TRIP PLANS (already has v7 engine inline — we enhance it) ──
        // The v7 engine in home.jsp handles this with its own advanced logic.
        // We do NOT duplicate it here. It already has:
        //   - Infinite loop with 3 cloned sets
        //   - Smart cursor control (left/center/right)
        //   - Drag, touch, wheel support
        //   - requestAnimationFrame engine
        // No changes needed for Popular Trip Plans.

        // ── 2. MUST-DO THINGS SECTION ──
        VoyastraScroller({
            outerSelector: '#mustDoOuter',
            trackSelector: '#mustDoInner',
            itemSelector: '.glass-panel',
            speed: -0.8,
            hoverPause: true,
            cursorControl: true,
            cloneSets: 1 // set 2 is already in HTML, we can clones more if needed
        });

        // ── 3. POPULAR ITINERARIES STRIP ──
        VoyastraScroller({
            outerSelector: '#itinStripOuter',
            trackSelector: '#itinStripInner',
            itemSelector: '.itin-card',
            speed: -1.0,
            hoverPause: true,
            cursorControl: true,
            cloneSets: 1
        });

        // ── 4. TRENDING DESTINATIONS — Add auto-slide ──
        // The dest carousel has a step-based auto-slide. We leave it as-is
        // since it uses a different paradigm (discrete slides with dots).

        // ── 5. TRAVEL PARTNERS MARQUEE (if exists) ──
        VoyastraScroller({
            outerSelector: '.partners-marquee-outer',
            trackSelector: '.partners-marquee-track',
            itemSelector: '.partner-logo',
            speed: -0.5,
            hoverPause: true,
            cursorControl: false,
            cloneSets: 3
        });

        // ── 6. TESTIMONIALS AUTO-SLIDE (if exists) ──
        VoyastraScroller({
            outerSelector: '#testimonialsOuter',
            trackSelector: '#testimonialsInner',
            itemSelector: '.testimonial-card',
            speed: -0.8,
            hoverPause: true,
            cursorControl: true,
            sectionSelector: '.testimonials-section',
            cloneSets: 1
        });

        // ── 7. OFFERS/DEALS CAROUSEL (if exists) ──
        VoyastraScroller({
            outerSelector: '.offers-scroll-outer',
            trackSelector: '.offers-scroll-track',
            itemSelector: '.offer-card',
            speed: -0.5,
            hoverPause: true,
            cursorControl: false,
            cloneSets: 2
        });

        // ── 8. COMMUNITY HIGHLIGHTS (if exists) ──
        VoyastraScroller({
            outerSelector: '.community-scroll-outer',
            trackSelector: '.community-scroll-track',
            itemSelector: '.community-card',
            speed: -0.3,
            hoverPause: true,
            cursorControl: false,
            cloneSets: 2
        });
    }

    // Wait for full DOM + images
    if (document.readyState === 'complete') {
        initAllScrollers();
    } else {
        window.addEventListener('load', initAllScrollers);
    }

    // Expose for external use
    window.VoyastraScroller = VoyastraScroller;

})();
