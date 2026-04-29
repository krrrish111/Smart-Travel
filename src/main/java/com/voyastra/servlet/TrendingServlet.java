package com.voyastra.servlet;

import com.voyastra.dao.TrendingDAO;
import com.voyastra.model.TrendingPlace;
import com.voyastra.util.AdminLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/trending")
public class TrendingServlet extends HttpServlet {

    private TrendingDAO trendingDAO;

    @Override
    public void init() throws ServletException {
        trendingDAO = new TrendingDAO();
    }

    /**
     * GET /trending          → forwards to index.jsp with all trending places sorted by rank.
     * GET /trending?limit=8  → forwards with only the top N places (useful for homepage widget).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<TrendingPlace> places;

            String limitParam = request.getParameter("limit");
            if (limitParam != null && !limitParam.trim().isEmpty()) {
                int limit = Integer.parseInt(limitParam.trim());
                places = trendingDAO.getTopTrending(limit);
            } else {
                places = trendingDAO.getAllTrending();
            }

            request.setAttribute("trendingPlaces", places);
            request.getRequestDispatcher("/pages/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=trendingFetchFailed");
        }
    }

    /**
     * POST /trending — admin-only CRUD: add, update, delete trending places.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/index.jsp";

        // RBAC guard — admin sessions only
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            if ("add".equals(action)) {
                TrendingPlace p = buildFromRequest(request);
                trendingDAO.addTrendingPlace(p);
                AdminLogger.log(request, "ADD", "TrendingPlace", 0, "Added trending place '" + p.getName() + "' at rank #" + p.getRank());
                response.sendRedirect(redirectUrl + "?trendingAdded=true");

            } else if ("update".equals(action)) {
                TrendingPlace p = buildFromRequest(request);
                p.setId(Integer.parseInt(request.getParameter("id")));
                trendingDAO.updateTrendingPlace(p);
                AdminLogger.log(request, "UPDATE", "TrendingPlace", p.getId(), "Updated trending place '" + p.getName() + "' to rank #" + p.getRank());
                response.sendRedirect(redirectUrl + "?trendingUpdated=true");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                trendingDAO.deleteTrendingPlace(id);
                AdminLogger.log(request, "DELETE", "TrendingPlace", id, "Deleted trending place #" + id);
                response.sendRedirect(redirectUrl + "?trendingDeleted=true");

            } else {
                response.sendRedirect(redirectUrl);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectUrl + "?error=invalidTrendingData");
        }
    }

    /** Shared helper — populates a TrendingPlace from POST parameters. */
    private TrendingPlace buildFromRequest(HttpServletRequest request) {
        TrendingPlace p = new TrendingPlace();
        p.setRank(Integer.parseInt(request.getParameter("rank")));
        p.setName(request.getParameter("name"));
        p.setImageUrl(request.getParameter("image_url"));
        p.setCategory(request.getParameter("category"));
        p.setCategoryColor(request.getParameter("category_color"));
        p.setSubTitle(request.getParameter("sub_title"));
        p.setPrice(request.getParameter("price"));
        p.setDuration(request.getParameter("duration"));
        p.setRating(Double.parseDouble(request.getParameter("rating")));
        return p;
    }
}
