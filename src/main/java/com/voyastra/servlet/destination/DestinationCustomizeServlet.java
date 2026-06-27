package com.voyastra.servlet.destination;

import com.voyastra.dao.DestinationDAO;
import com.voyastra.model.Destination;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/destination/customize")
public class DestinationCustomizeServlet extends HttpServlet {
    private DestinationDAO destinationDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
            return;
        }

        try {
            int destId = Integer.parseInt(idParam);
            Destination dest = destinationDAO.getDestinationById(destId);
            
            if (dest == null) {
                response.sendRedirect(request.getContextPath() + "/explore.jsp?error=notFound");
                return;
            }

            request.setAttribute("destination", dest);
            request.getRequestDispatcher("/pages/destination-customize.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/explore.jsp");
        }
    }
}
