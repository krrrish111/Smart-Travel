<%@ page import="java.sql.*,com.voyastra.util.DBConnection" %>
<%
    out.println("<h3>Destinations:</h3><ul>");
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT id, title, is_featured, is_active FROM destinations")) {
        while (rs.next()) {
            out.println("<li>ID: " + rs.getInt("id") + " - " + rs.getString("title") + " (Featured: " + rs.getBoolean("is_featured") + ", Active: " + rs.getBoolean("is_active") + ")</li>");
        }
    } catch (Exception e) {
        out.println("<li>Error: " + e.getMessage() + "</li>");
    }
    out.println("</ul>");
%>
