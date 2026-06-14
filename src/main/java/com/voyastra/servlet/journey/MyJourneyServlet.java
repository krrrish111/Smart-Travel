package com.voyastra.servlet.journey;

import com.voyastra.dao.JourneyDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.dao.journey.MyJourneyEcosystemDAO;
import com.voyastra.model.Journey;
import com.voyastra.model.Booking;
import com.voyastra.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;

@WebServlet("/my-journey")
public class MyJourneyServlet extends HttpServlet {

    private JourneyDAO journeyDAO;
    private MyJourneyEcosystemDAO ecosystemDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        journeyDAO = new JourneyDAO();
        ecosystemDAO = new MyJourneyEcosystemDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/my-journey");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "overview";
        }
        request.setAttribute("activeTab", tab);
        
        // Always fetch active journey
        Journey activeJourney = journeyDAO.getActiveJourneyForUser(String.valueOf(user.getId()));
        request.setAttribute("journey", activeJourney);
        
        // Fetch upcoming and completed trips if required
        if (tab.equals("upcoming") || tab.equals("completed") || tab.equals("memories") || tab.equals("overview") || tab.equals("calendar") || tab.equals("dna") || tab.equals("family") || tab.equals("reports")) {
            List<Booking> allBookings = bookingDAO.getBookingsByUser(user.getId());
            List<Booking> upcomingTrips = new ArrayList<>();
            List<Booking> completedTrips = new ArrayList<>();
            LocalDate today = LocalDate.now();

            for (Booking b : allBookings) {
                if ("CONFIRMED".equalsIgnoreCase(b.getStatus()) || "ACTIVE".equalsIgnoreCase(b.getStatus())) {
                    boolean isUpcoming = true;
                    if (b.getTravelDate() != null && !b.getTravelDate().isEmpty()) {
                        try {
                            LocalDate travelDate = LocalDate.parse(b.getTravelDate());
                            if (travelDate.isBefore(today)) {
                                isUpcoming = false;
                            }
                        } catch (Exception e) {}
                    }
                    if (isUpcoming) {
                        upcomingTrips.add(b);
                    } else {
                        completedTrips.add(b);
                    }
                } else if ("COMPLETED".equalsIgnoreCase(b.getStatus())) {
                    completedTrips.add(b);
                }
            }
            request.setAttribute("upcomingTrips", upcomingTrips);
            request.setAttribute("completedTrips", completedTrips);

            // If we're on the memories tab, let's also fetch memories for each completed trip
            if (tab.equals("memories")) {
                java.util.Map<Integer, List<com.voyastra.model.journey.TravelMemory>> memoriesMap = new java.util.HashMap<>();
                for (Booking t : completedTrips) {
                    memoriesMap.put(t.getId(), ecosystemDAO.getMemoriesForJourney(t.getId()));
                }
                request.setAttribute("tripMemoriesMap", memoriesMap);
            }
            
            if (tab.equals("dna")) {
                request.setAttribute("travelDNA", ecosystemDAO.calculateTravelDNA(user.getId(), completedTrips));
            }
        }
        
        // Fetch specific data based on tab
        if (tab.equals("family")) {
            request.setAttribute("familyMembers", ecosystemDAO.getFamilyMembersForUser(user.getId()));
        } else if (tab.equals("reports")) {
            request.setAttribute("tripReports", ecosystemDAO.getTripReportsForUser(user.getId()));
            List<Booking> completedTrips = (List<Booking>) request.getAttribute("completedTrips");
            request.setAttribute("annualReport", ecosystemDAO.generateAnnualReport(user.getId(), completedTrips));
        }
        
        // We always go to the main ecosystem dashboard now
        request.getRequestDispatcher("/pages/journey/my-journey.jsp").forward(request, response);
    }
}
