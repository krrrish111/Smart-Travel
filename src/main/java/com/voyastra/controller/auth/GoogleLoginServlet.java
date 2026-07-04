package com.voyastra.controller.auth;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.voyastra.dao.profile.UserDAO;
import com.voyastra.model.profile.User;
import com.voyastra.util.OAuthConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Servlet handling Google OAuth 2.0 Authorization Code flow.
 * Mapped to /google-login
 */
@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(GoogleLoginServlet.class);

    // --- Loaded from OAuthConfig ---
    private static final String CLIENT_ID = OAuthConfig.getClientId();
    private static final String CLIENT_SECRET = OAuthConfig.getClientSecret();

    private static final String AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String VOYA_USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    private String getRedirectUri(HttpServletRequest request) {
        String appUrl = com.voyastra.config.ConfigManager.get("APP_URL");
        if (appUrl == null || appUrl.trim().isEmpty()) {
            logger.warn("APP_URL environment variable is missing! Falling back to http://localhost:8080 for development.");
            appUrl = "http://localhost:8080";
        }
        if (appUrl.endsWith("/")) {
            appUrl = appUrl.substring(0, appUrl.length() - 1);
        }
        return appUrl + request.getContextPath() + "/google-login";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        logger.info("[STEP 1] GoogleLoginServlet entered. Method: {}, Request URI: {}", request.getMethod(), request.getRequestURI());

        HttpSession existingSession = request.getSession(false);
        if (existingSession != null && existingSession.getAttribute("user_id") != null) {
            logger.info("[STEP 1] User already logged in. Redirecting to home to prevent duplicate OAuth callback.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String code = request.getParameter("code");
        String redirectUri = getRedirectUri(request);
        logger.info("[STEP 3] Generated redirect URI: {}", redirectUri);

        // Phase 1: Redirect to Google if no code provided
        if (code == null || code.isEmpty()) {
            String url = AUTH_URL + "?" +
                    "client_id=" + CLIENT_ID +
                    "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8) +
                    "&response_type=code" +
                    "&scope=" + URLEncoder.encode("openid email profile", StandardCharsets.UTF_8) +
                    "&access_type=offline" +
                    "&prompt=select_account";

            logger.info("[STEP 1] Redirecting user to Google OAuth Consent Page URL: {}", url);
            response.sendRedirect(url);
            return;
        }

        logger.info("[STEP 2] Authorization code received: {}", (code.length() > 5 ? code.substring(0, 5) + "..." : code));

        String rawTokenResponse = "";
        String rawUserInfoResponse = "";
        JsonObject tokenJson = null;
        JsonObject userInfoJson = null;

        try {
            // 1. Exchange Code for Tokens
            logger.info("[STEP 4] Initiating OAuth token request. Token URL: {}, Client ID: {}", TOKEN_URL, CLIENT_ID);
            rawTokenResponse = exchangeCodeForToken(code, redirectUri);
            logger.info("[STEP 5] Complete Google token response: {}", rawTokenResponse);
            
            tokenJson = JsonParser.parseString(rawTokenResponse).getAsJsonObject();
            if (!tokenJson.has("access_token")) {
                throw new IllegalStateException("Google token response does not contain access_token. Response: " + rawTokenResponse);
            }
            String accessToken = tokenJson.get("access_token").getAsString();
            logger.info("[STEP 6] Extract access token: {}", (accessToken.length() > 5 ? accessToken.substring(0, 5) + "..." : accessToken));

            // 2. Fetch User Profile Info
            logger.info("[STEP 7] Fetching Google userinfo using access token.");
            rawUserInfoResponse = fetchUserInfo(accessToken);
            logger.info("[STEP 7] Complete Google userinfo response: {}", rawUserInfoResponse);
            
            userInfoJson = JsonParser.parseString(rawUserInfoResponse).getAsJsonObject();
            
            if (!userInfoJson.has("sub") || !userInfoJson.has("email")) {
                throw new IllegalStateException("Google userinfo response is missing OpenID fields. Response: " + rawUserInfoResponse);
            }

            String googleId = userInfoJson.get("sub").getAsString();
            String email = userInfoJson.get("email").getAsString();
            String name = userInfoJson.has("name") ? userInfoJson.get("name").getAsString() : email.split("@")[0];

            logger.info("[STEP 8] Google email: {}", email);
            logger.info("[STEP 9] Google id (sub): {}", googleId);

            // 3. Find or Create User in Database
            User user = userDAO.findOrCreateGoogleUser(googleId, email, name);
            if (user == null) {
                logger.error("[ERROR] Failed to link Google account (UserDAO returned null) for email: {}", email);
                request.setAttribute("errorMsg", "Failed to link Google account.");
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            // 4. Create Session
            logger.info("[STEP 18] Creating HttpSession.");
            HttpSession session = request.getSession(true);
            session.setAttribute("user_id", user.getId());
            session.setAttribute("name", user.getName());
            session.setAttribute("username", user.getName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setAttribute("user", user);
            session.setAttribute("auth_method", "google_oauth2");

            logger.info("[STEP 19] Session attributes set successfully:");
            logger.info("  - user_id: {}", session.getAttribute("user_id"));
            logger.info("  - name: {}", session.getAttribute("name"));
            logger.info("  - username: {}", session.getAttribute("username"));
            logger.info("  - email: {}", session.getAttribute("email"));
            logger.info("  - role: {}", session.getAttribute("role"));
            logger.info("  - auth_method: {}", session.getAttribute("auth_method"));

            logger.info("[STEP 20] Redirecting to home page: {}", request.getContextPath() + "/");
            response.sendRedirect(request.getContextPath() + "/");

        } catch (Exception e) {
            logger.error("[CRITICAL ERROR] Google Authentication Exception!");
            logger.error("Exception Class: {}", e.getClass().getName());
            logger.error("Exception Message: {}", e.getMessage());
            logger.error("Exception Cause: {}", e.getCause());
            
            // Print raw payloads if available
            logger.error("Token Response JSON payload: {}", rawTokenResponse);
            logger.error("UserInfo Response JSON payload: {}", rawUserInfoResponse);
            
            // Stack trace logging
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            logger.error("Stack Trace:\n{}", sw.toString());

            request.setAttribute("errorMsg", "Google Authentication failed: " + e.getMessage());
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
        }
    }

    private String exchangeCodeForToken(String code, String redirectUri) throws Exception {
        URL url = new URL(TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String params = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8) +
                "&client_id=" + URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8) +
                "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, StandardCharsets.UTF_8) +
                "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8) +
                "&grant_type=authorization_code";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes(StandardCharsets.UTF_8));
        }

        return readResponse(conn);
    }

    private String fetchUserInfo(String accessToken) throws Exception {
        URL url = new URL(VOYA_USERINFO_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        return readResponse(conn);
    }

    private String readResponse(HttpURLConnection conn) throws Exception {
        int status = conn.getResponseCode();
        InputStream is = (status < 400) ? conn.getInputStream() : conn.getErrorStream();

        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            if (status >= 400) {
                throw new Exception("HTTP " + status + ": " + sb.toString());
            }
            return sb.toString();
        }
    }
}
