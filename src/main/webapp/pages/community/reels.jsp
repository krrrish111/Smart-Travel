<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/global_ui.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Voyastra Reels</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reels.css">
</head>
<body class="dark-theme">

    <!-- Header Overlay -->
    <header class="reels-header">
        <a href="${pageContext.request.contextPath}/community" class="reels-back-btn">
            <i class="ri-arrow-left-line"></i>
        </a>
        <h1 class="reels-title">Reels</h1>
        <button class="reels-create-btn" onclick="openCreateReelModal()">
            <i class="ri-camera-lens-line"></i> Create
        </button>
    </header>

    <!-- Main Feed Container -->
    <main class="reels-feed" id="reelsFeed">

        <!-- Reel 1 -->
        <div class="reel-item">
            <!-- Simulated Video using a cover image and CSS gradient -->
            <img src="https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format&fit=crop&w=720&q=80" class="reel-video-bg" alt="Video" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            <div class="reel-overlay"></div>
            
            <div class="reel-info">
                <div class="reel-user">
                    <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Avatar" class="reel-avatar" onclick="window.location.href='${pageContext.request.contextPath}/community/user/sarahexplores'" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <span class="reel-username" onclick="window.location.href='${pageContext.request.contextPath}/community/user/sarahexplores'">@sarahexplores</span>
                    <button class="reel-follow-btn" onclick="toggleFollow(this)">Follow</button>
                </div>
                <p class="reel-caption">Waking up in Ladakh feels like stepping onto another planet. 🏔️ The air is thin but the views are endless. #Ladakh #IncredibleIndia #Wanderlust</p>
                <div class="reel-audio">
                    <i class="ri-music-2-line"></i>
                    <marquee scrollamount="3">Original Audio — Sarah Jenkins • Ambient Mountains</marquee>
                </div>
            </div>

            <div class="reel-actions">
                <button class="ra-btn" onclick="toggleLike(this)">
                    <div class="ra-icon"><i class="ri-heart-line"></i></div>
                    <span class="ra-count">84.2K</span>
                </button>
                <button class="ra-btn" onclick="VoyastraToast.show('Comments coming soon!', 'info')">
                    <div class="ra-icon"><i class="ri-chat-3-line"></i></div>
                    <span class="ra-count">1,204</span>
                </button>
                <button class="ra-btn" onclick="this.querySelector('i').className='ri-bookmark-fill'; this.style.color='var(--color-primary)'; VoyastraToast.show('Reel saved!', 'success')">
                    <div class="ra-icon"><i class="ri-bookmark-line"></i></div>
                    <span class="ra-count">Save</span>
                </button>
                <button class="ra-btn" onclick="VoyastraToast.show('Link copied!', 'success')">
                    <div class="ra-icon"><i class="ri-share-forward-line"></i></div>
                    <span class="ra-count">Share</span>
                </button>
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80" alt="Audio" class="reel-audio-thumb spin" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            </div>
        </div>

        <!-- Reel 2 -->
        <div class="reel-item">
            <img src="https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=720&q=80" class="reel-video-bg" alt="Video" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            <div class="reel-overlay"></div>
            
            <div class="reel-info">
                <div class="reel-user">
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80" alt="Avatar" class="reel-avatar" onclick="window.location.href='${pageContext.request.contextPath}/community/user/priyaeats'" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <span class="reel-username" onclick="window.location.href='${pageContext.request.contextPath}/community/user/priyaeats'">@priyaeats</span>
                    <button class="reel-follow-btn" onclick="toggleFollow(this)">Follow</button>
                </div>
                <p class="reel-caption">Cruising through the backwaters of Kerala at golden hour. 🌴☀️ The silence is broken only by the sound of water. Highly recommend taking a houseboat! #Kerala #GodsOwnCountry</p>
                <div class="reel-audio">
                    <i class="ri-music-2-line"></i>
                    <marquee scrollamount="3">Trending Song — Peaceful Vibes 2026</marquee>
                </div>
            </div>

            <div class="reel-actions">
                <button class="ra-btn" onclick="toggleLike(this)">
                    <div class="ra-icon"><i class="ri-heart-line"></i></div>
                    <span class="ra-count">32.1K</span>
                </button>
                <button class="ra-btn" onclick="VoyastraToast.show('Comments coming soon!', 'info')">
                    <div class="ra-icon"><i class="ri-chat-3-line"></i></div>
                    <span class="ra-count">482</span>
                </button>
                <button class="ra-btn" onclick="this.querySelector('i').className='ri-bookmark-fill'; this.style.color='var(--color-primary)'; VoyastraToast.show('Reel saved!', 'success')">
                    <div class="ra-icon"><i class="ri-bookmark-line"></i></div>
                    <span class="ra-count">Save</span>
                </button>
                <button class="ra-btn" onclick="VoyastraToast.show('Link copied!', 'success')">
                    <div class="ra-icon"><i class="ri-share-forward-line"></i></div>
                    <span class="ra-count">Share</span>
                </button>
                <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80" alt="Audio" class="reel-audio-thumb spin" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            </div>
        </div>

        <!-- Reel 3 -->
        <div class="reel-item">
            <img src="https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format&fit=crop&w=720&q=80" class="reel-video-bg" alt="Video" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            <div class="reel-overlay"></div>
            
            <div class="reel-info">
                <div class="reel-user">
                    <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80" alt="Avatar" class="reel-avatar" onclick="window.location.href='${pageContext.request.contextPath}/community/user/devonbudget'" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
                    <span class="reel-username" onclick="window.location.href='${pageContext.request.contextPath}/community/user/devonbudget'">@devonbudget</span>
                    <button class="reel-follow-btn" onclick="toggleFollow(this)">Follow</button>
                </div>
                <p class="reel-caption">You don't need a fortune to see palaces. Here is my 3-day itinerary for Jaipur under ₹6000! 🏰🤑 #BudgetTravel #Jaipur #TravelHacks</p>
                <div class="reel-audio">
                    <i class="ri-music-2-line"></i>
                    <marquee scrollamount="3">Original Audio — Dev Patel</marquee>
                </div>
            </div>

            <div class="reel-actions">
                <button class="ra-btn" onclick="toggleLike(this)">
                    <div class="ra-icon"><i class="ri-heart-line"></i></div>
                    <span class="ra-count">112K</span>
                </button>
                <button class="ra-btn" onclick="VoyastraToast.show('Comments coming soon!', 'info')">
                    <div class="ra-icon"><i class="ri-chat-3-line"></i></div>
                    <span class="ra-count">3,492</span>
                </button>
                <button class="ra-btn" onclick="this.querySelector('i').className='ri-bookmark-fill'; this.style.color='var(--color-primary)'; VoyastraToast.show('Reel saved!', 'success')">
                    <div class="ra-icon"><i class="ri-bookmark-line"></i></div>
                    <span class="ra-count">Save</span>
                </button>
                <button class="ra-btn" onclick="VoyastraToast.show('Link copied!', 'success')">
                    <div class="ra-icon"><i class="ri-share-forward-line"></i></div>
                    <span class="ra-count">Share</span>
                </button>
                <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=100&q=80" alt="Audio" class="reel-audio-thumb spin" loading="lazy" decoding="async" referrerpolicy="no-referrer" onerror="vImgErr(this)">
            </div>
        </div>

    </main>

    <!-- ══════════════════════════════════════════════════════
         CREATE REEL MODAL
    ══════════════════════════════════════════════════════════ -->
    <div class="modal-overlay" id="createReelModal" onclick="if(event.target===this)closeCreateReelModal()">
        <div class="reel-modal">
            <div class="rm-header">
                <h3>Create a Reel</h3>
                <button class="rm-close" onclick="closeCreateReelModal()"><i class="ri-close-line"></i></button>
            </div>
            
            <div class="rm-body">
                <!-- Duration Selector -->
                <div class="rm-section">
                    <label class="rm-label">Reel Length</label>
                    <div class="rm-duration-options">
                        <button class="rm-dur-btn active" onclick="setDur(this, 15)">15s</button>
                        <button class="rm-dur-btn" onclick="setDur(this, 30)">30s</button>
                        <button class="rm-dur-btn" onclick="setDur(this, 60)">60s</button>
                    </div>
                </div>

                <!-- Connect to Memories -->
                <div class="rm-ai-box">
                    <div class="rm-ai-icon"><i class="ri-magic-line"></i></div>
                    <div class="rm-ai-text">
                        <h4>AI Smart Reel</h4>
                        <p>Generate a montage automatically from your Travel Memories.</p>
                    </div>
                    <button class="rm-btn-secondary" onclick="VoyastraToast.show('Connecting to Memories...', 'info'); setTimeout(()=>VoyastraToast.show('AI Reel Generation Started!', 'success'), 1500); closeCreateReelModal();">Generate</button>
                </div>

                <div class="rm-divider"><span>OR</span></div>

                <!-- Upload -->
                <div class="rm-upload-area" onclick="VoyastraToast.show('File selector coming soon', 'info')">
                    <i class="ri-upload-cloud-2-line"></i>
                    <h4>Upload Video</h4>
                    <p>Select an MP4 from your device</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Main JS (Toast depends on this) -->
    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    <script>
        function toggleLike(btn) {
            const icon = btn.querySelector('i');
            const isLiked = icon.classList.contains('ri-heart-fill');
            if (isLiked) {
                icon.className = 'ri-heart-line';
                icon.style.color = '';
            } else {
                icon.className = 'ri-heart-fill';
                icon.style.color = '#ef4444';
            }
        }

        function toggleFollow(btn) {
            if (btn.innerText === 'Follow') {
                btn.innerText = 'Following';
                btn.style.background = 'transparent';
                btn.style.border = '1px solid white';
                VoyastraToast.show('Followed creator!', 'success');
            } else {
                btn.innerText = 'Follow';
                btn.style.background = 'var(--color-primary)';
                btn.style.border = 'none';
            }
        }

        function openCreateReelModal() {
            document.getElementById('createReelModal').classList.add('show');
        }

        function closeCreateReelModal() {
            document.getElementById('createReelModal').classList.remove('show');
        }

        function setDur(btn, seconds) {
            document.querySelectorAll('.rm-dur-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            VoyastraToast.show('Duration set to ' + seconds + ' seconds', 'info');
        }
    </script>
</body>
</html>
