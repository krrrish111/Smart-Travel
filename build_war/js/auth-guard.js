/**
 * Voyastra Auth Guard & Session Manager
 * ─────────────────────────────────────
 * Single source of truth for user auth state across the entire app.
 * Reads / writes to localStorage.  Replace localStorage.getItem with
 * a server cookie check when a real backend is available.
 *
 * Public API  (window.VoyastraAuth):
 *   .isLoggedIn()              → boolean
 *   .getSession()              → { name, email, avatar? } | null
 *   .requireAuth(dest, cb)     → true | redirect to login
 *   .login(name, email)        → saves session + dispatches 'va:authChange'
 *   .logout()                  → clears session + redirects home
 */

;(function (window) {
    'use strict';

    var SESSION_KEY = 'voyastra_user';

    /* ── Helpers ──────────────────────────────────────────────── */
    function getSession() {
        // Source 1: Check JVM Session mapped by header.jsp
        if (window.javaSession && window.javaSession.userId && window.javaSession.userId.length > 0) {
            return {
                name: window.javaSession.name || 'User',
                email: window.javaSession.email || '',
                role: window.javaSession.role || 'user'
            };
        }
        // Fallback or old prototype method
        try {
            var raw = localStorage.getItem(SESSION_KEY);
            return raw ? JSON.parse(raw) : null;
        } catch (e) {
            return null;
        }
    }

    function setSession(data) {
        localStorage.setItem(SESSION_KEY, JSON.stringify(data));
        _dispatch();
    }

    function clearSession() {
        localStorage.removeItem(SESSION_KEY);
        _dispatch();
    }

    function _dispatch() {
        try {
            window.dispatchEvent(new Event('va:authChange'));
        } catch (e) {}
    }

    /* ── Core API ─────────────────────────────────────────────── */
    function requireAuth(destination, callback) {
        if (getSession()) {
            if (typeof callback === 'function') callback();
            return true;
        }
        var target   = destination || window.location.href;
        var loginUrl = 'login.jsp?redirect=' + encodeURIComponent(target);
        window.location.href = loginUrl;
        return false;
    }

    function login(name, email) {
        setSession({ name: name, email: email });
    }

    function logout() {
        clearSession(); // Fallback backward compatibility 
        window.location.href = 'logout'; // Let the real Java Servlet gracefully kill auth
    }

    /* ── Expose ───────────────────────────────────────────────── */
    window.VoyastraAuth = {
        requireAuth: requireAuth,
        getSession:  getSession,
        isLoggedIn:  function () { return !!getSession(); },
        login:       login,
        logout:      logout
    };

})(window);
