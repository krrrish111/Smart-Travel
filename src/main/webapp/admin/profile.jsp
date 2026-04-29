<jsp:include page="/admin/common/layout_start.jsp" />

<style>
    .edit-profile-card {
        background: var(--surface-glass);
        backdrop-filter: blur(16px);
        border: 1px solid var(--color-border);
        border-radius: 20px;
        box-shadow: var(--shadow-xl);
        padding: 40px;
        max-width: 600px;
        margin: 20px auto;
    }
    .form-group {
        margin-bottom: 24px;
    }
    .form-label {
        display: block;
        font-family: 'Inter', sans-serif;
        font-size: 0.9rem;
        font-weight: 600;
        color: var(--text-main);
        margin-bottom: 8px;
    }
    .form-input {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid var(--color-border);
        border-radius: 10px;
        font-family: 'Inter', sans-serif;
        font-size: 0.95rem;
        color: var(--text-main);
        background: var(--bg-card);
        outline: none;
        transition: all 0.2s;
    }
    .form-input:focus {
        border-color: var(--color-primary);
        box-shadow: 0 0 0 3px rgba(79,70,229,0.1);
    }
    
    .avatar-upload {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 16px;
        margin-bottom: 32px;
    }
    .avatar-preview {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        background-color: var(--color-muted);
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>');
        background-size: cover;
        background-position: center;
        border: 3px solid var(--color-border);
        position: relative;
        overflow: hidden;
    }
    .avatar-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: none;
    }
    .avatar-edit-btn {
        background: var(--color-primary);
        color: white;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
</style>

<div class="admin-section active">
    <h2 style="margin-bottom: 8px;">Admin Profile</h2>
    <p class="text-muted" style="margin-bottom: 24px;">Manage your administrative account details.</p>

    <div class="edit-profile-card">
        <form id="adminProfileForm">
            <div class="avatar-upload">
                <div class="avatar-preview" id="avatarPreviewContainer">
                    <img id="avatarImage" src="" alt="Profile">
                </div>
                <label for="profileImageInput" class="avatar-edit-btn">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                    Upload Photo
                </label>
                <input type="file" id="profileImageInput" class="hidden" accept="image/*">
            </div>

            <div class="form-group">
                <label class="form-label" for="profileName">Full Name</label>
                <input type="text" id="profileName" class="form-input" placeholder="Your Name" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="profileEmail">Email Address</label>
                <input type="email" id="profileEmail" class="form-input" placeholder="email@example.com" required readonly>
            </div>

            <div class="form-group">
                <label class="form-label" for="profilePhone">Phone Number</label>
                <input type="tel" id="profilePhone" class="form-input" placeholder="+91 98765 43210">
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 32px;">
                <button type="button" class="btn btn-outline" onclick="window.history.back()">Cancel</button>
                <button type="submit" class="btn btn-primary" id="saveProfileBtn">Save Profile</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('adminProfileForm');
        const nameInput = document.getElementById('profileName');
        const emailInput = document.getElementById('profileEmail');
        const phoneInput = document.getElementById('profilePhone');
        const avatarImage = document.getElementById('avatarImage');
        const imageInput = document.getElementById('profileImageInput');

        // Pre-fill from window.javaSession (provided by layout_start.jsp)
        if (window.javaSession) {
            nameInput.value = window.javaSession.name || '';
            emailInput.value = window.javaSession.email || '';
        }

        // Handle Image Preview
        imageInput.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (!file) return;
            const reader = new FileReader();
            reader.onload = (event) => {
                avatarImage.src = event.target.result;
                avatarImage.style.display = 'block';
            };
            reader.readAsDataURL(file);
        });

        form.addEventListener('submit', (e) => {
            e.preventDefault();
            // Simulating save logic
            VoyastraToast.show('Admin profile updated successfully (Mock)', 'success');
        });
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
