import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;

public class DBAudit {
    private static final Map<String, String> env = new HashMap<>();

    public static void main(String[] args) {
        System.out.println("=== START DB AUDIT RUNTIME TRACE ===");
        
        // 1. Load .env
        try (BufferedReader reader = new BufferedReader(new FileReader(".env"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmedLine = line.trim();
                if (trimmedLine.isEmpty() || trimmedLine.startsWith("#")) {
                    continue;
                }
                int eqIdx = trimmedLine.indexOf("=");
                if (eqIdx > 0) {
                    String key = trimmedLine.substring(0, eqIdx).trim();
                    String value = trimmedLine.substring(eqIdx + 1).trim();
                    env.put(key, value);
                }
            }
            System.out.println("Loaded .env settings successfully.");
        } catch (Exception e) {
            System.out.println("Failed to load .env file: " + e.getMessage());
        }

        // 2. Establish connection
        String dbHost = env.get("DB_HOST");
        String dbPort = env.getOrDefault("DB_PORT", "3306");
        String dbName = env.get("DB_NAME");
        String dbUser = env.get("DB_USER");
        String dbPassword = env.get("DB_PASSWORD");
        
        // Fix: Use Aiven avnadmin if DB_USER is voyastra_user locally or not set correctly
        if (dbUser == null || dbUser.isEmpty() || dbUser.equals("voyastra_user")) {
            dbUser = "avnadmin";
        }

        String jdbcUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?sslMode=REQUIRED&zeroDateTimeBehavior=convertToNull";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            System.out.println("Failed to load Driver: " + e.getMessage());
            return;
        }

        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
            System.out.println("Connection established successfully!");
            System.out.println("Catalog: " + conn.getCatalog());

            // Check if users table exists with conn.getCatalog()
            boolean usersExistsWithCatalog = false;
            try (ResultSet rs = conn.getMetaData().getTables(conn.getCatalog(), null, "users", null)) {
                if (rs.next()) {
                    usersExistsWithCatalog = true;
                    System.out.println("Table 'users' exists with conn.getCatalog() = " + conn.getCatalog());
                } else {
                    System.out.println("Table 'users' DOES NOT exist with conn.getCatalog() = " + conn.getCatalog());
                }
            }

            // Check if users table exists with null catalog
            boolean usersExistsWithNull = false;
            try (ResultSet rs = conn.getMetaData().getTables(null, null, "users", null)) {
                while (rs.next()) {
                    usersExistsWithNull = true;
                    System.out.println("Table 'users' exists in catalog: " + rs.getString("TABLE_CAT") + ", schema: " + rs.getString("TABLE_SCHEM"));
                }
            }

            if (!usersExistsWithCatalog) {
                System.out.println("Initializing schema using src/main/resources/bootstrap.sql...");
                File bootstrapFile = new File("src/main/resources/bootstrap.sql");
                if (bootstrapFile.exists()) {
                    try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(bootstrapFile), StandardCharsets.UTF_8))) {
                        StringBuilder sqlBuilder = new StringBuilder();
                        String line;
                        while ((line = reader.readLine()) != null) {
                            String trimmed = line.trim();
                            if (trimmed.isEmpty() || trimmed.startsWith("--") || trimmed.startsWith("#") || trimmed.startsWith("//")) {
                                continue;
                            }
                            sqlBuilder.append(line).append("\n");
                        }

                        String[] statements = sqlBuilder.toString().split(";");
                        System.out.println("Parsed " + statements.length + " statements from bootstrap.sql.");
                        int count = 0;
                        try (Statement stmt = conn.createStatement()) {
                            stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
                            for (String statement : statements) {
                                String execSql = statement.trim();
                                if (!execSql.isEmpty()) {
                                    count++;
                                    stmt.execute(execSql);
                                }
                            }
                            stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
                            System.out.println("Database schema setup complete.");
                        }
                    } catch (Exception e) {
                        System.out.println("Failed to execute bootstrap.sql: " + e.getMessage());
                    }
                }
            }

            // SHOW TABLES
            System.out.println("Current tables in database after bootstrap:");
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SHOW TABLES")) {
                while (rs.next()) {
                    System.out.println(" - " + rs.getString(1));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        System.out.println("=== END DB AUDIT RUNTIME TRACE ===");
    }
}
