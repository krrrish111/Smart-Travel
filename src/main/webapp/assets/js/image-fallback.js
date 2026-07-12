/**
 * VOYASTRA GLOBAL IMAGE FALLBACK SYSTEM
 * ================================================
 * Handles all broken image scenarios across the entire application.
 * 
 * Usage:
 *   HTML: onerror="vImgErr(this)"
 *   JS:   safeImg(url)     → returns validated url or placeholder
 *         safeImgAttr(url) → returns onerror attribute string for templates
 *
 * The placeholder is an inline SVG data URI — no extra HTTP request.
 */

(function (global) {
    'use strict';

    /* ────────────────────────────────────────────
       PLACEHOLDER DATA URI
       Dark premium gradient, centered camera icon
       and "Image Unavailable" text.
    ──────────────────────────────────────────── */
    var PLACEHOLDER_SVG = [
        '<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">',
        '<defs>',
        '<linearGradient id="vbg" x1="0%" y1="0%" x2="100%" y2="100%">',
        '<stop offset="0%" stop-color="#0f0c29"/>',
        '<stop offset="50%" stop-color="#302b63"/>',
        '<stop offset="100%" stop-color="#24243e"/>',
        '</linearGradient>',
        '<linearGradient id="vac" x1="0%" y1="0%" x2="100%" y2="100%">',
        '<stop offset="0%" stop-color="#d4a574"/>',
        '<stop offset="100%" stop-color="#a07855"/>',
        '</linearGradient>',
        '</defs>',
        '<rect width="800" height="500" fill="url(#vbg)"/>',
        '<rect x="0" y="0" width="800" height="500" fill="rgba(0,0,0,0.25)"/>',
        /* subtle grid */
        '<g stroke="rgba(255,255,255,0.03)" stroke-width="1">',
        '<line x1="0" y1="100" x2="800" y2="100"/><line x1="0" y1="200" x2="800" y2="200"/>',
        '<line x1="0" y1="300" x2="800" y2="300"/><line x1="0" y1="400" x2="800" y2="400"/>',
        '<line x1="200" y1="0" x2="200" y2="500"/><line x1="400" y1="0" x2="400" y2="500"/>',
        '<line x1="600" y1="0" x2="600" y2="500"/>',
        '</g>',
        /* camera icon */
        '<g transform="translate(400,210)" fill="none" stroke="url(#vac)" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">',
        '<path d="M-60,-30 L-45,-50 L45,-50 L60,-30 L80,-30 Q90,-30 90,-18 L90,40 Q90,52 78,52 L-78,52 Q-90,52 -90,40 L-90,-18 Q-90,-30 -80,-30 Z"/>',
        '<circle cx="0" cy="12" r="28"/>',
        '<circle cx="0" cy="12" r="20" fill="rgba(212,165,116,0.12)"/>',
        '</g>',
        /* "VOYASTRA" wordmark */
        '<text x="400" y="300" text-anchor="middle" font-family="Poppins,Inter,Arial,sans-serif" font-size="13" font-weight="700" letter-spacing="8" fill="url(#vac)" opacity="0.9">VOYASTRA</text>',
        /* label */
        '<text x="400" y="332" text-anchor="middle" font-family="Poppins,Inter,Arial,sans-serif" font-size="15" fill="rgba(255,255,255,0.45)">Image Unavailable</text>',
        '</svg>'
    ].join('');

    var PLACEHOLDER_URI = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(PLACEHOLDER_SVG);

    /* ────────────────────────────────────────────
       AVATAR PLACEHOLDER (round, small profile images)
    ──────────────────────────────────────────── */
    var AVATAR_SVG = [
        '<svg xmlns="http://www.w3.org/2000/svg" width="120" height="120" viewBox="0 0 120 120">',
        '<defs><linearGradient id="avbg" x1="0%" y1="0%" x2="100%" y2="100%">',
        '<stop offset="0%" stop-color="#302b63"/><stop offset="100%" stop-color="#24243e"/>',
        '</linearGradient></defs>',
        '<circle cx="60" cy="60" r="60" fill="url(#avbg)"/>',
        '<circle cx="60" cy="48" r="22" fill="rgba(212,165,116,0.5)"/>',
        '<ellipse cx="60" cy="100" rx="35" ry="30" fill="rgba(212,165,116,0.5)"/>',
        '</svg>'
    ].join('');

    var AVATAR_URI = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(AVATAR_SVG);

    /* ────────────────────────────────────────────
       INVALID URL DETECTION
    ──────────────────────────────────────────── */
    var INVALID_VALUES = ['null', 'undefined', 'n/a', 'none', '', 'false'];

    function isInvalidUrl(url) {
        if (!url) return true;
        var s = String(url).trim().toLowerCase();
        if (INVALID_VALUES.indexOf(s) !== -1) return true;
        if (s.length < 4) return true;
        /* Must start with http/https or data: or / for local assets */
        if (!/^(https?:\/\/|data:|\/)/i.test(s)) return true;
        return false;
    }

    /* ────────────────────────────────────────────
       CORE PUBLIC API
    ──────────────────────────────────────────── */

    /**
     * Called via onerror="vImgErr(this)" on any <img> element.
     * Replaces the broken src with a placeholder.
     * Also applies layout-preserving CSS.
     */
    function handleImageError(img) {
        if (!img || img._vFallbackApplied) return;
        img._vFallbackApplied = true; // prevent infinite loop

        var isAvatar = img.classList.contains('community-avatar') ||
                       img.classList.contains('comment-user-img') ||
                       img.classList.contains('nav-avatar-img') ||
                       img.classList.contains('profile-avatar') ||
                       img.classList.contains('avatar') ||
                       img.classList.contains('user-avatar') ||
                       img.classList.contains('author-img') ||
                       img.classList.contains('story-avatar');

        img.src = isAvatar ? AVATAR_URI : PLACEHOLDER_URI;
        img.style.objectFit = 'cover';
        img.removeAttribute('onerror');
    }

    /**
     * Validates a URL and returns it if valid, otherwise returns placeholder.
     * Use in JS template literals: `<img src="${safeImg(url)}">`
     */
    function safeImg(url, type) {
        if (isInvalidUrl(url)) {
            return (type === 'avatar') ? AVATAR_URI : PLACEHOLDER_URI;
        }
        return url;
    }

    /**
     * Returns the onerror attribute string for use in JS-generated HTML.
     * Use: `<img src="..." ${safeImgAttr()}>`
     */
    function safeImgAttr() {
        return 'loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)"';
    }

    /**
     * Returns the full set of recommended attributes for dynamic images.
     * Use: `<img src="${safeImg(url)}" ${imgAttrs()}>`
     */
    function imgAttrs(extraClass) {
        var base = 'loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)"';
        return extraClass ? base + ' class="' + extraClass + '"' : base;
    }

    /* ────────────────────────────────────────────
       BACKGROUND-IMAGE VALIDATION
       For elements using background-image CSS
    ──────────────────────────────────────────── */
    function safeBgImg(url) {
        if (isInvalidUrl(url)) return PLACEHOLDER_URI;
        return url;
    }

    /* ────────────────────────────────────────────
       AUTO-SCAN ON DOM READY
       Attaches onerror to any <img> missing one,
       and validates src before load errors fire.
    ──────────────────────────────────────────── */
    function scanImages() {
        var imgs = document.querySelectorAll('img');
        for (var i = 0; i < imgs.length; i++) {
            (function (img) {
                /* If src is already invalid, replace immediately */
                if (isInvalidUrl(img.src) || img.src === window.location.href) {
                    handleImageError(img);
                    return;
                }
                /* Attach onerror if missing */
                if (!img.onerror) {
                    img.onerror = function () { handleImageError(this); };
                }
                /* If image already failed (naturalWidth=0 and complete) */
                if (img.complete && img.naturalWidth === 0) {
                    handleImageError(img);
                }
            })(imgs[i]);
        }
    }

    /* Run on DOM ready */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', scanImages);
    } else {
        scanImages();
    }

    /* Also observe dynamically added images via MutationObserver */
    if (global.MutationObserver) {
        var obs = new MutationObserver(function (mutations) {
            mutations.forEach(function (m) {
                m.addedNodes.forEach(function (node) {
                    if (node.nodeType !== 1) return;
                    if (node.tagName === 'IMG') {
                        (function (img) {
                            if (isInvalidUrl(img.src)) { handleImageError(img); return; }
                            if (!img.onerror) img.onerror = function () { handleImageError(this); };
                            if (img.complete && img.naturalWidth === 0) handleImageError(img);
                        })(node);
                    }
                    /* Check descendants */
                    var imgs = node.querySelectorAll ? node.querySelectorAll('img') : [];
                    for (var i = 0; i < imgs.length; i++) {
                        (function (img) {
                            if (isInvalidUrl(img.src)) { handleImageError(img); return; }
                            if (!img.onerror) img.onerror = function () { handleImageError(this); };
                            if (img.complete && img.naturalWidth === 0) handleImageError(img);
                        })(imgs[i]);
                    }
                });
            });
        });
        obs.observe(document.body || document.documentElement, { childList: true, subtree: true });
    }

    /* ────────────────────────────────────────────
       EXPORT TO GLOBAL SCOPE
    ──────────────────────────────────────────── */
    global.vImgErr          = handleImageError;       /* onerror handler  */
    global.safeImg          = safeImg;                /* URL validator     */
    global.safeBgImg        = safeBgImg;              /* bg-image validator*/
    global.safeImgAttr      = safeImgAttr;            /* attr string       */
    global.imgAttrs         = imgAttrs;               /* full attr string  */
    global.VOYASTRA_PLACEHOLDER = PLACEHOLDER_URI;    /* raw placeholder   */
    global.VOYASTRA_AVATAR_PLACEHOLDER = AVATAR_URI;  /* avatar placeholder*/

})(window);
