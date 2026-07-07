package com.voyastra.controller;

import com.voyastra.config.UploadConfig;
import com.voyastra.dao.StoryDAO;
import com.voyastra.model.Story;

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
import java.util.UUID;

@WebServlet("/community/story/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 100,      // 100MB
    maxRequestSize = 1024 * 1024 * 105    // 105MB
)
public class UploadStoryServlet extends HttpServlet {

    private StoryDAO storyDAO;

    @Override
    public void init() throws ServletException {
        storyDAO = new StoryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        try {
            Part filePart = request.getPart("storyMedia");
            if (filePart == null || filePart.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\":false,\"message\":\"No media file uploaded\"}");
                return;
            }

            String contentType = filePart.getContentType();
            String mediaType = contentType.startsWith("video/") ? "video" : "image";
            
            // Validate limits
            if ("image".equals(mediaType) && filePart.getSize() > 10 * 1024 * 1024) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"success\":false,\"message\":\"Image exceeds 10MB limit\"}");
                return;
            }

            // Save file
            String uploadPath = UploadConfig.getStoriesPath(getServletContext());
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String fileName = UUID.randomUUID().toString() + "_" + getSubmittedFileName(filePart);
            File destFile = new File(uploadDir, fileName);
            filePart.write(destFile.getAbsolutePath());
            UploadConfig.copyToSourceFolder("stories", fileName, destFile);

            String mediaUrl = UploadConfig.STORIES_URL + "/" + fileName;

            String caption = request.getParameter("caption");
            String location = request.getParameter("location");

            Story story = new Story();
            story.setUserId(userId);
            story.setMediaUrl(mediaUrl);
            story.setMediaType(mediaType);
            story.setCaption(caption);
            story.setLocation(location);

            if (storyDAO.addStory(story)) {
                response.getWriter().print("{\"success\":true,\"message\":\"Story uploaded successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"success\":false,\"message\":\"Database error\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\":false,\"message\":\"Upload failed\"}");
        }
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
}
