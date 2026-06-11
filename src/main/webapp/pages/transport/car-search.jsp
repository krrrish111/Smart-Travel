<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Car Search - Voyastra</title>
</head>
<body>
    <h1>Search Cars</h1>
    <form action="<%=request.getContextPath()%>/transport/car/booking" method="post">
        <button type="submit">Book Now</button>
    </form>
</body>
</html>
