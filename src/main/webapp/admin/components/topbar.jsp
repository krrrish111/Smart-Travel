<div class="admin-topbar">
            <!-- Mobile Menu Toggle Button -->
            <button class="mobile-menu-toggle" onclick="toggleAdminSidebar()" style="display:none; align-items:center; justify-content:center; background:var(--surface-light); border:1px solid var(--color-border); color:var(--text-main); border-radius:8px; cursor:pointer; width:40px; height:40px; transition:0.2s;" aria-label="Open Mobile Menu">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            <div class="admin-topbar-search">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="text" id="globalAdminSearch" placeholder="Quick search..." autocomplete="off">
                <div class="search-results-dropdown" id="globalSearchResults"></div>
            </div>
            <div class="admin-profile">
                <button class="theme-toggle" onclick="document.getElementById('themeToggle').click()" 
                        style="background:var(--surface-light); border:1px solid var(--color-border); color:var(--text-muted); cursor:pointer; margin-right:8px; width:40px; height:40px; border-radius:50%; display:flex; align-items:center; justify-content:center; transition:0.2s;"
                        onmouseover="this.style.background='rgba(79,70,229,0.1)';this.style.color='var(--color-primary)';"
                        onmouseout="this.style.background='var(--surface-light)';this.style.color='var(--text-muted)';">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>
                </button>
                <div style="text-align:right;">
                    <div style="font-weight:600; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">Systems Admin</div>
                    <div style="font-size:0.75rem; color:var(--text-muted);">Master Access</div>
                </div>
                <div class="admin-avatar" style="box-shadow: 0 4px 12px rgba(79,70,229,0.2);">SA</div>
            </div>
        </div>
