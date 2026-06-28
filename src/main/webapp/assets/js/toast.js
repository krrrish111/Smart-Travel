/* ================================================================
   VOYASTRA TOAST UTILITY — toast.js
   Global notification system for success, warning, error, info
   Features: smooth spring animation, progress bar, auto-dismiss,
             manual close, stacking, emoji or SVG icon support
   ================================================================ */

(function(window) {
    'use strict';

    var AUTO_HIDE_MS = 3000;

    function initContainer() {
        var container = document.getElementById('voyastraToastContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'voyastraToastContainer';
            container.className = 'voyastra-toast-container';
            document.body.appendChild(container);
        }
        return container;
    }

    var icons = {
        success: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>',
        warning: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>',
        error:   '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>',
        info:    '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>'
    };

    /**
     * Show a minimalist global toast notification.
     * Replaces any existing notification to prevent stacking.
     */
    function show(msg, type, duration) {
        type = type || 'info';
        duration = duration || AUTO_HIDE_MS;

        var container = initContainer();
        
        // --- PREVENT STACKING ---
        while (container.firstChild) {
            container.removeChild(container.firstChild);
        }

        var toast = document.createElement('div');
        var typeClass = icons[type] ? type : 'icon';
        toast.className = 'voyastra-toast voyastra-toast-' + typeClass;
        toast.setAttribute('role', 'alert');

        var iconHtml = icons[type] || '<span class="toast-emoji">' + type + '</span>';

        toast.innerHTML =
            '<div class="toast-icon">' + iconHtml + '</div>' +
            '<div class="toast-msg">' + msg + '</div>' +
            '<button class="toast-close" aria-label="Close">' +
                '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>' +
            '</button>';

        container.appendChild(toast);

        var hideTimeout;
        function closeToast() {
            toast.classList.remove('show');
            toast.classList.add('hide');
            clearTimeout(hideTimeout);
            setTimeout(function() { if (toast.parentNode) toast.remove(); }, 300);
        }

        toast.querySelector('.toast-close').addEventListener('click', closeToast);

        // Pause on hover
        toast.addEventListener('mouseenter', function() { clearTimeout(hideTimeout); });
        toast.addEventListener('mouseleave', function() { hideTimeout = setTimeout(closeToast, duration); });

        // Trigger show animation
        requestAnimationFrame(function() {
            requestAnimationFrame(function() {
                toast.classList.add('show');
                hideTimeout = setTimeout(closeToast, duration);
            });
        });
    }

    window.VoyastraToast = {
        show:    show,
        success: function(msg, d) { show(msg, 'success', d); },
        error:   function(msg, d) { show(msg, 'error', d); },
        warning: function(msg, d) { show(msg, 'warning', d); },
        info:    function(msg, d) { show(msg, 'info', d); }
    };

})(window);
