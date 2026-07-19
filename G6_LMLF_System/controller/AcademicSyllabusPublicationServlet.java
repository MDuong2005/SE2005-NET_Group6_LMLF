package controller;

import constant.RoleConstants;
import dao.AcademicSyllabusPublicationDAO;
import dao.AcademicSyllabusPublicationDAO.PublishResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.AcademicPublicationItem;
import model.User;
import utils.AuditUtil;
import utils.SessionUtil;

@WebServlet("/academic/syllabus-publication")
public class AcademicSyllabusPublicationServlet extends HttpServlet {

    private AcademicSyllabusPublicationDAO publicationDAO;

    @Override
    public void init() {
        publicationDAO = new AcademicSyllabusPublicationDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        User academic = requireAcademic(request, response);

        if (academic == null) {
            return;
        }

        List<AcademicPublicationItem> items
                = publicationDAO.listPublicationVersions();

        int readyCount = 0;
        int publishedCount = 0;
        int archivedCount = 0;

        for (AcademicPublicationItem item : items) {
            if (item.isReadyToPublish()) {
                readyCount++;
            }

            if ("PUBLISHED".equalsIgnoreCase(
                    item.getVersionStatus()
            )) {
                publishedCount++;
            }

            if ("ARCHIVED".equalsIgnoreCase(
                    item.getVersionStatus()
            )) {
                archivedCount++;
            }
        }

        moveFlashMessage(
                request,
                "publicationSuccess"
        );

        moveFlashMessage(
                request,
                "publicationError"
        );

        request.setAttribute("publicationItems", items);
        request.setAttribute("readyCount", readyCount);
        request.setAttribute("publishedCount", publishedCount);
        request.setAttribute("archivedCount", archivedCount);
        request.setAttribute(
                "pageTitle",
                "Syllabus Approval & Publication"
        );
        request.setAttribute(
                "contentPage",
                "academic/syllabus-publication.jsp"
        );
        request.setAttribute(
                "cssFile",
                "academic/academic.css"
        );

        request.getRequestDispatcher(
                "/views/dashboard.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        User academic = requireAcademic(request, response);

        if (academic == null) {
            return;
        }

        String action = request.getParameter("action");

        if (!"publish".equals(action)) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unsupported publication action."
            );
            return;
        }

        long versionId = parsePositiveLong(
                request.getParameter("versionId")
        );

        HttpSession session = request.getSession();

        if (versionId <= 0) {
            session.setAttribute(
                    "publicationError",
                    "Invalid syllabus version."
            );

            redirectToPublication(request, response);
            return;
        }

        try {
            PublishResult result
                    = publicationDAO.publishApprovedVersion(
                            versionId,
                            academic.getUserId()
                    );

            session.setAttribute(
                    "publicationSuccess",
                    result.getCourseLabel()
                    + " version "
                    + result.getVersionNumber()
                    + " was published successfully."
            );

            AuditUtil.logAction(
                    request,
                    "PUBLISH_SYLLABUS_VERSION",
                    "syllabus_versions",
                    result.getVersionId(),
                    "{\"status\":\"APPROVED\"}",
                    "{\"status\":\"PUBLISHED\"}"
            );

        } catch (SQLException exception) {
            exception.printStackTrace();

            session.setAttribute(
                    "publicationError",
                    exception.getMessage()
            );
        }

        redirectToPublication(request, response);
    }

    private User requireAcademic(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException, ServletException {

        User user = SessionUtil.getCurrentUser(request);

        if (user == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return null;
        }

        if (!user.hasRole(RoleConstants.ACADEMIC_OFFICE)) {
            response.setStatus(
                    HttpServletResponse.SC_FORBIDDEN
            );

            request.getRequestDispatcher(
                    "/views/error/403.jsp"
            ).forward(request, response);

            return null;
        }

        return user;
    }

    private void moveFlashMessage(
            HttpServletRequest request,
            String attributeName
    ) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return;
        }

        Object value = session.getAttribute(attributeName);

        if (value != null) {
            request.setAttribute(attributeName, value);
            session.removeAttribute(attributeName);
        }
    }

    private long parsePositiveLong(String value) {
        if (value == null || value.trim().isEmpty()) {
            return -1L;
        }

        try {
            long parsed = Long.parseLong(value.trim());
            return parsed > 0 ? parsed : -1L;

        } catch (NumberFormatException exception) {
            return -1L;
        }
    }

    private void redirectToPublication(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/academic/syllabus-publication"
        );
    }
}
