<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
    .edit-profile-card {
        background: var(--surface-glass);
        backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 20px;
        box-shadow: var(--shadow-xl);
        padding: 40px;
        max-width: 600px;
        margin: 0 auto;
    }
    .form-group {
        margin-bottom: 24px;
    }
    .form-label {
        display: block;
        font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
        font-size: 0.9rem;
        font-weight: 600;
        color: var(--text-main);
        margin-bottom: 8px;
        letter-spacing: 0.02em;
    }
    .form-input {
        width: 100%;
        padding: 14px 18px;
        border: 1.5px solid rgba(15,11,8,0.15);
        border-radius: 12px;
        font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
        font-size: 1rem;
        color: var(--text-main);
        background: rgba(255,255,255,0.7);
        outline: none;
        transition: all 0.2s;
    }
    [data-theme="dark"] .form-input {
        background: rgba(0,0,0,0.2);
        border-color: rgba(255,255,255,0.1);
        color: #ffffff;
    }
    .form-input:focus {
        border-color: var(--color-primary);
        box-shadow: 0 0 0 3px rgba(79,70,229,0.15);
        background: var(--bg-main);
    }
    
    .avatar-upload {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 16px;
        margin-bottom: 32px;
    }
    .avatar-preview {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background-color: var(--color-muted);
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>');
        background-size: cover;
        background-position: center;
        border: 4px solid var(--surface-glass);
        box-shadow: var(--shadow-md);
        position: relative;
        overflow: hidden;
    }
    .avatar-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: none; /* hidden until loaded */
    }
    .avatar-edit-btn {
        background: var(--color-primary);
        color: white;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: all 0.2s;
    }
    .avatar-edit-btn:hover {
        background: var(--color-accent);
        transform: translateY(-1px);
    }
    .file-input-hidden {
        display: none;
    }
</style>

<main style="padding-top: 120px; padding-bottom: 80px; min-height: 100vh;">
    <div class="container relative z-10">
        
        <div class="flex justify-center mb-8 slide-up">
            <div class="text-center">
                <h1 class="text-main mb-2 mt-4" style="font-size: 2.5rem; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif; font-weight: 700;">Edit Profile</h1>
                <p class="text-muted" style="font-size: 1.1rem;">Update your personal details and how we can reach you.</p>
            </div>
        </div>

        <div class="edit-profile-card slide-up delay-1">
            <form id="editProfileForm">
                
                <!-- Avatar Upload Section -->
                <div class="avatar-upload">
                    <div class="avatar-preview" id="avatarPreviewContainer">
                        <img id="avatarImage" src="" alt="Profile Preview">
                    </div>
                    <label for="profileImageInput" class="avatar-edit-btn">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="17 8 12 3 7 8"></polyline>
                            <line x1="12" y1="3" x2="12" y2="15"></line>
                        </svg>
                        Change Photo
                    </label>
                    <input type="file" id="profileImageInput" class="file-input-hidden" accept="image/*">
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="form-group md:col-span-2">
                        <label class="form-label" for="profileName">Full Name</label>
                        <input type="text" id="profileName" class="form-input" placeholder="e.g. Raj Das" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="profileEmail">Email Address</label>
                        <input type="email" id="profileEmail" class="form-input" placeholder="e.g. raj@voyastra.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="profilePhone">Phone Number</label>
                        <input type="tel" id="profilePhone" class="form-input" placeholder="+91 98765 43210">
                    </div>
                </div>

                <div class="flex justify-end gap-3 mt-6">
                    <a href="${pageContext.request.contextPath}/user-home" class="btn btn-outline" style="padding: 12px 24px;">Cancel</a>
                    <button type="submit" class="btn btn-primary" style="padding: 12px 32px;" id="saveProfileBtn">Save Changes</button>
                </div>
            </form>
        </div>

    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const SESSION_KEY = 'voyastra_user';
        const form = document.getElementById('editProfileForm');
        const nameInput = document.getElementById('profileName');
        const emailInput = document.getElementById('profileEmail');
        const phoneInput = document.getElementById('profilePhone');
        
        const avatarImage = document.getElementById('avatarImage');
        const avatarPreviewContainer = document.getElementById('avatarPreviewContainer');
        const imageInput = document.getElementById('profileImageInput');

        let currentBase64Image = null;

        // 1. Check Authentication via VoyastraAuth (Primary source: Java session)
        if (!VoyastraAuth.isLoggedIn()) {
            console.warn("[EditProfile] No active session found. Redirecting to login.");
            window.location.href = '${pageContext.request.contextPath}/login?redirect=profile';
            return;
        }

        // 2. Pre-fill form from session and localStorage fallback
        try {
            const user = VoyastraAuth.getSession();
            if (user) {
                if (user.name) nameInput.value = user.name;
                if (user.email) emailInput.value = user.email;
                
                // Fallback to localStorage for phone/profileImage if added there
                const localData = localStorage.getItem(SESSION_KEY);
                if (localData) {
                    const localUser = JSON.parse(localData);
                    if (localUser.phone) phoneInput.value = localUser.phone;
                    if (localUser.profileImage) {
                        currentBase64Image = localUser.profileImage;
                        avatarImage.src = currentBase64Image;
                        avatarImage.style.display = 'block';
                    }
                }
            }
        } catch(e) {
            console.error("Error pre-filling profile form:", e);
        }

        // 2. Handle Image Upload & Preview using FileReader
        imageInput.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (!file) return;

            // Only allow images
            if (!file.type.startsWith('image/')) {
                VoyastraToast.show('Please select an image file.', 'info');
                return;
            }

            const reader = new FileReader();
            reader.onload = (event) => {
                currentBase64Image = event.target.result;
                avatarImage.src = currentBase64Image;
                avatarImage.style.display = 'block';
            };
            // Read file as Base64 to save locally and preview instantly
            reader.readAsDataURL(file);
        });

        // 3. Save Data and Redirect
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            
            const btn = document.getElementById('saveProfileBtn');
            btn.innerHTML = 'Saving...';
            btn.style.opacity = '0.7';
            btn.style.pointerEvents = 'none';

            // Parse existing user object to keep other props if any
            let user = {};
            try {
                const existing = localStorage.getItem(SESSION_KEY);
                if (existing) user = JSON.parse(existing);
            } catch(e) {}

            // Update user object
            user.name = nameInput.value.trim();
            user.email = emailInput.value.trim();
            user.phone = phoneInput.value.trim();
            if (currentBase64Image) {
                user.profileImage = currentBase64Image;
            }

            // Save to localStorage
            localStorage.setItem(SESSION_KEY, JSON.stringify(user));

            // Short timeout to feel responsive
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/user-home';
            }, 500);
        });
    });
</script>

<%@ include file="/components/footer.jsp" %>
