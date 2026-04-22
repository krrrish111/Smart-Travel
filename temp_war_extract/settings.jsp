<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="components/header.jsp" %>
<%@ include file="components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden; min-height: 80vh;">
    <div class="container relative z-10 slide-up" style="max-width: 600px; margin: 0 auto; margin-top: 20px;">
        
        <h1 class="text-white mb-4" style="font-size: 2rem; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">Settings</h1>
        
        <div class="glass-panel p-5" style="padding: 30px;">
            
            <form id="settingsForm">
                
                <!-- Theme Settings -->
                <div class="settings-group mb-5">
                    <h3 class="text-main mb-2" style="font-size: 1.1rem; border-bottom: 1px solid var(--color-border); padding-bottom: 10px;">Appearance</h3>
                    
                    <div class="flex justify-between items-center" style="margin-top: 15px;">
                        <div>
                            <p class="text-main m-0" style="font-weight: 500;">Dark Mode</p>
                            <p class="text-muted text-sm m-0">Toggle between light and dark themes</p>
                        </div>
                        <label class="theme-toggle-switch">
                            <input type="checkbox" id="settingsThemeToggle">
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>

                <!-- Preferences Settings -->
                <div class="settings-group mb-5">
                    <h3 class="text-main mb-2" style="font-size: 1.1rem; border-bottom: 1px solid var(--color-border); padding-bottom: 10px;">Preferences</h3>
                    
                    <div class="form-group mb-4" style="margin-top: 15px;">
                        <label class="text-main" style="display:block; margin-bottom: 8px; font-weight: 500;">Currency</label>
                        <select id="settingsCurrency" class="settings-select w-full" style="padding: 12px; border-radius: 8px; background: rgba(0,0,0,0.2); border: 1px solid var(--color-border); color: var(--text-main); outline: none;">
                            <option value="INR" style="background: var(--bg-main);">₹ INR - Indian Rupee</option>
                            <option value="USD" style="background: var(--bg-main);">$ USD - US Dollar</option>
                            <option value="EUR" style="background: var(--bg-main);">€ EUR - Euro</option>
                            <option value="GBP" style="background: var(--bg-main);">£ GBP - British Pound</option>
                        </select>
                    </div>
                    
                    <div class="form-group mb-4">
                        <label class="text-main" style="display:block; margin-bottom: 8px; font-weight: 500;">Language</label>
                        <select id="settingsLanguage" class="settings-select w-full" style="padding: 12px; border-radius: 8px; background: rgba(0,0,0,0.2); border: 1px solid var(--color-border); color: var(--text-main); outline: none;">
                            <option value="en" style="background: var(--bg-main);">English</option>
                            <option value="hi" style="background: var(--bg-main);">Hindi</option>
                            <option value="es" style="background: var(--bg-main);">Spanish</option>
                            <option value="fr" style="background: var(--bg-main);">French</option>
                        </select>
                    </div>
                </div>

                <!-- Save Button -->
                <div class="flex justify-end mt-4 pt-4" style="border-top: 1px solid var(--color-border);">
                    <button type="submit" class="btn btn-primary" style="padding: 10px 24px;">Save Changes</button>
                </div>
            </form>

        </div>
    </div>
</main>

<!-- Page Specific Logic -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    
    // Elements
    const form = document.getElementById('settingsForm');
    const themeToggle = document.getElementById('settingsThemeToggle');
    const currencySelect = document.getElementById('settingsCurrency');
    const languageSelect = document.getElementById('settingsLanguage');
    
    // Initialize form values from localStorage
    const currentTheme = localStorage.getItem('theme') || 'dark';
    themeToggle.checked = (currentTheme === 'dark');
    
    const currentCurrency = localStorage.getItem('currency') || 'INR';
    currencySelect.value = currentCurrency;
    
    const currentLang = localStorage.getItem('language') || 'en';
    languageSelect.value = currentLang;
    
    // Instant theme toggle visual feedback
    themeToggle.addEventListener('change', function() {
        const newTheme = this.checked ? 'dark' : 'light';
        document.documentElement.setAttribute('data-theme', newTheme);
        // Sync with header toggle if it exists
        const headerToggleInputs = document.querySelectorAll('#theme-toggle-checkbox, #mobile-theme-toggle');
        headerToggleInputs.forEach(input => {
            if(input) input.checked = !this.checked; // logic might differ depending on header definition
        });
    });

    // Form Submit (Save changes)
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Save Theme
        const theme = themeToggle.checked ? 'dark' : 'light';
        localStorage.setItem('theme', theme);
        document.documentElement.setAttribute('data-theme', theme);
        
        // Save Currency
        localStorage.setItem('currency', currencySelect.value);
        
        // Save Language
        localStorage.setItem('language', languageSelect.value);
        
        // Show success toast
        if(window.VoyastraToast) {
            VoyastraToast.show('Settings saved successfully.', 'success');
        } else {
            VoyastraToast.show("Settings saved successfully.", "success");
        }
    });

});
</script>

<%@ include file="components/footer.jsp" %>
