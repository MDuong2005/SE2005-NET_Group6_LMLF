package controller;

import dao.DesignerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DesignerFile;
import model.DesignerReviewResult;
import model.DesignerTask;
import model.DesignerVersion;
import model.User;
import utils.SessionUtil;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(
        name = "DesignerServlet",
        urlPatterns = {"/designer/*"}
)
public class DesignerServlet extends HttpServlet {

    private final DesignerDAO designerDAO = new DesignerDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        User user = requireDesigner(request, response);

        if (user == null) {
            return;
        }

        String path = getPath(request);

        switch (path) {
            case "/tasks":
                showTasks(request, response, user);
                break;

            case "/download":
                downloadFile(request, response, user);
                break;

            case "/version-history":
                showVersionHistory(request, response, user);
                break;

            case "/review-result":
                showReviewResult(request, response, user);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath()
                        + "/designer/tasks"
                );
                break;
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        User user = requireDesigner(request, response);

        if (user == null) {
            return;
        }

        // Submission is handled by DesignerSyllabusEditorServlet
        // (/designer/editor/submit). The legacy Excel-upload flow has been
        // removed, so any other POST just returns to the task list.
        response.sendRedirect(
                request.getContextPath()
                + "/designer/tasks"
        );
    }

    private User requireDesigner(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException, ServletException {

        User user = SessionUtil.getCurrentUser(request);

        if (user == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );
            return null;
        }

        dao.SyllabusAssignmentDAO assignDAO = new dao.SyllabusAssignmentDAO();
        if (!assignDAO.hasAssignments(user.getUserId())) {
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

    private String getPath(HttpServletRequest request) {

        String path = request.getPathInfo();

        if (path == null
                || path.trim().isEmpty()
                || "/".equals(path)) {

            return "/tasks";
        }

        return path;
    }

    private void showTasks(
            HttpServletRequest request,
            HttpServletResponse response,
            User user
    ) throws ServletException, IOException {

        String filter = request.getParameter("status");

        if (!"draft".equalsIgnoreCase(filter)
                && !"submitted".equalsIgnoreCase(filter)) {

            filter = "all";
        }

        List<DesignerTask> tasks
                = designerDAO.getTasksByDesigner(
                        user.getUserId(),
                        filter
                );

        request.setAttribute("tasks", tasks);
        request.setAttribute("taskList", tasks);
        request.setAttribute("filter", filter);
        request.setAttribute(
                "pageTitle",
                "Assigned Tasks"
        );

        request.getRequestDispatcher(
                "/views/designer/syllabus/tasks.jsp"
        ).forward(request, response);
    }

    private void downloadFile(
            HttpServletRequest request,
            HttpServletResponse response,
            User user
    ) throws IOException {

        long fileId = parseLong(
                request.getParameter("fileId"),
                -1
        );

        if (fileId <= 0) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid file ID."
            );
            return;
        }

        DesignerFile file = designerDAO.getDownloadFile(
                fileId,
                user.getUserId()
        );

        if (file == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "File not found."
            );
            return;
        }

        Path path = Paths.get(file.getStoredFilePath());

        if (!Files.exists(path)
                || !Files.isRegularFile(path)) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Physical file not found."
            );
            return;
        }

        String mimeType = file.getMimeType();

        if (mimeType == null
                || mimeType.trim().isEmpty()) {

            mimeType = getServletContext().getMimeType(
                    file.getOriginalFileName()
            );
        }

        if (mimeType == null
                || mimeType.trim().isEmpty()) {

            mimeType = "application/octet-stream";
        }

        String encodedFileName = URLEncoder
                .encode(
                        file.getOriginalFileName(),
                        StandardCharsets.UTF_8
                )
                .replace("+", "%20");

        response.setContentType(mimeType);
        response.setContentLengthLong(
                Files.size(path)
        );

        response.setHeader(
                "Content-Disposition",
                "attachment; filename*=UTF-8''"
                + encodedFileName
        );

        try (OutputStream output
                     = response.getOutputStream()) {

            Files.copy(path, output);
        }
    }

    private void showVersionHistory(
            HttpServletRequest request,
            HttpServletResponse response,
            User user
    ) throws ServletException, IOException {

        List<DesignerVersion> versions
                = designerDAO.getVersionHistoryByDesigner(
                        user.getUserId()
                );

        request.setAttribute("versions", versions);
        request.setAttribute("versionList", versions);

        request.getRequestDispatcher(
                "/views/designer/syllabus/version_history.jsp"
        ).forward(request, response);
    }

    private void showReviewResult(
            HttpServletRequest request,
            HttpServletResponse response,
            User user
    ) throws ServletException, IOException {

        long versionId = parseLong(
                request.getParameter("versionId"),
                -1
        );

        if (versionId <= 0) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/designer/tasks?error=missing_version"
            );
            return;
        }

        List<DesignerReviewResult> reviews
                = designerDAO.getReviewResults(
                        versionId,
                        user.getUserId()
                );

        request.setAttribute("reviews", reviews);
        request.setAttribute("reviewResults", reviews);
        request.setAttribute("versionId", versionId);

        request.getRequestDispatcher(
                "/views/designer/syllabus/review_result.jsp"
        ).forward(request, response);
    }

    private long parseLong(
            String value,
            long defaultValue
    ) {
        try {
            return Long.parseLong(value);
        } catch (Exception exception) {
            return defaultValue;
        }
    }
}