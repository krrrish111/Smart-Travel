import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class DBInit {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            stmt.execute("CREATE TABLE IF NOT EXISTS site_content (" +
                         "id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "section_type VARCHAR(50) NOT NULL UNIQUE, " +
                         "title TEXT, " +
                         "subtitle TEXT, " +
                         "is_active BOOLEAN DEFAULT TRUE, " +
                         "display_order INT DEFAULT 0)");
            
            stmt.execute("INSERT IGNORE INTO site_content (section_type, title, subtitle, is_active, display_order) " +
                         "VALUES ('hero', 'Experience', 'Say goodbye to endless research. Our intelligent platform crafts hyper-personalized itineraries, seamlessly balancing iconic landmarks with undiscovered cultural treasures.', TRUE, 1)");
            
            stmt.execute("INSERT IGNORE INTO site_content (section_type, title, subtitle, is_active, display_order) " +
                         "VALUES ('promotion', 'Summer Special: 20% Off', 'Use code SUMMER20 for all European trips.', TRUE, 2)");
                         
            System.out.println("Success!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
