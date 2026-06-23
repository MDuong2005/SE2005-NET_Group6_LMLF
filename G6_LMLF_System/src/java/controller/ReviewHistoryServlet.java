package controller;

import dao.SyllabusReviewDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;

@WebServlet(name = "ReviewHistoryServlet", urlPatterns = {"/review-history"})
public class ReviewHistoryServlet extends HttpServlet {

    private final SyllabusReviewDAO reviewDAO = new SyllabusReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        long reviewerId = user.getUserId();

        List<Map<String, Object>> reviewHistory =
                reviewDAO.getReviewHistoryByReviewer(reviewerId);

        request.setAttribute("reviewHistory", reviewHistory);

        request.getRequestDispatcher("/views/review/review-history.jsp")
                .forward(request, response);
    }
}