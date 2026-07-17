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

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/role-assignment")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class RoleAssignmentServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private UserDAO userDAO;
    private SyllabusAssignmentDAO assignmentDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        userDAO = new UserDAO();
        assignmentDAO = new SyllabusAssignmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAccess(req, resp)) {
            return;
        }

        String action = req.getParameter("action");
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
                    assignmentDAO.enrichReviewerData(sa);
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
                    assignmentDAO.enrichReviewerData(sa);
                    req.setAttribute("detailAssignment", sa);
                    req.setAttribute("action", "detail");
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "Invalid assignment ID");
                }
            }
        }

        // Fetch assignments list
        List<SyllabusAssignment> assignmentList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            assignmentList = assignmentDAO.search(keyword.trim());
            req.setAttribute("keyword", keyword);
        } else {
            assignmentList = assignmentDAO.listAll();
        }

        assignmentDAO.enrichReviewerData(assignmentList);

        // Apply filterCourseId if selected
        if (filterCourseIdStr != null && !filterCourseIdStr.trim().isEmpty()) {
            try {
                Long filterCourseId = Long.parseLong(filterCourseIdStr.trim());
                req.setAttribute("filterCourseId", filterCourseId);
                assignmentList.removeIf(item -> item.getCourseId() != filterCourseId.longValue());
            } catch (NumberFormatException e) {
                // ignore invalid param
            }
        }

        // Apply filterSemester if selected
        if (filterSemester != null && !filterSemester.trim().isEmpty()) {
            req.setAttribute("filterSemester", filterSemester);
            assignmentList.removeIf(item -> !filterSemester.equalsIgnoreCase(item.getSemester()));
        }

        // Apply filterYear if selected
        if (filterYearStr != null && !filterYearStr.trim().isEmpty()) {
            try {
                int filterYear = Integer.parseInt(filterYearStr.trim());
                req.setAttribute("filterYear", filterYear);
                assignmentList.removeIf(item -> item.getAcademicYear() != filterYear);
            } catch (NumberFormatException e) {
                // ignore invalid param
            }
        }

        // Fetch courses and lecturers for selectors
        List<Course> courses = courseDAO.listAll();
        List<User> lecturers = userDAO.getActiveUsersByRole("LECTURER");

        req.setAttribute("assignmentList", assignmentList);
        req.setAttribute("courses", courses);
        req.setAttribute("lecturers", lecturers);
        req.getRequestDispatcher("/views/academic/role-assignment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        if (!checkAccess(req, resp)) {
            return;
        }

        String action = req.getParameter("action");

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
        String designerIdStr = req.getParameter("designerId");
        String[] reviewerIdValues
                = req.getParameterValues("reviewerId");
        String semester = req.getParameter("semester");
        String yearStr = req.getParameter("academicYear");
        String status = req.getParameter("status");
        String dueDateStr = req.getParameter("dueDate");

        req.setAttribute("action", "create");
        req.setAttribute("tempCourseId", courseIdStr);
        req.setAttribute("tempDesignerId", designerIdStr);
        req.setAttribute("tempSemester", semester);
        req.setAttribute("tempYear", yearStr);
        req.setAttribute("tempStatus", status);

        if (courseIdStr == null
                || courseIdStr.trim().isEmpty()
                || designerIdStr == null
                || designerIdStr.trim().isEmpty()
                || reviewerIdValues == null
                || reviewerIdValues.length == 0
                || semester == null
                || semester.trim().isEmpty()
                || yearStr == null
                || yearStr.trim().isEmpty()) {

            req.setAttribute(
                    "errorMessage",
                    "Course, Designer, Reviewer, semester, and academic year are required."
            );
            forwardToList(req, resp);
            return;
        }

        try {
            long courseId
                    = Long.parseLong(courseIdStr.trim());
            long designerId
                    = Long.parseLong(designerIdStr.trim());
            int academicYear
                    = Integer.parseInt(yearStr.trim());

            List<Long> reviewerIds
                    = parseReviewerIds(reviewerIdValues);

            if (reviewerIds.isEmpty()) {
                req.setAttribute(
                        "errorMessage",
                        "Please select at least one Reviewer."
                );
                forwardToList(req, resp);
                return;
            }

            if (reviewerIds.contains(designerId)) {
                req.setAttribute(
                        "errorMessage",
                        "The Designer cannot also be a Reviewer for the same assignment."
                );
                forwardToList(req, resp);
                return;
            }

            if (assignmentDAO.isDuplicate(
                    courseId,
                    semester,
                    academicYear
            )) {
                req.setAttribute(
                        "errorMessage",
                        "One assignment already exists for this Course, semester, and academic year."
                );
                forwardToList(req, resp);
                return;
            }

            java.sql.Timestamp dueDate
                    = parseDueDate(dueDateStr);

            HttpSession session = req.getSession();
            User loggedInUser
                    = (User) session.getAttribute("user");

            long assignedBy = loggedInUser == null
                    ? 0L
                    : loggedInUser.getUserId();

            Long fileId = saveTemplateFile(
                    req.getPart("templateFile"),
                    loggedInUser
            );

            SyllabusAssignment assignment
                    = new SyllabusAssignment();

            assignment.setCourseId(courseId);
            assignment.setDesignerId(designerId);
            assignment.setReviewerId(reviewerIds.get(0));
            assignment.setReviewerIds(reviewerIds);
            assignment.setSemester(semester);
            assignment.setAcademicYear(academicYear);
            assignment.setAssignmentStatus(
                    status == null || status.trim().isEmpty()
                            ? "PENDING"
                            : status.trim()
            );
            assignment.setTemplateFileId(fileId);
            assignment.setDueDate(dueDate);

            long assignmentId
                    = assignmentDAO.createWithReviewers(
                            assignment,
                            reviewerIds,
                            assignedBy,
                            req.getRemoteAddr()
                    );

            if (assignmentId <= 0) {
                req.setAttribute(
                        "errorMessage",
                        "Failed to create the assignment. Make sure the multi-Reviewer migration has been executed."
                );
                forwardToList(req, resp);
                return;
            }

            dao.RoleDAO roleDAO = new dao.RoleDAO();
            roleDAO.assignRoleToUser(
                    designerId,
                    "DESIGNER"
            );

            for (Long reviewerId : reviewerIds) {
                roleDAO.assignRoleToUser(
                        reviewerId,
                        "REVIEWER"
                );
            }

            req.getSession().setAttribute(
                    "successMessage",
                    "Assignment #"
                    + assignmentId
                    + " created for 1 Designer and "
                    + reviewerIds.size()
                    + " Reviewer(s)."
            );

            resp.sendRedirect(
                    req.getContextPath()
                    + "/role-assignment"
            );

        } catch (NumberFormatException exception) {
            req.setAttribute(
                    "errorMessage",
                    "Invalid numeric parameters."
            );
            forwardToList(req, resp);
        }
    }

    private void handleEdit(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        String assignmentIdStr
                = req.getParameter("assignmentId");
        String courseIdStr
                = req.getParameter("courseId");
        String designerIdStr
                = req.getParameter("designerId");
        String[] reviewerIdValues
                = req.getParameterValues("reviewerId");
        String semester
                = req.getParameter("semester");
        String yearStr
                = req.getParameter("academicYear");
        String status
                = req.getParameter("status");
        String dueDateStr
                = req.getParameter("dueDate");

        req.setAttribute("action", "edit");

        if (assignmentIdStr == null
                || assignmentIdStr.trim().isEmpty()
                || courseIdStr == null
                || courseIdStr.trim().isEmpty()
                || designerIdStr == null
                || designerIdStr.trim().isEmpty()
                || reviewerIdValues == null
                || reviewerIdValues.length == 0
                || semester == null
                || semester.trim().isEmpty()
                || yearStr == null
                || yearStr.trim().isEmpty()) {

            req.setAttribute(
                    "errorMessage",
                    "All assignment fields are required."
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

            assignmentDAO.enrichReviewerData(existing);
            req.setAttribute("assignment", existing);

            if (reviewerIds.isEmpty()) {
                req.setAttribute(
                        "errorMessage",
                        "Please select at least one Reviewer."
                );
                forwardToList(req, resp);
                return;
            }

            if (reviewerIds.contains(designerId)) {
                req.setAttribute(
                        "errorMessage",
                        "The Designer cannot also be a Reviewer for the same assignment."
                );
                forwardToList(req, resp);
                return;
            }

            if (assignmentDAO.isDuplicate(
                    courseId,
                    semester,
                    academicYear,
                    assignmentId
            )) {
                req.setAttribute(
                        "errorMessage",
                        "Another assignment already exists for this Course, semester, and academic year."
                );
                forwardToList(req, resp);
                return;
            }

            existing.setCourseId(courseId);
            existing.setDesignerId(designerId);
            existing.setReviewerId(reviewerIds.get(0));
            existing.setReviewerIds(reviewerIds);
            existing.setSemester(semester);
            existing.setAcademicYear(academicYear);
            existing.setAssignmentStatus(
                    status == null || status.trim().isEmpty()
                            ? existing.getAssignmentStatus()
                            : status.trim()
            );
            existing.setDueDate(
                    parseDueDate(dueDateStr)
            );

            HttpSession session = req.getSession();
            User loggedInUser
                    = (User) session.getAttribute("user");

            long updatedBy = loggedInUser == null
                    ? 0L
                    : loggedInUser.getUserId();

            boolean updated
                    = assignmentDAO.updateWithReviewers(
                            existing,
                            reviewerIds,
                            updatedBy,
                            req.getRemoteAddr()
                    );

            if (!updated) {
                req.setAttribute(
                        "errorMessage",
                        "Failed to update the assignment."
                );
                forwardToList(req, resp);
                return;
            }

            dao.RoleDAO roleDAO = new dao.RoleDAO();
            roleDAO.assignRoleToUser(
                    designerId,
                    "DESIGNER"
            );

            for (Long reviewerId : reviewerIds) {
                roleDAO.assignRoleToUser(
                        reviewerId,
                        "REVIEWER"
                );
            }

            req.getSession().setAttribute(
                    "successMessage",
                    "Assignment updated with "
                    + reviewerIds.size()
                    + " Reviewer(s)."
            );

            resp.sendRedirect(
                    req.getContextPath()
                    + "/role-assignment"
            );

        } catch (NumberFormatException exception) {
            req.setAttribute(
                    "errorMessage",
                    "Invalid numeric inputs."
            );
            forwardToList(req, resp);
        }
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
        assignmentDAO.enrichReviewerData(assignmentList);

        List<Course> courses = courseDAO.listAll();
        List<User> lecturers = userDAO.getActiveUsersByRole("LECTURER");

        req.setAttribute("assignmentList", assignmentList);
        req.setAttribute("courses", courses);
        req.setAttribute("lecturers", lecturers);
        req.getRequestDispatcher("/views/academic/role-assignment.jsp").forward(req, resp);
    }

    private List<Long> parseReviewerIds(
            String[] reviewerIdValues
    ) {

        Set<Long> reviewerIds
                = new LinkedHashSet<>();

        if (reviewerIdValues == null) {
            return new ArrayList<>();
        }

        for (String reviewerIdValue : reviewerIdValues) {
            if (reviewerIdValue == null
                    || reviewerIdValue.trim().isEmpty()) {
                continue;
            }

            reviewerIds.add(
                    Long.parseLong(reviewerIdValue.trim())
            );
        }

        return new ArrayList<>(reviewerIds);
    }

    private java.sql.Timestamp parseDueDate(
            String dueDateValue
    ) {

        if (dueDateValue == null
                || dueDateValue.trim().isEmpty()) {
            return null;
        }

        String normalizedValue
                = dueDateValue.trim().replace("T", " ");

        if (normalizedValue.length() == 16) {
            normalizedValue += ":00";
        }

        return java.sql.Timestamp.valueOf(
                normalizedValue
        );
    }

    private Long saveTemplateFile(
            Part filePart,
            User loggedInUser
    ) throws IOException {

        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        String originalFileName
                = java.nio.file.Paths.get(
                        filePart.getSubmittedFileName()
                ).getFileName().toString();

        String storedFileName
                = System.currentTimeMillis()
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
                = templateDirectory.resolve(
                        storedFileName
                );

        try (java.io.InputStream inputStream
                     = filePart.getInputStream()) {

            java.nio.file.Files.copy(
                    inputStream,
                    storedPath,
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING
            );
        }

        model.SyllabusVersionFile templateFile
                = new model.SyllabusVersionFile();

        templateFile.setFileType("TEMPLATE");
        templateFile.setOriginalFileName(
                originalFileName
        );
        templateFile.setStoredFilePath(
                storedPath.toAbsolutePath().toString()
        );
        templateFile.setFileSize(
                filePart.getSize()
        );
        templateFile.setMimeType(
                filePart.getContentType()
        );

        if (loggedInUser != null) {
            templateFile.setUploadedBy(
                    loggedInUser.getUserId()
            );
        }

        dao.SyllabusVersionFileDAO fileDAO
                = new dao.SyllabusVersionFileDAO();

        long fileId = fileDAO.insert(templateFile);

        return fileId > 0 ? fileId : null;
    }

    private boolean checkAccess(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            loggedInUser = new User();
            loggedInUser.setUserId(1L);
            loggedInUser.setFirstName("Academic");
            loggedInUser.setLastName("Office");
            loggedInUser.setEmail("academic@fpt.edu.vn");
            
            // Add academic office role for testing
            model.Role r = new model.Role();
            r.setRoleId(2L);
            r.setRoleName("ACADEMIC_OFFICE");
            List<model.Role> rolesList = new java.util.ArrayList<>();
            rolesList.add(r);
            loggedInUser.setRoles(rolesList);
            
            session.setAttribute("user", loggedInUser);
        }

        if (!loggedInUser.hasRole("ACADEMIC_OFFICE") && !loggedInUser.hasRole("ADMIN")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return false;
        }
        return true;
    }
}
