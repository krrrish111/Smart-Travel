<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="components/header.jsp" %>

<%@ include file="components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">
    <!-- Community Hero -->
    <section class="container text-center mb-8 relative z-10">
        <h1 class="editorial text-white mb-2" style="font-size: 3.5rem; text-shadow: 0 4px 12px rgba(0,0,0,0.4);">Traveler Community</h1>
        <p class="text-white opacity-80" style="font-size: 1.2rem; max-width: 600px; margin: 0 auto;">Discover hidden gems, read authentic reviews, and share your own unforgettable experiences with locals and globetrotters alike.</p>
    </section>

    <div class="container relative z-10" style="max-width: 800px; margin: 0 auto;">
        
        <!-- Share Experience Box (Create Post) -->
        <div class="glass-panel" style="border-radius: 16px; padding: 24px; box-shadow: var(--shadow-md); margin-bottom: 40px; background: var(--color-surface); backdrop-filter: blur(14px);">
            <div class="flex items-start gap-4">
                <img src="https://ui-avatars.com/api/?name=You&background=0D8ABC&color=fff" alt="User Profile" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;">
                <div class="flex-1">
                    <textarea class="w-full bg-transparent outline-none resize-none text-main placeholder-muted mb-3" rows="3" placeholder="Share a travel story, review a spot, or ask for local tips..." style="font-family: 'DM Sans', sans-serif; font-size: 1.1rem; border: none;"></textarea>
                    
                    <!-- Rating Input Mockup -->
                    <div class="flex items-center gap-2 mb-4">
                        <span class="text-sm font-semibold text-muted">Rate your trip:</span>
                        <div class="flex text-muted cursor-pointer">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        </div>
                    </div>

                    <div class="flex items-center justify-between border-t border-border pt-3">
                        <div class="flex gap-4">
                            <button class="flex items-center gap-2 text-primary font-semibold hover:opacity-80 transition-opacity">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg> Photos Let
                            </button>
                            <button class="flex items-center gap-2 text-primary font-semibold hover:opacity-80 transition-opacity">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg> Tag Location
                            </button>
                        </div>
                        <button class="btn btn-primary" style="padding: 8px 24px; border-radius: 20px;">Post</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Social Feed Divider -->
        <h3 class="editorial text-main mb-6" style="font-size: 2rem; border-bottom: 2px solid var(--color-border); padding-bottom: 12px;">Recent Reviews & Stories</h3>

        <!-- Feed Component: Post 1 -->
        <div class="social-card glass-panel mb-8" style="border-radius: 16px; padding: 24px; box-shadow: var(--shadow-sm); background: var(--color-surface); backdrop-filter: blur(14px);">
            <!-- Header -->
            <div class="flex justify-between items-start mb-4">
                <div class="flex items-center gap-4">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Sarah J." style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;">
                    <div>
                        <h4 class="font-bold text-main" style="font-size: 1.1rem;">Sarah Jenkins</h4>
                        <p class="text-sm text-muted flex items-center gap-1">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="var(--color-accent)" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            Visited Munnar, Kerala
                        </p>
                    </div>
                </div>
                <div class="text-right">
                    <div class="flex text-accent" style="fill: var(--color-accent);">
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    </div>
                    <span class="text-xs text-muted">2 days ago</span>
                </div>
            </div>
            <!-- Content -->
            <p class="text-main mb-4 line-height-relaxed">
                Absolutely breathless views at the tea estates! We booked the "Serene Retreat" plan and our local guide, Rajesh, was phenomenal. The sunrise over the misty hills is something I will never forget. Highly recommend the local cardamom tea! ☕🌿 
            </p>
            <!-- Gallery Grid -->
            <div class="grid grid-cols-2 md:grid-cols-3 gap-2 mb-4">
                <img src="https://images.unsplash.com/photo-1593693397690-362cb9666fc2?auto=format&fit=crop&w=400&h=300&q=80" alt="Munnar 1" style="border-radius: 8px; width: 100%; height: 140px; object-fit: cover; cursor: pointer;" class="hover:opacity-90 transition-opacity">
                <img src="https://images.unsplash.com/photo-1583094936329-8473de444bb4?auto=format&fit=crop&w=400&h=300&q=80" alt="Munnar 2" style="border-radius: 8px; width: 100%; height: 140px; object-fit: cover; cursor: pointer;" class="hover:opacity-90 transition-opacity">
            </div>
            <!-- Actions -->
            <div class="flex gap-6 border-t border-border pt-4 mt-2">
                <button class="flex items-center gap-2 text-muted hover:text-primary transition-colors font-semibold tooltip-trigger">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"></path></svg> 
                    Helpful (124)
                </button>
                <button class="flex items-center gap-2 text-muted hover:text-primary transition-colors font-semibold">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg> 
                    Discuss (14)
                </button>
            </div>
        </div>

        <!-- Feed Component: Post 2 -->
        <div class="social-card glass-panel mb-8" style="border-radius: 16px; padding: 24px; box-shadow: var(--shadow-sm); background: var(--color-surface); backdrop-filter: blur(14px);">
            <!-- Header -->
            <div class="flex justify-between items-start mb-4">
                <div class="flex items-center gap-4">
                    <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=100&q=80" alt="Arjun M." style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;">
                    <div>
                        <h4 class="font-bold text-main" style="font-size: 1.1rem;">Arjun Mehta</h4>
                        <p class="text-sm text-muted flex items-center gap-1">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="var(--color-accent)" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            Visited Rishikesh
                        </p>
                    </div>
                </div>
                <div class="text-right">
                    <div class="flex text-accent" style="fill: var(--color-accent);">
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <svg width="16" height="16" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"></path></svg>
                    </div>
                    <span class="text-xs text-muted">1 week ago</span>
                </div>
            </div>
            <!-- Content -->
            <p class="text-main mb-4 line-height-relaxed">
                The river rafting was intense! We met some amazing backpackers at the hostel and ended up doing the longest route. The Ganga Aarti at sundown was a spiritual anchor to a wildly adventurous day. 
            </p>
            <!-- Gallery Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-2 mb-4">
                <img src="https://images.unsplash.com/photo-1628126235206-5260b9ea6441?auto=format&fit=crop&w=400&h=200&q=80" alt="Rishikesh 1" style="border-radius: 8px; width: 100%; height: 200px; object-fit: cover; cursor: pointer;" class="hover:opacity-90 transition-opacity">
            </div>
            <!-- Actions -->
            <div class="flex gap-6 border-t border-border pt-4 mt-2">
                <button class="flex items-center gap-2 text-muted hover:text-primary transition-colors font-semibold tooltip-trigger">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"></path></svg> 
                    Helpful (89)
                </button>
                <button class="flex items-center gap-2 text-muted hover:text-primary transition-colors font-semibold">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg> 
                    Discuss (5)
                </button>
            </div>
        </div>

    </div>
</main>


</body>
</html>
