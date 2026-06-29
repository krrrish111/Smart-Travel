<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container mx-auto px-4 relative flex flex-col items-center justify-center" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh;">
    
    <div class="glass-panel p-10 rounded-3xl max-w-2xl w-full text-center slide-up">
        <div class="w-20 h-20 rounded-full bg-primary/20 text-primary flex items-center justify-center mx-auto mb-6">
            <i class="ri-radar-line text-4xl"></i>
        </div>
        <h1 class="text-primary mb-2 editorial" style="font-size: 2.5rem;">Travel Command Center</h1>
        <p class="text-muted mb-8">Real-time Weather Intelligence, Crowd Forecasting & Safety Analysis.</p>
        
        <form action="${pageContext.request.contextPath}/command-center" method="get" class="relative">
            <input type="text" name="destination" class="form-control text-xl py-4 pl-12 rounded-full text-center voyastra-autocomplete location-autocomplete" placeholder="Where are you planning to go?" required>
            <i class="ri-search-2-line absolute left-6 top-1/2 transform -translate-y-1/2 text-muted text-xl"></i>
            <button type="submit" class="btn btn-primary absolute right-2 top-1/2 transform -translate-y-1/2 rounded-full px-6 py-2">Analyze</button>
        </form>
        
        <div class="mt-8 flex gap-4 justify-center">
            <a href="${pageContext.request.contextPath}/command-center?destination=Goa" class="btn btn-outline btn-sm rounded-full">Explore Goa</a>
            <a href="${pageContext.request.contextPath}/command-center?destination=Gokarna" class="btn btn-outline btn-sm rounded-full">Explore Gokarna</a>
        </div>
    </div>
    
</main>

<%@ include file="/components/footer.jsp" %>
