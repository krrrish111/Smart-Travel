<%@ include file="components/header.jsp" %>

<%@ include file="components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">
    

    <div class="container relative z-10" style="margin-top: -10px;">
    
        <div class="flex justify-between items-center mb-5 slide-up" style="flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 class="text-white mb-1" style="font-size: 2.25rem; text-shadow: 0 2px 4px rgba(0,0,0,0.5);">Welcome back, Raj!</h1>
                <p class="text-white opacity-80" style="font-size: 1.1rem;">You have 1 upcoming trip & 3 saved itineraries.</p>
            </div>
            <button class="btn btn-outline" style="padding: 10px 20px; background: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.5); color: white;">Edit Profile</button>
        </div>

    <div class="grid grid-cols-3 gap-4">
        
        <!-- Main Content (Left 2 columns) -->
        <div class="col-span-2 slide-up delay-1" style="grid-column: span 2;">
            <h3 class="mb-3 text-main">Upcoming Trip</h3>
            
            <div class="glass-panel p-4 mb-5" style="padding: 24px;">
                <div class="flex justify-between items-start mb-3" style="flex-wrap: wrap; gap: 8px;">
                    <div>
                        <h4 class="text-main" style="font-size: 1.25rem; margin-bottom: 4px;">Rajasthan Royal Route</h4>
                        <p class="text-muted text-sm">Date: Oct 15 - Oct 20, 2026</p>
                    </div>
                    <span class="chip" style="background: rgba(6, 182, 212, 0.1); color: var(--secondary); margin:0;">Booked ✅</span>
                </div>
                
                <div class="progress-container mb-4" style="height: 6px;">
                    <div class="progress-bar" style="width: 100%; background: var(--secondary);"></div>
                </div>
                
                <div class="flex gap-2">
                    <a href="itinerary.jsp" class="btn btn-primary" style="padding: 8px 16px; font-size: 0.9rem;">View Itinerary</a>
                    <button class="btn btn-outline" style="padding: 8px 16px; font-size: 0.9rem;">Download Tickets</button>
                </div>
            </div>

            <h3 class="mb-3 text-main">Saved Drafts</h3>
            
            <div class="grid grid-cols-2 gap-3">
                <div class="card">
                    <h4 class="text-main mb-1" style="font-size: 1.1rem;">Kerala Backwaters</h4>
                    <p class="text-muted text-sm mb-3">Generated 2 days ago</p>
                    <div class="progress-container mb-2" style="height: 4px;">
                        <div class="progress-bar" style="width: 60%;"></div>
                    </div>
                    <p class="text-muted mb-3" style="font-size: 0.75rem;">Booking 60% complete</p>
                    <button class="btn btn-outline w-full" style="padding: 6px;">Resume</button>
                </div>

                <div class="card">
                    <h4 class="text-main mb-1" style="font-size: 1.1rem;">Meghalaya Monsoons</h4>
                    <p class="text-muted text-sm mb-3">Generated last week</p>
                    <div class="progress-container mb-2" style="height: 4px;">
                        <div class="progress-bar" style="width: 10%;"></div>
                    </div>
                    <p class="text-muted mb-3" style="font-size: 0.75rem;">Booking 10% complete</p>
                    <button class="btn btn-outline w-full" style="padding: 6px;">Resume</button>
                </div>
            </div>

        </div>

        <!-- Sidebar (Right column) -->
        <div class="slide-up delay-2">
            
            <div class="glass-panel mb-4" style="padding: 24px;">
                <h3 class="mb-3 text-main" style="font-size: 1.1rem;">Quick Stats</h3>
                
                <div class="flex justify-between mb-2">
                    <span class="text-muted">Total Trips</span>
                    <span class="font-bold">5</span>
                </div>
                <div class="flex justify-between mb-2">
                    <span class="text-muted">States Explored</span>
                    <span class="font-bold">8</span>
                </div>
                <div class="flex justify-between mb-2">
                    <span class="text-muted">AI Queries</span>
                    <span class="font-bold">24</span>
                </div>
            </div>

            <div class="glass-panel" style="padding: 24px; text-align: center;">
                <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(245, 158, 11, 0.1); color: var(--accent); display:flex; align-items:center; justify-content:center; margin: 0 auto 12px;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 16 16 12 12 8"></polyline><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                </div>
                <h3 class="mb-1 text-main" style="font-size: 1.1rem;">Travel Pro</h3>
                <p class="text-muted text-sm mb-3">Unlock unlimited AI planning and exclusive hotel deals.</p>
                <button class="btn btn-primary w-full" style="background: var(--accent); box-shadow: 0 0 15px rgba(245, 158, 11, 0.4); border-color: transparent;">Upgrade Now</button>
            </div>

        </div>

    </div>
    </div>
</main>

<%@ include file="components/footer.jsp" %>
