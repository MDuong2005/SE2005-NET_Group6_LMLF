package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Course;
import model.SyllabusAssignment;
import model.User;
import dao.CourseDAO;
import dao.UserDAO;
import dao.SyllabusAssignmentDAO;
import dao.AccountRequestDAO;
import dao.NotificationDAO;
import dao.AcademicSyllabusDAO;
import model.AccountRequest;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.Set;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/role-assignment")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  
    maxFileSize = 1024 * 1024 * 10,       
    maxRequestSize = 1024 * 1024 * 50     
)
public class RoleAssignmentServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private UserDAO userDAO;
    private SyllabusAssignmentDAO assignmentDAO;
    private NotificationDAO notificationDAO;
    private AcademicSyllabusDAO academicSyllabusDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        userDAO = new UserDAO();
        assignmentDAO = new SyllabusAssignmentDAO();
        notificationDAO = new NotificationDAO();
        academicSyllabusDAO = new AcademicSyllabusDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAccess(req, resp)) {
            return;
        }

        String action = req.getParameter("action");
        if ("checkExternalReviewer".equals(action)) {
            checkExternalReviewer(req, resp);
            return;
        }
        if ("checkAssignmentDuplicate".equals(action)) {
            checkAssignmentDuplicate(req, resp);
            return;
        }
        if ("create".equals(action)) {
            req.setAttribute("action", "create");
            req.setAttribute("tempCourseId", req.getParameter("courseId"));
            req.setAttribute("tempSyllabusId", req.getParameter("syllabusId"));
        }
        String keyword = req.getParameter("keyword");
        String filterCourseIdStr = req.getParameter("filterCourseId");
        String filterSemester = req.getParameter("filterSemester");
        String filterYearStr = req.getParameter("filterYear");

        // Handle deletion via GET request
        if ("delete".equals(action)) {
            handleDelete(req, resp);
            return;
        }

        // Load specific assignment if action is edit
        if ("edit".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr);
                    SyllabusAssignment sa = assignmentDAO.getById(id);
                    req.setAttribute("assignment", sa);
                    req.setAttribute("action", "edit");
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "Invalid assignment ID");
                }
            }
        }

        // Load specific assignment if action is detail
        if ("detail".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr);
                    SyllabusAssignment sa = assignmentDAO.getById(id);
                    req.setAttribute("detailAssignment", sa);
                    req.setAttribute("action", "detail");
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "Invalid assignment ID");
                }
            }
        }

        Long filterCourseId = null;
        Integer filterYear = null;
        if (filterCourseIdStr != null && !filterCourseIdStr.trim().isEmpty()) {
            try {
                filterCourseId = Long.parseLong(filterCourseIdStr.trim());
            } catch (NumberFormatException e) {
                filterCourseIdStr = "";
            }
        }
        if (filterYearStr != null && !filterYearStr.trim().isEmpty()) {
            try {
                filterYear = Integer.parseInt(filterYearStr.trim());
            } catch (NumberFormatException e) {
                filterYearStr = "";
            }
        }

        List<SyllabusAssignment> assignmentList = assignmentDAO.filter(
                keyword, filterCourseId, filterSemester, filterYear);
        List<SyllabusAssignment> duplicateCheckAssignments = assignmentDAO.filter(
                null, null, null, null);
        req.setAttribute("keyword", keyword == null ? "" : keyword);
        req.setAttribute("filterCourseId", filterCourseIdStr == null ? "" : filterCourseIdStr);
        req.setAttribute("filterSemester", filterSemester == null ? "" : filterSemester);
        req.setAttribute("filterYear", filterYearStr == null ? "" : filterYearStr);

        // Fetch courses and lecturers for selectors
        List<Course> courses = courseDAO.listAll();
        List<User> lecturers = userDAO.getActiveUsersByRole("LECTURER");
        List<User> externalReviewers = userDAO.getActiveUsersByRole("EXTERNAL_EXPERT");

        req.setAttribute("assignmentList", assignmentList);
        req.setAttribute("duplicateCheckAssignments", duplicateCheckAssignments);
        req.setAttribute("courses", courses);
        req.setAttribute("lecturers", lecturers);
        req.setAttribute("externalReviewers", externalReviewers);
        req.getRequestDispatcher("/views/academic/role-assignment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        if (!checkAccess(req, resp)) {
            return;
        }

        String action = req.getParameter("action");
        if ("sendExternalReviewerRequest".equals(action)) {
            sendExternalReviewerRequest(req, resp);
            return;
        }

        if ("create".equals(action)) {
            handleCreate(req, resp);
        } else if ("edit".equals(action)) {
            handleEdit(req, resp);
        } else if ("delete".equals(action)) {
            handleDelete(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/role-assignment");
        }
    }

    private void handleCreate(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        String courseIdStr = req.getParameter("courseId");
        String syllabusIdStr = req.getParameter("syllabusId");
        String designerIdStr = req.getParameter("designerId");
        String[] reviewerIdValues
                = req.getParameterValues("reviewerId");
        String semester = req.getParameter("semester");
        String yearStr = req.getParameter("academicYear");
        String status = req.getParameter("status");
        String dueDateStr = req.getParameter("dueDate");

        req.setAttribute("action", "create");
        req.setAttribute("tempCourseId", courseIdStr);
        req.setAttribute("tempSyllabusId", syllabusIdStr);
        req.setAttribute("tempDesignerId", designerIdStr);
        req.setAttribute("tempSemester", semester);
        req.setAttribute("tempYear", yearStr);
        req.setAttribute("tempStatus", status);

        if (isBlank(courseIdStr)
                || isBlank(designerIdStr)
                || reviewerIdValues == null
                || reviewerIdValues.length < 2
                || isBlank(semester)
                || isBlank(yearStr)) {

            req.setAttribute(
                    "errorMessage",
                    "All fields are required and at least two Reviewers must be selected in total."
            );
            forwardToList(req, resp);
            return;
        }

        try {
            long courseId = Long.parseLong(courseIdStr.trim());
            long designerId = Long.parseLong(designerIdStr.trim());
            int academicYear = Integer.parseInt(yearStr.trim());

            List<Long> reviewerIds
                    = parseReviewerIds(reviewerIdValues);

            if (reviewerIds.size() < 2) {
                req.setAttribute(
                        "errorMessage",
                        "Select at least two Internal and/or External Reviewers in total."
                );
                forwardToList(req, resp);
                return;
            }

            if (reviewerIds.contains(designerId)) {
                req.setAttribute(
                        "errorMessage",
                        "Syllabus Designer and Reviewer must be different lecturers."
                );
                forwardToList(req, resp);
                return;
            }

            String actorError = validateAssignmentActors(designerId, reviewerIds);
            if (actorError != null) {
                req.setAttribute("errorMessage", actorError);
                forwardToList(req, resp);
                return;
            }

            HttpSession session = req.getSession();
            User loggedInUser
                    = (User) session.getAttribute("user");

            if (loggedInUser == null) {
                resp.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Authentication required."
                );
                return;
            }

            Long templateFileId = saveTemplateFile(
                    req,
                    loggedInUser
            );

            SyllabusAssignment assignment
                    = new SyllabusAssignment();

            assignment.setCourseId(courseId);
            if (!isBlank(syllabusIdStr)) {
                assignment.setSyllabusId(Long.parseLong(syllabusIdStr.trim()));
            }
            assignment.setDesignerId(designerId);
            assignment.setSemester(semester.trim());
            assignment.setAcademicYear(academicYear);
            assignment.setAssignmentStatus(
                    isBlank(status)
                            ? "PENDING"
                            : status.trim()
            );
            assignment.setTemplateFileId(templateFileId);
            assignment.setDueDate(parseDueDate(dueDateStr));

            long assignmentId = assignmentDAO.createWithReviewers(
                    assignment,
                    reviewerIds,
                    loggedInUser.getUserId(),
                    req.getRemoteAddr()
            );

            if (assignmentId <= 0) {
                req.setAttribute(
                        "errorMessage",
                        "An assignment already exists with the same Course, Semester, and Academic Year, or the assignment could not be saved."
                );
                forwardToList(req, resp);
                return;
            }

            if (assignment.getSyllabusId() != null) {
                try {
                    academicSyllabusDAO.initializeUpdateDraft(
                            assignmentId,
                            assignment.getSyllabusId(),
                            designerId,
                            loggedInUser.getUserId()
                    );
                } catch (SQLException exception) {
                    assignmentDAO.cancelAssignment(assignmentId);
                    req.setAttribute("errorMessage",
                            "The update assignment was cancelled because its draft version could not be initialized: "
                            + exception.getMessage());
                    forwardToList(req, resp);
                    return;
                }
            }

            dao.RoleDAO roleDAO = new dao.RoleDAO();
            roleDAO.assignRoleToUser(designerId, "DESIGNER");

            for (Long reviewerId : reviewerIds) {
                roleDAO.assignRoleToUser(
                        reviewerId,
                        "REVIEWER"
                );
            }

            notificationDAO.notifyLecturerTaskAssignments(
                    assignmentId,
                    loggedInUser.getUserId(),
                    designerId,
                    reviewerIds
            );

            req.getSession().setAttribute(
                    "successMessage",
                    "Added syllabus role assignment successfully."
            );

            resp.sendRedirect(
                    req.getContextPath() + "/role-assignment"
            );

        } catch (NumberFormatException exception) {
            req.setAttribute(
                    "errorMessage",
                    "Invalid numeric parameters."
            );
            forwardToList(req, resp);
        }
    }

    private void checkAssignmentDuplicate(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // A syllabusId is supplied only by Request New Version from syllabus detail.
        if (!isBlank(req.getParameter("syllabusId"))) {
            resp.getWriter().write("{\"duplicate\":false,\"newVersionRequest\":true}");
            return;
        }

        try {
            long courseId = Long.parseLong(req.getParameter("courseId"));
            int academicYear = Integer.parseInt(req.getParameter("academicYear"));
            String semester = req.getParameter("semester");
            boolean duplicate = !isBlank(semester)
                    && assignmentDAO.isDuplicate(courseId, semester.trim(), academicYear);
            resp.getWriter().write("{\"duplicate\":" + duplicate + "}");
        } catch (NumberFormatException exception) {
            resp.getWriter().write("{\"duplicate\":false}");
        }
    }

    private void handleEdit(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        String assignmentIdStr = req.getParameter("assignmentId");
        String courseIdStr = req.getParameter("courseId");
        String designerIdStr = req.getParameter("designerId");
        String[] reviewerIdValues
                = req.getParameterValues("reviewerId");
        String semester = req.getParameter("semester");
        String yearStr = req.getParameter("academicYear");
        String status = req.getParameter("status");
        String dueDateStr = req.getParameter("dueDate");

        req.setAttribute("action", "edit");

        if (isBlank(assignmentIdStr)
                || isBlank(courseIdStr)
                || isBlank(designerIdStr)
                || reviewerIdValues == null
                || reviewerIdValues.length < 2
                || isBlank(semester)
                || isBlank(yearStr)) {

            req.setAttribute(
                    "errorMessage",
                    "All fields are required and at least two Reviewers must be selected in total."
            );
            forwardToList(req, resp);
            return;
        }

        try {
            long assignmentId
                    = Long.parseLong(assignmentIdStr.trim());

            long courseId
                    = Long.parseLong(courseIdStr.trim());

            long designerId
                    = Long.parseLong(designerIdStr.trim());

            int academicYear
                    = Integer.parseInt(yearStr.trim());

            List<Long> reviewerIds
                    = parseReviewerIds(reviewerIdValues);

            SyllabusAssignment existing
                    = assignmentDAO.getById(assignmentId);

            if (existing == null) {
                req.setAttribute(
                        "errorMessage",
                        "Syllabus assignment not found."
                );
                forwardToList(req, resp);
                return;
            }

            req.setAttribute("assignment", existing);

            if (reviewerIds.size() < 2) {
                req.setAttribute(
                        "errorMessage",
                        "Select at least two Internal and/or External Reviewers in total."
                );
                forwardToList(req, resp);
                return;
            }

            if (reviewerIds.contains(designerId)) {
                req.setAttribute(
                        "errorMessage",
                        "Syllabus Designer and Reviewer must be different lecturers."
                );
                forwardToList(req, resp);
                return;
            }

            String actorError = validateAssignmentActors(designerId, reviewerIds);
            if (actorError != null) {
                req.setAttribute("errorMessage", actorError);
                forwardToList(req, resp);
                return;
            }

            HttpSession session = req.getSession();
            User loggedInUser
                    = (User) session.getAttribute("user");

            if (loggedInUser == null) {
                resp.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Authentication required."
                );
                return;
            }

            existing.setCourseId(courseId);
            existing.setDesignerId(designerId);
            existing.setSemester(semester.trim());
            existing.setAcademicYear(academicYear);
            existing.setAssignmentStatus(
                    isBlank(status)
                            ? existing.getAssignmentStatus()
                            : status.trim()
            );
            existing.setDueDate(parseDueDate(dueDateStr));

            boolean updated = assignmentDAO.updateWithReviewers(
                    existing,
                    reviewerIds,
                    loggedInUser.getUserId(),
                    req.getRemoteAddr()
            );

            if (!updated) {
                req.setAttribute(
                        "errorMessage",
                        "Another assignment already uses this course, semester and academic year, or the assignment could not be updated."
                );
                forwardToList(req, resp);
                return;
            }

            dao.RoleDAO roleDAO = new dao.RoleDAO();
            roleDAO.assignRoleToUser(designerId, "DESIGNER");

            for (Long reviewerId : reviewerIds) {
                roleDAO.assignRoleToUser(
                        reviewerId,
                        "REVIEWER"
                );
            }

            notificationDAO.notifyLecturerTaskAssignments(
                    assignmentId,
                    loggedInUser.getUserId(),
                    designerId,
                    reviewerIds
            );

            req.getSession().setAttribute(
                    "successMessage",
                    "Updated syllabus role assignment successfully."
            );

            resp.sendRedirect(
                    req.getContextPath() + "/role-assignment"
            );

        } catch (NumberFormatException exception) {
            req.setAttribute(
                    "errorMessage",
                    "Invalid numeric parameters."
            );
            forwardToList(req, resp);
        }
    }

    /**
     * Verifies that the submitted designer/reviewer ids are legitimate
     * candidates: a Designer must be an ACTIVE lecturer, and every Reviewer
     * must be an ACTIVE lecturer or external expert. This blocks a crafted
     * request from assigning a DESIGNER/REVIEWER role to an arbitrary account
     * (e.g. a student or admin) whose id is not offered by the form.
     * Returns null when everything is valid, or an error message otherwise.
     */
    private String validateAssignmentActors(long designerId, List<Long> reviewerIds) {
        Set<Long> lecturerIds = new java.util.HashSet<>();
        for (User u : userDAO.getActiveUsersByRole("LECTURER")) {
            lecturerIds.add(u.getUserId());
        }
        Set<Long> reviewerCandidateIds = new java.util.HashSet<>(lecturerIds);
        for (User u : userDAO.getActiveUsersByRole("EXTERNAL_EXPERT")) {
            reviewerCandidateIds.add(u.getUserId());
        }

        if (!lecturerIds.contains(designerId)) {
            return "The selected Designer is not an active lecturer.";
        }
        for (Long reviewerId : reviewerIds) {
            if (!reviewerCandidateIds.contains(reviewerId)) {
                return "One of the selected Reviewers is not an active lecturer or external expert.";
            }
        }
        return null;
    }

    private List<Long> parseReviewerIds(
            String[] reviewerIdValues
    ) {

        Set<Long> distinctIds = new LinkedHashSet<>();

        if (reviewerIdValues == null) {
            return new ArrayList<>();
        }

        for (String reviewerIdValue : reviewerIdValues) {
            if (isBlank(reviewerIdValue)) {
                continue;
            }

            long reviewerId = Long.parseLong(
                    reviewerIdValue.trim()
            );

            if (reviewerId > 0) {
                distinctIds.add(reviewerId);
            }
        }

        return new ArrayList<>(distinctIds);
    }

    private java.sql.Timestamp parseDueDate(
            String dueDateValue
    ) {

        if (isBlank(dueDateValue)) {
            return null;
        }

        try {
            String formattedDate
                    = dueDateValue.trim().replace("T", " ");

            if (formattedDate.length() == 16) {
                formattedDate += ":00";
            }

            return java.sql.Timestamp.valueOf(formattedDate);

        } catch (IllegalArgumentException exception) {
            return null;
        }
    }

    private Long saveTemplateFile(
            HttpServletRequest req,
            User loggedInUser
    ) throws IOException, ServletException {

        Part filePart = req.getPart("templateFile");

        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        String originalFileName = java.nio.file.Paths.get(
                filePart.getSubmittedFileName()
        ).getFileName().toString();

        String storedFileName = System.currentTimeMillis()
                + "_"
                + originalFileName;

        java.nio.file.Path templateDirectory
                = java.nio.file.Paths.get(
                        System.getProperty("user.home"),
                        "lmlf_uploads",
                        "templates"
                );

        java.nio.file.Files.createDirectories(
                templateDirectory
        );

        java.nio.file.Path storedPath
                = templateDirectory.resolve(storedFileName);

        try (java.io.InputStream input
                     = filePart.getInputStream()) {

            java.nio.file.Files.copy(
                    input,
                    storedPath,
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING
            );
        }

        model.SyllabusVersionFile versionFile
                = new model.SyllabusVersionFile();

        versionFile.setFileType("TEMPLATE");
        versionFile.setOriginalFileName(originalFileName);
        versionFile.setStoredFilePath(
                storedPath.toAbsolutePath().toString()
        );
        versionFile.setFileSize(filePart.getSize());
        versionFile.setMimeType(filePart.getContentType());
        versionFile.setUploadedBy(loggedInUser.getUserId());

        dao.SyllabusVersionFileDAO fileDAO
                = new dao.SyllabusVersionFileDAO();

        long insertedFileId = fileDAO.insert(versionFile);

        return insertedFileId > 0
                ? insertedFileId
                : null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Invalid assignment ID.");
            forwardToList(req, resp);
            return;
        }

        try {
            Long id = Long.parseLong(idStr.trim());
            SyllabusAssignment existing = assignmentDAO.getById(id);

            if (existing == null) {
                req.setAttribute("errorMessage", "Syllabus assignment not found.");
                forwardToList(req, resp);
                return;
            }

            boolean result = assignmentDAO.delete(id);

            if (result) {
                req.getSession().setAttribute("successMessage", "Deleted syllabus role assignment successfully!");
                resp.sendRedirect(req.getContextPath() + "/role-assignment");
            } else {
                req.setAttribute("errorMessage", "Failed to delete assignment.");
                forwardToList(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid assignment ID.");
            forwardToList(req, resp);
        }
    }

    private void forwardToList(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        List<SyllabusAssignment> assignmentList = assignmentDAO.listAll();
        List<Course> courses = courseDAO.listAll();
        List<User> lecturers = userDAO.getActiveUsersByRole("LECTURER");
        List<User> externalReviewers = userDAO.getActiveUsersByRole("EXTERNAL_EXPERT");

        req.setAttribute("assignmentList", assignmentList);
        req.setAttribute("courses", courses);
        req.setAttribute("lecturers", lecturers);
        req.setAttribute("externalReviewers", externalReviewers);
        req.getRequestDispatcher("/views/academic/role-assignment.jsp").forward(req, resp);
    }

    private static class TempAccountRequestQuery extends context.DBContext {
        public boolean insertRequest(String email, String firstName, String lastName, long requestedBy) {
            String sql = "INSERT INTO account_requests (email, first_name, last_name, requested_by, status, requested_at) "
                       + "VALUES (?, ?, ?, ?, 'PENDING', CURRENT_TIMESTAMP)";
            try {
                if (connection != null) {
                    try (PreparedStatement ps = connection.prepareStatement(sql)) {
                        ps.setString(1, email);
                        ps.setString(2, firstName);
                        ps.setString(3, lastName);
                        ps.setLong(4, requestedBy);
                        return ps.executeUpdate() > 0;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        }

        public model.AccountRequest getLatestRequest(String email) {
            String sql = "SELECT TOP 1 * FROM account_requests WHERE email = ? ORDER BY requested_at DESC";
            try {
                if (connection != null) {
                    try (PreparedStatement ps = connection.prepareStatement(sql)) {
                        ps.setString(1, email);
                        try (java.sql.ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                model.AccountRequest req = new model.AccountRequest();
                                req.setRequestId(rs.getLong("request_id"));
                                req.setEmail(rs.getString("email"));
                                req.setFirstName(rs.getString("first_name"));
                                req.setLastName(rs.getString("last_name"));
                                req.setStatus(rs.getString("status"));
                                req.setNote(rs.getString("note"));
                                return req;
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return null;
        }
    }

    private void checkExternalReviewer(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Email không được để trống.\"}");
            return;
        }
        
        email = email.trim();
        UserDAO uDAO = new UserDAO();
        if (uDAO.existsByEmail(email)) {
            resp.getWriter().write("{\"success\":true,\"exists\":true,\"message\":\"Tài khoản đã tồn tại và đang hoạt động trên hệ thống.\"}");
            return;
        }
        
        TempAccountRequestQuery tempQuery = new TempAccountRequestQuery();
        model.AccountRequest latestReq = tempQuery.getLatestRequest(email);
        
        if (latestReq != null) {
            if ("PENDING".equalsIgnoreCase(latestReq.getStatus())) {
                resp.getWriter().write("{\"success\":true,\"exists\":false,\"requested\":true,\"status\":\"PENDING\",\"message\":\"Yêu cầu đã được gửi đến Admin. <br>Trạng thái: <b>PENDING</b>\"}");
                return;
            } else if ("REJECTED".equalsIgnoreCase(latestReq.getStatus())) {
                String note = latestReq.getNote();
                if (note == null || note.trim().isEmpty()) {
                    note = "Không có lý do từ chối.";
                }
                resp.getWriter().write("{\"success\":true,\"exists\":false,\"requested\":true,\"status\":\"REJECTED\",\"note\":\"" + note.replace("\"", "\\\"").replace("\n", "\\n") + "\",\"message\":\"Yêu cầu đã bị Admin từ chối. <br>Lý do: <b>" + note.replace("\"", "\\\"").replace("\n", "\\n") + "</b>\"}");
                return;
            } else if ("APPROVED".equalsIgnoreCase(latestReq.getStatus()) || "APPROVE".equalsIgnoreCase(latestReq.getStatus())) {
                resp.getWriter().write("{\"success\":true,\"exists\":false,\"requested\":true,\"status\":\"APPROVED\",\"message\":\"Yêu cầu đã được Admin phê duyệt. <br>Trạng thái: <b>APPROVED</b>\"}");
                return;
            }
        }
        
        resp.getWriter().write("{\"success\":true,\"exists\":false,\"requested\":false}");
    }

    private void sendExternalReviewerRequest(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Email không được để trống.\"}");
            return;
        }
        
        email = email.trim();
        UserDAO uDAO = new UserDAO();
        if (uDAO.existsByEmail(email)) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Tài khoản đã tồn tại và đang hoạt động trên hệ thống.\"}");
            return;
        }
        
        AccountRequestDAO arDAO = new AccountRequestDAO();
        List<AccountRequest> pendingList = arDAO.getPendingRequests();
        AccountRequest pendingReq = null;
        if (pendingList != null) {
            for (AccountRequest r : pendingList) {
                if (email.equalsIgnoreCase(r.getEmail())) {
                    pendingReq = r;
                    break;
                }
            }
        }
        
        if (pendingReq != null) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Yêu cầu cho email này đã được gửi từ trước và đang chờ duyệt.\"}");
            return;
        }
        
        User currentUser = (User) req.getSession().getAttribute("user");
        long requestedBy = (currentUser != null) ? currentUser.getUserId() : 1L;
        
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        
        if (firstName == null || firstName.trim().isEmpty()) {
            firstName = email.split("@")[0];
        } else {
            firstName = firstName.trim();
        }
        
        if (lastName == null || lastName.trim().isEmpty()) {
            lastName = "External";
        } else {
            lastName = lastName.trim();
        }
        
        TempAccountRequestQuery tempQuery = new TempAccountRequestQuery();
        if (tempQuery.insertRequest(email, firstName, lastName, requestedBy)) {
            resp.getWriter().write("{\"success\":true,\"message\":\"Yêu cầu đã được gửi đến Admin. <br>Trạng thái: <b>PENDING</b>\"}");
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"Có lỗi xảy ra khi gửi yêu cầu. Vui lòng thử lại.\"}");
        }
    }

    private boolean checkAccess(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("user");

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }

        if (!loggedInUser.hasRole("ACADEMIC_OFFICE") && !loggedInUser.hasRole("ADMIN")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return false;
        }
        return true;
    }
}
