package com.voyastra.servlet;

import com.voyastra.dao.UserDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.ItineraryDAO;
import com.voyastra.model.User;
import com.voyastra.model.Booking;
import com.voyastra.model.Itinerary;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
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
        
        // 1. Fetch Basic User Data
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);

        // 2. Handle Tab Selection
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "overview";
        request.setAttribute("activeTab", tab);

        // 3. Fetch Data based on active tab / Statistics
        try {
            // Stats (Always fetched for header/overview)
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

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        User user = userDAO.getUserById(userId);
        user.setName(request.getParameter("name"));
        user.setPhone(request.getParameter("phone"));
        user.setLocation(request.getParameter("location"));
        user.setBio(request.getParameter("bio"));

        if (userDAO.updateUser(user)) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&success=profile_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit-profile&error=update_failed");
        }
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
