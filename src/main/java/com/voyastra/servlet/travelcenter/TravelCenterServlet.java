package com.voyastra.servlet.travelcenter;

import com.voyastra.dao.travelcenter.RewardDAO;
import com.voyastra.dao.travelcenter.TravelCenterDAO;
import com.voyastra.dao.travelcenter.WalletDAO;
import com.voyastra.model.User;
import com.voyastra.model.travelcenter.RewardProfile;
import com.voyastra.model.travelcenter.TravelReadiness;
import com.voyastra.model.travelcenter.Wallet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/travel-center")
public class TravelCenterServlet extends HttpServlet {
    private WalletDAO walletDAO = new WalletDAO();
    private RewardDAO rewardDAO = new RewardDAO();
    private TravelCenterDAO travelCenterDAO = new TravelCenterDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/travel-center");
            return;
        }

        // Fetch or create wallet
        Wallet wallet = walletDAO.getWalletByUserId(user.getId());
        if (wallet == null) wallet = walletDAO.createWallet(user.getId());

        // Fetch or create reward profile
        RewardProfile rewards = rewardDAO.getProfileByUserId(user.getId());
        if (rewards == null) rewards = rewardDAO.createProfile(user.getId());

        // Example readiness (In a real scenario, this is based on an active upcoming international trip)
        TravelReadiness readiness = travelCenterDAO.getReadiness(user.getId(), "Thailand");
        if (readiness == null) readiness = travelCenterDAO.createReadiness(user.getId(), "Thailand");

        request.setAttribute("wallet", wallet);
        request.setAttribute("rewards", rewards);
        request.setAttribute("readiness", readiness);

        request.getRequestDispatcher("/pages/travelcenter/dashboard.jsp").forward(request, response);
    }
}
