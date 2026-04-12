/**
 * Voyastra Auth Guard — v3
 * ─────────────────────────
 * Synchronizes Java Server Sessions with the Frontend UI.
 * 
 * Sources of Truth:
 * 1. PRIMARY: window.javaSession (Populated by header.jsp from Java HttpSession)
 * 2. LIVE: Memory state maintained during AJAX login/logout cycles.
 * 
 * Note: localStorage is avoided for authentication state to prevent "stale sessions" 
 * where the frontend thinks it's logged in but the server session has expired.
 */

;(function (window) {
    'use strict';

    // Internal state tracking for the current page lifecycle
    var _state = {
        session: null,
        initialized: false
    };

    /**
     * Initializes the session from the bridge provided by the server.
     */
    function _init() {
        if (window.javaSession && window.javaSession.userId && window.javaSession.userId !== '0' && window.javaSession.userId !== '') {
            _state.session = {
                id:    window.javaSession.userId,
                name:  window.javaSession.name || 'Explorer',
                email: window.javaSession.email || '',
                role:  window.javaSession.role || 'user'
            };
        } else {
            _state.session = null;
        }
        _state.initialized = true;
    }

    /**
     * Retrieves the current session object.
     */
    function getSession() {
        if (!_state.initialized) _init();
        return _state.session;
    }

    /**
     * Checks if a user is currently authenticated on the server.
     */
    function isAuthenticated() {
        return !!getSession();
    }

    /**
     * Checks if the authenticated user has administrative privileges.
     */
    function isAdmin() {
        var s = getSession();
        return s && (s.role === 'admin' || s.role === 'ADMIN');
    }

    /**
     * Updates the frontend session state immediately (used after AJAX success).
     * @param {Object} data - The user session data from the server response.
     */
    function login(data) {
        if (!data) return;
        
        // Update the bridge and the local state
        window.javaSession = {
            userId: data.userId || data.id,
            name:   data.name,
            email:  data.email,
            role:   data.role
        };
        
        _state.session = {
            id:    window.javaSession.userId,
            name:  window.javaSession.name,
            email: window.javaSession.email,
            role:  window.javaSession.role
        };
        
        _dispatch();
    }

    /**
     * Triggers a server-side logout and clears local state.
     */
    function logout() {
        _state.session = null;
        window.javaSession = { userId: '0', role: 'user', name: '', email: '' };
        _dispatch();
        
        // Finalize on server
        window.location.href = 'logout';
    }

    /**
     * Route protector for JSP pages that require authentication.
     */
    function requireAuth(role) {
        var s = getSession();
        if (!s) {
            window.location.href = 'login?error=auth_required&redirect=' + encodeURIComponent(window.location.pathname);
            return false;
        }
        if (role === 'admin' && !isAdmin()) {
            window.location.href = 'index.jsp?error=unauthorized';
            return false;
        }
        return true;
    }

    /**
     * Notifies UI components (like the header widget) that auth state has changed.
     */
    function _dispatch() {
        try {
            window.dispatchEvent(new Event('va:authChange'));
        } catch (e) {
            console.error('Auth event dispatch failed', e);
        }
    }

    // Initialize on load
    _init();

    /* ── API Exposure ─────────────────────────────────────────── */
    window.VoyastraAuth = {
        getSession:      getSession,
        isLoggedIn:      isAuthenticated,
        isAuthenticated: isAuthenticated,
        isAdmin:         isAdmin,
        login:           login,
        logout:          logout,
        requireAuth:     requireAuth
    };

})(window);
