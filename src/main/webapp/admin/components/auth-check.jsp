<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Backend session and role validation
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("user_id") == null || !"admin".equals(adminSession.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login?error=adminRequired");
        return;
    }
%>
