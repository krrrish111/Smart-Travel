<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Helicopter Search - Voyastra</title>
</head>
<body>
    <h1>Search Helicopters</h1>
    <form action="<%=request.getContextPath()%>/transport/helicopter/booking" method="post">
        <button type="submit">Book Now</button>
    </form>
</body>
</html>
