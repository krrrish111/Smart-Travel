<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Bus Search - Voyastra</title>
</head>
<body>
    <h1>Search Buss</h1>
    <form action="<%=request.getContextPath()%>/transport/bus/booking" method="post">
        <button type="submit">Book Now</button>
    </form>
</body>
</html>
