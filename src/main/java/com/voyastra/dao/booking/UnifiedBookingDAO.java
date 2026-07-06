package com.voyastra.dao.booking;

import com.voyastra.model.booking.UnifiedBooking;
import com.voyastra.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Aggregates bookings from every booking table for a given user.
 * Returns a unified list suitable for the My Journey dashboard.
 */
public class UnifiedBookingDAO {

    /**
     * Fetches all bookings for userId across every booking table.
     * Each booking is normalised into a UnifiedBooking.
     * Per-table counts are printed to stdout for production debugging.
     */
    public List<UnifiedBooking> getAllForUser(int userId) {
        List<UnifiedBooking> list = new ArrayList<>();
        System.out.println("[UnifiedBookingDAO] *** Starting booking fetch for userId=" + userId + " ***");

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.err.println("[UnifiedBookingDAO] DB connection is NULL – check DBConnection config");
                return list;
            }

            int before;

            // 1. Central bookings table
            before = list.size();
            fetchCentral(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] bookings (central):        " + (list.size() - before));

            // 2. destination_bookings
            before = list.size();
            fetchDestinations(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] destination_bookings:      " + (list.size() - before));

            // 3. activity_bookings
            before = list.size();
            fetchActivities(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] activity_bookings:         " + (list.size() - before));

            // 4. hotel_bookings
            before = list.size();
            fetchHotels(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] hotel_bookings:            " + (list.size() - before));

            // 5. flight_bookings (VIEW on bookings WHERE type='flight')
            before = list.size();
            fetchFlights(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] flight_bookings (view):    " + (list.size() - before));

            // 6. bus_bookings
            before = list.size();
            fetchBus(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] bus_bookings:              " + (list.size() - before));

            // 7. train_bookings
            before = list.size();
            fetchTrains(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] train_bookings:            " + (list.size() - before));

            // 8. cab_bookings
            before = list.size();
            fetchCabs(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] cab_bookings:              " + (list.size() - before));

            // 9. car_bookings
            before = list.size();
            fetchCars(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] car_bookings:              " + (list.size() - before));

            // 10. cruise_bookings
            before = list.size();
            fetchCruises(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] cruise_bookings:           " + (list.size() - before));

            // 11. helicopter_bookings
            before = list.size();
            fetchHelicopters(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] helicopter_bookings:       " + (list.size() - before));

            // 12. package_bookings
            before = list.size();
            fetchPackages(conn, userId, list);
            System.out.println("[UnifiedBookingDAO] package_bookings:          " + (list.size() - before));

            System.out.println("[UnifiedBookingDAO] *** TOTAL unified bookings: " + list.size() + " ***");

        } catch (Exception e) {
            System.err.println("[UnifiedBookingDAO] getAllForUser FAILED: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    // -------------------------------------------------------------------------
    // Private helper methods — one per booking table
    // -------------------------------------------------------------------------

    private void fetchCentral(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT b.id, b.booking_code, b.type, b.total_price, b.status, " +
                     "b.travel_date, b.created_at, p.title AS plan_title " +
                     "FROM bookings b LEFT JOIN plans p ON b.plan_id = p.id " +
                     "WHERE b.user_id = ? ORDER BY b.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setId(rs.getInt("id"));
                    u.setBookingRef(rs.getString("booking_code"));
                    String type = rs.getString("type");
                    u.setType(type != null ? type : "trip");
                    String title = rs.getString("plan_title");
                    u.setLabel(title != null ? title : "Booking #" + u.getId());
                    u.setDestination(u.getLabel());
                    u.setTravelDate(rs.getString("travel_date"));
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    u.setTicketUrl("/trip-ticket?id=" + u.getId());
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] central fetch failed: " + e.getMessage());
        }
    }

    private void fetchDestinations(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT db.id, db.order_id, db.payment_id, db.status, db.amount, " +
                     "db.travel_date, db.booking_date, d.title, d.destination " +
                     "FROM destination_bookings db " +
                     "JOIN destinations d ON db.destination_id = d.id " +
                     "WHERE db.user_id = ? ORDER BY db.booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setId(rs.getInt("id"));
                    String payId = rs.getString("payment_id");
                    String ordId = rs.getString("order_id");
                    u.setBookingRef(payId != null && !payId.isEmpty() ? payId : ordId);
                    u.setType("destination");
                    String title = rs.getString("title");
                    u.setLabel(title != null ? title : "Destination Booking");
                    u.setDestination(rs.getString("destination"));
                    Object td = rs.getObject("travel_date");
                    u.setTravelDate(td != null ? td.toString().substring(0, 10) : null);
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("amount"));
                    Timestamp ts = rs.getTimestamp("booking_date");
                    u.setCreatedAt(ts);
                    String idKey = payId != null && !payId.isEmpty() ? payId : String.valueOf(u.getId());
                    u.setTicketUrl("/trip-ticket?id=" + idKey + "&type=destination");
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] destinations fetch failed: " + e.getMessage());
        }
    }

    private void fetchActivities(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT ab.id, ab.booking_id, ab.travel_date, ab.status, ab.amount, ab.created_at, " +
                     "a.title, a.location " +
                     "FROM activity_bookings ab " +
                     "JOIN activities a ON ab.activity_id = a.id " +
                     "WHERE ab.user_id = ? ORDER BY ab.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setId(rs.getInt("id"));
                    u.setBookingRef(rs.getString("booking_id"));
                    u.setType("activity");
                    String title = rs.getString("title");
                    u.setLabel(title != null ? title : "Activity");
                    u.setDestination(rs.getString("location"));
                    u.setTravelDate(rs.getString("travel_date"));
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("amount"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    u.setTicketUrl("/activity/ticket?id=" + u.getId());
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] activities fetch failed: " + e.getMessage());
        }
    }

    private void fetchHotels(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT hb.id, hb.booking_code, hb.check_in, hb.check_out, hb.status, hb.total_price, hb.created_at, h.name, h.city " +
                     "FROM hotel_bookings hb " +
                     "LEFT JOIN hotels h ON hb.hotel_id = h.id " +
                     "WHERE hb.user_id = ? ORDER BY hb.created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setId(rs.getInt("id"));
                    u.setBookingRef(rs.getString("booking_code"));
                    u.setType("hotel");
                    String name = rs.getString("name");
                    u.setLabel(name != null ? name : "Hotel Stay");
                    u.setDestination(rs.getString("city"));
                    Object ci = rs.getObject("check_in");
                    u.setTravelDate(ci != null ? ci.toString().substring(0, 10) : null);
                    Object co = rs.getObject("check_out");
                    u.setEndDate(co != null ? co.toString().substring(0, 10) : null);
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    u.setTicketUrl("/hotel/ticket?id=" + u.getId());
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] hotels fetch failed: " + e.getMessage());
        }
    }

    private void fetchFlights(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT id, booking_code, travel_date, status, total_price, created_at, details " +
                     "FROM flight_bookings WHERE user_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setId(rs.getInt("id"));
                    u.setBookingRef(rs.getString("booking_code"));
                    u.setType("flight");
                    String details = rs.getString("details");
                    u.setLabel(extractFlightLabel(details));
                    u.setDestination(extractFlightRoute(details));
                    u.setTravelDate(rs.getString("travel_date"));
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    u.setTicketUrl("/flight/ticket?id=" + u.getId());
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] flights fetch failed: " + e.getMessage());
        }
    }

    private void fetchBus(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT id, journey_date, from_city, to_city, status, total_price, booking_date " +
                     "FROM bus_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    // bus_bookings.id is VARCHAR(50)
                    String busId = rs.getString("id");
                    u.setBookingRef(busId);
                    u.setType("bus");
                    String from = rs.getString("from_city");
                    String to = rs.getString("to_city");
                    u.setLabel("Bus: " + nullSafe(from) + " \u2192 " + nullSafe(to));
                    u.setDestination(nullSafe(to));
                    Object jd = rs.getObject("journey_date");
                    u.setTravelDate(jd != null ? jd.toString().substring(0, 10) : null);
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("booking_date"));
                    u.setTicketUrl("/bus/ticket?id=" + busId);
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] bus fetch failed: " + e.getMessage());
        }
    }

    private void fetchTrains(Connection conn, int userId, List<UnifiedBooking> list) {
        // train_bookings uses total_price column (not fare)
        String sql = "SELECT id, journey_date, from_station, to_station, status, total_price, booking_date " +
                     "FROM train_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    String trainId = rs.getString("id");
                    u.setBookingRef(trainId);
                    u.setType("train");
                    String from = rs.getString("from_station");
                    String to = rs.getString("to_station");
                    u.setLabel("Train: " + nullSafe(from) + " \u2192 " + nullSafe(to));
                    u.setDestination(nullSafe(to));
                    Object jd = rs.getObject("journey_date");
                    u.setTravelDate(jd != null ? jd.toString().substring(0, 10) : null);
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("booking_date"));
                    u.setTicketUrl("/train/ticket?id=" + trainId);
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] trains fetch failed: " + e.getMessage());
        }
    }

    private void fetchCabs(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT id, pickup_date, pickup_location, drop_location, status, total_price, booking_date " +
                     "FROM cab_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setBookingRef(rs.getString("id"));
                    u.setType("cab");
                    String from = rs.getString("pickup_location");
                    String to = rs.getString("drop_location");
                    u.setLabel("Cab: " + nullSafe(from) + " → " + nullSafe(to));
                    u.setDestination(nullSafe(to));
                    u.setTravelDate(rs.getString("pickup_date"));
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("booking_date"));
                    u.setTicketUrl("/cab/ticket?id=" + u.getBookingRef());
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] cabs fetch failed: " + e.getMessage());
        }
    }

    private void fetchCars(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT id, pickup_date, pickup_city, return_date, status, amount, booking_date " +
                     "FROM car_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setBookingRef(rs.getString("id"));
                    u.setType("car");
                    String city = rs.getString("pickup_city");
                    u.setLabel("Car Rental: " + nullSafe(city));
                    u.setDestination(nullSafe(city));
                    u.setTravelDate(rs.getString("pickup_date"));
                    u.setEndDate(rs.getString("return_date"));
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("amount"));
                    u.setCreatedAt(rs.getTimestamp("booking_date"));
                    u.setTicketUrl("/car/ticket?id=" + u.getBookingRef());
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] cars fetch failed: " + e.getMessage());
        }
    }

    private void fetchCruises(Connection conn, int userId, List<UnifiedBooking> list) {
        String sql = "SELECT id, cruise_date, departure_port, destination, status, amount, booking_date " +
                     "FROM cruise_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    u.setBookingRef(rs.getString("id"));
                    u.setType("cruise");
                    String dest = rs.getString("destination");
                    u.setLabel("Cruise to " + nullSafe(dest));
                    u.setDestination(nullSafe(dest));
                    u.setTravelDate(rs.getString("cruise_date"));
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("amount"));
                    u.setCreatedAt(rs.getTimestamp("booking_date"));
                    u.setTicketUrl("/cruise/ticket?id=" + u.getBookingRef());
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] cruises fetch failed: " + e.getMessage());
        }
    }

    private void fetchHelicopters(Connection conn, int userId, List<UnifiedBooking> list) {
        // helicopter_bookings uses journey_date and total_price
        String sql = "SELECT id, journey_date, origin, destination, status, total_price, booking_date " +
                     "FROM helicopter_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    String heliId = rs.getString("id");
                    u.setBookingRef(heliId);
                    u.setType("helicopter");
                    String from = rs.getString("origin");
                    String to = rs.getString("destination");
                    u.setLabel("Helicopter: " + nullSafe(from) + " \u2192 " + nullSafe(to));
                    u.setDestination(nullSafe(to));
                    Object jd = rs.getObject("journey_date");
                    u.setTravelDate(jd != null ? jd.toString().substring(0, 10) : null);
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("booking_date"));
                    u.setTicketUrl("/helicopter/ticket?id=" + heliId);
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] helicopters fetch failed: " + e.getMessage());
        }
    }

    private void fetchPackages(Connection conn, int userId, List<UnifiedBooking> list) {
        // package_bookings uses travel_date (DATE) and total_price
        String sql = "SELECT id, travel_date, destination, package_name, status, total_price, booking_date " +
                     "FROM package_bookings WHERE user_id = ? ORDER BY booking_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UnifiedBooking u = new UnifiedBooking();
                    String pkgId = rs.getString("id");
                    u.setBookingRef(pkgId);
                    u.setType("package");
                    String name = rs.getString("package_name");
                    String dest = rs.getString("destination");
                    u.setLabel(name != null ? name : "Package to " + nullSafe(dest));
                    u.setDestination(nullSafe(dest));
                    Object td = rs.getObject("travel_date");
                    u.setTravelDate(td != null ? td.toString().substring(0, 10) : null);
                    u.setStatus(rs.getString("status"));
                    u.setTotalPrice(rs.getDouble("total_price"));
                    u.setCreatedAt(rs.getTimestamp("booking_date"));
                    u.setTicketUrl("/trip-ticket?id=" + pkgId + "&type=package");
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UnifiedBookingDAO] packages fetch failed: " + e.getMessage());
        }
    }

    // -------------------------------------------------------------------------
    // Utility helpers
    // -------------------------------------------------------------------------

    private static String nullSafe(String s) {
        return s != null ? s : "";
    }

    private static String extractFlightLabel(String details) {
        if (details == null) return "Flight";
        try {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("Flight:\\s*([^|]+)").matcher(details);
            if (m.find()) return "Flight: " + m.group(1).trim();
        } catch (Exception ignore) {}
        return "Flight";
    }

    private static String extractFlightRoute(String details) {
        if (details == null) return "";
        try {
            int arrow = details.indexOf("→");
            if (arrow != -1) {
                int prevPipe = details.lastIndexOf("|", arrow);
                int nextPipe = details.indexOf("|", arrow);
                if (prevPipe != -1 && nextPipe != -1)
                    return details.substring(prevPipe + 1, nextPipe).trim();
            }
        } catch (Exception ignore) {}
        return "";
    }

    /**
     * Classify a booking into journey stage based on travel date and status.
     * Returns one of: "active", "upcoming", "completed", "cancelled"
     */
    public static String classifyBooking(UnifiedBooking b, LocalDate today) {
        if ("CANCELLED".equalsIgnoreCase(b.getStatus())) return "cancelled";

        String td = b.getTravelDate();
        if (td == null || td.isEmpty()) {
            // No date → treat as upcoming if status suggests so
            return b.isConfirmed() ? "upcoming" : "completed";
        }

        try {
            LocalDate travel = LocalDate.parse(td.length() > 10 ? td.substring(0, 10) : td);
            String endStr = b.getEndDate();
            LocalDate endDate = (endStr != null && !endStr.isEmpty())
                    ? LocalDate.parse(endStr.length() > 10 ? endStr.substring(0, 10) : endStr)
                    : travel;

            if (!today.isAfter(endDate) && !today.isBefore(travel)) return "active";
            if (travel.isAfter(today)) return "upcoming";
            return "completed";
        } catch (Exception e) {
            return "upcoming";
        }
    }
}
