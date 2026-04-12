package com.voyastra.servlet;

import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Destination;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/destinations")
@javax.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15    // 15MB
)
public class DestinationServlet extends HttpServlet {

    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
    }

    /**
     * Handles API requests to fetch destinations as JSON.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            List<Destination> list = destinationDAO.getAllDestinations();
            
            // Build JSON Array manually so we don't depend on external jars.
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Destination d = list.get(i);
                
                // Note: The UI expects 'category' and 'location' from the frontend legacy object,
                // but our DB has 'name', 'description' (which we can map as category or location)
                // Let's parse 'description' if we want, but for now we map as best we can.
                // We'll extract a pseudo-category from description or just use "Uncategorized",
                // and a pseudo-location from the description.
                // Or better yet, we just serve what the model has and map it cleanly!
                
                String descRaw = d.getDescription() != null ? d.getDescription() : "";
                // To keep it simple and match our existing JS fields:
                // We will treat description as a comma separated string if needed, or just map literal properties.
                
                json.append("{")
                    .append("\"id\":").append(d.getId()).append(",")
                    .append("\"name\":\"").append(escapeJson(d.getName())).append("\",")
                    // If description contains our location/cat we can split it, but let's just pass raw here
                    .append("\"desc\":\"").append(escapeJson(descRaw)).append("\",")
                    // Since DB doesn't have native location/category column, we fake them or parse them.
                    .append("\"location\":\"").append("Global").append("\",")
                    .append("\"category\":\"").append("Misc").append("\",")
                    .append("\"image\":\"").append(escapeJson(d.getImageUrl())).append("\"")
                    .append("}");
                
                if (i < list.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Failed to fetch destinations.\"}");
            out.flush();
        }
    }

    /**
     * Handles AJAX operations for Add/Update/Delete a destination.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Admin Security Check
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
                    handleAdd(request, response, out);
                    break;
                case "update":
                    handleUpdate(request, response, out);
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
            e.printStackTrace();
            // Important: Send JSON error instead of allowing GlobalExceptionFilter to forward to HTML error page
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Server error executing operation: " + e.getMessage().replace("\"", "'") + "\"}");
            out.flush();
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws java.io.IOException {
        try {
            String name = request.getParameter("name");
            String desc = request.getParameter("desc");
            String location = request.getParameter("location");
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("image"); // This is the URL input fallback

            if (name == null || name.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"Name is required.\"}");
                return;
            }

            // Image Upload Logic
            String finalImagePath = imageUrl;
            javax.servlet.http.Part filePart = request.getPart("destImageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/") + "uploads" + java.io.File.separator + "destinations";
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String savedName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadPath + java.io.File.separator + savedName);
                finalImagePath = "uploads/destinations/" + savedName;
            }

            Destination dest = new Destination();
            dest.setName(name);
            dest.setDescription(desc);
            dest.setImage(finalImagePath);
            dest.setCategory(category);
            
            // Parse location into state/country (assuming "State, Country" format)
            if (location != null && location.contains(",")) {
                String[] parts = location.split(",");
                dest.setState(parts[0].trim());
                dest.setCountry(parts[1].trim());
            } else {
                dest.setState(location);
                dest.setCountry("Internal");
            }

            boolean success = destinationDAO.addDestination(dest);
            if (success) {
                AdminLogger.log(request, "ADD", "Destination", 0, "Created destination: " + dest.getName());
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?status=add_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?status=error&message=db_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?status=error&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws java.io.IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String desc = request.getParameter("desc");
            String location = request.getParameter("location");
            String category = request.getParameter("category");
            String imageUrl = request.getParameter("image");

            Destination dest = destinationDAO.getDestinationById(id);
            if (dest == null) {
                out.print("{\"status\":\"error\", \"message\":\"Destination not found.\"}");
                return;
            }

            // Image Upload Logic
            String finalImagePath = imageUrl != null && !imageUrl.isEmpty() ? imageUrl : dest.getImage();
            javax.servlet.http.Part filePart = request.getPart("destImageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/") + "uploads" + java.io.File.separator + "destinations";
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String savedName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadPath + java.io.File.separator + savedName);
                finalImagePath = "uploads/destinations/" + savedName;
            }

            dest.setName(name);
            dest.setDescription(desc);
            dest.setImage(finalImagePath);
            dest.setCategory(category);
            
            if (location != null && location.contains(",")) {
                String[] parts = location.split(",");
                dest.setState(parts[0].trim());
                dest.setCountry(parts[1].trim());
            } else {
                dest.setState(location);
            }

            boolean success = destinationDAO.updateDestination(dest);
            if (success) {
                AdminLogger.log(request, "UPDATE", "Destination", id, "Updated destination: " + name);
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?status=update_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?status=error&message=db_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?status=error&message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void handleDelete(HttpServletRequest request, PrintWriter out) {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"ID is required for deletion.\"}");
                return;
            }
            int id = Integer.parseInt(idStr);
            
            boolean success = destinationDAO.deleteDestination(id);
            if (success) {
                AdminLogger.log(request, "DELETE", "Destination", id, "Deleted destination ID: " + id);
                out.print("{\"status\":\"success\", \"message\":\"Destination deleted permanently.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Failed to delete destination from database.\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"status\":\"error\", \"message\":\"Invalid ID format.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"Error during deletion: " + e.getMessage() + "\"}");
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
