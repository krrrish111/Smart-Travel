/* =========================================================
   SETTINGS PANEL (AJAX)
========================================================= */

async function applySettingsTheme(isDark) {
    const slider = document.getElementById('themeSlider');
    const theme = isDark ? 'dark' : 'light';
    
    if (isDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
        if (slider) slider.style.background = '#4f46e5';
    } else {
        document.documentElement.setAttribute('data-theme', 'light');
        if (slider) slider.style.background = '#ccc';
    }
    
    await saveSetting('theme', theme);
    if (typeof showToast === 'function') showToast('Theme switched to ' + (isDark ? 'Dark' : 'Light') + ' mode.', 'success');
}

async function applyCurrency(currency) {
    await saveSetting('currency', currency);
    if (typeof showToast === 'function') showToast('Currency updated to ' + currency, 'success');
}

async function applyLanguage(language) {
    await saveSetting('language', language);
    if (typeof showToast === 'function') showToast('Language set to ' + language, 'success');
}

async function saveSetting(key, value) {
    const body = new URLSearchParams();
    body.append('action', 'updateSetting');
    body.append('key', key);
    body.append('value', value);

    try {
        await fetch(CONTEXT_PATH + '/admin/settings-api', { method: 'POST', body });
    } catch (err) {
        console.error('Save setting error:', err);
    }
}

async function initSettings() {
    try {
        const response = await fetch(CONTEXT_PATH + '/admin/settings-api');
        if (!response.ok) throw new Error('Failed to load settings');
        const settings = await response.json();
        
        const isDark = settings['theme'] === 'dark';
        const cb = document.getElementById('settingsTheme');
        if (cb) cb.checked = isDark;
        const slider = document.getElementById('themeSlider');
        if (slider) slider.style.background = isDark ? '#4f46e5' : '#ccc';
        
        if (isDark) document.documentElement.setAttribute('data-theme', 'dark');
        else document.documentElement.setAttribute('data-theme', 'light');

        const currencySelect = document.getElementById('settingsCurrency');
        if (currencySelect && settings['currency']) currencySelect.value = settings['currency'];

        const languageSelect = document.getElementById('settingsLanguage');
        if (languageSelect && settings['language']) languageSelect.value = settings['language'];
        
    } catch (err) {
        console.error('Settings load error:', err);
    }
}

async function resetAllData() {
    const body = new URLSearchParams();
    body.append('action', 'resetAll');

    try {
        const response = await fetch(CONTEXT_PATH + '/admin/settings-api', { method: 'POST', body });
        const res = await response.json();
        if (res.status === 'success') {
            if (typeof showToast === 'function') showToast('All settings reset to defaults.', 'warning');
            initSettings();
        } else {
            if (typeof showToast === 'function') showToast('Failed to reset settings.', 'error');
        }
    } catch (err) {
        console.error('Reset error:', err);
    }
}
