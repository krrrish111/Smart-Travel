import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class AlterPosts {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/voyastra?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true", "root", "Home@123");
            Statement stmt = conn.createStatement();
            stmt.executeUpdate("ALTER TABLE posts ADD COLUMN rating INT DEFAULT NULL");
            System.out.println("Table altered successfully!");
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
