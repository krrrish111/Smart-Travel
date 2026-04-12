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

/**
 * POST /google-auth
 * Receives Google ID token from frontend, verifies it with Google's tokeninfo
 * endpoint, then creates/finds user and establishes a Java HttpSession.
 */
@WebServlet("/google-auth")
public class GoogleOAuthServlet extends HttpServlet {

    private static final String GOOGLE_CLIENT_ID = OAuthConfig.getClientId();
    private static final String TOKENINFO_URL = "https://oauth2.googleapis.com/tokeninfo?id_token=";

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Read id_token from request body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null)
                sb.append(line);
        }

        JsonObject body;
        String idToken;
        try {
            body = JsonParser.parseString(sb.toString()).getAsJsonObject();
            idToken = body.get("credential").getAsString();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\":\"Missing credential token\"}");
            return;
        }

        // 2. Verify token with Google
        JsonObject payload = verifyGoogleToken(idToken);
        if (payload == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\":\"Invalid Google token\"}");
            return;
        }

        // 3. Verify audience matches our client ID
        String aud = payload.has("aud") ? payload.get("aud").getAsString() : "";
        if (!GOOGLE_CLIENT_ID.equals(aud)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\":\"Token audience mismatch\"}");
            return;
        }

        // 4. Extract user info from payload
        String googleId = payload.has("sub") ? payload.get("sub").getAsString() : "";
        String email = payload.has("email") ? payload.get("email").getAsString() : "";
        String name = payload.has("name") ? payload.get("name").getAsString()
                : (payload.has("given_name") ? payload.get("given_name").getAsString() : email.split("@")[0]);

        if (email.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\":\"Email not available from Google\"}");
            return;
        }

        // 5. Find or create the user in our DB
        User user = userDAO.findOrCreateGoogleUser(googleId, email, name);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\":\"Failed to create user account\"}");
            return;
        }

        // 6. Create Java HttpSession
        HttpSession session = request.getSession(false);
        if (session != null)
            session.invalidate();
        session = request.getSession(true);
        session.setAttribute("user_id", user.getId());
        session.setAttribute("username", user.getName());
        session.setAttribute("name", user.getName());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("role", user.getRole());
        session.setAttribute("auth_method", "google");

        // 7. Return redirect URL based on role
        // 7. Return redirect URL (always homepage for minimal flow change)
        String redirectUrl = request.getContextPath() + "/index.jsp";

        response.setStatus(HttpServletResponse.SC_OK);
        out.write("{\"success\":true,\"redirect\":\"" + redirectUrl + "\",\"role\":\"" + user.getRole()
                + "\",\"name\":\"" + escapeJson(user.getName()) + "\"}");
    }

    /**
     * Calls Google's tokeninfo endpoint to verify the ID token.
     * Returns the payload as a JsonObject, or null if invalid.
     */
    private JsonObject verifyGoogleToken(String idToken) {
        try {
            URL url = new URL(TOKENINFO_URL + idToken);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            int status = conn.getResponseCode();
            InputStream stream = (status == 200) ? conn.getInputStream() : conn.getErrorStream();

            StringBuilder resp = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(stream, "UTF-8"))) {
                String line;
                while ((line = reader.readLine()) != null)
                    resp.append(line);
            }

            if (status != 200) {
                System.err.println("Google tokeninfo rejected token: " + resp);
                return null;
            }

            return JsonParser.parseString(resp.toString()).getAsJsonObject();
        } catch (Exception e) {
            System.err.println("ERROR: GoogleOAuthServlet.verifyGoogleToken: " + e.getMessage());
            return null;
        }
    }

    private String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
