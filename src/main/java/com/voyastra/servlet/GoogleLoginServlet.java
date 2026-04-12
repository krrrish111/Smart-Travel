package com.voyastra.servlet;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.voyastra.dao.UserDAO;
import com.voyastra.model.User;
import com.voyastra.util.OAuthConfig;

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

    // --- Loaded from oauth.properties (git-ignored) or env vars ---
    private static final String CLIENT_ID = OAuthConfig.getClientId();
    private static final String CLIENT_SECRET = OAuthConfig.getClientSecret();

    private static final String REDIRECT_URI = "http://localhost:8080/voyastra/google-login";
    private static final String AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String VOYA_USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");

        // Phase 1: Redirect to Google if no code provided
        if (code == null || code.isEmpty()) {
            String url = AUTH_URL + "?" +
                    "client_id=" + CLIENT_ID +
                    "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8) +
                    "&response_type=code" +
                    "&scope=" + URLEncoder.encode("openid email profile", StandardCharsets.UTF_8) +
                    "&access_type=offline" +
                    "&prompt=select_account";

            response.sendRedirect(url);
            return;
        }

        // Phase 2: Handle Authorization Code callback
        try {
            // 1. Exchange Code for Tokens
            String tokenResponse = exchangeCodeForToken(code);
            JsonObject tokenJson = JsonParser.parseString(tokenResponse).getAsJsonObject();
            String accessToken = tokenJson.get("access_token").getAsString();

            // 2. Fetch User Profile Info
            String userInfoResponse = fetchUserInfo(accessToken);
            JsonObject userInfo = JsonParser.parseString(userInfoResponse).getAsJsonObject();

            String googleId = userInfo.get("sub").getAsString();
            String email = userInfo.get("email").getAsString();
            String name = userInfo.has("name") ? userInfo.get("name").getAsString() : email.split("@")[0];

            // 3. Find or Create User in Database
            User user = userDAO.findOrCreateGoogleUser(googleId, email, name);
            if (user == null) {
                request.setAttribute("errorMsg", "Failed to link Google account.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // 4. Create Session
            HttpSession session = request.getSession(true);
            session.setAttribute("user_id", user.getId());
            session.setAttribute("name", user.getName());
            session.setAttribute("username", user.getName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setAttribute("auth_method", "google_oauth2");

            // 5. Redirect based on role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Google Authentication failed: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private String exchangeCodeForToken(String code) throws Exception {
        URL url = new URL(TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String params = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8) +
                "&client_id=" + URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8) +
                "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, StandardCharsets.UTF_8) +
                "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8) +
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
