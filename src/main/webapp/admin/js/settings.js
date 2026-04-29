/* =========================================================
   SETTINGS PANEL
========================================================= */
function applySettingsTheme(isDark) {
    const slider = document.getElementById('themeSlider');
    if (isDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        if (slider) slider.style.background = '#4f46e5';
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        if (slider) slider.style.background = '#ccc';
    }
    localStorage.setItem('voyastra_admin_theme', isDark ? 'dark' : 'light');
    if (typeof showToast === 'function') showToast('Theme switched to ' + (isDark ? 'Dark' : 'Light') + ' mode.', 'success');
}

function initSettings() {
    const saved = localStorage.getItem('voyastra_admin_theme');
    const isDark = saved === 'dark';
    const cb = document.getElementById('settingsTheme');
    if (cb) cb.checked = isDark;
    const slider = document.getElementById('themeSlider');
    if (slider) slider.style.background = isDark ? '#4f46e5' : '#ccc';
}

function resetAllData() {
    localStorage.removeItem('voyastra_admin_plans');
    localStorage.removeItem('voyastra_admin_dests');
    localStorage.removeItem('voyastra_admin_reviews');
    localStorage.removeItem('voyastra_admin_content');
    
    if (typeof loadPlans === 'function') loadPlans();
    if (typeof loadDests === 'function') loadDests();
    if (typeof loadReviews === 'function') loadReviews();
    if (typeof loadContent === 'function') loadContent();
    if (typeof loadAnalytics === 'function') loadAnalytics();
    
    if (typeof showToast === 'function') showToast('All data reset to factory defaults.', 'warning');
}
