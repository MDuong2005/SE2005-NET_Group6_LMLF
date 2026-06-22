package controller;

import dao.SyllabusVersionDAO;
import dao.SyllabusReviewDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private final SyllabusVersionDAO versionDAO = new SyllabusVersionDAO();
    private final SyllabusReviewDAO reviewDAO = new SyllabusReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "pending";
        }

        switch (action) {
            case "pending":
                showPendingReviews(request, response);
                break;

            case "evaluate":
                showEvaluationScreen(request, response);
                break;

            default:
                showPendingReviews(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("approve".equals(action)) {
            approveSyllabus(request, response);
        } else if ("reject".equals(action)) {
            rejectSyllabus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/review?action=pending");
        }
    }

    private User getCurrentUser(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        return (User) session.getAttribute("user");
    }

    private void showPendingReviews(HttpServletRequest request,
                                    HttpServletResponse response)
            throws ServletException, IOException {

        User user = getCurrentUser(request, response);

        if (user == null) {
            return;
        }

        long reviewerId = user.getUserId();

        List<Map<String, Object>> pendingReviews =
                versionDAO.getPendingReviewsByReviewer(reviewerId);

        request.setAttribute("pendingReviews", pendingReviews);

        request.getRequestDispatcher("/views/review/pending-reviews.jsp")
                .forward(request, response);
    }

    private void showEvaluationScreen(HttpServletRequest request,
                                      HttpServletResponse response)
            throws ServletException, IOException {

        String versionIdRaw = request.getParameter("versionId");

        if (versionIdRaw == null || versionIdRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/review?action=pending");
            return;
        }

        long versionId = Long.parseLong(versionIdRaw);

        Map<String, Object> versionDetail =
                versionDAO.getReviewDetailByVersionId(versionId);

        request.setAttribute("versionDetail", versionDetail);

        request.getRequestDispatcher("/views/review/evaluation.jsp")
                .forward(request, response);
    }

    private void approveSyllabus(HttpServletRequest request,
                                 HttpServletResponse response)
            throws IOException {

        User user = getCurrentUser(request, response);

        if (user == null) {
            return;
        }

        long reviewerId = user.getUserId();
        long versionId = Long.parseLong(request.getParameter("versionId"));

        String comment = request.getParameter("comment");

        boolean updated = versionDAO.approveVersion(versionId, reviewerId);

        if (updated) {
            reviewDAO.insertReview(
                    versionId,
                    reviewerId,
                    "APPROVED",
                    comment
            );
        }

        response.sendRedirect(request.getContextPath() + "/review?action=pending");
    }

    private void rejectSyllabus(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        User user = getCurrentUser(request, response);

        if (user == null) {
            return;
        }

        long reviewerId = user.getUserId();
        long versionId = Long.parseLong(request.getParameter("versionId"));

        String comment = request.getParameter("comment");

        if (comment == null || comment.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/review?action=evaluate&versionId="
                    + versionId
                    + "&error=comment_required"
            );
            return;
        }

        boolean updated = versionDAO.rejectVersion(versionId, reviewerId);

        if (updated) {
            reviewDAO.insertReview(
                    versionId,
                    reviewerId,
                    "REJECTED",
                    comment
            );
        }

        response.sendRedirect(request.getContextPath() + "/review?action=pending");
    }
}