package com.voyastra.servlet;

import com.voyastra.dao.BookingDAO;
import com.voyastra.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * BookingServlet — handles the "Select" button from search results.
 *
 * Flow:
 *   GET /book?type=flight&id=AI-101&price=4800&name=Air+India&class=economy
 *   → Build Booking object
 *   → Save to DB via BookingDAO.createBooking()
 *   → Store in session as "currentBooking"
 *   → Redirect to /payment
 */
@WebServlet("/book")
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ── Auth guard ──────────────────────────────────────────────────────
        if (session == null || session.getAttribute("user_id") == null) {
            String fullPath = "/book?" + request.getQueryString();
            response.sendRedirect(request.getContextPath()
                    + "/login?redirect=" + java.net.URLEncoder.encode(fullPath, "UTF-8"));
            return;
        }

        // ── Read URL params ─────────────────────────────────────────────────
        String type       = getParam(request, "type",  "flight");
        String refId      = getParam(request, "id",    "N/A");
        String name       = getParam(request, "name",  "Voyastra Service");
        String priceStr   = getParam(request, "price", "0");
        String seatClass  = getParam(request, "class", "economy");
        String passengers = getParam(request, "passengers", "1");
        String travelDate = getParam(request, "date",  "");
        String from       = getParam(request, "from",  "");
        String to         = getParam(request, "to",    "");

        double price = 0;
        try { price = Double.parseDouble(priceStr); } catch (Exception ignored) {}

        int userId = 0;
        try { userId = (int) session.getAttribute("user_id"); } catch (Exception ignored) {}

        String userName  = safeStr(session.getAttribute("name"),  "Guest");
        String userEmail = safeStr(session.getAttribute("email"), "");

        // ── Build readable details string ───────────────────────────────────
        String details = buildDetails(type, refId, name, seatClass, passengers, from, to, travelDate);

        // ── Generate unique booking code ────────────────────────────────────
        String bookingCode = generateBookingCode(type);

        // ── Populate Booking model ──────────────────────────────────────────
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setType(type);
        booking.setDetails(details);
        booking.setTotalPrice(price + 250);    // add ₹250 taxes
        booking.setStatus("PENDING");
        booking.setBookingCode(bookingCode);
        booking.setCustomerName(userName);
        booking.setCustomerEmail(userEmail);
        booking.setCustomerPhone("");
        booking.setTravelDate(travelDate);
        booking.setNumAdults(parseIntSafe(passengers, 1));
        booking.setNumChildren(0);
        booking.setRoomType(seatClass);

        // ── Persist to DB ───────────────────────────────────────────────────
        int bookingId = -1;
        try {
            bookingId = bookingDAO.createBooking(booking);
        } catch (Exception e) {
            System.err.println("[BookingServlet] DB save failed: " + e.getMessage());
        }

        if (bookingId > 0) {
            booking.setId(bookingId);
        } else {
            // Graceful degradation: proceed without DB (e.g., DB not available)
            System.err.println("[BookingServlet] DB save failed; continuing in session-only mode.");
            booking.setId(-1);
        }

        // ── Extra display fields (not persisted separately, for JSP use) ────
        booking.setPlanTitle(name);
        booking.setPlanImage(resolveTypeImage(type));

        // ── Store in session ────────────────────────────────────────────────
        session.setAttribute("currentBooking", booking);
        session.setAttribute("bookingId", bookingId);

        System.out.println("[BookingServlet] Booking created: " + bookingCode
                + " | type=" + type + " | price=₹" + (price + 250)
                + " | db_id=" + bookingId);

        // ── Redirect to payment ─────────────────────────────────────────────
        response.sendRedirect(request.getContextPath()
                + "/pages/payment.jsp?id=" + bookingId);
    }

    // ──────────────────────── HELPERS ──────────────────────────────────────

    private String buildDetails(String type, String refId, String name,
                                String seatClass, String passengers,
                                String from, String to, String date) {
        StringBuilder sb = new StringBuilder();
        switch (type.toLowerCase()) {
            case "flight":
                sb.append("Flight: ").append(name)
                  .append(" (").append(refId).append(")")
                  .append(" | ").append(from.toUpperCase())
                  .append(" → ").append(to.toUpperCase())
                  .append(" | Class: ").append(capitalize(seatClass))
                  .append(" | Passengers: ").append(passengers);
                if (!date.isEmpty()) sb.append(" | Date: ").append(date);
                break;
            case "hotel":
                sb.append("Hotel: ").append(name)
                  .append(" | Location: ").append(to)
                  .append(" | Guests: ").append(passengers);
                if (!date.isEmpty()) sb.append(" | Check-in: ").append(date);
                break;
            case "taxi": case "car": case "bus": case "train":
                sb.append("Transport: ").append(name)
                  .append(" (").append(refId).append(")")
                  .append(" | ").append(from).append(" → ").append(to);
                if (!date.isEmpty()) sb.append(" | Date: ").append(date);
                break;
            case "tour":
                sb.append("Tour: ").append(name)
                  .append(" | Guests: ").append(passengers);
                if (!date.isEmpty()) sb.append(" | Date: ").append(date);
                break;
            default:
                sb.append("Booking: ").append(name).append(" | Ref: ").append(refId);
        }
        return sb.toString();
    }

    private String generateBookingCode(String type) {
        String prefix = "VYS";
        if ("flight".equalsIgnoreCase(type))           prefix = "FLT";
        else if ("hotel".equalsIgnoreCase(type))        prefix = "HTL";
        else if ("taxi".equalsIgnoreCase(type)
              || "car".equalsIgnoreCase(type))          prefix = "CAB";
        else if ("tour".equalsIgnoreCase(type))         prefix = "TUR";
        String year = new SimpleDateFormat("yyyy").format(new Date());
        int rand = 10000 + new Random().nextInt(89999);
        return prefix + "-" + year + "-" + rand;
    }

    private String resolveTypeImage(String type) {
        switch (type.toLowerCase()) {
            case "flight": return "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=600&q=80";
            case "hotel":  return "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=600&q=80";
            case "tour":   return "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=600&q=80";
            default:       return "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?auto=format&fit=crop&w=600&q=80";
        }
    }

    private String getParam(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.trim().isEmpty()) ? v.trim() : def;
    }

    private String safeStr(Object o, String def) {
        return (o != null) ? o.toString() : def;
    }

    private int parseIntSafe(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private String capitalize(String s) {
        if (s == null || s.isEmpty()) return s;
        return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
    }
}
