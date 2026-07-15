package controller;

import constant.RoleConstants;
import dao.DesignerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.DesignerFile;
import model.DesignerReviewResult;
import model.DesignerTask;
import model.DesignerVersion;
import model.User;
import utils.SessionUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet(
        name = "DesignerServlet",
        urlPatterns = {"/designer/*"}
)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 20L * 1024L * 1024L,
        maxRequestSize = 25L * 1024L * 1024L
)
public class DesignerServlet extends HttpServlet {

    private static final Path UPLOAD_DIR = Paths.get(
            System.getProperty("user.home"),
            "lmlf_uploads",
            "designer_excel"
    );

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

            case "/design":
                showDesign(request, response, user);
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

        String path = getPath(request);

        if ("/upload".equals(path)) {
            uploadSyllabus(request, response, user);
            return;
        }

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

        if (!user.hasRole(RoleConstants.DESIGNER)) {
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

    private void showDesign(
            HttpServletRequest request,
            HttpServletResponse response,
            User user
    ) throws ServletException, IOException {

        long assignmentId = parseLong(
                request.getParameter("assignmentId"),
                -1
        );

        if (assignmentId <= 0) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/designer/tasks?error=missing_assignment"
            );
            return;
        }

        DesignerTask task = designerDAO.getTaskDetail(
                assignmentId,
                user.getUserId()
        );

        if (task == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Assignment not found."
            );
            return;
        }

        if (!task.isUploadAllowed()) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This assignment cannot be edited."
            );
            return;
        }

        request.setAttribute("task", task);

        request.getRequestDispatcher(
                "/views/designer/syllabus/design.jsp"
        ).forward(request, response);
    }

    private void uploadSyllabus(
            HttpServletRequest request,
            HttpServletResponse response,
            User user
    ) throws ServletException, IOException {

        long assignmentId = parseLong(
                request.getParameter("assignmentId"),
                -1
        );

        if (assignmentId <= 0) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/designer/tasks?error=missing_assignment"
            );
            return;
        }

        DesignerTask task = designerDAO.getTaskDetail(
                assignmentId,
                user.getUserId()
        );

        if (task == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Assignment not found."
            );
            return;
        }

        if (!task.isUploadAllowed()) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This assignment cannot be submitted."
            );
            return;
        }

        Part part = request.getPart("syllabusFile");

        if (part == null || part.getSize() == 0) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/designer/design?assignmentId="
                    + assignmentId
                    + "&error=no_file"
            );
            return;
        }

        String originalFileName
                = getSubmittedFileName(part);

        if (!isExcelFile(originalFileName)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/designer/design?assignmentId="
                    + assignmentId
                    + "&error=invalid_file"
            );
            return;
        }

        Files.createDirectories(UPLOAD_DIR);

        String storedName
                = "assignment_"
                + assignmentId
                + "_designer_"
                + user.getUserId()
                + "_"
                + UUID.randomUUID()
                + getExtension(originalFileName);

        Path storedPath = UPLOAD_DIR.resolve(storedName);

        try (InputStream input = part.getInputStream()) {
            Files.copy(
                    input,
                    storedPath,
                    StandardCopyOption.REPLACE_EXISTING
            );
        }

        try {
            long versionId
                    = designerDAO.submitSyllabusExcel(
                            assignmentId,
                            user.getUserId(),
                            originalFileName,
                            storedPath.toAbsolutePath().toString(),
                            part.getSize(),
                            part.getContentType(),
                            request.getParameter("description")
                    );

            response.sendRedirect(
                    request.getContextPath()
                    + "/designer/review-result?versionId="
                    + versionId
                    + "&success=submitted"
            );

        } catch (Exception exception) {
            Files.deleteIfExists(storedPath);

            throw new ServletException(
                    "Cannot upload and submit syllabus Excel.",
                    exception
            );
        }
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

    private String getSubmittedFileName(Part part) {

        String submittedFileName
                = part.getSubmittedFileName();

        if (submittedFileName == null
                || submittedFileName.trim().isEmpty()) {

            return "syllabus.xlsx";
        }

        return Paths.get(submittedFileName)
                .getFileName()
                .toString();
    }

    private boolean isExcelFile(String fileName) {

        if (fileName == null) {
            return false;
        }

        String lowerFileName
                = fileName.toLowerCase();

        return lowerFileName.endsWith(".xlsx")
                || lowerFileName.endsWith(".xls");
    }

    private String getExtension(String fileName) {

        int dotIndex = fileName.lastIndexOf('.');

        return dotIndex >= 0
                ? fileName.substring(dotIndex)
                : ".xlsx";
    }
}