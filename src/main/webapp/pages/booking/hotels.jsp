<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 80px; overflow-x: hidden;">
    <div class="container relative z-10" style="margin-top: 20px;">
        <jsp:include page="/components/hotel-search.jsp"/>


    </div>
</main>
<%@ include file="/components/footer.jsp" %>