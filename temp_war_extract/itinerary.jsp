<%@ include file="components/header.jsp" %>

<main class="container" style="padding-top: 100px; min-height: calc(100vh - 80px); padding-bottom: 40px;">
    
    <div class="mb-5 text-center slide-up">
        <h1 class="text-primary mb-1">Your Rajasthan Adventure</h1>
        <p class="text-muted text-sm">5 Days • Culture & Heritage • Budget: ₹50,000</p>
    </div>

    <div class="grid grid-cols-3 gap-4">
        
        <!-- Timeline Section (Left 2 columns) -->
        <div class="timeline col-span-2" style="grid-column: span 2;">
            
            <!-- Day 1 -->
            <div class="timeline-item slide-up delay-1">
                <div class="timeline-dot"></div>
                <div class="card timeline-card" style="margin-right: 20px;">
                    <div class="timeline-header flex justify-between items-center mb-2">
                        <div>
                            <h3 class="text-main mb-1" style="font-size: 1.25rem;">Day 1: Arrival in Jaipur</h3>
                            <p class="text-muted text-sm" style="margin:0;">The Pink City Welcome</p>
                        </div>
                        <svg class="expand-icon text-muted" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </div>
                    
                    <div class="timeline-body mt-3 pt-3" style="border-top: 1px solid rgba(0,0,0,0.05);">
                        <ul style="display:flex; flex-direction:column; gap: 16px;">
                            <li class="flex gap-3 items-start">
                                <div class="text-primary mt-1"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg></div>
                                <div>
                                    <div class="font-semibold text-sm">Morning: Check-in at Heritage Hotel</div>
                                    <div class="text-muted" style="font-size: 0.85rem;">Relax and enjoy traditional Rajasthani welcome.</div>
                                </div>
                            </li>
                            <li class="flex gap-3 items-start">
                                <div class="text-accent mt-1"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg></div>
                                <div>
                                    <div class="font-semibold text-sm">Afternoon: Amer Fort Visit</div>
                                    <div class="text-muted" style="font-size: 0.85rem;">Explore the majestic fort architecture.</div>
                                </div>
                            </li>
                            <li class="flex gap-3 items-start">
                                <div class="text-secondary mt-1"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path><line x1="6" y1="1" x2="6" y2="4"></line><line x1="10" y1="1" x2="10" y2="4"></line><line x1="14" y1="1" x2="14" y2="4"></line></svg></div>
                                <div>
                                    <div class="font-semibold text-sm">Evening: Dinner at Chokhi Dhani</div>
                                    <div class="text-muted" style="font-size: 0.85rem;">Authentic food and local folk dances.</div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Day 2 -->
            <div class="timeline-item slide-up delay-2">
                <div class="timeline-dot"></div>
                <div class="card timeline-card" style="margin-right: 20px;">
                    <div class="timeline-header flex justify-between items-center mb-2">
                        <div>
                            <h3 class="text-main mb-1" style="font-size: 1.25rem;">Day 2: Jaipur City Tour</h3>
                            <p class="text-muted text-sm" style="margin:0;">Palaces and Bazaars</p>
                        </div>
                        <svg class="expand-icon text-muted" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="transform: rotate(180deg);"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </div>
                    
                    <div class="timeline-body mt-3 pt-3 hidden" style="border-top: 1px solid rgba(0,0,0,0.05);">
                        <ul style="display:flex; flex-direction:column; gap: 16px;">
                            <li class="flex gap-3 items-start">
                                <div class="text-accent mt-1"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg></div>
                                <div>
                                    <div class="font-semibold text-sm">Morning: Hawa Mahal & City Palace</div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4 slide-up delay-3 w-full" style="max-width: 90%;">
                <button class="btn btn-outline w-full text-center">Load More Days</button>
            </div>

        </div>

        <!-- Budget Breakdown (Right column) -->
        <div class="slide-up delay-2">
            <div class="glass-panel" style="padding: 24px; position: sticky; top: 100px;">
                <h3 class="mb-4 text-main text-center" style="font-size: 1.25rem;">Budget Breakdown</h3>
                
                <!-- Donut Chart Visualization -->
                <div class="flex justify-center mb-6 mt-2 relative">
                    <div style="
                        width: 140px; 
                        height: 140px; 
                        border-radius: 50%; 
                        background: conic-gradient(
                            #4f46e5 0% 33%, 
                            #06b6d4 33% 51%, 
                            #10b981 51% 73%, 
                            #f59e0b 73% 100%
                        );
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                        animation: fadeUp 1s cubic-bezier(0.4, 0, 0.2, 1);
                    ">
                        <!-- Inner circle for donut hole -->
                        <div style="
                            width: 110px; 
                            height: 110px; 
                            background: var(--bg-base); 
                            border-radius: 50%;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            justify-content: center;
                            box-shadow: inset 0 2px 10px rgba(0,0,0,0.05);
                        ">
                            <span class="text-[0.65rem] text-muted uppercase font-bold tracking-widest mt-1">Total</span>
                            <span class="font-bold text-main" style="font-size: 1.25rem;">₹45K</span>
                        </div>
                    </div>
                </div>

                <!-- Legend / Breakdown List -->
                <div class="flex justify-between items-center mb-3 pb-3" style="border-bottom: 1px dashed rgba(0,0,0,0.1);">
                    <span class="text-muted text-sm flex gap-3 items-center">
                        <div style="width: 10px; height: 10px; border-radius: 50%; background: #4f46e5;"></div>
                        Accommodation
                    </span>
                    <span class="font-bold" style="color: #4f46e5;">₹15,000</span>
                </div>
                
                <div class="flex justify-between items-center mb-3 pb-3" style="border-bottom: 1px dashed rgba(0,0,0,0.1);">
                    <span class="text-muted text-sm flex gap-3 items-center">
                        <div style="width: 10px; height: 10px; border-radius: 50%; background: #06b6d4;"></div>
                        Activities
                    </span>
                    <span class="font-bold" style="color: #06b6d4;">₹8,000</span>
                </div>
                
                <div class="flex justify-between items-center mb-3 pb-3" style="border-bottom: 1px dashed rgba(0,0,0,0.1);">
                    <span class="text-muted text-sm flex gap-3 items-center">
                        <div style="width: 10px; height: 10px; border-radius: 50%; background: #10b981;"></div>
                        Transport
                    </span>
                    <span class="font-bold" style="color: #10b981;">₹10,000</span>
                </div>
                
                <div class="flex justify-between items-center mb-5 pb-3" style="border-bottom: 1px dashed rgba(0,0,0,0.1);">
                    <span class="text-muted text-sm flex gap-3 items-center">
                        <div style="width: 10px; height: 10px; border-radius: 50%; background: #f59e0b;"></div>
                        Food
                    </span>
                    <span class="font-bold" style="color: #f59e0b;">₹12,000</span>
                </div>
                
                <a href="booking.jsp" class="btn btn-primary w-full" style="justify-content: center; box-shadow: 0 4px 15px rgba(79,70,229,0.25);"
                   onclick="event.preventDefault(); VoyastraAuth.requireAuth('booking.jsp');">Confirm Booking</a>
            </div>
        </div>

    </div>
</main>

<%@ include file="components/footer.jsp" %>
