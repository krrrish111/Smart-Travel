package com.voyastra.servlet;

import com.google.gson.Gson;
import com.voyastra.dao.NotificationDAO;
import com.voyastra.model.Notification;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if ("count".equals(action)) {
            int count = notificationDAO.getUnreadCount(user.getId());
            Map<String, Integer> res = new HashMap<>();
            res.put("unreadCount", count);
            response.getWriter().write(gson.toJson(res));
        } else {
            List<Notification> notifications = notificationDAO.getNotificationsByUser(user.getId());
            response.getWriter().write(gson.toJson(notifications));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();

        if ("markRead".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                boolean success = notificationDAO.markAsRead(Integer.parseInt(idParam), user.getId());
                result.put("success", success);
            } else {
                result.put("success", false);
                result.put("error", "Missing id");
            }
        } else if ("markAllRead".equals(action)) {
            boolean success = notificationDAO.markAllAsRead(user.getId());
            result.put("success", success);
        } else {
            result.put("success", false);
            result.put("error", "Invalid action");
        }

        response.getWriter().write(gson.toJson(result));
    }
}
