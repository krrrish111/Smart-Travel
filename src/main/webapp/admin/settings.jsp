<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Settings Section -->
<section id="adminSettings" class="admin-section active">
    <h2 style="margin-bottom: 8px;">Settings</h2>
    <p class="text-muted" style="margin-bottom: 28px;">Customize your admin panel preferences.</p>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px;">

        <div class="stat-card">
            <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Appearance</div>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <span style="font-size:0.9rem;">Dark Mode</span>
                <label style="position: relative; display: inline-block; width: 44px; height: 24px;">
                    <input type="checkbox" id="settingsTheme" style="opacity:0; width:0; height:0;" onchange="applySettingsTheme(this.checked)">
                    <span style="position:absolute; cursor:pointer; top:0; left:0; right:0; bottom:0; background:#ccc; border-radius:24px; transition:.3s;" id="themeSlider"></span>
                </label>
            </div>
            <p style="font-size:0.8rem; color:var(--text-muted);">Toggle between dark and light interface mode.</p>
        </div>

        <div class="stat-card">
            <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Currency</div>
            <select class="filter-select" id="settingsCurrency" style="width:100%; margin-bottom:12px; border: 1px solid var(--color-border); border-radius: 8px;" onchange="showToast('Currency updated to ' + this.options[this.selectedIndex].text, 'success')">
                <option value="USD">USD — US Dollar ($)</option>
                <option value="EUR">EUR — Euro (€)</option>
                <option value="GBP">GBP — British Pound (£)</option>
                <option value="INR">INR — Indian Rupee (₹)</option>
                <option value="AUD">AUD — Australian Dollar (A$)</option>
            </select>
            <p style="font-size:0.8rem; color:var(--text-muted);">Sets the default currency displayed across the platform.</p>
        </div>

        <div class="stat-card">
            <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Language</div>
            <select class="filter-select" id="settingsLanguage" style="width:100%; margin-bottom:12px; border: 1px solid var(--color-border); border-radius: 8px;" onchange="showToast('Language set to ' + this.options[this.selectedIndex].text, 'success')">
                <option value="en">English</option>
                <option value="es">Español</option>
                <option value="fr">Français</option>
                <option value="de">Deutsch</option>
                <option value="hi">Hindi</option>
                <option value="ja">日本語</option>
            </select>
            <p style="font-size:0.8rem; color:var(--text-muted);">Language preference for the admin interface.</p>
        </div>

        <div class="stat-card">
            <div style="font-weight: 600; margin-bottom: 20px; font-size: 0.95rem;">Data Management</div>
            <button class="btn btn-outline" style="width:100%; margin-bottom: 12px; border-color:#ef4444; color:#ef4444;" onclick="advancedConfirm('Reset ALL admin data to factory defaults? This cannot be undone.', resetAllData)">Reset All Data</button>
            <p style="font-size:0.8rem; color:var(--text-muted);">Clears all localStorage data and restores initial mock data.</p>
        </div>

    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/settings.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof initSettings === 'function') initSettings();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
