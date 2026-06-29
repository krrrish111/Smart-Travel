document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('ai-draggable-container');
    const orb = document.getElementById('ai-buddy-orb');
    const popup = document.getElementById('ai-smart-popup');
    const minimizeBtn = document.getElementById('ai-minimize-btn');
    const chatInput = document.getElementById('ai-chat-input');
    const sendBtn = document.getElementById('ai-chat-send');
    const chatHistory = document.getElementById('ai-chat-history');
    const typingIndicator = document.getElementById('ai-typing-indicator');

    // --- Drag and Snap Logic ---
    let isDragging = false;
    let startX, startY, initialLeft, initialTop;
    let clickTimeout;

    // Load saved position
    const savedPos = localStorage.getItem('voyastraAIPos');
    if (savedPos && window.innerWidth > 768) {
        const pos = JSON.parse(savedPos);
        container.style.left = pos.left + 'px';
        container.style.top = pos.top + 'px';
        container.style.bottom = 'auto';
        container.style.right = 'auto';
        adjustPopupPosition(pos.left);
    }

    orb.addEventListener('pointerdown', (e) => {
        if (window.innerWidth <= 768) return; // Disable drag on mobile
        isDragging = false;
        startX = e.clientX;
        startY = e.clientY;
        const rect = container.getBoundingClientRect();
        initialLeft = rect.left;
        initialTop = rect.top;
        
        orb.setPointerCapture(e.pointerId);

        // Treat as click if pointer is released quickly
        clickTimeout = setTimeout(() => {
            isDragging = true;
        }, 200);
    });

    orb.addEventListener('pointermove', (e) => {
        if (!isDragging) return;
        const dx = e.clientX - startX;
        const dy = e.clientY - startY;
        
        let newLeft = initialLeft + dx;
        let newTop = initialTop + dy;

        // Prevent dragging off screen
        const maxX = window.innerWidth - orb.offsetWidth;
        const maxY = window.innerHeight - orb.offsetHeight;
        newLeft = Math.max(0, Math.min(newLeft, maxX));
        newTop = Math.max(0, Math.min(newTop, maxY));

        container.style.left = newLeft + 'px';
        container.style.top = newTop + 'px';
        container.style.bottom = 'auto';
        container.style.right = 'auto';
    }, { passive: true });

    orb.addEventListener('pointerup', (e) => {
        if (window.innerWidth <= 768) return;
        clearTimeout(clickTimeout);
        orb.releasePointerCapture(e.pointerId);
        
        if (isDragging) {
            isDragging = false;
            // Snap to nearest edge
            const rect = container.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const screenCenterX = window.innerWidth / 2;
            
            const snapLeft = centerX < screenCenterX ? 20 : window.innerWidth - rect.width - 20;
            
            container.style.transition = 'left 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
            container.style.left = snapLeft + 'px';
            
            setTimeout(() => {
                container.style.transition = '';
                localStorage.setItem('voyastraAIPos', JSON.stringify({ left: snapLeft, top: rect.top }));
                adjustPopupPosition(snapLeft);
            }, 300);
        } else {
            // It was a click
            togglePopup();
        }
    });

    // Handle click for mobile
    orb.addEventListener('click', (e) => {
        if (window.innerWidth <= 768) {
            togglePopup();
        }
    });

    function adjustPopupPosition(containerLeft) {
        if (window.innerWidth <= 768) return;
        const screenCenterX = window.innerWidth / 2;
        if (containerLeft < screenCenterX) {
            popup.classList.remove('popup-right');
            popup.classList.add('popup-left');
        } else {
            popup.classList.remove('popup-left');
            popup.classList.add('popup-right');
        }
    }

    // --- Popup Toggle and Context Logic ---
    function togglePopup() {
        if (popup.classList.contains('hidden')) {
            updateContextRecommendations();
            popup.classList.remove('hidden');
            setTimeout(() => chatInput.focus(), 300);
        } else {
            popup.classList.add('hidden');
        }
    }

    minimizeBtn.addEventListener('click', togglePopup);

    const getPageContext = () => {
        const path = window.location.pathname.toLowerCase();
        if (path.includes('travel-center')) return 'Travel Center';
        if (path.includes('flight')) return 'Flights';
        if (path.includes('journey')) return 'Journey';
        if (path.includes('hotel')) return 'Hotels';
        if (path.includes('train')) return 'Trains';
        if (path.includes('bus')) return 'Buses';
        if (path.includes('cab')) return 'Cabs';
        if (path.includes('cruise')) return 'Cruises';
        if (path.includes('helicopter')) return 'Helicopters';
        if (path.includes('planner')) return 'Planner';
        if (path.includes('community') || path.includes('post')) return 'Community';
        if (path.includes('profile')) return 'Profile';
        if (path.includes('booking')) return 'Bookings';
        return 'Home';
    };

    function updateContextRecommendations() {
        const context = getPageContext();
        const msgEl = document.getElementById('ai-context-message');
        const actionsContainer = document.querySelector('.ai-quick-actions');
        
        let msg = "How can I help you today?";
        let actions = `
            <button class="ai-action-btn" data-action="destinations">Explore Destinations</button>
            <button class="ai-action-btn" data-action="budget">Optimize Budget</button>
        `;

        if (context === 'Flights') {
            msg = "I found a cheaper flight departing later.";
        } else if (context === 'Journey') {
            msg = "Hi! You are in Goa. I found a hidden beach 2 km away. Want directions?";
            actions = `
                <button class="ai-action-btn" data-action="directions">Get Directions</button>
                <button class="ai-action-btn" data-action="weather">Weather Update</button>
                <button class="ai-action-btn" data-action="budget">Check Budget</button>
            `;
        } else if (context === 'Hotels') {
            msg = "This hotel has free breakfast and better ratings.";
        } else if (context === 'Trains' || context === 'Buses' || context === 'Cabs' || context === 'Cruises' || context === 'Helicopters') {
            msg = "Comparing alternative transport options...";
            actions = `<button class="ai-action-btn" data-action="compare">Compare Prices</button>` + actions;
        } else if (context === 'Planner') {
            msg = "Would you like a personalized itinerary?";
            actions = `<button class="ai-action-btn" data-action="itinerary">Create Itinerary</button>` + actions;
        } else if (context === 'Community') {
            msg = "This hidden gem is trending.";
            actions = `
                <button class="ai-action-btn" data-action="add_trip">Add To Trip</button>
                <button class="ai-action-btn" data-action="save_place">Save Place</button>
            `;
        } else if (context === 'Profile') {
            msg = "You completed 5 trips this year.";
        } else if (context === 'Travel Center') {
            msg = "Welcome to the Travel Center. Prepare for your next premium journey.";
            actions = `
                <button class="ai-action-btn" data-action="visa">Visa Requirements</button>
                <button class="ai-action-btn" data-action="forex">Order Forex</button>
                <button class="ai-action-btn" data-action="insurance">Travel Insurance</button>
            `;
        } else if (context === 'Bookings') {
            msg = "Your Goa trip starts in 4 days.";
            actions = `
                <button class="ai-action-btn" data-action="weather">Weather</button>
                <button class="ai-action-btn" data-action="packing">Packing List</button>
                <button class="ai-action-btn" data-action="tips">Travel Tips</button>
            `;
        }

        msgEl.textContent = msg;
        actionsContainer.innerHTML = actions;
    }

    // Event delegation for quick actions
    document.querySelector('.ai-quick-actions').addEventListener('click', (e) => {
        if (e.target.classList.contains('ai-action-btn')) {
            const action = e.target.getAttribute('data-action');
            let initialMsg = e.target.textContent;
            sendChatMessage(initialMsg);
        }
    });

    // --- Chat Engine Logic ---
    const appendMessage = (text, sender) => {
        const msgDiv = document.createElement('div');
        msgDiv.className = `chat-message ${sender}-message`;
        msgDiv.innerHTML = `<div class="message-content">${text}</div>`;
        
        chatHistory.insertBefore(msgDiv, typingIndicator);
        chatHistory.scrollTop = chatHistory.scrollHeight;
    };

    const sendChatMessage = async (text) => {
        if (!text.trim()) return;

        appendMessage(text, 'user');
        chatInput.value = '';
        typingIndicator.classList.remove('hidden');
        chatHistory.scrollTop = chatHistory.scrollHeight;

        try {
            const context = getPageContext();
            const response = await fetch(`${window.location.origin}/antigravity/api/ai-buddy`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ message: text, context: context })
            });

            const data = await response.json();
            typingIndicator.classList.add('hidden');
            
            if (data.status === 'success') {
                appendMessage(data.reply.replace(/\n/g, '<br/>'), 'ai');
            } else {
                appendMessage("I'm sorry, I encountered an error connecting to my servers.", 'ai');
            }
        } catch (error) {
            console.error('AI Buddy Error:', error);
            typingIndicator.classList.add('hidden');
            appendMessage("I'm having trouble reaching the network right now. Please try again later.", 'ai');
        }
    };

    sendBtn.addEventListener('click', () => sendChatMessage(chatInput.value));
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendChatMessage(chatInput.value);
    });

    // Initialize position class on load
    if (savedPos && window.innerWidth > 768) {
        adjustPopupPosition(JSON.parse(savedPos).left);
    } else {
        popup.classList.add('popup-right'); // Default
    }
});
