<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Cab Search - Voyastra</title>
</head>
<body>
    <h1>Search Cabs</h1>
    <form action="<%=request.getContextPath()%>/transport/cab/booking" method="post">
        <button type="submit">Book Now</button>
    </form>
</body>
</html>
