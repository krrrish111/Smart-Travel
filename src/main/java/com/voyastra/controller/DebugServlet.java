package com.voyastra.controller;

import com.voyastra.util.DiagnosticManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/debug")
public class DebugServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setAttribute("dbConnected", DiagnosticManager.dbConnected);
        request.setAttribute("servletsRegistered", DiagnosticManager.servletsRegistered);
        request.setAttribute("youtubeConfigured", DiagnosticManager.youtubeConfigured);
        request.setAttribute("unsplashConfigured", DiagnosticManager.unsplashConfigured);
        request.setAttribute("allStatuses", DiagnosticManager.getAllStatuses());

        request.getRequestDispatcher("/pages/common/debug.jsp").forward(request, response);
    }
}
