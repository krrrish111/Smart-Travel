<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main class="container" style="padding-top: 120px; min-height: 80vh;">
    <h1 class="text-main fw-bold">Experience Details</h1>
    <p class="text-muted">Activity: <%= request.getParameter("activity") != null ? request.getParameter("activity") : "General Experience" %></p>
    <div class="glass-panel p-5 mt-4">
        <p>This is a dedicated page for the Must-Do Things section featuring: <%= request.getParameter("activity") != null ? request.getParameter("activity") : "exciting activities" %>.</p>
        <p>Detailed information, booking options, and galleries will be populated here.</p>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
