<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Cruise Search - Voyastra</title>
</head>
<body>
    <h1>Search Cruises</h1>
    <form action="<%=request.getContextPath()%>/transport/cruise/booking" method="post">
        <button type="submit">Book Now</button>
    </form>
</body>
</html>
