import java.sql.*;
import com.voyastra.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

public class CreateAdmin {
    public static void main(String[] args) {
        String email = "admin@voyastra.com";
        String password = "adminpassword"; // Using a simple one for testing
        String name = "Master Admin";
        String role = "admin";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Check if exists
            PreparedStatement check = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();
            
            if (rs.next()) {
                // Update
                PreparedStatement update = conn.prepareStatement("UPDATE users SET role = 'admin', is_verified = 1, password = ? WHERE email = ?");
                update.setString(1, BCrypt.hashpw(password, BCrypt.gensalt(12)));
                update.setString(2, email);
                update.executeUpdate();
                System.out.println("SUCCESS: Existing user " + email + " promoted to Admin and password reset.");
            } else {
                // Insert
                PreparedStatement insert = conn.prepareStatement("INSERT INTO users (name, email, password, role, is_verified) VALUES (?, ?, ?, ?, 1)");
                insert.setString(1, name);
                insert.setString(2, email);
                insert.setString(3, BCrypt.hashpw(password, BCrypt.gensalt(12)));
                insert.setString(4, role);
                insert.executeUpdate();
                System.out.println("SUCCESS: Admin user " + email + " created.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
