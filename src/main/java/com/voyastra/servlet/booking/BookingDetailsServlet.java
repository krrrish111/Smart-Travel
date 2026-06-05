package com.voyastra.servlet.booking;

import com.voyastra.dao.BoardingPassDAO;
import com.voyastra.dao.BookingDAO;
import com.voyastra.model.BoardingPass;
import com.voyastra.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/booking-details")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class BookingDetailsServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private BoardingPassDAO passDAO = new BoardingPassDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings");
            return;
        }

        Booking booking = bookingDAO.getBookingByCode(code);
        if (booking == null || booking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=not_found");
            return;
        }

        List<BoardingPass> passes = passDAO.getPassesByBooking(booking.getId());

        request.setAttribute("booking", booking);
        request.setAttribute("passes", passes);

        request.getRequestDispatcher("/pages/booking/booking-timeline.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) return;
        
        String code = request.getParameter("code");
        Booking booking = bookingDAO.getBookingByCode(code);
        if (booking == null) return;

        Part filePart = request.getPart("boardingPass");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "boarding_passes";
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);
            
            BoardingPass bp = new BoardingPass();
            bp.setBookingId(booking.getId());
            bp.setFilePath("uploads/boarding_passes/" + fileName);
            passDAO.saveBoardingPass(bp);
        }

        response.sendRedirect(request.getContextPath() + "/booking-details?code=" + code + "&success=uploaded");
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "pass.pdf";
    }
}
