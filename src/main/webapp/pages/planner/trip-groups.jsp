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
    
    <div class="mt-8">
        <h3 class="text-main font-bold mb-4 text-center">My Groups</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 max-w-2xl mx-auto">
            <c:if test="${empty myGroups}">
                <div class="col-span-full text-center p-6 text-muted border border-dashed border-white/10 rounded-xl">
                    You aren't in any groups yet.
                </div>
            </c:if>
            <c:forEach var="grp" items="${myGroups}">
                <a href="${pageContext.request.contextPath}/trip-groups?id=${grp.id}" class="glass-panel p-6 rounded-2xl hover:border-primary/50 transition-all text-center flex flex-col items-center justify-center">
                    <div class="w-12 h-12 rounded-full bg-primary/20 text-primary flex items-center justify-center mb-3">
                        <i class="ri-group-line text-2xl"></i>
                    </div>
                    <h4 class="text-main font-bold mb-1">${grp.name}</h4>
                    <p class="text-xs text-muted">Click to view dashboard</p>
                </a>
            </c:forEach>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
