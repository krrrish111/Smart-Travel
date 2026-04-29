/**
 * VOYASTRA HOME DYNAMIC ENGINE
 * Manages: Theme System, Hero Rotator, Background Slider, Parallax, and Search Modal.
 */

document.addEventListener('DOMContentLoaded', () => {
    /* --- DYNAMIC THEME SYSTEM --- */
    const themes = [
        { '--color-primary': '#b8cfe0', '--color-accent': '#6a9ab8', '--color-muted': 'rgba(195,215,230,0.6)', '--color-surface': 'rgba(200,220,235,0.06)', '--color-border': 'rgba(185,210,228,0.16)', '--text-heading': '#edf2f7', '--text-body': 'rgba(215,230,242,0.7)' },
        { '--color-primary': '#96c98d', '--color-accent': '#4a8c42', '--color-muted': 'rgba(165,205,160,0.6)', '--color-surface': 'rgba(120,180,115,0.06)', '--color-border': 'rgba(148,200,142,0.16)', '--text-heading': '#eef5ec', '--text-body': 'rgba(195,230,190,0.7)' },
        { '--color-primary': '#d4a86a', '--color-accent': '#9c6820', '--color-muted': 'rgba(215,185,135,0.6)', '--color-surface': 'rgba(185,140,80,0.06)', '--color-border': 'rgba(210,175,115,0.16)', '--text-heading': '#f7f0e6', '--text-body': 'rgba(235,215,180,0.7)' },
        { '--color-primary': '#d48c5a', '--color-accent': '#a04818', '--color-muted': 'rgba(215,165,120,0.6)', '--color-surface': 'rgba(180,110,65,0.06)', '--color-border': 'rgba(210,148,95,0.16)', '--text-heading': '#f5ede4', '--text-body': 'rgba(240,205,170,0.7)' },
        { '--color-primary': '#9ab8d4', '--color-accent': '#4a7898', '--color-muted': 'rgba(165,195,218,0.6)', '--color-surface': 'rgba(110,160,195,0.06)', '--color-border': 'rgba(145,188,215,0.16)', '--text-heading': '#edf2f8', '--text-body': 'rgba(200,220,238,0.7)' },
        { '--color-primary': '#c8a8d8', '--color-accent': '#7a4898', '--color-muted': 'rgba(198,170,218,0.6)', '--color-surface': 'rgba(155,110,185,0.06)', '--color-border': 'rgba(188,148,210,0.16)', '--text-heading': '#f5f0f8', '--text-body': 'rgba(220,200,235,0.7)' },
        { '--color-primary': '#78c4b8', '--color-accent': '#2a8878', '--color-muted': 'rgba(130,195,188,0.6)', '--color-surface': 'rgba(80,165,155,0.06)', '--color-border': 'rgba(108,188,180,0.16)', '--text-heading': '#edf6f5', '--text-body': 'rgba(185,225,220,0.7)' },
        { '--color-primary': '#c88858', '--color-accent': '#884018', '--color-muted': 'rgba(200,155,110,0.6)', '--color-surface': 'rgba(165,105,60,0.06)', '--color-border': 'rgba(195,138,88,0.16)', '--text-heading': '#f6ede6', '--text-body': 'rgba(235,210,185,0.7)' },
        { '--color-primary': '#68c8d8', '--color-accent': '#1080a0', '--color-muted': 'rgba(118,200,215,0.6)', '--color-surface': 'rgba(65,175,195,0.06)', '--color-border': 'rgba(98,202,218,0.16)', '--text-heading': '#edf8f9', '--text-body': 'rgba(185,230,238,0.7)' },
        { '--color-primary': '#a8b888', '--color-accent': '#587848', '--color-muted': 'rgba(168,185,145,0.6)', '--color-surface': 'rgba(125,148,100,0.06)', '--color-border': 'rgba(155,172,128,0.16)', '--text-heading': '#f0f2ec', '--text-body': 'rgba(210,220,195,0.7)' },
        { '--color-primary': '#d8c8b0', '--color-accent': '#907858', '--color-muted': 'rgba(215,200,175,0.6)', '--color-surface': 'rgba(185,168,140,0.06)', '--color-border': 'rgba(210,192,165,0.16)', '--text-heading': '#f8f5f0', '--text-body': 'rgba(238,228,215,0.7)' },
        { '--color-primary': '#78b890', '--color-accent': '#286848', '--color-muted': 'rgba(128,185,148,0.6)', '--color-surface': 'rgba(75,148,105,0.06)', '--color-border': 'rgba(105,178,130,0.16)', '--text-heading': '#eef4f0', '--text-body': 'rgba(195,228,208,0.7)' },
    ];

    const themesAreLight = [true, false, false, false, false, false, false, false, false, true, true, true];
    const lightThemeDark = {
        0: { primary: '#2d6e98', accent: '#1a4a6a' },
        9: { primary: '#3a5830', accent: '#223520' },
        10: { primary: '#7a5830', accent: '#4a3010' },
        11: { primary: '#1a5c38', accent: '#0a3820' },
    };

    function applyTheme(index) {
        const t = themes[index] || themes[0];
        const root = document.documentElement;
        const isLight = themesAreLight[index] || false;
        document.body.classList.toggle('theme-light', isLight);
        Object.entries(t).forEach(([k, v]) => root.style.setProperty(k, v));

        if (isLight) {
            const dk = lightThemeDark[index];
            root.style.setProperty('--color-primary', dk.primary);
            root.style.setProperty('--color-accent', dk.accent);
            root.style.setProperty('--color-muted', 'rgba(40,30,18,0.55)');
            root.style.setProperty('--text-heading', '#1a1612');
            root.style.setProperty('--text-body', 'rgba(30,22,12,0.72)');
            root.style.setProperty('--color-surface', 'rgba(15,10,5,0.06)');
            root.style.setProperty('--color-border', 'rgba(20,14,6,0.15)');
            document.querySelectorAll('.bg-slide').forEach(s => s.style.filter = 'brightness(0.78)');
        } else {
            document.querySelectorAll('.bg-slide').forEach(s => s.style.filter = 'brightness(0.40)');
        }
        
        const primary = isLight ? lightThemeDark[index].primary : t['--color-primary'];
        document.querySelectorAll('.bg-dot.active').forEach(d => d.style.boxShadow = '0 0 15px ' + primary);
    }

    applyTheme(0);

    /* --- Rotator --- */
    const rotatorTrack = document.getElementById('rotatorTrack');
    if (rotatorTrack) {
        let currentWord = 0;
        setInterval(() => {
            currentWord++;
            rotatorTrack.style.transition = 'transform 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55)';
            rotatorTrack.style.transform = `translateY(-${currentWord * 1.2}em)`;
            if (currentWord === rotatorTrack.children.length - 1) {
                setTimeout(() => {
                    rotatorTrack.style.transition = 'none';
                    currentWord = 0;
                    rotatorTrack.style.transform = 'translateY(0)';
                }, 600);
            }
        }, 2400);
    }

    /* --- BG Slider --- */
    const bgSlides = document.querySelectorAll('.bg-slide');
    const bgDots = document.querySelectorAll('.bg-dot');
    let bgIndex = 0;
    let bgInterval;

    function setBg(index) {
        bgSlides.forEach(s => s.classList.remove('active'));
        bgDots.forEach(d => d.classList.remove('active'));
        bgSlides[index].classList.add('active');
        bgDots[index].classList.add('active');
        bgIndex = index;
        setTimeout(() => applyTheme(index), 100);
    }

    function startBgInterval() {
        clearInterval(bgInterval);
        bgInterval = setInterval(() => setBg((bgIndex + 1) % bgSlides.length), 5000);
    }

    startBgInterval();
    bgDots.forEach((dot, i) => dot.addEventListener('click', () => { setBg(i); startBgInterval(); }));

    /* --- Parallax --- */
    window.addEventListener('mousemove', (e) => {
        const x = (e.clientX / window.innerWidth - 0.5) * 2;
        const y = (e.clientY / window.innerHeight - 0.5) * 2;
        document.querySelectorAll('.parallax-bg').forEach(el => {
            const speed = parseFloat(el.getAttribute('data-speed')) || 0.05;
            el.style.transform = `translate(${x * 100 * speed}px, ${y * 100 * speed}px)`;
        });
        bgSlides.forEach(slide => {
            if (slide.classList.contains('active')) {
                slide.style.transform = `translate(${x * -20}px, ${y * -20}px) scale(1.05)`;
            }
        });
    });

    /* --- Scroll Progress --- */
    const scrollProgress = document.getElementById('scrollProgress');
    window.addEventListener('scroll', () => {
        const scrolled = (window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100;
        if (scrollProgress) scrollProgress.style.height = scrolled + '%';
    });

    /* --- Intelligent Search Modal --- */
    const SEARCH_DB = [
        { city: 'Delhi', airport: 'DEL, Indira Gandhi Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Mumbai', airport: 'BOM, Chhatrapati Shivaji Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Bengaluru', airport: 'BLR, Kempegowda Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Hyderabad', airport: 'HYD, Rajiv Gandhi Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Chennai', airport: 'MAA, Chennai Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Kolkata', airport: 'CCU, Netaji Subhas Chandra Bose', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Goa', airport: 'GOI, Dabolim Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Jaipur', airport: 'JAI, Jaipur Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Udaipur', airport: 'UDR, Maharana Pratap', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Pune', airport: 'PNQ, Pune Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Kochi', airport: 'COK, Cochin Intl', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' },
        { city: 'Varanasi', airport: 'VNS, Lal Bahadur Shastri', icon: 'M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z' }
    ];
    const RECENTS_KEY = 'voyastra_recent_searches';
    const modal = document.getElementById('intelligentSearchModal');
    const input = document.getElementById('intelligentSearchInput');
    let activeSearchField = null;

    const openSearchModal = (fieldEl) => {
        activeSearchField = fieldEl;
        if (!modal || !input) return;
        input.value = '';
        modal.classList.remove('hidden');
        const rect = fieldEl.getBoundingClientRect();
        modal.style.top = (rect.bottom + window.scrollY + 8) + 'px';
        modal.style.left = Math.min(rect.left, window.innerWidth - 344) + 'px';
        setTimeout(() => input.focus(), 50);
    };

    document.querySelectorAll('.search-field').forEach(field => {
        const labelNode = field.querySelector('.field-label');
        if (labelNode && ["From", "To", "City, Property Name Or Location"].includes(labelNode.innerText.trim())) {
            field.addEventListener('click', (e) => { e.stopPropagation(); openSearchModal(field); });
        }
    });

    /* --- Destination Carousel --- */
    (function () {
        const track = document.getElementById('destTrack');
        const viewport = document.getElementById('destViewport');
        if (!track || !viewport) return;

        let current = 0;
        let isAnimating = false;
        const cards = Array.from(track.querySelectorAll('.dest-card'));
        const total = cards.length;
        const dotsEl = document.getElementById('destDots');

        function getPerView() {
            const w = window.innerWidth;
            if (w >= 1100) return 4;
            if (w >= 768)  return 3;
            if (w >= 480)  return 2;
            return 1;
        }

        function buildDots() {
            if (!dotsEl) return;
            dotsEl.innerHTML = '';
            const perView = getPerView();
            const pages = Math.ceil(total / perView);
            for (let i = 0; i < pages; i++) {
                const btn = document.createElement('button');
                btn.className = 'dest-dot' + (i === 0 ? ' active' : '');
                btn.addEventListener('click', () => {
                    current = i * perView;
                    track.style.transition = 'transform 0.6s cubic-bezier(0.23, 1, 0.32, 1)';
                    update();
                });
                dotsEl.appendChild(btn);
            }
        }

        function updateDots() {
            if (!dotsEl) return;
            const perView = getPerView();
            const idx = ((current % total) + total) % total;
            const activePage = Math.floor(idx / perView);
            dotsEl.querySelectorAll('.dest-dot').forEach((d, i) => d.classList.toggle('active', i === activePage));
        }

        function build() {
            track.querySelectorAll('.dest-card-clone').forEach(el => el.remove());
            cards.forEach(c => { const cl = c.cloneNode(true); cl.classList.add('dest-card-clone'); track.appendChild(cl); });
            [...cards].reverse().forEach(c => { const cl = c.cloneNode(true); cl.classList.add('dest-card-clone'); track.insertBefore(cl, track.firstChild); });
            buildDots();
            update();
        }

        function update() {
            const firstCard = track.querySelector('.dest-card');
            if (!firstCard) return;
            const style = getComputedStyle(track);
            const gap = parseFloat(style.gap) || 24;
            const cw = firstCard.offsetWidth + gap;
            track.style.transform = `translateX(-${(current + total) * cw}px)`;
            updateDots();
        }

        document.getElementById('destNext')?.addEventListener('click', () => {
            if(isAnimating) return;
            isAnimating = true;
            current++;
            track.style.transition = 'transform 0.6s cubic-bezier(0.23, 1, 0.32, 1)';
            update();
        });

        document.getElementById('destPrev')?.addEventListener('click', () => {
            if(isAnimating) return;
            isAnimating = true;
            current--;
            track.style.transition = 'transform 0.6s cubic-bezier(0.23, 1, 0.32, 1)';
            update();
        });

        track.addEventListener('transitionend', () => {
            isAnimating = false;
            if (current >= total || current <= -total) {
                current = (current % total + total) % total;
                track.style.transition = 'none';
                update();
            }
        });

        build();
        window.addEventListener('resize', () => { buildDots(); update(); });
        setInterval(() => { if(!isAnimating) { current++; track.style.transition = 'transform 0.6s cubic-bezier(0.23, 1, 0.32, 1)'; update(); } }, 5000);
    })();

    /* --- Universal Auto-Scroller (Partners, Testimonials, Must-Do) --- */
    function initScroller(outerId, innerId, baseSpeed = 0.8) {
        const outer = document.getElementById(outerId);
        const inner = document.getElementById(innerId);
        if (!outer || !inner) return;

        // Clone content for seamless loop
        const items = Array.from(inner.children);
        items.forEach(item => inner.appendChild(item.cloneNode(true)));

        let pos = 0;
        let currentSpeed = baseSpeed;
        let targetSpeed = baseSpeed;
        let isHovering = false;
        let mouseX = 0;

        function step() {
            const rect = outer.getBoundingClientRect();
            const width = rect.width;
            const halfWay = inner.scrollWidth / 2;

            if (isHovering) {
                const relX = mouseX - rect.left;
                const edgeSize = width * 0.2;
                if (relX < edgeSize) {
                    targetSpeed = -((edgeSize - relX) / edgeSize) * 8 - baseSpeed;
                } else if (relX > (width - edgeSize)) {
                    targetSpeed = ((relX - (width - edgeSize)) / edgeSize) * 8 + baseSpeed;
                } else {
                    targetSpeed = baseSpeed * 0.2;
                }
            } else {
                targetSpeed = baseSpeed;
            }

            currentSpeed += (targetSpeed - currentSpeed) * 0.1;
            pos -= currentSpeed;
            
            if (pos <= -halfWay) pos += halfWay;
            if (pos > 0) pos -= halfWay;

            inner.style.transform = `translateX(${pos}px)`;
            requestAnimationFrame(step);
        }

        outer.addEventListener('mousemove', (e) => { isHovering = true; mouseX = e.clientX; });
        outer.addEventListener('mouseleave', () => { isHovering = false; });
        requestAnimationFrame(step);
    }

    initScroller('partnersOuter', 'partnersTrack', 0.6);
    initScroller('testiOuter', 'testiTrack', 0.8);
    initScroller('mustDoOuter', 'mustDoInner', 0.8);
    initScroller('itinStripOuter', 'itinStripInner', 1.0);

    /* --- Custom Cursor --- */
    const cursorDot = document.getElementById('cursorDot');
    const cursorOutline = document.getElementById('cursorOutline');
    if (cursorDot && cursorOutline) {
        window.addEventListener('mousemove', (e) => {
            const posX = e.clientX;
            const posY = e.clientY;
            cursorDot.style.left = posX + 'px';
            cursorDot.style.top = posY + 'px';
            cursorOutline.animate({ left: posX + 'px', top: posY + 'px' }, { duration: 500, fill: "forwards" });
        });

        const hoverables = document.querySelectorAll('a, button, .dest-item, .tilt-card, .dest-dot');
        hoverables.forEach(el => {
            el.addEventListener('mouseenter', () => {
                cursorOutline.style.width = '60px';
                cursorOutline.style.height = '60px';
                cursorOutline.style.backgroundColor = 'rgba(79, 70, 229, 0.2)';
            });
            el.addEventListener('mouseleave', () => {
                cursorOutline.style.width = '40px';
                cursorOutline.style.height = '40px';
                cursorOutline.style.backgroundColor = 'transparent';
            });
        });
    }
    
    /* --- Premium Trip Plans Carousel --- */
    (function() {
        const section = document.querySelector('.premium-carousel-section');
        const outer = document.getElementById('planCarouselOuter');
        const track = document.getElementById('planCarouselTrack');
        const prevBtn = document.getElementById('planPrevBtn');
        const nextBtn = document.getElementById('planNextBtn');

        if (!outer || !track) return;

        const originalCards = Array.from(track.querySelectorAll('.plan-card'));
        if (originalCards.length < 1) return;

        const cloneSet = () => {
            originalCards.forEach(card => {
                const clone = card.cloneNode(true);
                clone.removeAttribute('id');
                track.appendChild(clone);
            });
        };
        
        track.innerHTML = '';
        cloneSet(); // Set A
        cloneSet(); // Set B (Main)
        cloneSet(); // Set C
        
        let setWidth = 0;
        let currentX = 0;
        let isDragging = false;
        let isNavigating = false;
        let isHovered = false;
        let startX = 0;
        let baseScrollLeft = 0;
        
        const defaultSpeed = -0.85;
        let currentSpeed = defaultSpeed;
        let targetSpeed = defaultSpeed;
        
        const updateDimensions = () => {
            const allCards = track.children;
            const setSize = originalCards.length;
            if (allCards.length >= setSize * 2) {
                setWidth = allCards[setSize].offsetLeft - allCards[0].offsetLeft;
            } else {
                setWidth = track.scrollWidth / 3;
            }
            if (currentX === 0) currentX = -setWidth;
        };

        updateDimensions();
        setTimeout(updateDimensions, 500);
        window.addEventListener('resize', updateDimensions);
        
        const animate = () => {
            if (!isDragging && !isNavigating) {
                currentSpeed += (targetSpeed - currentSpeed) * 0.04;
                currentX += currentSpeed;
                if (currentX <= -(setWidth * 2)) currentX += setWidth;
                if (currentX >= 0) currentX -= setWidth;
                track.style.transform = `translateX(${currentX}px)`;
            }
            requestAnimationFrame(animate);
        };

        if (section) {
            section.addEventListener('mousemove', (e) => {
                isHovered = true;
                const rect = section.getBoundingClientRect();
                const mouseX = e.clientX - rect.left;
                const pct = mouseX / rect.width;

                if (pct < 0.2) {
                    const factor = 1 + (1 - (pct / 0.2)) * 6;
                    targetSpeed = defaultSpeed * factor;
                } else if (pct > 0.8) {
                    const intensity = (pct - 0.8) / 0.2; 
                    targetSpeed = 2.5 * intensity; 
                } else if (pct > 0.7 && pct <= 0.8) {
                    targetSpeed = defaultSpeed * (1 - (pct - 0.7) / 0.1);
                } else {
                    targetSpeed = defaultSpeed;
                }
            });

            section.addEventListener('mouseleave', () => {
                isHovered = false;
                targetSpeed = defaultSpeed;
            });
        }

        const manualNav = (dir) => {
            if (isNavigating) return;
            isNavigating = true;
            const cardWidth = track.children[1].offsetLeft - track.children[0].offsetLeft;
            const jump = cardWidth * (window.innerWidth < 768 ? 1 : 2);
            track.style.transition = 'transform 0.6s cubic-bezier(0.16, 1, 0.3, 1)';
            currentX += (dir === 'next' ? -jump : jump);
            track.style.transform = `translateX(${currentX}px)`;
            setTimeout(() => {
                track.style.transition = 'none';
                if (currentX <= -(setWidth * 2)) currentX += setWidth;
                if (currentX >= 0) currentX -= setWidth;
                isNavigating = false;
            }, 600);
        };

        if (prevBtn) prevBtn.addEventListener('click', () => manualNav('prev'));
        if (nextBtn) nextBtn.addEventListener('click', () => manualNav('next'));

        const onDragStart = (e) => {
            isDragging = true;
            startX = (e.pageX || (e.touches && e.touches[0].pageX));
            baseScrollLeft = currentX;
            track.style.transition = 'none';
        };
        const onDragMove = (e) => {
            if (!isDragging) return;
            const x = (e.pageX || (e.touches && e.touches[0].pageX));
            const walk = x - startX;
            currentX = baseScrollLeft + walk;
            if (currentX <= -(setWidth * 2)) currentX += setWidth;
            if (currentX >= 0) currentX -= setWidth;
            track.style.transform = `translateX(${currentX}px)`;
        };
        const onDragEnd = () => { isDragging = false; };

        outer.addEventListener('mousedown', onDragStart);
        window.addEventListener('mousemove', onDragMove);
        window.addEventListener('mouseup', onDragEnd);
        outer.addEventListener('touchstart', onDragStart, {passive: true});
        outer.addEventListener('touchmove', onDragMove, {passive: true});
        outer.addEventListener('touchend', onDragEnd);

        outer.addEventListener('wheel', (e) => {
            if (Math.abs(e.deltaX) > Math.abs(e.deltaY) || Math.abs(e.deltaY) > 0) {
                e.preventDefault();
                const delta = e.deltaX || e.deltaY;
                currentX -= delta * 0.8;
                if (currentX <= -(setWidth * 2)) currentX += setWidth;
                if (currentX >= 0) currentX -= setWidth;
                track.style.transform = `translateX(${currentX}px)`;
            }
        }, {passive: false});

        requestAnimationFrame(animate);
    })();
});
