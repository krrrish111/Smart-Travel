<%@ page import="java.sql.*, com.voyastra.util.DBConnection" %>
<%
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM hotels");
        rs.next();
        int count = rs.getInt(1);
        out.println("Current hotel count: " + count + "<br>");
        
        if (count <= 1) {
            out.println("Populating hotels...<br>");
            String insert = "INSERT INTO hotels (name, city, address, description, rating, imageUrl, amenities, latitude, longitude, best_seller, recommended, starting_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insert)) {
                Object[][] hotels = {
                    {"Oceanview Retreat", "Bali", "123 Beachfront Ave", "Beautiful ocean views.", 4.8, "https://images.unsplash.com/photo-1522798514-97ceb8c4f1c8", "WiFi,Pool,Spa", -8.409518, 115.188919, true, true, 250.0},
                    {"Alpine Lodge", "Zurich", "45 Mountain Rd", "Cozy lodge in the alps.", 4.7, "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4", "WiFi,Heater,Ski", 47.3769, 8.5417, false, true, 300.0},
                    {"Urban Boutique", "Tokyo", "789 Downtown St", "Modern stay in the city center.", 4.9, "https://images.unsplash.com/photo-1512453979436-5a50ce8c5d18", "WiFi,Gym,Bar", 35.6762, 139.6503, true, true, 200.0},
                    {"Desert Oasis", "Dubai", "101 Sand Dunes Blvd", "Luxury oasis in the desert.", 4.9, "https://images.unsplash.com/photo-1542314831-c6a4d27ece50", "WiFi,Pool,Air Conditioning", 25.2048, 55.2708, true, true, 500.0},
                    {"Historic Palace", "Rome", "222 Colosseum Way", "Live like royalty in Rome.", 4.6, "https://images.unsplash.com/photo-1534438327276-14e5300c3a48", "WiFi,Restaurant,Tour", 41.9028, 12.4964, false, true, 180.0}
                };
                for (Object[] h : hotels) {
                    pstmt.setString(1, (String) h[0]);
                    pstmt.setString(2, (String) h[1]);
                    pstmt.setString(3, (String) h[2]);
                    pstmt.setString(4, (String) h[3]);
                    pstmt.setDouble(5, (Double) h[4]);
                    pstmt.setString(6, (String) h[5]);
                    pstmt.setString(7, (String) h[6]);
                    pstmt.setDouble(8, (Double) h[7]);
                    pstmt.setDouble(9, (Double) h[8]);
                    pstmt.setBoolean(10, (Boolean) h[9]);
                    pstmt.setBoolean(11, (Boolean) h[10]);
                    pstmt.setDouble(12, (Double) h[11]);
                    pstmt.executeUpdate();
                }
            }
            out.println("Hotels populated successfully.<br>");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
