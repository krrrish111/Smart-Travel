import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;

public class ExecuteSQL {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voyastra", "root", "root");
                 Statement stmt = conn.createStatement()) {
                
                String sqlFile = "c:\\Users\\Dell\\Desktop\\antigravity\\sql\\super_app_tables.sql";
                String content = new String(Files.readAllBytes(Paths.get(sqlFile)));
                String[] queries = content.split(";");
                
                for (String query : queries) {
                    if (!query.trim().isEmpty()) {
                        stmt.execute(query.trim());
                        System.out.println("Executed: " + query.trim().substring(0, Math.min(30, query.trim().length())) + "...");
                    }
                }
                System.out.println("Success");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
