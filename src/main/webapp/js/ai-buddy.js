document.addEventListener('DOMContentLoaded', () => {
    const orb = document.getElementById('ai-buddy-orb');
    const contextPanel = document.getElementById('ai-context-panel');
    const chatDrawer = document.getElementById('ai-chat-drawer');
    const closeContextBtn = document.getElementById('ai-close-context');
    const closeDrawerBtn = document.getElementById('ai-close-drawer');
    const chatInput = document.getElementById('ai-chat-input');
    const sendBtn = document.getElementById('ai-chat-send');
    const chatHistory = document.getElementById('ai-chat-history');
    const typingIndicator = document.getElementById('ai-typing-indicator');

    let state = 'orb'; // 'orb', 'context', 'chat'

    // Extract current page info for context
    const getPageContext = () => {
        const path = window.location.pathname.toLowerCase();
        if (path.includes('flight')) return 'Flights';
        if (path.includes('hotel')) return 'Hotels';
        if (path.includes('train')) return 'Trains';
        if (path.includes('bus')) return 'Buses';
        if (path.includes('planner')) return 'Planner';
        if (path.includes('community') || path.includes('post')) return 'Community';
        if (path.includes('profile')) return 'Profile';
        if (path.includes('booking')) return 'Bookings';
        return 'General';
    };

    const updateContextPanel = (context) => {
        const msgEl = document.getElementById('ai-context-message');
        const actionsContainer = document.querySelector('.ai-quick-actions');
        
        let msg = "Hey there! Looking for recommendations?";
        let actions = `
            <button class="ai-action-btn" data-action="destinations">Explore Destinations</button>
            <button class="ai-action-btn" data-action="budget">Optimize Budget</button>
            <button class="ai-action-btn" data-action="chat">Chat with AI</button>
        `;

        if (context === 'Flights') {
            msg = "I found a cheaper flight departing later.";
        } else if (context === 'Hotels') {
            msg = "This hotel has free breakfast and better ratings.";
        } else if (context === 'Trains') {
            msg = "Train saves ₹2500 compared to flight.";
        } else if (context === 'Buses') {
            msg = "Overnight bus saves one hotel night.";
        } else if (context === 'Planner') {
            msg = "Would you like a personalized itinerary?";
        } else if (context === 'Community') {
            msg = "This hidden gem is trending.";
            actions = `
                <button class="ai-action-btn" data-action="add_trip">Add To Trip</button>
                <button class="ai-action-btn" data-action="save_place">Save Place</button>
                <button class="ai-action-btn" data-action="chat">Chat with AI</button>
            `;
        } else if (context === 'Profile') {
            msg = "You completed 5 trips this year.";
        } else if (context === 'Bookings') {
            msg = "Your Goa trip starts in 4 days.";
            actions = `
                <button class="ai-action-btn" data-action="weather">Weather</button>
                <button class="ai-action-btn" data-action="packing">Packing List</button>
                <button class="ai-action-btn" data-action="tips">Travel Tips</button>
                <button class="ai-action-btn" data-action="chat">Chat with AI</button>
            `;
        }

        msgEl.textContent = msg;
        actionsContainer.innerHTML = actions;
    };

    // Layer transitions
    orb.addEventListener('click', () => {
        if (state === 'orb') {
            updateContextPanel(getPageContext());
            contextPanel.classList.remove('hidden');
            orb.style.transform = 'scale(0)';
            state = 'context';
        }
    });

    closeContextBtn.addEventListener('click', () => {
        contextPanel.classList.add('hidden');
        orb.style.transform = 'scale(1)';
        state = 'orb';
    });

    const openChat = () => {
        contextPanel.classList.add('hidden');
        chatDrawer.classList.remove('hidden');
        orb.style.transform = 'scale(0)';
        state = 'chat';
        setTimeout(() => chatInput.focus(), 500);
    };

    closeDrawerBtn.addEventListener('click', () => {
        chatDrawer.classList.add('hidden');
        orb.style.transform = 'scale(1)';
        state = 'orb';
    });

    // Handle Quick Actions using event delegation
    document.querySelector('.ai-quick-actions').addEventListener('click', (e) => {
        if (e.target.classList.contains('ai-action-btn')) {
            const action = e.target.getAttribute('data-action');
            let initialMsg = '';
            
            if (action === 'destinations') initialMsg = 'Can you explore some destinations for me?';
            else if (action === 'budget') initialMsg = 'How can I optimize my travel budget?';
            else if (action === 'add_trip') initialMsg = 'Can you add this to my trip planner?';
            else if (action === 'save_place') initialMsg = 'Please save this place for later.';
            else if (action === 'weather') initialMsg = 'What is the weather going to be like?';
            else if (action === 'packing') initialMsg = 'Help me create a packing list.';
            else if (action === 'tips') initialMsg = 'Do you have any travel tips for my destination?';
            else if (action === 'chat') initialMsg = 'Hi!';
            
            openChat();
            if (initialMsg && initialMsg !== 'Hi!') {
                sendChatMessage(initialMsg);
            }
        }
    });

    // Chat Logic
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
            // Send request to backend servlet
            const context = getPageContext();
            const response = await fetch(`${window.location.origin}/antigravity/api/ai-buddy`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ message: text, context: context })
            });

            const data = await response.json();
            typingIndicator.classList.add('hidden');
            
            if (data.status === 'success') {
                // To handle markdown from Gemini, we might want a library like marked.js, but for now simple replacement or innerText
                // We'll trust innerHTML since it's from our own API wrapper but ideally we sanitize
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
});
