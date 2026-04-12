/**
 * Voyastra Auth Guard — v2
 * ─────────────────────────
 * Primary source of truth: window.javaSession (set by header.jsp from Java HttpSession).
 * localStorage fallback is kept only for compatibility but no longer drives auth decisions.
 */

;(function (window) {
    'use strict';

    var SESSION_KEY = 'voyastra_user';
    var TOKEN_KEY   = 'voyastra_token';
    var ROLE_KEY    = 'voyastra_role';

    /* ── Helpers ──────────────────────────────────────────────── */
    function getSession() {
        // PRIMARY: Java HttpSession state (always authoritative)
        if (window.javaSession &&
            window.javaSession.userId &&
            String(window.javaSession.userId).trim().length > 0 &&
            window.javaSession.userId !== '0') {
            
            var session = {
                name:  window.javaSession.name  || 'User',
                email: window.javaSession.email || '',
                role:  window.javaSession.role  || 'user'
            };

            // Sync with localStorage for "JWT" / persistence requirement
            try {
                localStorage.setItem(ROLE_KEY, session.role);
                // Create a mock JWT (Base64 of user info) if no real token exists
                if (!localStorage.getItem(TOKEN_KEY)) {
                    var mockToken = btoa(JSON.stringify({ id: window.javaSession.userId, exp: Date.now() + 86400000 }));
                    localStorage.setItem(TOKEN_KEY, mockToken);
                }
            } catch (e) {}

            return session;
        }
        // FALLBACK: localStorage (for pages that don't include header.jsp)
        try {
            var raw = localStorage.getItem(SESSION_KEY);
            return raw ? JSON.parse(raw) : null;
        } catch (e) {
            return null;
        }
    }

    function isAuthenticated() {
        return !!getSession();
    }

    function isAdmin() {
        var s = getSession();
        return s && s.role === 'admin';
    }

    function setSession(data) {
        try { 
            localStorage.setItem(SESSION_KEY, JSON.stringify(data));
            if (data.role) localStorage.setItem(ROLE_KEY, data.role);
        } catch(e) {}
        _dispatch();
    }

    function clearSession() {
        try { 
            localStorage.removeItem(SESSION_KEY);
            localStorage.removeItem(TOKEN_KEY);
            localStorage.removeItem(ROLE_KEY);
        } catch(e) {}
        _dispatch();
    }

    function _dispatch() {
        try { window.dispatchEvent(new Event('va:authChange')); } catch (e) {}
    }

    /* ── Core API ─────────────────────────────────────────────── */
    function requireAuth(destination, callback) {
        if (getSession()) {
            if (typeof callback === 'function') callback();
            return true;
        }
        var target   = destination || window.location.pathname;
        var loginUrl = 'login?error=auth_required';
        window.location.href = loginUrl;
        return false;
    }

    function login(name, email) {
        setSession({ name: name, email: email });
    }

    function logout() {
        clearSession();
        window.location.href = 'logout';
    }

    /* ── Expose ───────────────────────────────────────────────── */
    window.VoyastraAuth = {
        requireAuth:     requireAuth,
        getSession:      getSession,
        isLoggedIn:      isAuthenticated,
        isAuthenticated: isAuthenticated,
        isAdmin:         isAdmin,
        login:           login,
        logout:          logout
    };

})(window);
