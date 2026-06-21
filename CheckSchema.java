import java.sql.*;
public class CheckSchema {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/voyastra?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true", "root", "Home@123");
            ResultSet rs = conn.getMetaData().getColumns(null, null, "posts", null);
            while (rs.next()) {
                System.out.println(rs.getString("COLUMN_NAME"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
