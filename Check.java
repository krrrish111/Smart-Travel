import java.sql.*;

public class Check {
    public static void main(String[] args) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/voyastra?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true", "root", "Home@123");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, title, is_featured FROM destinations");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + ", Title: " + rs.getString("title") + ", Featured: " + rs.getBoolean("is_featured"));
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
