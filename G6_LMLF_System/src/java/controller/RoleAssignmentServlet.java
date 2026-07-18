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
import model.AccountRequest;

import java.io.IOException;
import java.util.List;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
        if ("checkExternalReviewer".equals(action)) {
            checkExternalReviewer(req, resp);
            return;
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

        // Fetch assignments list
        List<SyllabusAssignment> assignmentList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            assignmentList = assignmentDAO.search(keyword.trim());
            req.setAttribute("keyword", keyword);
        } else {
            assignmentList = assignmentDAO.listAll();
        }

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
        List<User> externalReviewers = userDAO.getActiveUsersByRole("EXTERNAL_EXPERT");

        req.setAttribute("assignmentList", assignmentList);
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

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String courseIdStr = req.getParameter("courseId");
        String designerIdStr = req.getParameter("designerId");
        String[] reviewerIds = req.getParameterValues("reviewerId");
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

        if (courseIdStr == null || courseIdStr.trim().isEmpty() || 
            designerIdStr == null || designerIdStr.trim().isEmpty() ||
            reviewerIds == null || reviewerIds.length == 0 ||
            semester == null || semester.trim().isEmpty() ||
            yearStr == null || yearStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "All fields are required.");
            forwardToList(req, resp);
            return;
        }

        try {
            Long courseId = Long.parseLong(courseIdStr.trim());
            Long designerId = Long.parseLong(designerIdStr.trim());
            int academicYear = Integer.parseInt(yearStr.trim());

            java.sql.Timestamp dueDate = null;
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                try {
                    String formattedDate = dueDateStr.trim().replace("T", " ");
                    if (formattedDate.length() == 16) {
                        formattedDate += ":00";
                    }
                    dueDate = java.sql.Timestamp.valueOf(formattedDate);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            boolean hasSuccess = false;
            boolean hasDuplicate = false;
            HttpSession session = req.getSession();
            User loggedInUser = (User) session.getAttribute("user");
            String ipAddress = req.getRemoteAddr();

            // Handle file upload
            Part filePart = req.getPart("templateFile");
            Long fileId = null;
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String mimeType = filePart.getContentType();
                long fileSize = filePart.getSize();
                
                String storedFileName = System.currentTimeMillis() + "_" + originalFileName;
                
                java.nio.file.Path templateDir = java.nio.file.Paths.get(
                        System.getProperty("user.home"),
                        "lmlf_uploads",
                        "templates"
                );
                java.nio.file.Files.createDirectories(templateDir);
                java.nio.file.Path storedPath = templateDir.resolve(storedFileName);
                
                try (java.io.InputStream input = filePart.getInputStream()) {
                    java.nio.file.Files.copy(input, storedPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                }
                
                model.SyllabusVersionFile svFile = new model.SyllabusVersionFile();
                svFile.setFileType("TEMPLATE");
                svFile.setOriginalFileName(originalFileName);
                svFile.setStoredFilePath(storedPath.toAbsolutePath().toString());
                svFile.setFileSize(fileSize);
                svFile.setMimeType(mimeType);
                if (loggedInUser != null) {
                    svFile.setUploadedBy(loggedInUser.getUserId());
                }
                
                dao.SyllabusVersionFileDAO fileDAO = new dao.SyllabusVersionFileDAO();
                long insertedFileId = fileDAO.insert(svFile);
                if (insertedFileId > 0) {
                    fileId = insertedFileId;
                }
            }

            for (String revIdStr : reviewerIds) {
                if (revIdStr == null || revIdStr.trim().isEmpty()) {
                    continue;
                }
                Long reviewerId = Long.parseLong(revIdStr.trim());

                if (designerId.equals(reviewerId)) {
                    continue; // Skip same account
                }

                if (assignmentDAO.isDuplicateForReviewer(courseId, semester, academicYear, reviewerId)) {
                    hasDuplicate = true;
                    continue;
                }

                SyllabusAssignment sa = new SyllabusAssignment();
                sa.setCourseId(courseId);
                sa.setDesignerId(designerId);
                sa.setReviewerId(reviewerId);
                sa.setSemester(semester);
                sa.setAcademicYear(academicYear);
                sa.setAssignmentStatus((status != null && !status.trim().isEmpty()) ? status : "PENDING");
                sa.setTemplateFileId(fileId);
                sa.setDueDate(dueDate);

                boolean result = assignmentDAO.create(sa);
                if (result) {
                    assignmentDAO.saveAssignment(sa, loggedInUser.getUserId(), ipAddress);
                    
                    // Assign DESIGNER and REVIEWER roles to user in database
                    dao.RoleDAO roleDAO = new dao.RoleDAO();
                    roleDAO.assignRoleToUser(designerId, "DESIGNER");
                    roleDAO.assignRoleToUser(reviewerId, "REVIEWER");
                    
                    hasSuccess = true;
                }
            }

            if (hasSuccess) {
                req.getSession().setAttribute("successMessage", "Added syllabus role assignment(s) successfully!");
                resp.sendRedirect(req.getContextPath() + "/role-assignment");
            } else {
                if (hasDuplicate) {
                    req.setAttribute("errorMessage", "An assignment for this course, reviewer, semester and academic year already exists.");
                } else {
                    req.setAttribute("errorMessage", "Failed to save syllabus role assignment. Please check inputs.");
                }
                forwardToList(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid parameters provided.");
            forwardToList(req, resp);
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String assignmentIdStr = req.getParameter("assignmentId");
        String courseIdStr = req.getParameter("courseId");
        String designerIdStr = req.getParameter("designerId");
        String reviewerIdStr = req.getParameter("reviewerId");
        String semester = req.getParameter("semester");
        String yearStr = req.getParameter("academicYear");
        String status = req.getParameter("status");

        req.setAttribute("action", "edit");

        if (assignmentIdStr == null || assignmentIdStr.trim().isEmpty() ||
            courseIdStr == null || courseIdStr.trim().isEmpty() || 
            designerIdStr == null || designerIdStr.trim().isEmpty() ||
            reviewerIdStr == null || reviewerIdStr.trim().isEmpty() ||
            semester == null || semester.trim().isEmpty() ||
            yearStr == null || yearStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "All fields are required.");
            forwardToList(req, resp);
            return;
        }

        try {
            Long assignmentId = Long.parseLong(assignmentIdStr.trim());
            Long courseId = Long.parseLong(courseIdStr.trim());
            Long designerId = Long.parseLong(designerIdStr.trim());
            Long reviewerId = Long.parseLong(reviewerIdStr.trim());
            int academicYear = Integer.parseInt(yearStr.trim());

            SyllabusAssignment existing = assignmentDAO.getById(assignmentId);
            if (existing == null) {
                req.setAttribute("errorMessage", "Syllabus assignment not found.");
                forwardToList(req, resp);
                return;
            }

            req.setAttribute("assignment", existing);

            // Backend business logic enforcement: Block edits if status is SUBMITTED or COMPLETED
            if ("SUBMITTED".equalsIgnoreCase(existing.getAssignmentStatus()) || "COMPLETED".equalsIgnoreCase(existing.getAssignmentStatus())) {
                req.setAttribute("errorMessage", "This assignment is already SUBMITTED or COMPLETED and cannot be updated.");
                forwardToList(req, resp);
                return;
            }

            // Backend business logic enforcement: Block edits to Course, Semester, or Academic Year
            if (existing.getCourseId() != courseId || 
                !existing.getSemester().equalsIgnoreCase(semester) || 
                existing.getAcademicYear() != academicYear) {
                req.setAttribute("errorMessage", "Course, Semester, and Academic Year cannot be modified.");
                forwardToList(req, resp);
                return;
            }

            if (designerId.equals(reviewerId)) {
                req.setAttribute("errorMessage", "Syllabus Designer and Reviewer must be different lecturers.");
                forwardToList(req, resp);
                return;
            }

            if (assignmentDAO.isDuplicateForReviewer(courseId, semester, academicYear, reviewerId, assignmentId)) {
                req.setAttribute("errorMessage", "An assignment for this course, reviewer, semester and academic year already exists.");
                forwardToList(req, resp);
                return;
            }

            String dueDateStr = req.getParameter("dueDate");
            java.sql.Timestamp dueDate = null;
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                try {
                    String formattedDate = dueDateStr.trim().replace("T", " ");
                    if (formattedDate.length() == 16) {
                        formattedDate += ":00";
                    }
                    dueDate = java.sql.Timestamp.valueOf(formattedDate);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            existing.setCourseId(courseId);
            existing.setDesignerId(designerId);
            existing.setReviewerId(reviewerId);
            existing.setSemester(semester);
            existing.setAcademicYear(academicYear);
            existing.setAssignmentStatus((status != null && !status.trim().isEmpty()) ? status : existing.getAssignmentStatus());
            existing.setDueDate(dueDate);

            boolean result = assignmentDAO.update(existing);

            if (result) {
                HttpSession session = req.getSession();
                User loggedInUser = (User) session.getAttribute("user");
                String ipAddress = req.getRemoteAddr();
                assignmentDAO.saveAssignment(existing, loggedInUser.getUserId(), ipAddress);
                
                // Assign DESIGNER and REVIEWER roles to user in database
                dao.RoleDAO roleDAO = new dao.RoleDAO();
                roleDAO.assignRoleToUser(designerId, "DESIGNER");
                roleDAO.assignRoleToUser(reviewerId, "REVIEWER");
                
                req.getSession().setAttribute("successMessage", "Updated syllabus role assignment successfully!");
                resp.sendRedirect(req.getContextPath() + "/role-assignment");
            } else {
                req.setAttribute("errorMessage", "Failed to update assignment.");
                forwardToList(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid numeric inputs.");
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
