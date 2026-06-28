package com.voyastra.controller.admin;

import com.voyastra.dao.SiteContentDAO;
import com.voyastra.model.SiteContent;
import com.voyastra.util.AdminLogger;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/content-api")
public class AdminContentServlet extends HttpServlet {
    private SiteContentDAO contentDAO;

    @Override
    public void init() throws ServletException {
        contentDAO = new SiteContentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("[]");
            return;
        }

        List<SiteContent> contentList = contentDAO.getAllContent();
        response.setContentType("application/json;charset=UTF-8");
        new Gson().toJson(contentList, response.getWriter());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            try {
                String idStr = request.getParameter("id");
                if (idStr == null || idStr.trim().isEmpty()) {
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Missing content ID\"}");
                    return;
                }
                SiteContent c = new SiteContent();
                c.setId(Integer.parseInt(idStr.trim()));
                c.setTitle(nvl(request.getParameter("title")));
                c.setSubtitle(nvl(request.getParameter("subtitle")));
                c.setBodyText(nvl(request.getParameter("body_text")));
                c.setImageUrl(nvl(request.getParameter("image_url")));
                c.setButtonText(nvl(request.getParameter("button_text")));
                c.setButtonLink(nvl(request.getParameter("button_link")));
                c.setPromoCode(nvl(request.getParameter("promo_code")));
                c.setActive(Boolean.parseBoolean(request.getParameter("is_active")));

                boolean success = contentDAO.updateContent(c);
                if (success) {
                    AdminLogger.log(request, "UPDATE", "Content", c.getId(), "Updated site content #" + c.getId() + " (" + c.getSectionType() + ")");
                    response.getWriter().write("{\"status\":\"success\",\"message\":\"Content updated successfully!\"}");
                } else {
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"No rows updated. Check the content ID.\"}");
                }
            } catch (NumberFormatException e) {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid content ID format.\"}");
            } catch (Exception e) {
                System.err.println("[AdminContentServlet] Unexpected error: " + e.getMessage());
                e.printStackTrace();
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Server error: " + e.getMessage().replace("\"", "'") + "\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Unknown action: " + nvl(action) + "\"}");
        }
    }

    private String nvl(String s) {
        return s == null ? "" : s.trim();
    }
}
