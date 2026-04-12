package com.voyastra.servlet;

import com.voyastra.dao.ImageDAO;
import com.voyastra.model.UploadedImage;

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

@WebServlet("/gallery")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ImageUploadServlet extends HttpServlet {

    private ImageDAO imageDAO;
    private static final String UPLOAD_DIR = "images" + File.separator + "uploads";

    @Override
    public void init() {
        imageDAO = new ImageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<UploadedImage> images = imageDAO.getAllImages();
        request.setAttribute("images", images);
        request.getRequestDispatcher("/gallery.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Auth Check: Ensure user is logged in (double defense)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login to upload images.");
            return;
        }

        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        
        File fileSaveDir = new File(uploadFilePath);
        if (!fileSaveDir.exists()) fileSaveDir.mkdirs();

        try {
            for (Part part : request.getParts()) {
                if (part.getName().equals("imageFile") && part.getSize() > 0) {
                    
                    // 2. MIME Type Validation (More secure than extension check)
                    String contentType = part.getContentType();
                    if (!contentType.startsWith("image/")) {
                        throw new IllegalArgumentException("Only image files are allowed.");
                    }

                    String rawFileName = getFileName(part);
                    // 3. Filename Sanitization: Remove directory traversal and dangerous chars
                    String sanitizedName = rawFileName.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
                    
                    // 4. Force safe extensions
                    String ext = "";
                    if (sanitizedName.contains(".")) {
                        ext = sanitizedName.substring(sanitizedName.lastIndexOf(".")).toLowerCase();
                    }
                    if (!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png") && !ext.equals(".webp")) {
                        throw new IllegalArgumentException("Unsupported image format.");
                    }

                    String uniqueFileName = System.currentTimeMillis() + "_" + sanitizedName;
                    String savePath = uploadFilePath + File.separator + uniqueFileName;
                    
                    part.write(savePath);
                    
                    String relativePath = "images/uploads/" + uniqueFileName;
                    UploadedImage img = new UploadedImage(relativePath);
                    img.setUserId((Integer) session.getAttribute("user_id"));
                    imageDAO.saveImage(img);
                }
            }
            session.setAttribute("successMsg", "📸 Image uploaded successfully!");
        } catch (Exception ex) {
            session.setAttribute("errorMsg", "Upload failed: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/gallery");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length()-1);
            }
        }  
        return "";
    }
}
