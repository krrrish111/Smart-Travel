import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;

public class HashPassword {
    public static void main(String[] args) throws Exception {
        String plain = "Admin@1234";
        String hashed = BCrypt.hashpw(plain, BCrypt.gensalt(12));
        System.out.println("Hash: " + hashed);

        String url = "jdbc:mysql://localhost:3306/voyastra?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        try (Connection conn = DriverManager.getConnection(url, "root", "Home@123")) {
            PreparedStatement ps = conn.prepareStatement("UPDATE users SET password=? WHERE email='admin@voyastra.com'");
            ps.setString(1, hashed);
            ps.executeUpdate();
            System.out.println("Password updated successfully with BCrypt hash.");
        }
    }
}
