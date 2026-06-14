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
        const path = window.location.pathname;
        if (path.includes('flight')) return 'Flights';
        if (path.includes('hotel')) return 'Hotels';
        if (path.includes('planner')) return 'Planner';
        if (path.includes('budget')) return 'Budget';
        return 'General';
    };

    // Layer transitions
    orb.addEventListener('click', () => {
        if (state === 'orb') {
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

    // Handle Quick Actions
    document.querySelectorAll('.ai-action-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const action = e.target.getAttribute('data-action');
            let initialMsg = '';
            if(action === 'destinations') initialMsg = 'Can you explore some destinations for me?';
            if(action === 'budget') initialMsg = 'How can I optimize my travel budget?';
            if(action === 'chat') initialMsg = 'Hi!';
            
            openChat();
            if (initialMsg !== 'Hi!') {
                sendChatMessage(initialMsg);
            }
        });
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
