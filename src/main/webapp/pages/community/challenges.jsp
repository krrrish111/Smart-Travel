<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/challenges.css">

<div class="ch-page">
    
    <!-- ══════════════════════════════════════════════════════
         HERO DASHBOARD
    ══════════════════════════════════════════════════════════ -->
    <div class="ch-hero">
        <div class="ch-container">
            <div class="ch-header">
                <a href="${pageContext.request.contextPath}/community" class="ch-back-btn">
                    <i class="ri-arrow-left-line"></i> Back
                </a>
                <h1 class="ch-title">Creator Challenges</h1>
                <p class="ch-subtitle">Complete quests, earn Voyastra Miles, and climb the global leaderboard.</p>
            </div>

            <!-- User Stats Card -->
            <div class="ch-user-card">
                <div class="ch-user-profile">
                    <div class="ch-avatar-wrap">
                        <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80" alt="My Avatar">
                        <div class="ch-rank-badge">#42</div>
                    </div>
                    <div class="ch-user-info">
                        <h2>Traveler Name</h2>
                        <span class="ch-level"><i class="ri-vip-crown-fill"></i> Level 12 Explorer</span>
                    </div>
                </div>
                
                <div class="ch-user-stats">
                    <div class="ch-stat">
                        <span class="ch-stat-label">Total XP</span>
                        <span class="ch-stat-value">12,450 <span class="ch-xp">XP</span></span>
                    </div>
                    <div class="ch-stat">
                        <span class="ch-stat-label">Voyastra Miles</span>
                        <span class="ch-stat-value">8,200 <i class="ri-plane-fill"></i></span>
                    </div>
                    <div class="ch-stat">
                        <span class="ch-stat-label">Badges</span>
                        <span class="ch-stat-value">14 <i class="ri-medal-fill"></i></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="ch-container ch-main-layout">
        
        <!-- ══════════════════════════════════════════════════════
             ACTIVE QUESTS (LEFT COLUMN)
        ══════════════════════════════════════════════════════════ -->
        <div class="ch-quests">
            <h3 class="ch-section-title"><i class="ri-sword-fill"></i> Active Quests</h3>

            <!-- Quest 1 -->
            <div class="ch-quest-card in-progress">
                <div class="ch-qc-icon"><i class="ri-gem-fill"></i></div>
                <div class="ch-qc-body">
                    <div class="ch-qc-header">
                        <h4>Hidden Gem Hunter</h4>
                        <span class="ch-qc-reward">+500 XP | 100 Miles</span>
                    </div>
                    <p class="ch-qc-desc">Visit and review 3 Hidden Gems in the community network.</p>
                    <div class="ch-progress-wrap">
                        <div class="ch-progress-text"><span>1 / 3 Completed</span> <span>33%</span></div>
                        <div class="ch-progress-bar"><div class="ch-progress-fill" style="width: 33%"></div></div>
                    </div>
                </div>
            </div>

            <!-- Quest 2 -->
            <div class="ch-quest-card claimable">
                <div class="ch-qc-icon"><i class="ri-restaurant-fill"></i></div>
                <div class="ch-qc-body">
                    <div class="ch-qc-header">
                        <h4>Local Foodie</h4>
                        <span class="ch-qc-reward">+800 XP | "Foodie" Badge</span>
                    </div>
                    <p class="ch-qc-desc">Try and post 10 local dishes in the Food Discovery network.</p>
                    <div class="ch-progress-wrap">
                        <div class="ch-progress-text"><span>10 / 10 Completed</span> <span>100%</span></div>
                        <div class="ch-progress-bar"><div class="ch-progress-fill" style="width: 100%"></div></div>
                    </div>
                    <button class="ch-btn-claim" onclick="VoyastraToast.show('Reward Claimed! +800 XP', 'success')"><i class="ri-gift-fill"></i> Claim Reward</button>
                </div>
            </div>

            <!-- Quest 3 -->
            <div class="ch-quest-card available">
                <div class="ch-qc-icon"><i class="ri-camera-lens-fill"></i></div>
                <div class="ch-qc-body">
                    <div class="ch-qc-header">
                        <h4>Shutterbug Weekend</h4>
                        <span class="ch-qc-reward">+1200 XP | Gold Frame</span>
                    </div>
                    <p class="ch-qc-desc">Upload 20 travel photos this weekend from any destination.</p>
                    <button class="ch-btn-join" onclick="this.innerHTML='<i class=\'ri-check-line\'></i> Joined'; this.classList.add('joined'); VoyastraToast.show('Quest started!', 'success')">Join Quest</button>
                </div>
            </div>

            <!-- Quest 4 -->
            <div class="ch-quest-card available">
                <div class="ch-qc-icon"><i class="ri-calendar-event-fill"></i></div>
                <div class="ch-qc-body">
                    <div class="ch-qc-header">
                        <h4>Weekend Warrior</h4>
                        <span class="ch-qc-reward">+2000 XP | 500 Miles</span>
                    </div>
                    <p class="ch-qc-desc">Book and complete 2 weekend trips using community guides.</p>
                    <button class="ch-btn-join" onclick="this.innerHTML='<i class=\'ri-check-line\'></i> Joined'; this.classList.add('joined'); VoyastraToast.show('Quest started!', 'success')">Join Quest</button>
                </div>
            </div>

        </div>

        <!-- ══════════════════════════════════════════════════════
             LEADERBOARD (RIGHT COLUMN)
        ══════════════════════════════════════════════════════════ -->
        <div class="ch-leaderboard-section">
            <div class="ch-lb-header">
                <h3 class="ch-section-title"><i class="ri-bar-chart-grouped-fill"></i> Global Leaderboard</h3>
                <div class="ch-lb-tabs">
                    <button class="ch-lb-tab active">Weekly</button>
                    <button class="ch-lb-tab">Monthly</button>
                    <button class="ch-lb-tab">All Time</button>
                </div>
            </div>

            <div class="ch-lb-list">
                
                <!-- Rank 1 -->
                <div class="ch-lb-item rank-1">
                    <div class="ch-lb-rank">1</div>
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Sarah">
                    <div class="ch-lb-info">
                        <span class="ch-lb-name">Sarah Jenkins <i class="ri-verified-badge-fill" style="color:var(--color-primary)"></i></span>
                        <span class="ch-lb-handle">@sarahexplores</span>
                    </div>
                    <div class="ch-lb-score">45,200 <span>XP</span></div>
                </div>

                <!-- Rank 2 -->
                <div class="ch-lb-item rank-2">
                    <div class="ch-lb-rank">2</div>
                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80" alt="Dev">
                    <div class="ch-lb-info">
                        <span class="ch-lb-name">Dev Patel</span>
                        <span class="ch-lb-handle">@devonbudget</span>
                    </div>
                    <div class="ch-lb-score">42,850 <span>XP</span></div>
                </div>

                <!-- Rank 3 -->
                <div class="ch-lb-item rank-3">
                    <div class="ch-lb-rank">3</div>
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80" alt="Priya">
                    <div class="ch-lb-info">
                        <span class="ch-lb-name">Priya Kapoor</span>
                        <span class="ch-lb-handle">@priyaeats</span>
                    </div>
                    <div class="ch-lb-score">39,100 <span>XP</span></div>
                </div>

                <!-- Rank 4 -->
                <div class="ch-lb-item">
                    <div class="ch-lb-rank">4</div>
                    <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=100&q=80" alt="Nisha">
                    <div class="ch-lb-info">
                        <span class="ch-lb-name">Nisha Tiwari</span>
                        <span class="ch-lb-handle">@nishaluxe</span>
                    </div>
                    <div class="ch-lb-score">35,400 <span>XP</span></div>
                </div>

                <!-- Rank 5 -->
                <div class="ch-lb-item">
                    <div class="ch-lb-rank">5</div>
                    <img src="https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&w=100&q=80" alt="Alex">
                    <div class="ch-lb-info">
                        <span class="ch-lb-name">Alex M.</span>
                        <span class="ch-lb-handle">@alexwander</span>
                    </div>
                    <div class="ch-lb-score">31,200 <span>XP</span></div>
                </div>

                <!-- Current User Rank Indicator -->
                <div class="ch-lb-divider">
                    <i class="ri-more-2-line"></i>
                </div>

                <div class="ch-lb-item my-rank">
                    <div class="ch-lb-rank">42</div>
                    <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=100&q=80" alt="Me">
                    <div class="ch-lb-info">
                        <span class="ch-lb-name">Traveler Name (You)</span>
                        <span class="ch-lb-handle">@traveler</span>
                    </div>
                    <div class="ch-lb-score">12,450 <span>XP</span></div>
                </div>

            </div>
        </div>

    </div>
</div>

<script>
    // Tab Switching Logic
    document.querySelectorAll('.ch-lb-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.ch-lb-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            VoyastraToast.show('Loading leaderboard...', 'info');
        });
    });
</script>

<%@ include file="/components/footer.jsp" %>
