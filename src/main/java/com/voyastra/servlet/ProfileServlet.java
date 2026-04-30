package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.ItineraryDAO;
import com.voyastra.model.User;
import com.voyastra.model.Booking;
import com.voyastra.model.Itinerary;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
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
        
        // 1. Fetch Fresh User Data
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);

        // 2. Handle Tab Selection
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "overview";
        request.setAttribute("activeTab", tab);

        // 3. Fetch Data based on active tab / Statistics
        try {
            List<Booking> userBookings = bookingDAO.getUserBookings(userId);
            List<Itinerary> userPlans = itineraryDAO.getSavedPlans(userId);
            
            request.setAttribute("totalTrips", userBookings.size());
            request.setAttribute("savedCount", userPlans.size());

            if ("overview".equals(tab) || "bookings".equals(tab)) {
                request.setAttribute("bookings", userBookings);
            }
            
            if ("overview".equals(tab) || "saved-plans".equals(tab)) {
                request.setAttribute("savedPlans", userPlans);
            }
        } catch (Exception e) {
            System.err.println("[ProfileServlet] Error fetching data: " + e.getMessage());
        }

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
        } else {
            doGet(request, response);
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException, ServletException {
        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/profile?error=user_not_found");
                return;
            }

            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setBio(request.getParameter("bio"));

            // Handle Profile Image Upload
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "profiles";
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + fileName);
                user.setProfileImage("uploads/profiles/" + fileName);
            }

            if (userDAO.updateUser(user)) {
                // Update Session
                HttpSession session = request.getSession();
                session.setAttribute("name", user.getName());
                session.setAttribute("email", user.getEmail());
                
                response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&error=db_error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&error=exception");
        }
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "default.png";
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        String current = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (newPass != null && newPass.equals(confirm) && userDAO.changePassword(userId, current, newPass)) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=security&success=pass_changed");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?tab=security&error=invalid_request");
        }
    }
}
