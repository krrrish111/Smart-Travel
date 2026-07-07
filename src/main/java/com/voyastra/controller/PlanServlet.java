package com.voyastra.controller;

import com.voyastra.config.UploadConfig;
import com.voyastra.dao.PlanDAO;
import com.voyastra.model.Plan;
import com.voyastra.util.AdminLogger;
import java.util.logging.Logger;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/plans")
@javax.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class PlanServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(PlanServlet.class.getName());
    private PlanDAO planDAO;

    @Override
    public void init() throws ServletException {
        planDAO = new PlanDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            List<Plan> list = planDAO.getPlansWithDestinations();
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Plan p = list.get(i);
                
                json.append("{")
                    .append("\"id\":").append(p.getId()).append(",")
                    .append("\"title\":\"").append(escapeJson(p.getTitle())).append("\",")
                    .append("\"destination_id\":").append(p.getDestinationId()).append(",")
                    .append("\"destination_name\":\"").append(escapeJson(p.getDestinationName())).append("\",")
                    .append("\"price\":").append(p.getPrice()).append(",")
                    .append("\"days\":").append(p.getDays()).append(",")
                    .append("\"nights\":").append(p.getNights()).append(",")
                    .append("\"category\":\"").append(escapeJson(p.getCategory())).append("\",")
                    .append("\"description\":\"").append(escapeJson(p.getDescription())).append("\",")
                    .append("\"image\":\"").append(escapeJson(p.getImage())).append("\"")
                    .append("}");
                
                if (i < list.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception in GET /plans", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Failed to fetch plans.\"}");
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"status\":\"error\", \"message\":\"Access Denied. Admins only.\"}");
            out.flush();
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"No action specified.\"}");
            out.flush();
            return;
        }

        try {
            switch (action.toLowerCase()) {
                case "add":
                    handleAdd(request, out);
                    break;
                case "update":
                    handleUpdate(request, out);
                    break;
                case "delete":
                    handleDelete(request, out);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"status\":\"error\", \"message\":\"Unknown action.\"}");
                    out.flush();
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception in POST /plans", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Server error executing operation: " + e.getMessage().replace("\"", "'") + "\"}");
            out.flush();
        }
    }

    private void populatePlanFromRequest(Plan p, HttpServletRequest request) {
        p.setTitle(request.getParameter("title"));
        p.setCategory(request.getParameter("category"));
        p.setDescription(request.getParameter("desc"));
        
        try {
            String destId = request.getParameter("destination_id");
            if (destId != null && !destId.isEmpty()) p.setDestinationId(Integer.parseInt(destId));
            
            String price = request.getParameter("price");
            if (price != null && !price.isEmpty()) p.setPrice(Integer.parseInt(price));
            
            String days = request.getParameter("days");
            if (days != null && !days.isEmpty()) p.setDays(Integer.parseInt(days));
            
            String nights = request.getParameter("nights");
            if (nights != null && !nights.isEmpty()) p.setNights(Integer.parseInt(nights));
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Error parsing numeric values for plan", e);
        }
    }

    private String handleFileUpload(Part filePart) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = UploadConfig.getPlansPath(getServletContext());
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            String savedName = java.util.UUID.randomUUID().toString() + "_" + filePart.getSubmittedFileName();
            java.io.File destFile = new java.io.File(uploadDir, savedName);
            filePart.write(destFile.getAbsolutePath());
            UploadConfig.copyToSourceFolder("plans", savedName, destFile);
            return UploadConfig.PLANS_URL + "/" + savedName;
        }
        return null;
    }

    private void handleAdd(HttpServletRequest request, PrintWriter out) throws IOException, ServletException {
        String title = request.getParameter("title");
        if (title == null || title.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Title is required.\"}");
            return;
        }

        Plan plan = new Plan();
        populatePlanFromRequest(plan, request);

        // Handle Image
        String imageUrl = request.getParameter("image");
        String uploadedImage = handleFileUpload(request.getPart("planImageFile"));
        plan.setImage(uploadedImage != null ? uploadedImage : imageUrl);

        boolean success = planDAO.addPlan(plan);
        if (success) {
            AdminLogger.log(request, "ADD", "Plan", 0, "Created plan: " + plan.getTitle());
            out.print("{\"status\":\"success\", \"message\":\"Plan created successfully.\"}");
        } else {
            out.print("{\"status\":\"error\", \"message\":\"Failed to create plan.\"}");
        }
    }

    private void handleUpdate(HttpServletRequest request, PrintWriter out) throws IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Plan plan = planDAO.getPlanById(id);
            if (plan == null) {
                out.print("{\"status\":\"error\", \"message\":\"Plan not found.\"}");
                return;
            }

            populatePlanFromRequest(plan, request);

            // Handle Image
            String imageUrl = request.getParameter("image");
            String uploadedImage = handleFileUpload(request.getPart("planImageFile"));
            if (uploadedImage != null) {
                plan.setImage(uploadedImage);
            } else if (imageUrl != null && !imageUrl.isEmpty()) {
                plan.setImage(imageUrl);
            }

            boolean success = planDAO.updatePlan(plan);
            if (success) {
                AdminLogger.log(request, "UPDATE", "Plan", id, "Updated plan: " + plan.getTitle());
                out.print("{\"status\":\"success\", \"message\":\"Plan updated successfully.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Failed to update plan.\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"status\":\"error\", \"message\":\"Invalid plan ID.\"}");
        }
    }

    private void handleDelete(HttpServletRequest request, PrintWriter out) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = planDAO.deletePlan(id);
            if (success) {
                AdminLogger.log(request, "DELETE", "Plan", id, "Deleted plan ID: " + id);
                out.print("{\"status\":\"success\", \"message\":\"Plan deleted permanently.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Failed to delete plan.\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"status\":\"error\", \"message\":\"Invalid ID format.\"}");
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
