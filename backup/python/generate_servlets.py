import os

base_dir = r"C:\Users\Dell\Desktop\antigravity\src\main\java\com\voyastra\servlet\transport"
flight_dir = r"C:\Users\Dell\Desktop\antigravity\src\main\java\com\voyastra\servlet\booking"
hotel_dir = r"C:\Users\Dell\Desktop\antigravity\src\main\java\com\voyastra\servlet"

types = [
    {"name": "Flight", "lower": "flight", "model": "FlightBooking", "dao": "com.voyastra.dao.FlightBookingDAO", "daomethod": "getBookingById", "dir": flight_dir, "pkg": "com.voyastra.servlet.booking", "jsp_details": "/pages/booking/flight-details.jsp", "jsp_ticket": "/pages/booking/booking-success.jsp", "id_type": "int"},
    {"name": "Hotel", "lower": "hotel", "model": "HotelBooking", "dao": "com.voyastra.dao.HotelBookingDAO", "daomethod": "getBookingById", "dir": hotel_dir, "pkg": "com.voyastra.servlet", "jsp_details": "/pages/hotel-confirmation.jsp", "jsp_ticket": "/pages/booking/invoice.jsp", "id_type": "int"},
    {"name": "Train", "lower": "train", "model": "TrainBooking", "dao": "com.voyastra.dao.TrainBookingDAO", "daomethod": "getBookingById", "dir": base_dir, "pkg": "com.voyastra.servlet.transport", "jsp_details": "/pages/transport/train-confirmation.jsp", "jsp_ticket": "/pages/transport/train-ticket.jsp", "id_type": "String"},
    {"name": "Bus", "lower": "bus", "model": "BusBooking", "dao": "com.voyastra.dao.BusBookingDAO", "daomethod": "getBookingById", "dir": base_dir, "pkg": "com.voyastra.servlet.transport", "jsp_details": "/pages/transport/bus-confirmation.jsp", "jsp_ticket": "/pages/transport/bus-ticket.jsp", "id_type": "String"},
    {"name": "Cab", "lower": "cab", "model": "CabBooking", "dao": "com.voyastra.dao.CabBookingDAO", "daomethod": "getBookingById", "dir": base_dir, "pkg": "com.voyastra.servlet.transport", "jsp_details": "/pages/transport/cab-confirmation.jsp", "jsp_ticket": "/pages/transport/cab-ticket.jsp", "id_type": "String"},
    {"name": "Car", "lower": "car", "model": "CarBooking", "dao": "com.voyastra.dao.CarBookingDAO", "daomethod": "getBookingById", "dir": base_dir, "pkg": "com.voyastra.servlet.transport", "jsp_details": "/pages/transport/car-confirmation.jsp", "jsp_ticket": "/pages/transport/car-ticket.jsp", "id_type": "String"},
    {"name": "Cruise", "lower": "cruise", "model": "CruiseBooking", "dao": "com.voyastra.dao.CruiseBookingDAO", "daomethod": "getBookingById", "dir": base_dir, "pkg": "com.voyastra.servlet.transport", "jsp_details": "/pages/transport/cruise-confirmation.jsp", "jsp_ticket": "/pages/transport/cruise-ticket.jsp", "id_type": "String"},
    {"name": "Helicopter", "lower": "helicopter", "model": "HelicopterBooking", "dao": "com.voyastra.dao.HelicopterBookingDAO", "daomethod": "getBookingById", "dir": base_dir, "pkg": "com.voyastra.servlet.transport", "jsp_details": "/pages/transport/helicopter-confirmation.jsp", "jsp_ticket": "/pages/transport/helicopter-ticket.jsp", "id_type": "String"},
]

def generate_details_servlet(t):
    id_arg = 'Integer.parseInt(bookingId)' if t['id_type'] == 'int' else 'bookingId'
    return f"""package {t['pkg']};

import com.voyastra.model.{t['model']};
import {t['dao']};
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/{t['lower']}/details")
public class {t['name']}BookingDetailsServlet extends HttpServlet {{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{
        String bookingId = request.getParameter("id");
        System.out.println("Booking ID = " + bookingId);
        System.out.println("Booking Type = {t['lower']}");
        if (bookingId == null || bookingId.isEmpty()) {{
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }}
        {t['model']} booking = null;
        try {{
            booking = new {t['dao']}().{t['daomethod']}({id_arg});
        }} catch(Exception e) {{
            e.printStackTrace();
        }}
        System.out.println("Booking Loaded = " + booking);
        if (booking == null) {{
            System.out.println("Error: Booking is null for id " + bookingId);
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }}
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("{t['jsp_details']}").forward(request, response);
    }}
}}
"""

def generate_ticket_servlet(t):
    id_arg = 'Integer.parseInt(bookingId)' if t['id_type'] == 'int' else 'bookingId'
    return f"""package {t['pkg']};

import com.voyastra.model.{t['model']};
import {t['dao']};
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/{t['lower']}/ticket")
public class {t['name']}TicketServlet extends HttpServlet {{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{
        String bookingId = request.getParameter("id");
        System.out.println("Booking ID = " + bookingId);
        System.out.println("Booking Type = {t['lower']}");
        if (bookingId == null || bookingId.isEmpty()) {{
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }}
        {t['model']} booking = null;
        try {{
            booking = new {t['dao']}().{t['daomethod']}({id_arg});
        }} catch(Exception e) {{
            e.printStackTrace();
        }}
        System.out.println("Booking Loaded = " + booking);
        if (booking == null) {{
            System.out.println("Error: Booking is null for id " + bookingId);
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }}
        request.setAttribute("booking", booking);
        String print = request.getParameter("print");
        if (print != null && print.equals("true")) {{
            request.setAttribute("autoPrint", true);
        }}
        request.getRequestDispatcher("{t['jsp_ticket']}").forward(request, response);
    }}
}}
"""

def generate_download_servlet(t):
    id_arg = 'Integer.parseInt(bookingId)' if t['id_type'] == 'int' else 'bookingId'
    return f"""package {t['pkg']};

import com.voyastra.model.{t['model']};
import {t['dao']};
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/{t['lower']}/download-ticket")
public class {t['name']}DownloadTicketServlet extends HttpServlet {{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{
        String bookingId = request.getParameter("id");
        System.out.println("Booking ID = " + bookingId);
        System.out.println("Booking Type = {t['lower']}");
        if (bookingId == null || bookingId.isEmpty()) {{
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }}
        {t['model']} booking = null;
        try {{
            booking = new {t['dao']}().{t['daomethod']}({id_arg});
        }} catch(Exception e) {{
            e.printStackTrace();
        }}
        System.out.println("Booking Loaded = " + booking);
        if (booking == null) {{
            System.out.println("Error: Booking is null for id " + bookingId);
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }}
        request.setAttribute("booking", booking);
        request.setAttribute("autoDownload", true);
        request.getRequestDispatcher("{t['jsp_ticket']}").forward(request, response);
    }}
}}
"""

for t in types:
    os.makedirs(t['dir'], exist_ok=True)
    with open(os.path.join(t['dir'], f"{t['name']}BookingDetailsServlet.java"), "w", encoding="utf-8") as f:
        f.write(generate_details_servlet(t))
    with open(os.path.join(t['dir'], f"{t['name']}TicketServlet.java"), "w", encoding="utf-8") as f:
        f.write(generate_ticket_servlet(t))
    with open(os.path.join(t['dir'], f"{t['name']}DownloadTicketServlet.java"), "w", encoding="utf-8") as f:
        f.write(generate_download_servlet(t))

print("Servlets generated.")
