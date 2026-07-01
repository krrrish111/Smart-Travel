<%@ page import="java.sql.*, java.util.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/voyastra";
    String user = "root";
    String password = "Home@123";
    try (Connection conn = DriverManager.getConnection(url, user, password);
         Statement stmt = conn.createStatement()) {
         
        out.println("<h2>All Hotels</h2>");
        ResultSet rs1 = stmt.executeQuery("SELECT id, name FROM hotels");
        while(rs1.next()) {
            out.println(rs1.getInt(1) + " - " + rs1.getString(2) + "<br>");
        }
        
        out.println("<h2>Recommended Hotels Query Result</h2>");
        String q = "SELECT * FROM hotels WHERE id IN (SELECT min_id FROM (SELECT MIN(id) as min_id FROM hotels GROUP BY name) as temp) ORDER BY rating DESC, id DESC LIMIT 4";
        ResultSet rs2 = stmt.executeQuery(q);
        while(rs2.next()) {
            out.println(rs2.getInt("id") + " - " + rs2.getString("name") + "<br>");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
