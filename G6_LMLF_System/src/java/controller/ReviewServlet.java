package controller;

import dao.ReviewAssignmentDAO;
import dao.ReviewCriteriaDAO;
import dao.ReviewerSyllabusDAO;
import dao.SyllabusReviewDAO;
import dao.ReviewerVersionDAO;
import dao.ReviewerSectionDAO;
import dao.ReviewerNotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import model.User;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private ReviewerVersionDAO versionDAO;
    private SyllabusReviewDAO reviewDAO;
    private ReviewCriteriaDAO criteriaDAO;
    private ReviewAssignmentDAO assignmentDAO;
    private ReviewerSyllabusDAO syllabusDAO;
    private ReviewerSectionDAO sectionDAO;
    private ReviewerNotificationDAO reviewerNotificationDAO;

    @Override
    public void init() {
        versionDAO = new ReviewerVersionDAO();
        reviewDAO = new SyllabusReviewDAO();
        criteriaDAO = new ReviewCriteriaDAO();
        assignmentDAO = new ReviewAssignmentDAO();
        syllabusDAO = new ReviewerSyllabusDAO();
        sectionDAO = new ReviewerSectionDAO();
        reviewerNotificationDAO = new ReviewerNotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("submitEvaluation".equals(action)) {
            submitEvaluation(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/review?action=pending");
        }
    }

    private Long getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            return null;
        }

        return user.getUserId();
    }

    private void showPendingReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long reviewerId = getCurrentUserId(request);

        if (reviewerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Map<String, Object>> pendingReviews
                = versionDAO.getPendingReviewsByAssignedReviewer(reviewerId);

        request.setAttribute("pendingReviews", pendingReviews);

        request.getRequestDispatcher("/views/review/pending-reviews.jsp")
                .forward(request, response);
    }

    private void showEvaluationScreen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long reviewerId = getCurrentUserId(request);

        if (reviewerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String versionIdStr = request.getParameter("versionId");

        if (versionIdStr == null || versionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/review?action=pending&error=missing_version");
            return;
        }

        try {
            Long versionId = Long.parseLong(versionIdStr);

            if (!assignmentDAO.isReviewerAssigned(versionId, reviewerId)) {
                response.sendRedirect(request.getContextPath() + "/review?action=pending&error=not_assigned");
                return;
            }

            if (reviewDAO.hasReviewerReviewed(versionId, reviewerId)) {
                response.sendRedirect(request.getContextPath() + "/review-history");
                return;
            }

            Map<String, Object> versionDetail = versionDAO.getReviewDetailByVersionId(versionId);
            List<Map<String, Object>> criteriaList = criteriaDAO.getActiveCriteria();
            Map<String, String> sectionContentMap = sectionDAO.getSectionContentMap(versionId);

            request.setAttribute("versionDetail", versionDetail);
            request.setAttribute("criteriaList", criteriaList);
            request.setAttribute("sectionContentMap", sectionContentMap);

            request.getRequestDispatcher("/views/review/evaluation.jsp")
                    .forward(request, response);
            List<Map<String, Object>> allImportedSections = sectionDAO.getAllSectionsByVersionId(versionId);
            request.setAttribute("allImportedSections", allImportedSections);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/review?action=pending&error=invalid_version");
        }
    }

    private void submitEvaluation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long reviewerId = getCurrentUserId(request);

        if (reviewerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String versionIdStr = request.getParameter("versionId");
        String summaryComment = request.getParameter("summaryComment");

        if (versionIdStr == null || versionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/review?action=pending&error=missing_version");
            return;
        }

        try {
            Long versionId = Long.parseLong(versionIdStr);

            if (!assignmentDAO.isReviewerAssigned(versionId, reviewerId)) {
                response.sendRedirect(request.getContextPath() + "/review?action=pending&error=not_assigned");
                return;
            }

            if (reviewDAO.hasReviewerReviewed(versionId, reviewerId)) {
                response.sendRedirect(request.getContextPath() + "/review-history");
                return;
            }

            List<Map<String, Object>> criteriaList = criteriaDAO.getActiveCriteria();

            boolean hasReject = false;
            boolean hasComment = false;

            for (Map<String, Object> criteria : criteriaList) {
                Long criteriaId = ((Number) criteria.get("criteria_id")).longValue();

                String decision = request.getParameter("decision_" + criteriaId);
                String comment = request.getParameter("comment_" + criteriaId);

                if (decision == null || decision.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/review?action=evaluate&versionId=" + versionId
                            + "&error=missing_decision");
                    return;
                }

                if ("REJECTED".equalsIgnoreCase(decision)) {
                    hasReject = true;

                    if (comment == null || comment.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath()
                                + "/review?action=evaluate&versionId=" + versionId
                                + "&error=reject_comment_required");
                        return;
                    }
                }

                if (comment != null && !comment.trim().isEmpty()) {
                    hasComment = true;
                }
            }

            String finalDecision;

            if (hasReject) {
                finalDecision = "REJECTED";
            } else if (hasComment) {
                finalDecision = "APPROVED_WITH_COMMENT";
            } else {
                finalDecision = "APPROVED";
            }

            Long reviewId = reviewDAO.insertReviewAndReturnId(
                    versionId,
                    reviewerId,
                    finalDecision,
                    summaryComment
            );

            if (reviewId == null) {
                response.sendRedirect(request.getContextPath()
                        + "/review?action=evaluate&versionId=" + versionId
                        + "&error=save_failed");
                return;
            }

            for (Map<String, Object> criteria : criteriaList) {
                Long criteriaId = ((Number) criteria.get("criteria_id")).longValue();

                String decision = request.getParameter("decision_" + criteriaId);
                String comment = request.getParameter("comment_" + criteriaId);

                reviewDAO.insertSectionReview(reviewId, criteriaId, decision, comment);
            }

            assignmentDAO.markCompleted(versionId, reviewerId);

            int assignedCount = assignmentDAO.countAssignedReviewers(versionId);
            int approvedCount = reviewDAO.countApprovedReviews(versionId);
            int rejectedCount = reviewDAO.countRejectedReviews(versionId);

            if (rejectedCount > 0) {
                versionDAO.updateStatus(versionId, "REJECTED");
                syllabusDAO.markRevisionRequiredByVersionId(versionId);

                reviewerNotificationDAO.notifyDesignerAfterReview(
                        versionId,
                        reviewerId,
                        finalDecision
                );

            } else if (assignedCount >= 2 && approvedCount == assignedCount) {
                versionDAO.updateStatus(versionId, "APPROVED");

                reviewerNotificationDAO.notifyAcademicWhenAllReviewersApproved(
                        versionId,
                        reviewerId
                );

            } else {
                reviewerNotificationDAO.notifyDesignerAfterReview(
                        versionId,
                        reviewerId,
                        finalDecision
                );
            }
            reviewerNotificationDAO.createReviewCompletedNotification(
                    versionId,
                    reviewerId,
                    finalDecision
            );
            response.sendRedirect(request.getContextPath() + "/review-history");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/review?action=pending&error=invalid_version");
        }
    }
}
