<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Flight Details - Voyastra</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
</head>
<body style="padding-top: 80px; padding-bottom: 60px; overflow-x: hidden;">

    <jsp:include page="/components/header.jsp" />
    <jsp:include page="/components/booking-stepper.jsp"><jsp:param name="step" value="1"/></jsp:include>

    <div class="container" style="max-width: 800px; margin: 40px auto; padding: 0 20px;">

        <h1 class="text-white font-bold text-center mb-6" style="font-size: 2rem;">Review Flight Details</h1>

        <div style="background: rgba(255,255,255,0.03); border: 1px solid var(--color-border); border-radius: 16px; padding: 32px; margin-bottom: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 24px; margin-bottom: 24px;">
                <div style="display: flex; align-items: center; gap: 16px;">
                    <div style="font-size: 2.5rem;">✈️</div>
                    <div>
                        <div style="font-size: 1.5rem; font-weight: 800; color: var(--text-main);">${requestScope.from} &rarr; ${requestScope.to}</div>
                        <div style="color: var(--color-muted);">${requestScope.name} | Flight ${requestScope.id}</div>
                    </div>
                </div>
                <div style="text-align: right;">
                    <div style="font-size: 0.9rem; color: var(--color-muted);">Departure Date</div>
                    <div style="font-weight: 700; color: var(--text-main);">${requestScope.date}</div>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                <div>
                    <div style="font-size: 0.85rem; color: var(--color-muted); margin-bottom: 4px;">Class</div>
                    <div style="font-weight: 700; color: var(--text-main); text-transform: capitalize;">${requestScope.seatClass}</div>
                </div>
                <div>
                    <div style="font-size: 0.85rem; color: var(--color-muted); margin-bottom: 4px;">Passengers</div>
                    <div style="font-weight: 700; color: var(--text-main);">${requestScope.passengers} Adult(s)</div>
                </div>
                <div>
                    <div style="font-size: 0.85rem; color: var(--color-muted); margin-bottom: 4px;">Total Price</div>
                    <div style="font-size: 1.5rem; font-weight: 800; color: var(--color-primary);">₹${requestScope.price}</div>
                </div>
            </div>
        </div>

        <div style="display: flex; gap: 16px; justify-content: center;">
            <a href="javascript:history.back()" style="padding: 14px 24px; border-radius: 8px; font-weight: 700; color: var(--text-main); text-decoration: none; border: 1px solid rgba(255,255,255,0.2);">Back to Search</a>
            <form action="${pageContext.request.contextPath}/travellers" method="get">
                <button type="submit" class="btn-select" style="padding: 14px 32px; border-radius: 8px; font-weight: 800; background: var(--color-primary); color: #000; border: none; cursor: pointer; font-size: 1.1rem;">
                    Continue to Traveller Details &rarr;
                </button>
            </form>
        </div>
    </div>

    <jsp:include page="/components/footer.jsp" />
    <jsp:include page="/components/global_ui.jsp" />
</body>
</html>
