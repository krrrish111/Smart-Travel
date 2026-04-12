<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up — Voyastra</title>
    <link rel="icon" type="image/svg+xml" href="images/favicon.svg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/theme.css">
    <link rel="stylesheet" href="css/components.css">
    <script src="js/auth-guard.js"></script>
    <script src="js/toast.js"></script>
    <!-- Prevent flash of wrong theme -->
    <script>(function(){ var t=localStorage.getItem('theme'); if(t) document.documentElement.setAttribute('data-theme',t); })();</script>

    <style>
        /* ── Login Page Exclusive Styles ── */
        body { cursor: auto !important; display: flex; min-height: 100vh; }

        .login-split {
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 100vh;
            width: 100%;
        }

        /* Left — brand panel */
        .login-brand-panel {
            position: relative;
            background: #0d0d11;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px;
            overflow: hidden;
        }
        .login-brand-panel::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 30% 50%, rgba(79,70,229,0.18) 0%, transparent 70%),
                        radial-gradient(ellipse at 80% 20%, rgba(6,182,212,0.12) 0%, transparent 60%);
            pointer-events: none;
        }
        .login-brand-svg {
            width: 200px;
            height: 100px;
            margin-bottom: 32px;
            opacity: 0;
            animation: loginBrandIn 1s 0.3s ease forwards;
        }
        .login-brand-title {
            font-family: 'Poppins', sans-serif;
            font-size: 2.8rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            color: #ffffff;
            margin-bottom: 12px;
            opacity: 0;
            animation: loginBrandIn 1s 0.5s ease forwards;
        }
        .login-brand-sub {
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            font-weight: 400;
            color: rgba(255,255,255,0.5);
            text-align: center;
            max-width: 280px;
            line-height: 1.7;
            opacity: 0;
            animation: loginBrandIn 1s 0.7s ease forwards;
        }
        .login-brand-dots {
            position: absolute;
            bottom: 40px;
            display: flex;
            gap: 8px;
            opacity: 0.3;
        }
        .login-brand-dots span {
            width: 6px; height: 6px;
            border-radius: 50%;
            background: #06b6d4;
        }

        /* Right — form panel */
        .login-form-panel {
            background: #ffffff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 80px;
        }
        [data-theme="dark"] .login-form-panel { background: #0f0f14; }

        .login-form-wrap {
            width: 100%;
            max-width: 380px;
            opacity: 0;
            animation: loginFormIn 0.9s 0.4s cubic-bezier(0.25,1,0.5,1) forwards;
        }
        .login-eyebrow {
            font-family: 'Poppins', sans-serif;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: #4f46e5;
            margin-bottom: 10px;
        }
        .login-heading {
            font-family: 'Poppins', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: #0f0b08;
            margin-bottom: 6px;
        }
        [data-theme="dark"] .login-heading { color: #ffffff; }
        .login-subhead {
            font-family: 'Inter', sans-serif;
            font-size: 0.88rem;
            color: rgba(15,11,8,0.5);
            margin-bottom: 36px;
        }
        [data-theme="dark"] .login-subhead { color: rgba(255,255,255,0.4); }

        /* Form fields */
        .login-field {
            position: relative;
            margin-bottom: 18px;
        }
        .login-field label {
            display: block;
            font-family: 'Poppins', sans-serif;
            font-size: 0.78rem;
            font-weight: 600;
            color: #0f0b08;
            margin-bottom: 7px;
            letter-spacing: 0.03em;
        }
        [data-theme="dark"] .login-field label { color: rgba(255,255,255,0.75); }
        .login-field input {
            width: 100%;
            padding: 13px 16px;
            border: 1.5px solid rgba(15,11,8,0.15);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.92rem;
            color: #0f0b08;
            background: #fafafa;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
            cursor: text !important;
        }
        [data-theme="dark"] .login-field input {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.12);
            color: #ffffff;
        }
        .login-field input:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79,70,229,0.12);
        }
        .login-field input::placeholder { color: rgba(15,11,8,0.35); }
        [data-theme="dark"] .login-field input::placeholder { color: rgba(255,255,255,0.25); }

        /* Toggle password */
        .login-field .pw-toggle {
            position: absolute;
            right: 14px;
            top: 38px;
            background: none;
            border: none;
            cursor: pointer !important;
            color: rgba(15,11,8,0.35);
            padding: 0;
            line-height: 1;
        }
        [data-theme="dark"] .pw-toggle { color: rgba(255,255,255,0.3); }
        .login-field .pw-toggle:hover { color: #4f46e5; }

        /* Error message */
        #loginError {
            display: none;
            align-items: center;
            gap: 8px;
            background: rgba(239,68,68,0.08);
            border: 1px solid rgba(239,68,68,0.25);
            border-radius: 8px;
            padding: 10px 14px;
            font-family: 'Inter', sans-serif;
            font-size: 0.82rem;
            color: #ef4444;
            margin-bottom: 18px;
        }

        /* Hint */
        .login-hint {
            font-family: 'Inter', sans-serif;
            font-size: 0.76rem;
            color: rgba(15,11,8,0.35);
            background: rgba(79,70,229,0.06);
            border-radius: 8px;
            padding: 10px 14px;
            margin-bottom: 22px;
            line-height: 1.6;
        }
        [data-theme="dark"] .login-hint {
            color: rgba(255,255,255,0.35);
            background: rgba(79,70,229,0.1);
        }
        .login-hint code {
            font-weight: 700;
            color: #4f46e5;
            background: none;
        }

        /* Submit button */
        .login-btn {
            width: 100%;
            padding: 14px;
            background: #0f0b08;
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.9rem;
            font-weight: 700;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            cursor: pointer !important;
            transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
        }
        [data-theme="dark"] .login-btn { background: #ffffff; color: #0f0b08; }
        .login-btn:hover { background: #1a1510; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(0,0,0,0.2); }
        [data-theme="dark"] .login-btn:hover { background: #f0f0f0; }
        .login-btn:active { transform: translateY(0); }
        .login-btn.loading { opacity: 0.65; pointer-events: none; }

        /* Back link */
        .login-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-family: 'Inter', sans-serif;
            font-size: 0.82rem;
            color: rgba(15,11,8,0.45);
            text-decoration: none;
            margin-top: 24px;
            cursor: pointer !important;
            transition: color 0.2s;
        }
        [data-theme="dark"] .login-back { color: rgba(255,255,255,0.3); }
        .login-back:hover { color: #4f46e5; }

        /* Animations */
        @keyframes loginBrandIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes loginFormIn {
            from { opacity: 0; transform: translateX(24px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        /* Floating orbs on brand panel */
        .orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(60px);
            pointer-events: none;
        }
        .orb-1 { width: 300px; height: 300px; background: rgba(79,70,229,0.15); top: -80px; left: -60px; }
        .orb-2 { width: 200px; height: 200px; background: rgba(6,182,212,0.12); bottom: 60px; right: -40px; }

        /* Mobile */
        @media (max-width: 768px) {
            .login-split { grid-template-columns: 1fr; }
            .login-brand-panel { display: none; }
            .login-form-panel { padding: 40px 28px; }
        }
    </style>
</head>
<body>

<div class="login-split">
    <!-- ── Left: Brand Panel ── -->
    <div class="login-brand-panel">
        <div class="orb orb-1"></div>
        <div class="orb orb-2"></div>

        <!-- Animated infinity SVG (same as preloader) -->
        <svg class="login-brand-svg" viewBox="0 0 300 150">
            <defs>
                <linearGradient id="loginGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stop-color="#4f46e5" />
                    <stop offset="100%" stop-color="#06b6d4" />
                </linearGradient>
            </defs>
            <path fill="none" stroke="url(#loginGrad)" stroke-width="2.5"
                  stroke-dasharray="800" stroke-dashoffset="800"
                  style="animation: loginPathDraw 3s cubic-bezier(0.4,0,0.2,1) 0.8s infinite;"
                  d="M 150,75 C 200,15 300,15 300,75 C 300,135 200,135 150,75 C 100,15 0,15 0,75 C 0,135 100,135 150,75 Z" />
        </svg>
        <style>
            @keyframes loginPathDraw {
                0%   { stroke-dashoffset: 800; }
                100% { stroke-dashoffset: 0; }
            }
        </style>

        <div class="login-brand-title">Voyastra</div>
        <div class="login-brand-sub">Plan smarter. Travel better. Discover India like never before.</div>
        <div class="login-brand-dots">
            <span></span><span style="opacity:0.6"></span><span style="opacity:0.3"></span>
        </div>
    </div>

    <!-- ── Right: Form Panel ── -->
    <div class="login-form-panel">
        <div class="login-form-wrap">
            <div class="login-eyebrow">Start your journey</div>
            <h1 class="login-heading">Create Account</h1>
            <p class="login-subhead">Plan and organize your trips seamlessly.</p>

            <!-- Error -->
            <c:if test="${not empty errorMessage}">
                <div id="loginError" style="display: flex;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    ${errorMessage}
                </div>
            </c:if>

            <form action="register" method="POST" id="registerForm" novalidate data-vx>
                <div class="login-field">
                    <label for="loginName">Full Name</label>
                    <input type="text" id="loginName" name="name" placeholder="John Doe"
                           data-v-required data-v-min-len="2" data-v-label="Full Name">
                </div>

                <div class="login-field">
                    <label for="loginEmail">Email address</label>
                    <input type="email" id="loginEmail" name="email" placeholder="you@example.com" autocomplete="email"
                           data-v-required data-v-email data-v-label="Email">
                </div>

                <div class="login-field">
                    <label for="loginPassword">Password</label>
                    <input type="password" id="loginPassword" name="password" placeholder="At least 6 characters" autocomplete="current-password"
                           data-v-required data-v-min-len="6" data-v-label="Password">
                    <button type="button" class="pw-toggle" id="pwToggle" aria-label="Show/hide password">
                        <svg id="eyeIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>

                <button type="submit" class="login-btn" id="registerBtn">Create Account</button>
            </form>

            <a href="login.jsp" class="login-back">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                Already have an account? Sign in
            </a>
        </div>
    </div>
</div>

<script>
    // Expose Java session bridge for registration context
    window.javaSession = {
        userId: "${sessionScope.user_id}",
        role:   "${sessionScope.role}",
        name:   "${sessionScope.name}",
        email:  "${sessionScope.email}"
    };

    // If already logged in, redirect
    if (VoyastraAuth.isLoggedIn()) {
        window.location.replace('dashboard.jsp');
    }

    // Toggle password visibility
    document.getElementById('pwToggle').addEventListener('click', function () {
        var pw   = document.getElementById('loginPassword');
        var icon = document.getElementById('eyeIcon');
        if (pw.type === 'password') {
            pw.type = 'text';
            icon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
        } else {
            pw.type = 'password';
            icon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
        }
    });

    // --- AJAX REGISTER FLOW ---
    document.getElementById('registerForm').addEventListener('submit', function (e) {
        e.preventDefault();
        
        var btn = document.getElementById('registerBtn');
        var errBox = document.getElementById('loginError');
        var name = document.getElementById('loginName').value;
        var email = document.getElementById('loginEmail').value;
        var password = document.getElementById('loginPassword').value;

        if (!name || !email || !password) return;

        btn.classList.add('loading');
        btn.disabled = true;
        btn.textContent = 'Processing...';
        if (errBox) errBox.style.display = 'none';

        fetch('register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name: name, email: email, password: password })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                // SYNC SESSION
                if (window.VoyastraAuth) VoyastraAuth.login(data);
                
                if (window.VoyastraToast) VoyastraToast.show(data.message, 'success');
                setTimeout(function() {
                    window.location.href = data.redirect || 'dashboard.jsp';
                }, 1200);
            } else {
                btn.classList.remove('loading');
                btn.disabled = false;
                btn.textContent = 'Create Account';
                
                if (window.VoyastraToast) VoyastraToast.show(data.message, 'error');
                
                if (!errBox) {
                    errBox = document.createElement('div');
                    errBox.id = 'loginError';
                    errBox.style.cssText = 'display:flex; align-items:center; gap:8px; padding:10px 14px; background:rgba(239,68,68,0.1); border:1px solid rgba(239,68,68,0.3); border-radius:8px; color:#ef4444; font-size:0.875rem; margin-bottom:16px;';
                    document.getElementById('registerForm').insertAdjacentElement('beforebegin', errBox);
                }
                errBox.style.display = 'flex';
                errBox.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>' + data.message;
            }
        })
        .catch(function(err) {
            btn.classList.remove('loading');
            btn.disabled = false;
            btn.textContent = 'Create Account';
            if (window.VoyastraToast) VoyastraToast.show('Network error. Please try again.', 'error');
        });
    });
</script>

</body>
</html>
