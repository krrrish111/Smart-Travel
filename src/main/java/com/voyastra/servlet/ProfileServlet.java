package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.ItineraryDAO;
import com.voyastra.model.User;
import com.voyastra.model.Booking;
import com.voyastra.model.Itinerary;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * ProfileServlet — handles user profile view and edit routing.
 * Ensures that users are redirected to the correct profile page based on their role.
 */
@WebServlet("/profile")
@javax.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15   // 15MB
)
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final ItineraryDAO itineraryDAO = new ItineraryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required&redirect=profile");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String role = (String) session.getAttribute("role");
        
        // Admin redirect logic
        if ("admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/profile");
            return;
        }

        // 1. Fetch User Data
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);

        // 2. Fetch Recent Bookings
        List<Booking> recentBookings = bookingDAO.getBookingsByUser(userId);
        request.setAttribute("bookings", recentBookings);

        // 3. Fetch Saved Itineraries
        List<Itinerary> savedPlans = itineraryDAO.getByUser(userId);
        request.setAttribute("savedPlans", savedPlans);

        // 4. Calculate Stats
        int totalTrips = recentBookings.size();
        long completedTrips = recentBookings.stream().filter(b -> "COMPLETED".equalsIgnoreCase(b.getStatus())).count();
        long upcomingTrips = recentBookings.stream().filter(b -> "CONFIRMED".equalsIgnoreCase(b.getStatus())).count();
        int savedCount = savedPlans.size();

        request.setAttribute("totalTrips", totalTrips);
        request.setAttribute("completedTrips", (int)completedTrips);
        request.setAttribute("upcomingTrips", (int)upcomingTrips);
        request.setAttribute("savedCount", savedCount);

        request.getRequestDispatcher("/pages/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleUpdateProfile(request, response, userId);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(request, response, userId);
        } else if ("deleteAccount".equals(action)) {
            handleDeleteAccount(request, response, userId);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_action");
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException, ServletException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String location = request.getParameter("location");
        String bio = request.getParameter("bio");

        User user = userDAO.getUserById(userId);
        user.setName(name);
        user.setPhone(phone);
        user.setLocation(location);
        user.setBio(bio);

        // Handle Image Upload
        javax.servlet.http.Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = "profile_" + userId + "_" + System.currentTimeMillis() + ".jpg";
            String uploadPath = getServletContext().getRealPath("/") + "uploads/profiles";
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + java.io.File.separator + fileName);
            user.setProfileImage("uploads/profiles/" + fileName);
        }

        if (userDAO.updateUserProfile(user)) {
            response.sendRedirect(request.getContextPath() + "/profile?success=profile_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        if (newPass == null || !newPass.equals(confirmPass)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=pass_mismatch");
            return;
        }

        if (userDAO.changePassword(userId, currentPass, newPass)) {
            response.sendRedirect(request.getContextPath() + "/profile?success=pass_changed");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_current_pass");
        }
    }

    private void handleDeleteAccount(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        String confirmEmail = request.getParameter("confirmEmail");
        User user = userDAO.getUserById(userId);

        if (user != null && user.getEmail().equalsIgnoreCase(confirmEmail)) {
            if (userDAO.deleteUser(userId)) {
                request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + "/login?success=account_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?error=delete_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?error=email_mismatch");
        }
    }
}

