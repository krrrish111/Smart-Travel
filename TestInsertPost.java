import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestInsertPost {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/voyastra?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true", "root", "Home@123");
            String query = "INSERT INTO posts (user_id, content, location, image_url, category, hashtags) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, 2); // assuming user 2 exists
            stmt.setString(2, "This is a test post from Antigravity");
            stmt.setString(3, "Bangalore");
            stmt.setString(4, "");
            stmt.setString(5, "For You");
            stmt.setString(6, "#test");
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                System.out.println("Insert successful!");
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    System.out.println("New post ID: " + rs.getInt(1));
                }
            } else {
                System.out.println("Insert failed.");
            }
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
