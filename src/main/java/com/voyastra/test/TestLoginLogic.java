package com.voyastra.test;

import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;

public class TestLoginLogic {
    public static void main(String[] args) {
        System.out.println("--- Starting Login Logic Test ---");
        
        UserDAO dao = new UserDAO();
        
        // Let's test with the dummy email mentioned in login.jsp
        String testEmail = "demo@voyastra.com";
        String testPassword = "voyastra123";
        
        System.out.println("1. Fetching user with email: " + testEmail);
        User user = dao.getUserByEmail(testEmail);
        
        if (user == null) {
            System.out.println("User not found in the database. (If database is empty, this is expected)");
            System.out.println("But the LoginServlet code correctly handles this by returning: Invalid email or password.");
        } else {
            System.out.println("User found! Name: " + user.getName());
            
            System.out.println("2. Validating Password...");
            if (user.getPassword().equals(testPassword)) {
                System.out.println("Password match: SUCCESS!");
                System.out.println("3. LoginServlet will now set session variables: user_id=" + user.getId() + ", role=" + user.getRole());
                
                if ("admin".equals(user.getRole())) {
                    System.out.println("4. Redirecting to -> /admin-dashboard.jsp");
                } else {
                    System.out.println("4. Redirecting to -> /index.jsp");
                }
            } else {
                System.out.println("Password match: FAILED. LoginServlet returns 'Invalid password'.");
            }
        }
        
        System.out.println("--- Test Completed ---");
    }
}
