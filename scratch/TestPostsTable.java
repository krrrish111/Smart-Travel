import com.voyastra.util.DBConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestPostsTable {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SHOW CREATE TABLE posts")) {
            if (rs.next()) {
                System.out.println(rs.getString(2));
            } else {
                System.out.println("Table not found!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
