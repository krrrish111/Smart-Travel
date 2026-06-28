<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- Modern Draggable AI Buddy UI -->
<div id="ai-draggable-container">
    
    <!-- The AI Orb -->
    <div id="ai-buddy-orb" class="ai-orb" title="Voyastra AI Buddy">
        <div class="orb-core"></div>
        <div class="orb-pulse"></div>
        <span class="ai-icon">🤖</span>
    </div>

    <!-- The Glassmorphic AI Popup -->
    <div id="ai-smart-popup" class="ai-popup hidden">
        <div class="ai-popup-header">
            <div class="popup-title">
                <i class="fas fa-sparkles"></i> Voyastra AI
            </div>
            <div class="popup-controls">
                <button id="ai-minimize-btn" class="icon-btn" title="Minimize"><i class="fas fa-minus"></i></button>
            </div>
        </div>
        
        <div class="ai-popup-body">
            <!-- Context Aware Suggestions Section -->
            <div class="ai-context-section">
                <p id="ai-context-message">Loading recommendations...</p>
                <div class="ai-quick-actions">
                    <!-- Buttons injected via JS -->
                </div>
            </div>

            <!-- Chat History -->
            <div id="ai-chat-history" class="ai-chat-scroll">
                <div class="chat-message ai-message">
                    <div class="message-content">Hello! I'm your AI Travel Buddy. I can help you plan trips, discover hidden gems, or optimize your budget. How can I assist you today?</div>
                </div>
                <div id="ai-typing-indicator" class="typing-indicator hidden">
                    <span></span><span></span><span></span>
                </div>
            </div>
        </div>

        <div class="ai-popup-footer">
            <div class="chat-input-wrapper">
                <input type="text" id="ai-chat-input" placeholder="Ask me anything..." />
                <button id="ai-chat-send" class="icon-btn send-btn"><i class="fas fa-paper-plane"></i></button>
            </div>
        </div>
    </div>
</div>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ai-buddy.css">
<script src="${pageContext.request.contextPath}/assets/js/ai-buddy.js" defer></script>
