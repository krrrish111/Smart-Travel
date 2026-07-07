<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%--
  AI Buddy Widget — Single-Instance Guard
  Idempotency check at the HTML level (data attribute on body)
  and at the JS level (window.voyastraBuddyInitialized flag).
  Only ONE widget will be created regardless of how many times
  this file is included.
--%>
<script>
/* AI Buddy single-instance guard (runs synchronously, before any HTML is written) */
if (!window.voyastraBuddyInitialized) {
    window.voyastraBuddyInitialized = true;
    document.write('<div id="ai-draggable-container">');
    document.write('    <!-- The AI Orb -->');
    document.write('    <div id="ai-buddy-orb" class="ai-orb" title="Voyastra AI Buddy">');
    document.write('        <div class="orb-core"></div>');
    document.write('        <div class="orb-pulse"></div>');
    document.write('        <span class="ai-icon">🤖</span>');
    document.write('    </div>');
    document.write('    <!-- The Glassmorphic AI Popup -->');
    document.write('    <div id="ai-smart-popup" class="ai-popup hidden">');
    document.write('        <div class="ai-popup-header">');
    document.write('            <div class="popup-title"><i class="fas fa-sparkles"></i> Voyastra AI</div>');
    document.write('            <div class="popup-controls"><button id="ai-minimize-btn" class="icon-btn" title="Minimize"><i class="fas fa-minus"></i></button></div>');
    document.write('        </div>');
    document.write('        <div class="ai-popup-body">');
    document.write('            <div class="ai-context-section">');
    document.write('                <p id="ai-context-message">Loading recommendations...</p>');
    document.write('                <div class="ai-quick-actions"></div>');
    document.write('            </div>');
    document.write('            <div id="ai-chat-history" class="ai-chat-scroll">');
    document.write('                <div class="chat-message ai-message"><div class="message-content">Hello! I\'m your AI Travel Buddy. I can help you plan trips, discover hidden gems, or optimize your budget. How can I assist you today?</div></div>');
    document.write('                <div id="ai-typing-indicator" class="typing-indicator hidden"><span></span><span></span><span></span></div>');
    document.write('            </div>');
    document.write('        </div>');
    document.write('        <div class="ai-popup-footer">');
    document.write('            <div class="chat-input-wrapper">');
    document.write('                <input type="text" id="ai-chat-input" placeholder="Ask me anything..." />');
    document.write('                <button id="ai-chat-send" class="icon-btn send-btn"><i class="fas fa-paper-plane"></i></button>');
    document.write('            </div>');
    document.write('        </div>');
    document.write('    </div>');
    document.write('</div>');
}
</script>

<script>
(function() {
    /* Safety net: If duplicate DOM nodes somehow exist, remove all but the first. */
    function deduplicateBuddy() {
        var all = document.querySelectorAll('#ai-draggable-container');
        if (all.length > 1) {
            for (var i = 1; i < all.length; i++) {
                all[i].parentNode.removeChild(all[i]);
            }
        }
    }

    /* Enforce correct bottom-right positioning — override any stale localStorage positions
       that might have moved the widget to top-left or bottom-left from a previous drag session. */
    function enforceDefaultPosition(container) {
        var saved = null;
        try { saved = JSON.parse(localStorage.getItem('voyastraAIPos')); } catch(e) {}
        if (!saved || window.innerWidth <= 768) {
            /* No saved pos or mobile: canonical bottom-right via CSS, clear any inline overrides */
            container.style.removeProperty('left');
            container.style.removeProperty('top');
            container.style.removeProperty('right');
            container.style.removeProperty('bottom');
            return;
        }
        /* Validate saved position is on-screen; if not, reset it */
        var orbW = 68;
        var orbH = 68;
        if (saved.left < 0 || saved.left > window.innerWidth - orbW ||
            saved.top  < 0 || saved.top  > window.innerHeight - orbH) {
            localStorage.removeItem('voyastraAIPos');
            container.style.removeProperty('left');
            container.style.removeProperty('top');
        }
    }

    /* Lazy-load CSS + JS on first interaction */
    function initBuddyLoader() {
        var orb = document.getElementById('ai-buddy-orb');
        if (!orb) return;

        deduplicateBuddy();

        var container = document.getElementById('ai-draggable-container');
        if (container) enforceDefaultPosition(container);

        var loaded = false;
        function loadAiBuddy() {
            if (loaded) return;
            loaded = true;
            orb.removeEventListener('mouseenter', loadAiBuddy);
            orb.removeEventListener('click',      loadAiBuddy);

            /* Avoid loading CSS twice */
            if (!document.querySelector('link[href*="ai-buddy.css"]')) {
                var link = document.createElement('link');
                link.rel  = 'stylesheet';
                link.href = (window.CONTEXT_PATH || '') + '/assets/css/ai-buddy.css';
                document.head.appendChild(link);
            }

            /* Avoid loading JS twice */
            if (!document.querySelector('script[src*="ai-buddy.js"]')) {
                var script  = document.createElement('script');
                script.src  = (window.CONTEXT_PATH || '') + '/assets/js/ai-buddy.js';
                script.defer = true;
                document.body.appendChild(script);
            }
        }

        orb.addEventListener('mouseenter', loadAiBuddy);
        orb.addEventListener('click',      loadAiBuddy);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initBuddyLoader);
    } else {
        initBuddyLoader();
    }
})();
</script>
