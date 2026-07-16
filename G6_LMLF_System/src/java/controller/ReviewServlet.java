package controller;

import dao.ReviewAssignmentDAO;
import dao.ReviewCriteriaDAO;
import dao.ReviewerNotificationDAO;
import dao.ReviewerSectionDAO;
import dao.ReviewerVersionDAO;
import dao.SyllabusReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.User;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    private ReviewerVersionDAO versionDAO;
    private SyllabusReviewDAO reviewDAO;
    private ReviewCriteriaDAO criteriaDAO;
    private ReviewAssignmentDAO assignmentDAO;
    private ReviewerSectionDAO sectionDAO;
    private ReviewerNotificationDAO notificationDAO;

    @Override
    public void init() {
        versionDAO = new ReviewerVersionDAO();
        reviewDAO = new SyllabusReviewDAO();
        criteriaDAO = new ReviewCriteriaDAO();
        assignmentDAO = new ReviewAssignmentDAO();
        sectionDAO = new ReviewerSectionDAO();
        notificationDAO = new ReviewerNotificationDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = "pending";
        }

        switch (action) {
            case "evaluate":
                showEvaluationScreen(request, response);
                break;

            case "pending":
            default:
                showPendingReviews(request, response);
                break;
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("submitEvaluation".equals(action)) {
            submitEvaluation(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/review?action=pending"
        );
    }

    private void showPendingReviews(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Long reviewerId = getCurrentUserId(request);

        if (reviewerId == null) {
            redirectToLogin(request, response);
            return;
        }

        List<Map<String, Object>> pendingReviews
                = versionDAO.getPendingReviewsByAssignedReviewer(
                        reviewerId
                );

        request.setAttribute("pendingReviews", pendingReviews);

        request.getRequestDispatcher(
                "/views/review/pending-reviews.jsp"
        ).forward(request, response);
    }

    private void showEvaluationScreen(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        Long reviewerId = getCurrentUserId(request);

        if (reviewerId == null) {
            redirectToLogin(request, response);
            return;
        }

        Long versionId = parsePositiveLong(
                request.getParameter("versionId")
        );

        if (versionId == null) {
            redirectPending(
                    request,
                    response,
                    "invalid_version"
            );
            return;
        }

        if (reviewDAO.hasReviewerReviewed(versionId, reviewerId)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/review-history"
            );
            return;
        }

        if (!assignmentDAO.isReviewerAssigned(
                versionId,
                reviewerId
        )) {
            redirectPending(
                    request,
                    response,
                    "not_assigned_or_closed"
            );
            return;
        }

        if (!assignmentDAO.markInProgress(
                versionId,
                reviewerId
        )) {
            redirectPending(
                    request,
                    response,
                    "cannot_start_review"
            );
            return;
        }

        Map<String, Object> versionDetail
                = versionDAO.getReviewDetailByVersionId(versionId);

        if (versionDetail == null) {
            redirectPending(
                    request,
                    response,
                    "version_not_found"
            );
            return;
        }

        List<Map<String, Object>> criteriaList
                = criteriaDAO.getActiveCriteria();

        Map<String, String> sectionContentMap
                = sectionDAO.getSectionContentMap(versionId);

        List<Map<String, Object>> allImportedSections
                = sectionDAO.getAllSectionsByVersionId(versionId);

        request.setAttribute("versionDetail", versionDetail);
        request.setAttribute("criteriaList", criteriaList);
        request.setAttribute("sectionContentMap", sectionContentMap);
        request.setAttribute(
                "allImportedSections",
                allImportedSections
        );

        request.getRequestDispatcher(
                "/views/review/evaluation.jsp"
        ).forward(request, response);
    }

    private void submitEvaluation(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Long reviewerId = getCurrentUserId(request);

        if (reviewerId == null) {
            redirectToLogin(request, response);
            return;
        }

        Long versionId = parsePositiveLong(
                request.getParameter("versionId")
        );

        if (versionId == null) {
            redirectPending(
                    request,
                    response,
                    "invalid_version"
            );
            return;
        }

        if (reviewDAO.hasReviewerReviewed(versionId, reviewerId)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/review-history"
            );
            return;
        }

        if (!assignmentDAO.isReviewerAssigned(
                versionId,
                reviewerId
        )) {
            redirectPending(
                    request,
                    response,
                    "not_assigned_or_closed"
            );
            return;
        }

        List<Map<String, Object>> criteriaList
                = criteriaDAO.getActiveCriteria();

        if (criteriaList == null || criteriaList.isEmpty()) {
            redirectEvaluation(
                    request,
                    response,
                    versionId,
                    "criteria_not_found"
            );
            return;
        }

        List<SyllabusReviewDAO.SectionDecision> sectionDecisions
                = new ArrayList<>();

        for (Map<String, Object> criteria : criteriaList) {
            Object criteriaIdObject = criteria.get("criteria_id");

            if (!(criteriaIdObject instanceof Number)) {
                redirectEvaluation(
                        request,
                        response,
                        versionId,
                        "invalid_criteria"
                );
                return;
            }

            long criteriaId
                    = ((Number) criteriaIdObject).longValue();

            String decision = trimToNull(
                    request.getParameter(
                            "decision_" + criteriaId
                    )
            );

            String comment = trimToNull(
                    request.getParameter(
                            "comment_" + criteriaId
                    )
            );

            if (!"APPROVED".equalsIgnoreCase(decision)
                    && !"REJECTED".equalsIgnoreCase(decision)) {
                redirectEvaluation(
                        request,
                        response,
                        versionId,
                        "missing_decision"
                );
                return;
            }

            if ("REJECTED".equalsIgnoreCase(decision)
                    && comment == null) {
                redirectEvaluation(
                        request,
                        response,
                        versionId,
                        "reject_comment_required"
                );
                return;
            }

            sectionDecisions.add(
                    new SyllabusReviewDAO.SectionDecision(
                            criteriaId,
                            decision.toUpperCase(),
                            comment
                    )
            );
        }

        String summaryComment = trimToNull(
                request.getParameter("summaryComment")
        );

        try {
            SyllabusReviewDAO.ReviewSubmissionResult result
                    = reviewDAO.submitEvaluation(
                            versionId,
                            reviewerId,
                            summaryComment,
                            sectionDecisions
                    );

            if (result.isRejected()) {
                notificationDAO.notifyDesignerAfterReview(
                        versionId,
                        reviewerId,
                        "REJECTED"
                );

            } else if (result.isAllApproved()) {
                notificationDAO.notifyAcademicWhenAllReviewersApproved(
                        versionId,
                        reviewerId
                );
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/review-history"
                    + "?submitted=1"
                    + "&decision="
                    + result.getReviewerDecision()
                    + "&workflow="
                    + result.getWorkflowStatus()
            );

        } catch (SQLException exception) {
            exception.printStackTrace();

            String message = exception.getMessage();
            String errorCode = "save_failed";

            if (message != null
                    && message.toLowerCase().contains(
                            "already closed"
                    )) {
                errorCode = "review_closed";
            }

            redirectEvaluation(
                    request,
                    response,
                    versionId,
                    errorCode
            );
        }
    }

    private Long getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object userObject = session.getAttribute("user");

        if (!(userObject instanceof User)) {
            return null;
        }

        User user = (User) userObject;
        return user.getUserId();
    }

    private Long parsePositiveLong(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            long parsed = Long.parseLong(value.trim());
            return parsed > 0 ? parsed : null;

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }

    private void redirectToLogin(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        response.sendRedirect(
                request.getContextPath() + "/login"
        );
    }

    private void redirectPending(
            HttpServletRequest request,
            HttpServletResponse response,
            String errorCode
    ) throws IOException {
        response.sendRedirect(
                request.getContextPath()
                + "/review?action=pending&error="
                + errorCode
        );
    }

    private void redirectEvaluation(
            HttpServletRequest request,
            HttpServletResponse response,
            long versionId,
            String errorCode
    ) throws IOException {
        response.sendRedirect(
                request.getContextPath()
                + "/review?action=evaluate"
                + "&versionId=" + versionId
                + "&error=" + errorCode
        );
    }
}