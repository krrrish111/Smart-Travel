import os

servlet_dir = "src/main/java/com/voyastra/servlet"
transport_dir = os.path.join(servlet_dir, "transport")
booking_dir = os.path.join(servlet_dir, "booking")

os.makedirs(transport_dir, exist_ok=True)
os.makedirs(booking_dir, exist_ok=True)

modules = [
    {"name": "Flight", "path": "flight", "dao": "FlightBookingDAO", "model": "FlightBooking", "details_jsp": "/pages/booking/flight-details.jsp", "ticket_jsp": "/pages/flight-ticket.jsp", "dir": booking_dir, "type_param": "String"},
    {"name": "Hotel", "path": "hotel", "dao": "HotelBookingDAO", "model": "HotelBooking", "details_jsp": "/pages/hotel-confirmation.jsp", "ticket_jsp": "/pages/hotel-ticket.jsp", "dir": servlet_dir, "type_param": "int"},
    {"name": "Train", "path": "train", "dao": "TrainBookingDAO", "model": "TrainBooking", "details_jsp": "/pages/transport/train-confirmation.jsp", "ticket_jsp": "/pages/transport/train-ticket.jsp", "dir": transport_dir, "type_param": "String"},
    {"name": "Bus", "path": "bus", "dao": "BusBookingDAO", "model": "BusBooking", "details_jsp": "/pages/transport/bus-confirmation.jsp", "ticket_jsp": "/pages/transport/bus-ticket.jsp", "dir": transport_dir, "type_param": "String"},
    {"name": "Cab", "path": "cab", "dao": "CabBookingDAO", "model": "CabBooking", "details_jsp": "/pages/transport/cab-confirmation.jsp", "ticket_jsp": "/pages/transport/cab-ticket.jsp", "dir": transport_dir, "type_param": "String"},
    {"name": "Car", "path": "car", "dao": "CarBookingDAO", "model": "CarBooking", "details_jsp": "/pages/transport/car-confirmation.jsp", "ticket_jsp": "/pages/transport/car-ticket.jsp", "dir": transport_dir, "type_param": "String"},
    {"name": "Cruise", "path": "cruise", "dao": "CruiseBookingDAO", "model": "CruiseBooking", "details_jsp": "/pages/transport/cruise-confirmation.jsp", "ticket_jsp": "/pages/transport/cruise-ticket.jsp", "dir": transport_dir, "type_param": "String"},
    {"name": "Helicopter", "path": "helicopter", "dao": "HelicopterBookingDAO", "model": "HelicopterBooking", "details_jsp": "/pages/transport/helicopter-confirmation.jsp", "ticket_jsp": "/pages/transport/helicopter-ticket.jsp", "dir": transport_dir, "type_param": "String"}
]

details_template = """package com.voyastra.servlet{pkg};

import com.voyastra.model.{model};
import com.voyastra.dao.{dao};
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/{path}/details")
public class {name}DetailsServlet extends HttpServlet {{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {{
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }}
        {model} booking = null;
        try {{
            {param_parse}
            booking = new {dao}().getBookingById(idParam);
        }} catch(Exception e) {{
            e.printStackTrace();
        }}
        
        System.out.println("Booking Loaded: " + booking);
        if (booking != null) {{
            System.out.println("Amount: " + booking.getAmountPaid());
            System.out.println("Status: " + booking.getBookingStatus());
        }}
        
        if (booking == null) {{
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }}
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("{jsp}").forward(request, response);
    }}
}}
"""

ticket_template = """package com.voyastra.servlet{pkg};

import com.voyastra.model.{model};
import com.voyastra.dao.{dao};
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/{path}/ticket")
public class {name}TicketServlet extends HttpServlet {{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {{
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }}
        {model} booking = null;
        try {{
            {param_parse}
            booking = new {dao}().getBookingById(idParam);
        }} catch(Exception e) {{
            e.printStackTrace();
        }}
        
        if (booking == null) {{
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }}
        request.setAttribute("booking", booking);
        
        String print = request.getParameter("print");
        if ("true".equals(print)) {{
            request.setAttribute("autoPrint", true);
        }}
        
        request.getRequestDispatcher("{jsp}").forward(request, response);
    }}
}}
"""

download_template = """package com.voyastra.servlet{pkg};

import com.voyastra.model.{model};
import com.voyastra.dao.{dao};
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/{path}/download-ticket")
public class {name}DownloadTicketServlet extends HttpServlet {{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {{
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {{
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }}
        {model} booking = null;
        try {{
            {param_parse}
            booking = new {dao}().getBookingById(idParam);
        }} catch(Exception e) {{
            e.printStackTrace();
        }}
        
        if (booking == null) {{
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }}
        request.setAttribute("booking", booking);
        request.setAttribute("autoDownload", true);
        
        request.getRequestDispatcher("{jsp}").forward(request, response);
    }}
}}
"""

for mod in modules:
    pkg = ""
    if mod['dir'] == transport_dir:
        pkg = ".transport"
    elif mod['dir'] == booking_dir:
        pkg = ".booking"
        
    param_parse = "String idParam = bookingId;"
    if mod['type_param'] == 'int':
        param_parse = "int idParam = Integer.parseInt(bookingId);"
        
    # Write Details Servlet
    details_code = details_template.format(
        pkg=pkg, model=mod['model'], dao=mod['dao'], path=mod['path'],
        name=mod['name'], param_parse=param_parse, jsp=mod['details_jsp']
    )
    with open(os.path.join(mod['dir'], f"{mod['name']}DetailsServlet.java"), 'w', encoding='utf-8') as f:
        f.write(details_code)
        
    # Write Ticket Servlet
    ticket_code = ticket_template.format(
        pkg=pkg, model=mod['model'], dao=mod['dao'], path=mod['path'],
        name=mod['name'], param_parse=param_parse, jsp=mod['ticket_jsp']
    )
    with open(os.path.join(mod['dir'], f"{mod['name']}TicketServlet.java"), 'w', encoding='utf-8') as f:
        f.write(ticket_code)
        
    # Write Download Servlet
    download_code = download_template.format(
        pkg=pkg, model=mod['model'], dao=mod['dao'], path=mod['path'],
        name=mod['name'], param_parse=param_parse, jsp=mod['ticket_jsp']
    )
    with open(os.path.join(mod['dir'], f"{mod['name']}DownloadTicketServlet.java"), 'w', encoding='utf-8') as f:
        f.write(download_code)

print("Servlets generated successfully.")
