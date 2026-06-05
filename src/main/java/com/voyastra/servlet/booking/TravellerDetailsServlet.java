package com.voyastra.servlet.booking;

import com.voyastra.dao.BookingDraftDAO;
import com.voyastra.model.BookingDraft;
import com.voyastra.model.Traveller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet("/travellers")
public class TravellerDetailsServlet extends HttpServlet {

    private BookingDraftDAO draftDAO = new BookingDraftDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/pages/booking/traveller-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        int passengers = Integer.parseInt(currentFlight.getOrDefault("passengers", "1"));
        String draftId = UUID.randomUUID().toString();

        BookingDraft draft = new BookingDraft();
        draft.setDraftId(draftId);
        draft.setUserId(userId);
        draft.setFlightId(currentFlight.get("id"));
        draft.setFlightName(currentFlight.get("name"));
        try { draft.setFlightPrice(Double.parseDouble(currentFlight.get("price"))); } catch(Exception e){}
        draft.setFlightClass(currentFlight.get("class"));
        draft.setPassengers(passengers);
        draft.setTravelDate(currentFlight.get("date"));
        draft.setOrigin(currentFlight.get("from"));
        draft.setDestination(currentFlight.get("to"));
        
        draft.setContactEmail(request.getParameter("contactEmail"));
        draft.setContactPhone(request.getParameter("contactPhone"));
        draft.setGstNumber(request.getParameter("gstNumber"));

        List<Traveller> travellers = new ArrayList<>();
        for (int i = 1; i <= passengers; i++) {
            Traveller t = new Traveller();
            t.setDraftId(draftId);
            t.setTitle(request.getParameter("title_" + i));
            t.setFirstName(request.getParameter("firstName_" + i));
            t.setLastName(request.getParameter("lastName_" + i));
            t.setGender(request.getParameter("gender_" + i));
            t.setDob(request.getParameter("dob_" + i));
            t.setNationality(request.getParameter("nationality_" + i));
            t.setPassport(request.getParameter("passport_" + i));
            travellers.add(t);
        }

        // Validate (basic validation handled by HTML5 required fields, we just trust it for now)
        boolean saved = draftDAO.createDraft(draft, travellers);
        if (saved) {
            session.setAttribute("draftId", draftId);
            response.sendRedirect(request.getContextPath() + "/seat-selection");
        } else {
            request.setAttribute("error", "Could not save details. Please try again.");
            request.getRequestDispatcher("/pages/booking/traveller-details.jsp").forward(request, response);
        }
    }
}
