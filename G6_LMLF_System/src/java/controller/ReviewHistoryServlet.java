package controller;

import dao.SyllabusReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.User;

@WebServlet(name = "ReviewHistoryServlet", urlPatterns = {"/review-history"})
public class ReviewHistoryServlet extends HttpServlet {

    private SyllabusReviewDAO reviewDAO;

    @Override
    public void init() {
        reviewDAO = new SyllabusReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Long reviewerId = user.getUserId();

        List<Map<String, Object>> reviewHistory =
                reviewDAO.getReviewHistoryByReviewer(reviewerId);

        Map<Long, List<Map<String, Object>>> sectionReviewsMap =
                reviewDAO.getSectionReviewsByReviewer(reviewerId);

        request.setAttribute("reviewHistory", reviewHistory);
        request.setAttribute("sectionReviewsMap", sectionReviewsMap);

        request.getRequestDispatcher("/views/review/review-history.jsp")
                .forward(request, response);
    }
}