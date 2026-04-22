package com.voyastra.util;

import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;
import java.util.UUID;

public class UserSeeder {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        
        seed(dao, "admin@voyastra.com", "Admin@123", "Voyastra Admin", "admin");
        seed(dao, "user@voyastra.com", "User@123", "Voyastra User", "user");
    }
    
    private static void seed(UserDAO dao, String email, String pass, String name, String role) {
        if (dao.emailExists(email)) {
            System.out.println("User " + email + " already exists. Resetting password.");
            User existing = dao.getUserByEmail(email);
            dao.updatePassword(existing.getId(), pass);
        } else {
            User u = new User();
            u.setName(name);
            u.setEmail(email);
            u.setPassword(pass);
            u.setRole(role);
            u.setVerified(true);
            u.setVerificationToken(UUID.randomUUID().toString());
            dao.registerUser(u);
            System.out.println("SUCCESS: Created " + role + " user: " + email);
        }
    }
}
