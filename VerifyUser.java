import java.sql.*;
import com.voyastra.util.DBConnection;

public class VerifyUser {
    public static void main(String[] args) {
        String email = "arjun@example.com";
        String sql = "UPDATE users SET is_verified = 1 WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                System.out.println("SUCCESS: User " + email + " is now verified.");
            } else {
                System.out.println("FAILURE: User " + email + " not found or already verified.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
