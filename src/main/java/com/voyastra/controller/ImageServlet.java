package com.voyastra.controller;

import com.voyastra.config.UploadConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * ImageServlet - serves all uploaded files under /uploads/*
 *
 * Uses UploadConfig to resolve the real filesystem path dynamically
 * from the Tomcat deployment context (no hardcoded absolute paths).
 *
 * If the requested image file is not found, it transparently proxies
 * a default avatar from ui-avatars.com so broken image icons never appear.
 */
@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Resolve the absolute upload base dir dynamically from Tomcat context or env
        String uploadBase = com.voyastra.config.ConfigManager.get("UPLOAD_DIR");
        if (uploadBase == null || uploadBase.trim().isEmpty()) {
            uploadBase = getServletContext().getRealPath("/");
            if (uploadBase != null && !uploadBase.endsWith(File.separator)) {
                uploadBase += File.separator;
            }
            uploadBase += "uploads";
        }
        // IMPORTANT: strip the leading '/' from pathInfo before passing to new File().
        // In Java, new File(parent, child) ignores the parent when child starts with '/'
        // (treated as an absolute path on Unix). This causes files to be looked up at
        // /posts/uuid.jpg instead of /var/voyastra/uploads/posts/uuid.jpg.
        String relativePath = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        File imageFile = new File(uploadBase, relativePath);

        // Security: prevent path traversal attacks
        String canonicalBase = new File(uploadBase).getCanonicalPath();
        String canonicalFile = imageFile.getCanonicalPath();
        if (!canonicalFile.startsWith(canonicalBase)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!imageFile.exists() || !imageFile.isFile()) {
            // Serve a default avatar instead of a broken 404
            serveDefaultAvatar(response);
            return;
        }

        String contentType = getServletContext().getMimeType(imageFile.getName());
        if (contentType == null) {
            contentType = "image/jpeg";
        }

        response.setContentType(contentType);
        response.setContentLength((int) imageFile.length());
        response.setHeader("Cache-Control", "public, max-age=86400");

        try (FileInputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    /**
     * When a user's profile image is missing, proxy a default avatar
     * from ui-avatars.com so the browser never shows a broken image icon.
     */
    private void serveDefaultAvatar(HttpServletResponse response) throws IOException {
        try {
            URL avatarUrl = new URL(
                "https://ui-avatars.com/api/?name=User&background=d4a574&color=1a0f08&bold=true&size=128"
            );
            HttpURLConnection conn = (HttpURLConnection) avatarUrl.openConnection();
            conn.setConnectTimeout(3000);
            conn.setReadTimeout(3000);
            conn.connect();

            if (conn.getResponseCode() == 200) {
                response.setContentType("image/png");
                response.setHeader("Cache-Control", "public, max-age=3600");
                try (java.io.InputStream in = conn.getInputStream();
                     OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
                return;
            }
        } catch (Exception ignored) {
            // Fall through to inline SVG fallback
        }

        // Final fallback: serve a simple inline SVG avatar
        String svg = "<svg xmlns='http://www.w3.org/2000/svg' width='128' height='128' viewBox='0 0 128 128'>" +
            "<rect width='128' height='128' fill='#d4a574' rx='64'/>" +
            "<circle cx='64' cy='50' r='24' fill='#1a0f08' opacity='0.7'/>" +
            "<ellipse cx='64' cy='105' rx='38' ry='28' fill='#1a0f08' opacity='0.7'/>" +
            "</svg>";
        response.setContentType("image/svg+xml");
        response.setHeader("Cache-Control", "public, max-age=3600");
        response.getWriter().write(svg);
    }
}
