package com.voyastra.controller.booking;

import com.voyastra.dao.booking.BookingDraftDAO;
import com.voyastra.model.booking.BookingDraft;
import com.voyastra.model.Traveller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

    private static final Logger logger = LoggerFactory.getLogger(TravellerDetailsServlet.class);
    private BookingDraftDAO draftDAO = new BookingDraftDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doGetInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("TravellerDetailsServlet", "doGet", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("TravellerDetailsServlet", "doGet", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("TravellerDetailsServlet", "doGet", status, duration, "Traveller Details GET page load");
        }
    }

    private void doGetInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[TravellerDetailsServlet] doGet called.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            logger.warn("[TravellerDetailsServlet] Unauthorized access attempt. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            logger.warn("[TravellerDetailsServlet] Flight details missing from session. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        logger.info("[TravellerDetailsServlet] Rendering passenger details form.");
        request.getRequestDispatcher("/pages/booking/traveller-details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long startTime = System.currentTimeMillis();
        String status = "SUCCESS";
        try {
            doPostInternal(request, response);
        } catch (ServletException | IOException e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("TravellerDetailsServlet", "doPost", e);
            throw e;
        } catch (Exception e) {
            status = "ERROR";
            com.voyastra.util.ObservabilityLogger.logError("TravellerDetailsServlet", "doPost", e);
            throw new ServletException(e);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            com.voyastra.util.ObservabilityLogger.logStep("TravellerDetailsServlet", "doPost", status, duration, "Traveller Details POST page submission");
        }
    }

    private void doPostInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("[TravellerDetailsServlet] doPost called to save passenger details.");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            logger.warn("[TravellerDetailsServlet] Unauthorized access attempt in doPost. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, String> currentFlight = (Map<String, String>) session.getAttribute("currentFlight");
        if (currentFlight == null) {
            logger.warn("[TravellerDetailsServlet] Flight details missing from session in doPost. Redirecting to home.");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        
        int passengers = 1;
        try {
            passengers = Integer.parseInt(currentFlight.getOrDefault("passengers", "1"));
        } catch (NumberFormatException e) {
            logger.warn("[TravellerDetailsServlet] Invalid passengers count string in session, defaulting to 1: {}", e.getMessage());
        }

        String draftId = UUID.randomUUID().toString();
        logger.info("[TravellerDetailsServlet] Generating booking draft. ID: {}, User: {}, Passengers: {}", draftId, userId, passengers);

        BookingDraft draft = new BookingDraft();
        draft.setDraftId(draftId);
        draft.setUserId(userId);
        draft.setFlightId(currentFlight.get("id"));
        draft.setFlightName(currentFlight.get("name"));
        try { 
            draft.setFlightPrice(Double.parseDouble(currentFlight.get("price"))); 
        } catch(Exception e){
            logger.warn("[TravellerDetailsServlet] Could not parse flight price: {}", e.getMessage());
            draft.setFlightPrice(0.0);
        }
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

        logger.info("[TravellerDetailsServlet] Submitting draft write to database.");
        
        long daoStart = System.currentTimeMillis();
        boolean saved = draftDAO.createDraft(draft, travellers);
        long daoDuration = System.currentTimeMillis() - daoStart;
        com.voyastra.util.ObservabilityLogger.logStep("BookingDraftDAO", "createDraft", saved ? "SUCCESS" : "ERROR", daoDuration,
                "Save draft and travellers. Count: " + travellers.size(), userId, null);
                
        if (saved) {
            logger.info("[TravellerDetailsServlet] Draft and traveller list saved successfully. Redirecting to seat selection.");
            session.setAttribute("draftId", draftId);
            response.sendRedirect(request.getContextPath() + "/seat-selection");
        } else {
            logger.error("[TravellerDetailsServlet] Database write failed for draft ID: {}", draftId);
            request.setAttribute("error", "Could not save details. Please try again.");
            request.getRequestDispatcher("/pages/booking/traveller-details.jsp").forward(request, response);
        }
    }
}
