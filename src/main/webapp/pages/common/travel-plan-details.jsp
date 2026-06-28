<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container" style="padding-top: 120px; min-height: 80vh;">
    <h1 class="text-main fw-bold">Travel Plan Details</h1>
    <p class="text-muted">Theme: <%= request.getParameter("theme") != null ? request.getParameter("theme") : "All Themes" %></p>
    <div class="glass-panel p-5 mt-4">
        <p>This is a dedicated page for Top Travel Plans themed around <%= request.getParameter("theme") != null ? request.getParameter("theme") : "various categories" %>.</p>
        <p>Content to be loaded dynamically from the backend.</p>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
