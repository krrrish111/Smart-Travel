package com.voyastra.servlet;

import com.voyastra.dao.PostDAO;
import com.voyastra.model.Post;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.io.IOException;

@WebServlet("/community/post/create")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 50, maxRequestSize = 1024 * 1024 * 50)
public class CreatePostServlet extends HttpServlet {

    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Please login to create a post.\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String text = request.getParameter("text");
        String location = request.getParameter("location");
        String imageUrl = request.getParameter("image_url");
        String category = request.getParameter("category");
        String hashtags = request.getParameter("hashtags");
        
        try {
            Part mediaPart = request.getPart("media");
            if (mediaPart != null && mediaPart.getSize() > 0) {
                String submittedFileName = mediaPart.getSubmittedFileName();
                String contentType = mediaPart.getContentType();
                
                // Validate file type
                java.util.Set<String> allowedTypes = new java.util.HashSet<>(
                    java.util.Arrays.asList("image/jpeg", "image/png", "image/webp", "video/mp4")
                );
                if (contentType == null || !allowedTypes.contains(contentType.toLowerCase())) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().print("{\"status\":\"error\",\"message\":\"Unsupported file type. Allowed: JPG, PNG, WEBP, MP4.\"}");
                    return;
                }
                
                String ext = "";
                if (submittedFileName != null && submittedFileName.lastIndexOf('.') > 0) {
                    ext = submittedFileName.substring(submittedFileName.lastIndexOf('.')).toLowerCase();
                }
                String uniqueFilename = UUID.randomUUID().toString() + ext;
                
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "posts";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                File destFile = new File(uploadDir, uniqueFilename);
                try (InputStream input = mediaPart.getInputStream()) {
                    Files.copy(input, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                
                // Copy to src/main/webapp for persistence
                File srcDir = new File("c:\\Users\\Dell\\Desktop\\antigravity\\src\\main\\webapp\\uploads\\posts");
                if (!srcDir.exists()) {
                    srcDir.mkdirs();
                }
                File srcFile = new File(srcDir, uniqueFilename);
                Files.copy(destFile.toPath(), srcFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                
                imageUrl = request.getContextPath() + "/uploads/posts/" + uniqueFilename;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("WARN: Could not process media upload. Proceeding with standard params.");
        }

        if (text == null || text.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Post content cannot be empty.\"}");
            return;
        }

        Post post = new Post();
        post.setUserId(userId);
        post.setText(text.trim());
        post.setLocation(location != null ? location.trim() : "");
        post.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        post.setCategory(category != null ? category.trim() : "For You");
        post.setHashtags(hashtags != null ? hashtags.trim() : "");
        
        String ratingParam = request.getParameter("rating");
        if (ratingParam != null && !ratingParam.trim().isEmpty()) {
            try {
                int rating = Integer.parseInt(ratingParam);
                if (rating >= 1 && rating <= 5) {
                    post.setRating(rating);
                }
            } catch (NumberFormatException e) {
                // Ignore invalid rating
            }
        }

        boolean success = postDAO.addPost(post);
        if (success) {
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Post created successfully!\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Failed to create post in database.\"}");
        }
    }
}
