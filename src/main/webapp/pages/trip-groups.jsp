<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container mx-auto px-4 relative" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh;">
    <div class="text-center mb-6 slide-up">
        <h1 class="text-primary mb-1 editorial" style="font-size: 2.5rem;">Trip Groups & Expenses</h1>
        <p class="text-muted text-sm">Manage your travel buddies and split expenses easily (Splitwise Clone).</p>
    </div>

    <div class="glass-panel max-w-lg mx-auto p-6 text-center" style="border-radius: 20px;">
        <h3 class="text-main font-bold mb-4">Create a New Trip Group</h3>
        <form action="${pageContext.request.contextPath}/trip-groups" method="post">
            <input type="hidden" name="action" value="create">
            <div class="form-group mb-4">
                <input type="text" name="groupName" class="form-control text-center" placeholder="e.g., Goa Boys Trip 2026" required>
            </div>
            <button type="submit" class="btn btn-primary w-full" style="border-radius: 50px;">Create Group</button>
        </form>
    </div>
    
    <div class="mt-8 text-center text-muted">
        <p>This is the core foundation for the Splitwise clone integration.</p>
        <p>Future iterations will include expense adding, splitting math, and Venmo/Razorpay P2P integration.</p>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
