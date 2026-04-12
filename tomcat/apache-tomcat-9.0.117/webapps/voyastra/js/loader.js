/* ================================================================
   VOYASTRA LOADER — loader.js
   Three loading experiences in one file:
   1. Top progress bar (NProgress-style) — fires on every page navigation
   2. Skeleton card generator — VoyastraLoader.skeletons(container, count, type)
   3. Image lazy-load shimmer — auto-applied to all .explore-img elements
   ================================================================ */

(function(window) {
    'use strict';

    /* ══════════════════════════════════════════════
       1. TOP PROGRESS BAR
    ══════════════════════════════════════════════ */
    var bar = null;
    var barTimeout = null;
    var barValue = 0;
    var barRAF = null;

    function createBar() {
        if (bar) return;
        bar = document.createElement('div');
        bar.id = 'vx-progress-bar';
        bar.innerHTML = '<div id="vx-progress-fill"></div>';
        document.body.appendChild(bar);

        // Hide main content for a smooth fade-in
        var main = document.querySelector('main');
        if (main) {
            main.style.opacity = '0';
            main.style.transition = 'opacity 0.8s ease-in-out';
        }
    }

    function setBarWidth(pct) {
        var fill = document.getElementById('vx-progress-fill');
        if (fill) fill.style.width = pct + '%';
    }

    function startBar() {
        createBar();
        barValue = 5;
        setBarWidth(barValue);
        bar.classList.add('active');

        // Trickle up to 90%
        function trickle() {
            if (barValue < 90) {
                barValue += Math.random() * 8;
                barValue = Math.min(barValue, 90);
                setBarWidth(barValue);
                barRAF = setTimeout(trickle, 400 + Math.random() * 400);
            }
        }
        trickle();
    }

    function finishBar() {
        clearTimeout(barRAF);
        barValue = 100;
        setBarWidth(100);
        
        // Show main content
        var main = document.querySelector('main');
        if (main) main.style.opacity = '1';

        setTimeout(function() {
            if (bar) bar.classList.remove('active');
            barValue = 0;
        }, 400);
    }

    /* ══════════════════════════════════════════════
       2. SKELETON CARD GENERATOR
    ══════════════════════════════════════════════ */

    /**
     * Inject skeleton cards into a container element.
     * @param {string|Element} container - CSS selector or DOM element
     * @param {number} count - How many skeletons to inject (default: 6)
     * @param {string} type - 'card' | 'trending' | 'list' (default: 'card')
     */
    function skeletons(container, count, type) {
        var el = typeof container === 'string' ? document.querySelector(container) : container;
        if (!el) return;
        count = count || 6;
        type = type || 'card';

        el.innerHTML = '';
        for (var i = 0; i < count; i++) {
            var sk = document.createElement('div');
            sk.className = 'vx-skeleton-card';
            sk.setAttribute('aria-hidden', 'true');

            if (type === 'trending') {
                sk.innerHTML =
                    '<div class="vx-sk vx-sk-img vx-sk-trending-img"></div>' +
                    '<div style="padding:14px;">' +
                        '<div class="vx-sk vx-sk-line" style="width:70%"></div>' +
                        '<div class="vx-sk vx-sk-line vx-sk-short" style="width:45%;margin-top:8px;"></div>' +
                    '</div>';
                sk.style.minWidth = '280px';
            } else if (type === 'list') {
                sk.style.display = 'flex';
                sk.style.gap = '14px';
                sk.style.padding = '16px';
                sk.innerHTML =
                    '<div class="vx-sk vx-sk-avatar"></div>' +
                    '<div style="flex:1">' +
                        '<div class="vx-sk vx-sk-line" style="width:60%"></div>' +
                        '<div class="vx-sk vx-sk-line vx-sk-short" style="width:40%;margin-top:8px;"></div>' +
                    '</div>';
            } else {
                // default: full card
                sk.innerHTML =
                    '<div class="vx-sk vx-sk-img"></div>' +
                    '<div style="padding:18px;">' +
                        '<div class="vx-sk vx-sk-line" style="width:75%"></div>' +
                        '<div class="vx-sk vx-sk-line vx-sk-short" style="width:50%;margin-top:8px;"></div>' +
                        '<div class="vx-sk vx-sk-line vx-sk-short" style="width:35%;margin-top:8px;opacity:0.6;"></div>' +
                    '</div>';
            }
            el.appendChild(sk);
        }
    }

    /**
     * Replace skeleton cards with real content.
     * Animates the cards in with a stagger.
     * @param {string|Element} container
     * @param {string} html - innerHTML to replace skeletons with
     */
    function reveal(container, html) {
        var el = typeof container === 'string' ? document.querySelector(container) : container;
        if (!el) return;
        
        // Use a wrapper to fade out skeletons
        el.style.transition = 'opacity 0.3s ease';
        el.style.opacity = '0';
        
        setTimeout(function() {
            el.innerHTML = html;
            el.style.opacity = '1';
            
            // Stagger reveal of items with .glass-panel or child cards
            var items = el.querySelectorAll('.glass-panel, .card, .trending-card, .timeline-card');
            items.forEach(function(item, i) {
                item.classList.add('reveal-item');
                setTimeout(function() {
                    item.classList.add('revealed');
                }, i * 50);
            });
            
            // Re-init lazy images if any in the new content
            if (window.VoyastraLoader && window.VoyastraLoader.initLazyImages) {
                window.VoyastraLoader.initLazyImages();
            }
        }, 300);
    }

    /* ══════════════════════════════════════════════
       3. IMAGE LAZY-LOAD SHIMMER
    ══════════════════════════════════════════════ */
    function initLazyImages() {
        var imgs = document.querySelectorAll('img.explore-img, img[data-lazy]');
        imgs.forEach(function(img) {
            // Wrap in shimmer if not already
            var parent = img.parentNode;
            if (parent && !parent.classList.contains('vx-img-wrap')) {
                var wrap = document.createElement('div');
                wrap.className = 'vx-img-wrap';
                wrap.style.cssText = parent.style.cssText.includes('height') ? '' : 'position:relative;';
                parent.insertBefore(wrap, img);
                wrap.appendChild(img);

                var shimmer = document.createElement('div');
                shimmer.className = 'vx-img-shimmer';
                wrap.appendChild(shimmer);
            }

            if (img.complete && img.naturalWidth > 0) {
                // Already loaded
                var sh = img.parentNode ? img.parentNode.querySelector('.vx-img-shimmer') : null;
                if (sh) sh.style.display = 'none';
            } else {
                img.addEventListener('load', function() {
                    var sh = img.parentNode ? img.parentNode.querySelector('.vx-img-shimmer') : null;
                    if (sh) {
                        sh.style.opacity = '0';
                        setTimeout(function() { if (sh) sh.style.display = 'none'; }, 300);
                    }
                });
                img.addEventListener('error', function() {
                    var sh = img.parentNode ? img.parentNode.querySelector('.vx-img-shimmer') : null;
                    if (sh) sh.style.display = 'none';
                });
            }
        });
    }

    /* ══════════════════════════════════════════════
       4. PAGE TRANSITION — fire bar on link clicks
    ══════════════════════════════════════════════ */
    function initPageTransitions() {
        document.addEventListener('click', function(e) {
            var link = e.target.closest('a[href]');
            if (!link) return;
            var href = link.getAttribute('href');
            // Skip: anchor links, external links, javascript:, download
            if (!href || href.startsWith('#') || href.startsWith('javascript') ||
                href.startsWith('http') || href.startsWith('//') ||
                link.hasAttribute('download') || link.target === '_blank') return;
            startBar();
        });

        // Also fire on form submissions
        document.addEventListener('submit', function() {
            startBar();
        });
    }

    /* ══════════════════════════════════════════════
       5. INIT
    ══════════════════════════════════════════════ */
    document.addEventListener('DOMContentLoaded', function() {
        // Finish the bar when the page is fully ready
        finishBar();

        // Init lazy image shimmer
        initLazyImages();

        // Wire page transitions
        initPageTransitions();

        // Auto-inject skeletons on grids with data-skeleton attribute
        document.querySelectorAll('[data-skeleton]').forEach(function(el) {
            var type = el.getAttribute('data-skeleton') || 'card';
            var count = parseInt(el.getAttribute('data-skeleton-count') || '6', 10);
            // Only inject if empty (no server-rendered content)
            if (!el.children.length) {
                skeletons(el, count, type);
            }
        });
    });

    // Start bar immediately when script loads (covers server render time)
    startBar();

    window.VoyastraLoader = {
        start: startBar,
        finish: finishBar,
        skeletons: skeletons,
        reveal: reveal
    };

})(window);
