<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/ai-buddy.css">

<!-- Layer 1: Floating AI Orb -->
<div class="ai-orb" id="aiOrb" onclick="toggleAIChat()">
    <i class="ri-robot-2-line"></i>
</div>

<!-- Layer 2: Context Tooltip -->
<div class="ai-tooltip" id="aiTooltip">
    <span id="aiTooltipText">Need help planning your trip?</span>
</div>

<!-- Layer 3: Full AI Chat Window -->
<div class="ai-chat-window" id="aiChatWindow">
    <div class="ai-chat-header">
        <div class="ai-chat-title">
            <i class="ri-sparkling-line text-primary"></i>
            <span>Voyastra AI Buddy</span>
        </div>
        <button onclick="toggleAIChat()" class="text-muted hover:text-white bg-transparent border-none cursor-pointer">
            <i class="ri-close-line text-xl"></i>
        </button>
    </div>
    
    <div class="ai-chat-body" id="aiChatBody">
        <div class="chat-bubble chat-ai">
            Hi! I'm your global travel assistant. I adapt to whatever page you're on. How can I help today?
        </div>
    </div>
    
    <div class="ai-chat-input-area">
        <input type="text" id="aiChatInput" class="ai-chat-input" placeholder="Ask me anything..." onkeypress="handleAIChatKeyPress(event)">
        <button class="ai-chat-send" onclick="sendAIMessage()">
            <i class="ri-send-plane-fill"></i>
        </button>
    </div>
</div>

<script>
    // Context mapping for Tooltip
    document.addEventListener("DOMContentLoaded", function() {
        const path = window.location.pathname;
        let tooltipText = "Need help planning your trip?";
        
        if (path.includes("/budget")) {
            tooltipText = "Analyze my current spending limit.";
        } else if (path.includes("/command-center")) {
            tooltipText = "Is there any bad weather expected?";
        } else if (path.includes("/hotels")) {
            tooltipText = "Find me the best rated hotels here.";
        } else if (path.includes("/explore")) {
            tooltipText = "Discover hidden gems nearby.";
        }
        
        document.getElementById("aiTooltipText").innerText = tooltipText;
        
        // Show tooltip briefly on load
        setTimeout(() => {
            const tooltip = document.getElementById("aiTooltip");
            if (!document.getElementById("aiChatWindow").classList.contains("open")) {
                tooltip.classList.add("show");
                setTimeout(() => {
                    tooltip.classList.remove("show");
                }, 5000);
            }
        }, 2000);
    });

    function toggleAIChat() {
        const chatWindow = document.getElementById("aiChatWindow");
        const tooltip = document.getElementById("aiTooltip");
        
        if (chatWindow.classList.contains("open")) {
            chatWindow.classList.remove("open");
        } else {
            chatWindow.classList.add("open");
            tooltip.classList.remove("show");
            document.getElementById("aiChatInput").focus();
        }
    }

    function handleAIChatKeyPress(event) {
        if (event.key === "Enter") {
            sendAIMessage();
        }
    }

    function sendAIMessage() {
        const inputField = document.getElementById("aiChatInput");
        const message = inputField.value.trim();
        if (!message) return;
        
        // 1. Add user message to UI
        appendMessage(message, "user");
        inputField.value = "";
        
        // 2. Add typing indicator
        const typingId = "typing-" + Date.now();
        appendTypingIndicator(typingId);
        
        // 3. Send to Backend
        const contextPath = window.location.pathname;
        const formData = new URLSearchParams();
        formData.append("message", message);
        formData.append("context", contextPath);
        
        fetch("${pageContext.request.contextPath}/api/ai-buddy", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData.toString()
        })
        .then(response => {
            if(!response.ok) throw new Error("API Error");
            return response.json();
        })
        .then(data => {
            removeTypingIndicator(typingId);
            appendMessage(data.reply, "ai");
        })
        .catch(error => {
            console.error(error);
            removeTypingIndicator(typingId);
            appendMessage("Sorry, my connection to the Voyastra intelligence core was interrupted.", "ai");
        });
    }

    function appendMessage(text, sender) {
        const chatBody = document.getElementById("aiChatBody");
        const bubble = document.createElement("div");
        bubble.className = "chat-bubble " + (sender === "user" ? "chat-user" : "chat-ai");
        bubble.innerText = text;
        chatBody.appendChild(bubble);
        chatBody.scrollTop = chatBody.scrollHeight;
    }
    
    function appendTypingIndicator(id) {
        const chatBody = document.getElementById("aiChatBody");
        const indicator = document.createElement("div");
        indicator.className = "typing-indicator";
        indicator.id = id;
        indicator.innerHTML = '<div class="typing-dot"></div><div class="typing-dot"></div><div class="typing-dot"></div>';
        chatBody.appendChild(indicator);
        chatBody.scrollTop = chatBody.scrollHeight;
    }
    
    function removeTypingIndicator(id) {
        const el = document.getElementById(id);
        if (el) el.remove();
    }
</script>
