package com.voyastra.servlet;

import com.voyastra.dao.DestinationDAO;
import java.util.logging.Logger;
import java.util.logging.Level;
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
import javax.servlet.http.Part;
import java.util.Collection;

@WebServlet("/destinations")
@javax.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 100   // 100MB
)
public class DestinationServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(DestinationServlet.class.getName());

    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String action = request.getParameter("action");
            List<Destination> list = destinationDAO.getAllDestinations();
            
            if ("listNames".equals(action)) {
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < list.size(); i++) {
                    Destination d = list.get(i);
                    json.append("{")
                        .append("\"id\":").append(d.getId()).append(",")
                        .append("\"name\":\"").append(escapeJson(d.getName())).append("\"")
                        .append("}");
                    if (i < list.size() - 1) json.append(",");
                }
                json.append("]");
                out.print(json.toString());
                out.flush();
                return;
            }
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Destination d = list.get(i);
                String descRaw = d.getDescription() != null ? d.getDescription() : "";
                
                // Fetch gallery
                List<String> gallery = destinationDAO.getGalleryForDestination(d.getId());
                StringBuilder galleryJson = new StringBuilder("[");
                for (int j = 0; j < gallery.size(); j++) {
                    galleryJson.append("\"").append(escapeJson(gallery.get(j))).append("\"");
                    if (j < gallery.size() - 1) galleryJson.append(",");
                }
                galleryJson.append("]");
                
                json.append("{")
                    .append("\"id\":").append(d.getId()).append(",")
                    .append("\"name\":\"").append(escapeJson(d.getName())).append("\",")
                    .append("\"desc\":\"").append(escapeJson(descRaw)).append("\",")
                    .append("\"location\":\"").append(escapeJson(d.getState() != null ? d.getState() : "")).append("\",")
                    .append("\"country\":\"").append(escapeJson(d.getCountry() != null ? d.getCountry() : "")).append("\",")
                    .append("\"category\":\"").append(escapeJson(d.getCategory())).append("\",")
                    .append("\"image\":\"").append(escapeJson(d.getImageUrl())).append("\",")
                    .append("\"price\":").append(d.getPriceInr()).append(",")
                    .append("\"duration_days\":").append(d.getDurationDays()).append(",")
                    .append("\"duration_nights\":").append(d.getDurationNights()).append(",")
                    .append("\"best_season\":\"").append(escapeJson(d.getBestSeason())).append("\",")
                    .append("\"latitude\":").append(d.getLatitude() != null ? d.getLatitude() : "null").append(",")
                    .append("\"longitude\":").append(d.getLongitude() != null ? d.getLongitude() : "null").append(",")
                    .append("\"highlights\":\"").append(escapeJson(d.getHighlights())).append("\",")
                    .append("\"has_unesco\":").append(d.hasUnesco()).append(",")
                    .append("\"is_trending\":").append(d.isTrending()).append(",")
                    .append("\"is_popular\":").append(d.isPopular()).append(",")
                    .append("\"is_featured\":").append(d.isFeatured()).append(",")
                    .append("\"status\":\"").append(d.isActive() ? "Active" : "Inactive").append("\",")
                    .append("\"rating\":").append(d.getRating()).append(",")
                    .append("\"gallery\":").append(galleryJson.toString())
                    .append("}");
                
                if (i < list.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Failed to fetch destinations.\"}");
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
                case "create":
                case "add":
                    handleAdd(request, response, out);
                    break;
                case "update":
                case "edit":
                    handleUpdate(request, response, out);
                    break;
                case "delete":
                    handleDelete(request, out);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"status\":\"error\", \"receivedAction\":\"" + escapeJson(action) + "\", \"supportedActions\":[\"create\", \"update\", \"delete\", \"list\"]}");
                    out.flush();
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Server error executing operation: " + e.getMessage().replace("\"", "'") + "\"}");
            out.flush();
        }
    }

    private void populateDestinationFromRequest(Destination dest, HttpServletRequest request) {
        dest.setName(request.getParameter("name"));
        dest.setDescription(request.getParameter("desc"));
        dest.setFullDescription(request.getParameter("desc"));
        dest.setShortDescription(request.getParameter("desc"));
        dest.setCategory(request.getParameter("category"));
        
        String location = request.getParameter("location"); // Now represents State/City
        String country = request.getParameter("country");
        
        if (country != null && !country.isEmpty()) {
            dest.setState(location);
            dest.setCountry(country);
            dest.setDestination(country); // Fallback for old schema
            dest.setStartingCity(location);
        } else {
            // legacy fallback
            if (location != null && location.contains(",")) {
                String[] parts = location.split(",");
                dest.setState(parts[0].trim());
                dest.setCountry(parts[1].trim());
                dest.setDestination(parts[1].trim());
                dest.setStartingCity(parts[0].trim());
            } else {
                dest.setState(location);
                dest.setCountry("Internal");
                dest.setDestination("Internal");
                dest.setStartingCity(location);
            }
        }

        // New Phase 2 fields
        try {
            String price = request.getParameter("price");
            if (price != null && !price.isEmpty()) dest.setPriceInr(Double.parseDouble(price));
            
            String days = request.getParameter("duration_days");
            if (days != null && !days.isEmpty()) dest.setDurationDays(Integer.parseInt(days));
            
            String nights = request.getParameter("duration_nights");
            if (nights != null && !nights.isEmpty()) dest.setDurationNights(Integer.parseInt(nights));
            
            String lat = request.getParameter("latitude");
            if (lat != null && !lat.isEmpty()) dest.setLatitude(Double.parseDouble(lat));
            
            String lng = request.getParameter("longitude");
            if (lng != null && !lng.isEmpty()) dest.setLongitude(Double.parseDouble(lng));
            
            String rating = request.getParameter("rating");
            if (rating != null && !rating.isEmpty()) dest.setRating(Float.parseFloat(rating));
            
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error parsing numerical values", e);
        }

        dest.setBestSeason(request.getParameter("best_season"));
        dest.setHighlights(request.getParameter("highlights"));
        
        dest.setHasUnesco("on".equals(request.getParameter("has_unesco")));
        dest.setTrending("on".equals(request.getParameter("is_trending")));
        dest.setPopular("on".equals(request.getParameter("is_popular")));
        dest.setFeatured("on".equals(request.getParameter("is_featured")));
        dest.setActive(true); // Default active for now
    }

    private String handleFileUpload(Part filePart) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/") + "uploads" + java.io.File.separator + "destinations";
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            String savedName = System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + java.io.File.separator + savedName);
            return "uploads/destinations/" + savedName;
        }
        return null;
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws java.io.IOException {
        try {
            String name = request.getParameter("name");
            if (name == null || name.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"Name is required.\"}");
                return;
            }

            Destination dest = new Destination();
            populateDestinationFromRequest(dest, request);

            // Handle Hero Image
            String imageUrl = request.getParameter("image");
            String uploadedImage = handleFileUpload(request.getPart("destImageFile"));
            if (uploadedImage != null) {
                dest.setImage(uploadedImage);
            } else {
                dest.setImage(imageUrl);
            }

            boolean success = destinationDAO.addDestination(dest);
            if (success) {
                // Handle Gallery
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if ("galleryFiles".equals(part.getName()) && part.getSize() > 0) {
                        String gImg = handleFileUpload(part);
                        if (gImg != null) {
                            destinationDAO.addGalleryImage(dest.getId(), gImg);
                        }
                    }
                }

                AdminLogger.log(request, "ADD", "Destination", dest.getId(), "Created destination: " + dest.getName());
                out.print("{\"status\":\"success\", \"message\":\"Destination created successfully.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Database insertion failed.\"}");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            out.print("{\"status\":\"error\", \"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws java.io.IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Destination dest = destinationDAO.getDestinationById(id);
            if (dest == null) {
                out.print("{\"status\":\"error\", \"message\":\"Destination not found.\"}");
                return;
            }

            populateDestinationFromRequest(dest, request);

            // Handle Hero Image
            String imageUrl = request.getParameter("image");
            String uploadedImage = handleFileUpload(request.getPart("destImageFile"));
            if (uploadedImage != null) {
                dest.setImage(uploadedImage);
            } else if (imageUrl != null && !imageUrl.isEmpty()) {
                dest.setImage(imageUrl);
            }

            boolean success = destinationDAO.updateDestination(dest);
            if (success) {
                // Handle Gallery Uploads (append to existing)
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if ("galleryFiles".equals(part.getName()) && part.getSize() > 0) {
                        String gImg = handleFileUpload(part);
                        if (gImg != null) {
                            destinationDAO.addGalleryImage(dest.getId(), gImg);
                        }
                    }
                }

                AdminLogger.log(request, "UPDATE", "Destination", id, "Updated destination: " + dest.getName());
                out.print("{\"status\":\"success\", \"message\":\"Destination updated successfully.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Database update failed.\"}");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Exception occurred", e);
            out.print("{\"status\":\"error\", \"message\":\"" + escapeJson(e.getMessage()) + "\"}");
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
            logger.log(Level.SEVERE, "Exception occurred", e);
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
