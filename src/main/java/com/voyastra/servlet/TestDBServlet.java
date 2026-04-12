package com.voyastra.servlet;

import com.voyastra.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

@WebServlet("/testDB")
public class TestDBServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html><html><head>");
        out.println("<title>DB Connection Test - Voyastra</title>");
        out.println("<style>");
        out.println("  body { font-family: 'Inter', sans-serif; display: flex; align-items: center;");
        out.println("         justify-content: center; min-height: 100vh; margin: 0;");
        out.println("         background: #0f0f13; color: #e0e0e0; }");
        out.println("  .card { background: #1a1a24; border: 1px solid rgba(255,255,255,0.08);");
        out.println("          border-radius: 16px; padding: 40px 48px; text-align: center;");
        out.println("          box-shadow: 0 20px 60px rgba(0,0,0,0.4); min-width: 360px; }");
        out.println("  h2 { font-size: 1.3rem; margin-bottom: 16px; color: #a0a0b0; font-weight: 600; }");
        out.println("  .status { font-size: 1.5rem; font-weight: 800; margin: 20px 0; padding: 16px 24px;");
        out.println("            border-radius: 10px; }");
        out.println("  .success { background: rgba(34,197,94,0.12); color: #22c55e;");
        out.println("             border: 1px solid rgba(34,197,94,0.25); }");
        out.println("  .error   { background: rgba(239,68,68,0.12);  color: #ef4444;");
        out.println("             border: 1px solid rgba(239,68,68,0.25); }");
        out.println("  .detail  { font-size: 0.85rem; color: #606070; margin-top: 12px; word-break: break-all; }");
        out.println("</style></head><body><div class='card'>");
        out.println("<h2>&#128736; Voyastra — Database Connection Test</h2>");

        // ── Test the connection ────────────────────────────────────
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            if (conn != null && !conn.isClosed()) {
                out.println("<div class='status success'>&#10003; Connected Successfully!</div>");
                out.println("<p class='detail'>Database: <strong>voyastra</strong> &nbsp;|&nbsp; Driver: com.mysql.cj.jdbc.Driver</p>");
            } else {
                out.println("<div class='status error'>&#10007; Connection returned null</div>");
                out.println("<p class='detail'>DBConnection.getConnection() returned a null or closed connection.</p>");
            }

        } catch (Exception e) {
            out.println("<div class='status error'>&#10007; Connection Failed</div>");
            out.println("<p class='detail'>" + e.getClass().getSimpleName() + ": " + e.getMessage() + "</p>");
        } finally {
            // Always close the connection after testing
            if (conn != null) {
                try { conn.close(); } catch (Exception ignored) {}
            }
        }

        out.println("</div></body></html>");
    }
}
