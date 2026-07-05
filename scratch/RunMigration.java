import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;

public class RunMigration {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            try {
                stmt.executeUpdate("ALTER TABLE posts ADD COLUMN rating INT DEFAULT NULL");
                System.out.println("Migration successful: rating column added.");
            } catch (Exception e) {
                System.out.println("Migration error or already applied: " + e.getMessage());
            }

            try (ResultSet rs = stmt.executeQuery("SHOW CREATE TABLE posts")) {
                if (rs.next()) {
                    System.out.println("Table schema: " + rs.getString(2));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
