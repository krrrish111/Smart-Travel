package com.voyastra.config;

import javax.servlet.ServletContext;
import java.io.File;

/**
 * Centralized upload directory configuration.
 * All upload paths are resolved dynamically from the servlet context (Tomcat webapps dir),
 * eliminating hardcoded absolute paths.
 *
 * URL pattern: /uploads/{category}/{filename}
 * Disk path:   {tomcat_webapps}/voyastra/uploads/{category}/{filename}
 */
public class UploadConfig {

    // Web-relative URL prefixes (used in JSPs and HTML img src)
    public static final String UPLOADS_URL_PREFIX = "uploads";

    public static final String PROFILES_URL    = UPLOADS_URL_PREFIX + "/profiles";
    public static final String POSTS_URL       = UPLOADS_URL_PREFIX + "/posts";
    public static final String STORIES_URL     = UPLOADS_URL_PREFIX + "/stories";
    public static final String DESTINATIONS_URL = UPLOADS_URL_PREFIX + "/destinations";
    public static final String ACTIVITIES_URL  = UPLOADS_URL_PREFIX + "/activities";
    public static final String HOTELS_URL      = UPLOADS_URL_PREFIX + "/hotels";
    public static final String PLANS_URL       = UPLOADS_URL_PREFIX + "/plans";
    public static final String DL_URL          = UPLOADS_URL_PREFIX + "/dl";

    // Default fallback avatar (external, always available)
    public static final String DEFAULT_AVATAR_BASE_URL =
        "https://ui-avatars.com/api/?background=d4a574&color=1a0f08&bold=true&size=128&name=";

    /**
     * Returns the absolute filesystem path for a given upload sub-folder,
     * resolved from the live Tomcat webapps deploy directory.
     *
     * @param context  the active ServletContext
     * @param category e.g. "profiles", "posts", "stories"
     * @return absolute path string, e.g. C:/tomcat/webapps/voyastra/uploads/profiles
     */
    public static String getUploadPath(ServletContext context, String category) {
        String base = com.voyastra.config.ConfigManager.get("UPLOAD_DIR");
        if (base == null || base.trim().isEmpty()) {
            base = context.getRealPath("/");
            if (base != null && !base.endsWith(File.separator)) {
                base += File.separator;
            }
            base += "uploads";
        }
        String path = base + File.separator + category;
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return path;
    }

    /** Profiles upload directory */
    public static String getProfilesPath(ServletContext context) {
        return getUploadPath(context, "profiles");
    }

    /** Community posts upload directory */
    public static String getPostsPath(ServletContext context) {
        return getUploadPath(context, "posts");
    }

    /** Community stories upload directory */
    public static String getStoriesPath(ServletContext context) {
        return getUploadPath(context, "stories");
    }

    /** Destination images upload directory */
    public static String getDestinationsPath(ServletContext context) {
        return getUploadPath(context, "destinations");
    }

    /** Activity images upload directory */
    public static String getActivitiesPath(ServletContext context) {
        return getUploadPath(context, "activities");
    }

    /** Hotel images upload directory */
    public static String getHotelsPath(ServletContext context) {
        return getUploadPath(context, "hotels");
    }

    /** Travel plans upload directory */
    public static String getPlansPath(ServletContext context) {
        return getUploadPath(context, "plans");
    }

    /** Driving license / document upload directory */
    public static String getDlPath(ServletContext context) {
        return getUploadPath(context, "dl");
    }

    /**
     * Returns a safe image URL to use in JSP.
     * If storedPath is null/empty, returns a UI-Avatars fallback URL using the user's name.
     *
     * @param contextPath   e.g. "/voyastra"
     * @param storedPath    value from DB, e.g. "uploads/profiles/abc.jpg"
     * @param fallbackName  user's display name for generating a letter-avatar
     * @return a usable img src value
     */
    public static String resolveProfileImageUrl(String contextPath, String storedPath, String fallbackName) {
        if (storedPath != null && !storedPath.trim().isEmpty()) {
            // Prepend context path so the URL is absolute from webapp root
            if (storedPath.startsWith("http")) {
                return storedPath; // External URL (Google OAuth etc.)
            }
            return contextPath + "/" + storedPath;
        }
        String safeName = (fallbackName != null && !fallbackName.isEmpty()) ? fallbackName : "User";
        try {
            safeName = java.net.URLEncoder.encode(safeName, "UTF-8");
        } catch (java.io.UnsupportedEncodingException ignored) {}
        return DEFAULT_AVATAR_BASE_URL + safeName;
    }

    /**
     * Mirrors an uploaded file to the source webapp directory during development,
     * so that local file uploads survive clean rebuilds or WAR redeployments.
     */
    public static void copyToSourceFolder(String category, String fileName, File targetFile) {
        try {
            File sourceDir = new File("src/main/webapp/uploads/" + category);
            if (sourceDir.exists() || sourceDir.mkdirs()) {
                File sourceFile = new File(sourceDir, fileName);
                java.nio.file.Files.copy(targetFile.toPath(), sourceFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                System.out.println("[UploadConfig] Successfully mirrored uploaded file to source directory: " + sourceFile.getAbsolutePath());
            }
        } catch (Exception e) {
            System.err.println("[UploadConfig WARN] Could not mirror upload to source folder: " + e.getMessage());
        }
    }

    /**
     * Dynamically resolves story media URLs with the proper context path.
     */
    public static String resolveStoryImageUrl(String contextPath, String storedPath) {
        if (storedPath != null && !storedPath.trim().isEmpty()) {
            if (storedPath.startsWith("http")) {
                return storedPath;
            }
            if (storedPath.startsWith("/")) {
                if (!contextPath.isEmpty() && !storedPath.startsWith(contextPath)) {
                    return contextPath + storedPath;
                }
                return storedPath;
            }
            return contextPath + "/" + storedPath;
        }
        return "";
    }
}
