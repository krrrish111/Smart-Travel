package com.voyastra.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import com.voyastra.model.User;

import java.io.ByteArrayOutputStream;

public class TransportPdfGenerator {

    public static byte[] generateGenericTicketPdf(Object bookingObj, User user) throws DocumentException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);

        document.open();

        Font headerFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);

        document.add(new Paragraph("VOYASTRA E-TICKET", headerFont));
        document.add(new Paragraph("Passenger: " + user.getName(), normalFont));
        
        String pnr = getPnr(bookingObj);
        document.add(new Paragraph("PNR / Booking Ref: " + pnr, normalFont));
        document.add(new Paragraph("Type: " + bookingObj.getClass().getSimpleName(), normalFont));
        document.add(new Paragraph("Status: CONFIRMED", normalFont));

        document.add(new Paragraph("--------------------------------------------------"));
        document.add(new Paragraph("Thank you for booking with Voyastra!", normalFont));
        
        document.close();
        return baos.toByteArray();
    }

    public static byte[] generateGenericInvoicePdf(Object bookingObj, User user) throws DocumentException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, baos);

        document.open();

        Font headerFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);

        document.add(new Paragraph("TAX INVOICE", headerFont));
        document.add(new Paragraph("Customer: " + user.getName(), normalFont));
        
        String pnr = getPnr(bookingObj);
        document.add(new Paragraph("Invoice Number: INV-" + pnr, normalFont));
        document.add(new Paragraph("Booking Ref: " + pnr, normalFont));
        document.add(new Paragraph("Date: " + new java.util.Date().toString(), normalFont));

        document.add(new Paragraph("--------------------------------------------------"));
        document.add(new Paragraph("Amount Paid: Confirmed", normalFont));
        
        document.close();
        return baos.toByteArray();
    }
    
    private static String getPnr(Object bookingObj) {
        if (bookingObj instanceof com.voyastra.model.TrainBooking) {
            return ((com.voyastra.model.TrainBooking) bookingObj).getId();
        } else if (bookingObj instanceof com.voyastra.model.BusBooking) {
            return ((com.voyastra.model.BusBooking) bookingObj).getId();
        } else if (bookingObj instanceof com.voyastra.model.CabBooking) {
            return ((com.voyastra.model.CabBooking) bookingObj).getId();
        } else if (bookingObj instanceof com.voyastra.model.CarBooking) {
            return ((com.voyastra.model.CarBooking) bookingObj).getId();
        } else if (bookingObj instanceof com.voyastra.model.CruiseBooking) {
            return ((com.voyastra.model.CruiseBooking) bookingObj).getId();
        } else if (bookingObj instanceof com.voyastra.model.HelicopterBooking) {
            return ((com.voyastra.model.HelicopterBooking) bookingObj).getId();
        }
        return "UNKNOWN";
    }
}
