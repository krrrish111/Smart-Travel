<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container mx-auto px-4 relative" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh;">
    
    <div class="mb-6 flex justify-between items-center slide-up">
        <div>
            <a href="${pageContext.request.contextPath}/trip-groups" class="text-sm text-muted hover:text-primary mb-2 inline-block"><i class="ri-arrow-left-line"></i> Back to Groups</a>
            <h1 class="text-primary editorial" style="font-size: 2.5rem;">${group.name}</h1>
            <p class="text-muted text-sm">Created on ${group.created_at}</p>
        </div>
        <button class="btn btn-primary rounded-full px-6" onclick="copyInviteLink()"><i class="ri-links-line mr-2"></i>Invite Link</button>
    </div>

    <!-- Tabs -->
    <div class="flex gap-4 border-b border-white/10 mb-8 overflow-x-auto pb-2 custom-scrollbar slide-up delay-1">
        <button class="px-4 py-2 text-main border-b-2 border-primary font-bold tab-btn" onclick="switchTab('overview', this)">Overview</button>
        <button class="px-4 py-2 text-muted hover:text-main font-bold tab-btn" onclick="switchTab('members', this)">Members</button>
        <button class="px-4 py-2 text-muted hover:text-main font-bold tab-btn" onclick="switchTab('expenses', this)">Expenses</button>
        <button class="px-4 py-2 text-muted hover:text-main font-bold tab-btn" onclick="switchTab('voting', this)">Voting</button>
        <button class="px-4 py-2 text-muted hover:text-main font-bold tab-btn" onclick="switchTab('chat', this)">Chat</button>
    </div>

    <!-- Tab Contents -->
    <div id="tab-overview" class="tab-content slide-up delay-2">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="glass-panel p-6 rounded-2xl md:col-span-2">
                <h3 class="text-main font-bold mb-4">Trip Timeline</h3>
                <div class="text-center p-10 text-muted border border-dashed border-white/10 rounded-xl">
                    <i class="ri-calendar-event-line text-4xl mb-3 block"></i>
                    <p>No timeline events yet. Start by generating an AI itinerary.</p>
                </div>
            </div>
            <div class="glass-panel p-6 rounded-2xl border border-primary/20 bg-primary/5">
                <h3 class="text-primary font-bold mb-4 flex items-center"><i class="ri-robot-2-line mr-2"></i> AI Assistant</h3>
                <p class="text-sm text-muted/90 italic">"Most group members haven't added activities yet. I recommend starting a poll to decide the destination."</p>
                <button class="btn btn-outline btn-sm w-full mt-4" onclick="switchTab('voting', document.querySelectorAll('.tab-btn')[3])">Create Poll</button>
            </div>
        </div>
    </div>

    <div id="tab-members" class="tab-content hidden">
        <div class="glass-panel p-6 rounded-2xl max-w-2xl">
            <h3 class="text-main font-bold mb-4">Group Members</h3>
            <div class="flex flex-col gap-3">
                <c:forEach var="member" items="${members}">
                    <div class="flex justify-between items-center p-3 hover:bg-white/5 rounded-xl border border-white/5">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-purple-600 flex items-center justify-center text-white font-bold">
                                ${member.name.substring(0,1)}
                            </div>
                            <div>
                                <h4 class="text-main text-sm font-bold">${member.name}</h4>
                                <p class="text-xs text-muted">${member.role}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div id="tab-expenses" class="tab-content hidden">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <!-- Balances & Summary -->
            <div class="flex flex-col gap-6">
                <div class="glass-panel p-6 rounded-2xl">
                    <h3 class="text-main font-bold mb-2">Total Group Spent</h3>
                    <h2 class="text-3xl font-mono font-bold text-main">₹${totalSpent}</h2>
                </div>

                <div class="glass-panel p-6 rounded-2xl">
                    <h3 class="text-main font-bold mb-4">Balances</h3>
                    <div class="flex flex-col gap-3">
                        <c:forEach var="bal" items="${settlements}">
                            <div class="flex justify-between items-center text-sm p-2 bg-white/5 rounded-lg border border-white/5">
                                <span class="text-muted font-bold">${bal.name}</span>
                                <c:choose>
                                    <c:when test="${bal.balance > 0}">
                                        <span class="text-green-400 font-mono font-bold">Gets back ₹${bal.balance}</span>
                                    </c:when>
                                    <c:when test="${bal.balance < 0}">
                                        <span class="text-red-400 font-mono font-bold">Owes ₹${-bal.balance}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted font-mono font-bold">Settled up</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Expense List & Add -->
            <div class="md:col-span-2 glass-panel p-6 rounded-2xl">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-main font-bold">Expenses</h3>
                    <button class="btn btn-primary btn-sm rounded-full" onclick="document.getElementById('expenseModal').style.display='flex'"><i class="ri-add-line mr-1"></i>Add Expense</button>
                </div>
                
                <div class="flex flex-col gap-4">
                    <c:if test="${empty expenses}">
                        <div class="text-center p-10 text-muted">No expenses yet.</div>
                    </c:if>
                    <c:forEach var="exp" items="${expenses}">
                        <div class="flex justify-between items-center p-4 hover:bg-white/5 rounded-xl border border-white/5 transition-all">
                            <div>
                                <h4 class="text-main font-bold text-sm mb-1">${exp.description}</h4>
                                <p class="text-xs text-muted">Paid by <span class="text-primary font-bold">${exp.payer_name}</span></p>
                            </div>
                            <div class="text-right">
                                <h4 class="text-main font-bold font-mono">₹${exp.amount}</h4>
                                <p class="text-xs text-muted">${exp.created_at.toString().substring(0, 10)}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    
    <div id="tab-voting" class="tab-content hidden">
        <div class="glass-panel p-6 rounded-2xl">
            <h3 class="text-main font-bold mb-4">Active Polls</h3>
            <div class="text-center p-10 text-muted border border-dashed border-white/10 rounded-xl mb-4">
                <i class="ri-bar-chart-2-line text-4xl mb-3 block"></i>
                <p>No active polls. (Coming soon)</p>
            </div>
        </div>
    </div>
    
    <div id="tab-chat" class="tab-content hidden">
        <div class="glass-panel p-6 rounded-2xl flex flex-col h-[500px]">
            <h3 class="text-main font-bold mb-4 border-b border-white/10 pb-4">Group Chat</h3>
            <div class="flex-1 overflow-y-auto p-4 custom-scrollbar text-center text-muted flex items-center justify-center">
                Chat functionality coming soon.
            </div>
            <div class="mt-4 flex gap-2">
                <input type="text" class="form-control flex-1" placeholder="Type a message..." disabled>
                <button class="btn btn-primary" disabled><i class="ri-send-plane-fill"></i></button>
            </div>
        </div>
    </div>

</main>

<!-- Add Expense Modal -->
<div id="expenseModal" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 hidden flex-col items-center justify-center p-4" style="display: none;">
    <div class="glass-panel p-6 rounded-2xl max-w-md w-full relative slide-up">
        <button class="absolute top-4 right-4 text-muted hover:text-white" onclick="document.getElementById('expenseModal').style.display='none'"><i class="ri-close-line text-2xl"></i></button>
        <h3 class="text-main font-bold mb-6 text-xl">Add Expense</h3>
        <form action="${pageContext.request.contextPath}/trip-groups" method="post">
            <input type="hidden" name="action" value="add_expense">
            <input type="hidden" name="groupId" value="${group.id}">
            
            <div class="form-group mb-4">
                <label class="text-xs text-muted font-bold uppercase tracking-wider block mb-2">Description</label>
                <input type="text" name="description" class="form-control" placeholder="e.g., Dinner at Ritz" required>
            </div>
            
            <div class="form-group mb-4">
                <label class="text-xs text-muted font-bold uppercase tracking-wider block mb-2">Amount (₹)</label>
                <input type="number" step="0.01" name="amount" class="form-control text-2xl font-mono" placeholder="0.00" required>
            </div>
            
            <div class="bg-primary/10 text-primary text-xs p-3 rounded-lg mb-6 border border-primary/20">
                <i class="ri-information-line mr-1"></i> This expense will be split equally among all ${members.size()} group members.
            </div>
            
            <button type="submit" class="btn btn-primary w-full py-3 rounded-full font-bold">Save Expense</button>
        </form>
    </div>
</div>

<script>
    function switchTab(tabId, btn) {
        document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
        document.querySelectorAll('.tab-btn').forEach(el => {
            el.classList.remove('border-b-2', 'border-primary', 'text-main');
            el.classList.add('text-muted');
        });
        
        document.getElementById('tab-' + tabId).classList.remove('hidden');
        btn.classList.remove('text-muted');
        btn.classList.add('border-b-2', 'border-primary', 'text-main');
    }

    function copyInviteLink() {
        const url = window.location.origin + "${pageContext.request.contextPath}/trip-groups?id=${group.id}&invite=true";
        navigator.clipboard.writeText(url).then(() => {
            VoyastraToast.show("Invite link copied to clipboard!", "success");
        });
    }
    
    // Check URL parameters for tab
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');
    if (tab) {
        const btns = document.querySelectorAll('.tab-btn');
        for(let b of btns) {
            if(b.innerText.toLowerCase() === tab) {
                switchTab(tab, b);
                break;
            }
        }
    }
</script>

<%@ include file="/components/footer.jsp" %>
