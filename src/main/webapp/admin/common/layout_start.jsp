<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/admin/components/auth-check.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voyastra Admin Dashboard</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,600;1,600&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Expose Session Variables to JS -->
    <script>
        window.CONTEXT_PATH = "${pageContext.request.contextPath}";
        window.javaSession = {
            userId: "${sessionScope.user_id}",
            role: "${sessionScope.role}",
            name: "${sessionScope.name}",
            email: "${sessionScope.email}"
        };
    </script>
</head>
<body class="admin-body">

<div class="admin-sidebar-overlay" id="adminSidebarOverlay" onclick="toggleAdminSidebar()"></div>
<div class="admin-layout-wrapper" id="adminDashboardLayout">
    
    <!-- SIDEBAR -->
    <jsp:include page="/admin/components/sidebar.jsp" />

    <!-- CONTENT AREA -->
    <main class="admin-content">
        
        <!-- ADMIN TOPBAR -->
        <jsp:include page="/admin/components/topbar.jsp" />
