<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voyastra AI Travel Buddy</title>
    
    <!-- Google Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- App Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ai-buddy.css">

    <style>
        /* Specific adjustments to override the floating drawer when on the dedicated page */
        body { margin: 0; padding: 0; background: #0A0A10; color: #E0E0E0; font-family: 'Inter', sans-serif; height: 100vh; display: flex; flex-direction: column; overflow: hidden; }
        
        .ai-fullpage-container {
            flex: 1;
            display: flex;
            height: calc(100vh - 80px); /* Assuming header is ~80px */
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
            gap: 20px;
            padding: 20px;
            box-sizing: border-box;
        }

        /* Sidebar for memory and tools */
        .ai-sidebar {
            width: 320px;
            background: rgba(30, 30, 44, 0.6);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 24px;
            overflow-y: auto;
        }

        /* Main Chat Area */
        .ai-chat-main {
            flex: 1;
            background: var(--ai-dark, #1E1E2C);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            position: relative;
        }

        .ai-sidebar h3 { font-size: 16px; font-weight: 600; color: #FFF; margin-top: 0; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
        .ai-sidebar h3 i { color: var(--ai-primary, #6C5CE7); }
        
        .memory-tag {
            display: inline-block;
            background: rgba(108, 92, 231, 0.15);
            color: #A29BFE;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 13px;
            margin: 4px;
            border: 1px solid rgba(108, 92, 231, 0.3);
        }

        .ai-suggestions-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .ai-suggestion-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.05);
            padding: 16px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .ai-suggestion-card:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateY(-2px);
            border-color: var(--ai-primary, #6C5CE7);
        }

        .ai-suggestion-card i { font-size: 20px; color: var(--ai-primary); margin-bottom: 8px; }
        .ai-suggestion-card p { font-size: 13px; margin: 0; color: #CCC; line-height: 1.4; }

        /* Hide the global floating orb on this page since we are already in the AI page */
        #ai-buddy-container { display: none !important; }

        /* Full page chat styles */
        .full-chat-header {
            padding: 20px 30px;
            background: linear-gradient(135deg, rgba(108, 92, 231, 0.1), transparent);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .full-chat-header h2 { margin: 0; color: #FFF; font-size: 20px; font-weight: 600; }
        .full-chat-header p { margin: 0; color: #888; font-size: 13px; margin-top: 4px; }
        
        #full-chat-history {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        #full-chat-history::-webkit-scrollbar { width: 8px; }
        #full-chat-history::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 4px; }

        .full-chat-input-wrapper {
            padding: 20px 30px;
            background: rgba(30, 30, 44, 0.8);
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        .full-input-box {
            display: flex;
            background: rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 8px 16px;
            align-items: center;
            transition: border-color 0.3s;
        }

        .full-input-box:focus-within { border-color: var(--ai-primary); box-shadow: 0 0 0 2px rgba(108, 92, 231, 0.2); }

        #full-chat-input {
            flex: 1;
            background: transparent;
            border: none;
            color: #FFF;
            font-size: 15px;
            outline: none;
            padding: 12px 0;
            font-family: inherit;
        }

        .full-send-btn {
            background: var(--ai-primary);
            color: #FFF;
            border: none;
            width: 44px;
            height: 44px;
            border-radius: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            transition: all 0.2s;
        }

        .full-send-btn:hover { background: var(--ai-secondary, #A29BFE); transform: scale(1.05); }

    </style>
</head>
<body>
    
    <!-- We can include header here if it exists -->
    <jsp:include page="/components/header.jsp" />

    <div class="ai-fullpage-container">
        
        <!-- Sidebar -->
        <div class="ai-sidebar">
            <div class="ai-memory-section">
                <h3><i class="fas fa-brain"></i> AI Memory</h3>
                <p style="font-size: 13px; color: #888; margin-bottom: 12px;">I remember your preferences to give you personalized recommendations.</p>
                <div>
                    <span class="memory-tag"><i class="fas fa-suitcase-rolling"></i> Backpacking</span>
                    <span class="memory-tag"><i class="fas fa-leaf"></i> Vegetarian</span>
                    <span class="memory-tag"><i class="fas fa-wallet"></i> Mid-Range Budget</span>
                    <span class="memory-tag"><i class="fas fa-umbrella-beach"></i> Loves Beaches</span>
                </div>
            </div>

            <div class="ai-tools-section">
                <h3><i class="fas fa-bolt"></i> Example Queries</h3>
                <div class="ai-suggestions-grid">
                    <div class="ai-suggestion-card" onclick="sendFullChatMessage('Plan a 5-day Goa trip.')">
                        <i class="fas fa-map-marked-alt"></i>
                        <p>Plan a 5-day Goa trip</p>
                    </div>
                    <div class="ai-suggestion-card" onclick="sendFullChatMessage('Suggest hidden beaches.')">
                        <i class="fas fa-eye-slash"></i>
                        <p>Suggest hidden beaches</p>
                    </div>
                    <div class="ai-suggestion-card" onclick="sendFullChatMessage('Find destinations under ₹20k.')">
                        <i class="fas fa-rupee-sign"></i>
                        <p>Destinations under ₹20k</p>
                    </div>
                    <div class="ai-suggestion-card" onclick="sendFullChatMessage('Recommend food trails.')">
                        <i class="fas fa-utensils"></i>
                        <p>Recommend food trails</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Chat -->
        <div class="ai-chat-main">
            <div class="full-chat-header">
                <div style="font-size: 32px;">🤖</div>
                <div>
                    <h2>Voyastra AI Travel Buddy</h2>
                    <p>Powered by Gemini Intelligence</p>
                </div>
            </div>
            
            <div id="full-chat-history">
                <div class="chat-message ai-message">
                    <div class="message-content" style="background: rgba(108, 92, 231, 0.1); border: 1px solid rgba(108, 92, 231, 0.3);">
                        <strong>Welcome to your dedicated AI hub!</strong><br><br>
                        I am connected to Voyastra's Planner, Community, Budget Engine, and Food Database. Because I remember your past trips and preferences, I can help you plan the perfect journey. What are we exploring today?
                    </div>
                </div>
                <div id="full-typing-indicator" class="typing-indicator hidden">
                    <span></span><span></span><span></span>
                </div>
            </div>

            <div class="full-chat-input-wrapper">
                <div class="full-input-box">
                    <input type="text" id="full-chat-input" placeholder="Ask anything... 'Find photography spots in Jaipur'" />
                    <button class="full-send-btn" onclick="submitFullChat()"><i class="fas fa-paper-plane"></i></button>
                </div>
            </div>
        </div>

    </div>

    <!-- Include footer without floating AI since it's hidden by CSS -->
    <jsp:include page="/components/footer.jsp" />

    <script>
        const chatHistory = document.getElementById('full-chat-history');
        const chatInput = document.getElementById('full-chat-input');
        const typingIndicator = document.getElementById('full-typing-indicator');

        chatInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') submitFullChat();
        });

        function submitFullChat() {
            if (chatInput.value.trim()) {
                sendFullChatMessage(chatInput.value);
            }
        }

        async function sendFullChatMessage(text) {
            appendMessage(text, 'user');
            chatInput.value = '';
            typingIndicator.classList.remove('hidden');
            chatHistory.scrollTop = chatHistory.scrollHeight;

            try {
                // Send request to backend servlet
                // Context is 'Dedicated AI Hub'
                const response = await fetch(`${window.location.origin}/antigravity/api/ai-buddy`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ message: text, context: 'Dedicated AI Hub' })
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
        }

        function appendMessage(text, sender) {
            const msgDiv = document.createElement('div');
            msgDiv.className = `chat-message ${sender}-message`;
            
            // We use the same message content styles as the floating buddy, but inject into full history
            msgDiv.innerHTML = `<div class="message-content">${text}</div>`;
            
            chatHistory.insertBefore(msgDiv, typingIndicator);
            chatHistory.scrollTop = chatHistory.scrollHeight;
        }
    </script>
</body>
</html>
