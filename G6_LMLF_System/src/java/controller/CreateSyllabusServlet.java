package controller;

import dao.CourseDAO;
import dao.SyllabusDAO;
import dao.SyllabusVersionDAO;
import model.Course;
import model.Syllabus;
import model.SyllabusVersion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/syllabus/create")
public class CreateSyllabusServlet extends HttpServlet {

    private SyllabusDAO syllabusDAO;
    private SyllabusVersionDAO versionDAO;
    private CourseDAO courseDAO;

    @Override
    public void init() {
        syllabusDAO = new SyllabusDAO();
        versionDAO = new SyllabusVersionDAO();
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equals(action) || action == null) {
                showCreateForm(request, response);
            } else if ("edit".equals(action)) {
                showEditForm(request, response);
            } else if ("view".equals(action)) {
                viewSyllabus(request, response);
            } else if ("delete".equals(action)) {
                deleteSyllabus(request, response);
            } else if ("list".equals(action)) {
                listSyllabuses(request, response);
            } else {
                showCreateForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            listSyllabuses(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createSyllabus(request, response);
            } else if ("edit".equals(action)) {
                editSyllabus(request, response);
            } else if ("saveDraft".equals(action)) {
                saveDraft(request, response);
            } else {
                listSyllabuses(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            listSyllabuses(request, response);
        }
    }

    // ==================== LIST SYLLABUSES ====================
    private void listSyllabuses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Syllabus> syllabuses = syllabusDAO.getAll();
        request.setAttribute("syllabuses", syllabuses);
        request.setAttribute("totalSyllabuses", syllabuses.size());
        // Đường dẫn đúng: views/designer/syllabus/list.jsp
        request.getRequestDispatcher("/views/designer/syllabus/list.jsp").forward(request, response);
    }

    // ==================== SHOW CREATE FORM ====================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Course> courses = courseDAO.listAll();
        request.setAttribute("mode", "create");
        request.setAttribute("pageTitle", "Create New Syllabus");
        request.setAttribute("courses", courses);
        // Đường dẫn đúng: views/designer/syllabus/create.jsp
        request.getRequestDispatcher("/views/designer/syllabus/create.jsp").forward(request, response);
    }

    // ==================== SHOW EDIT FORM ====================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
            return;
        }

        try {
            Long syllabusId = Long.parseLong(idParam);
            Syllabus syllabus = syllabusDAO.getById(syllabusId);

            if (syllabus == null) {
                response.sendRedirect("syllabus/create?action=list&error=Syllabus not found");
                return;
            }

            SyllabusVersion latestVersion = versionDAO.getLatestBySyllabusId(syllabusId);
            List<Course> courses = courseDAO.listAll();

            request.setAttribute("mode", "edit");
            request.setAttribute("syllabus", syllabus);
            request.setAttribute("latestVersion", latestVersion);
            request.setAttribute("courses", courses);
            request.setAttribute("pageTitle", "Edit Syllabus - " + syllabus.getTitle());
            // Đường dẫn đúng: views/designer/syllabus/create.jsp
            request.getRequestDispatcher("/views/designer/syllabus/create.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
        }
    }

    // ==================== VIEW SYLLABUS ====================
    private void viewSyllabus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
            return;
        }

        try {
            Long syllabusId = Long.parseLong(idParam);
            Syllabus syllabus = syllabusDAO.getById(syllabusId);

            if (syllabus == null) {
                response.sendRedirect("syllabus/create?action=list&error=Syllabus not found");
                return;
            }

            List<SyllabusVersion> versions = versionDAO.getBySyllabusId(syllabusId);

            request.setAttribute("mode", "view");
            request.setAttribute("syllabus", syllabus);
            request.setAttribute("versions", versions);
            request.setAttribute("pageTitle", "View Syllabus - " + syllabus.getTitle());
            // Đường dẫn đúng: views/designer/syllabus/view.jsp (nếu có)
            // Hoặc có thể dùng create.jsp để view
            request.getRequestDispatcher("/views/designer/syllabus/create.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
        }
    }

    // ==================== DELETE SYLLABUS ====================
    private void deleteSyllabus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
            return;
        }

        try {
            Long syllabusId = Long.parseLong(idParam);
            Syllabus syllabus = syllabusDAO.getById(syllabusId);

            if (syllabus == null) {
                response.sendRedirect("syllabus/create?action=list&error=Syllabus not found");
                return;
            }

            if (syllabusDAO.softDelete(syllabusId)) {
                response.sendRedirect("syllabus/create?action=list&success=Syllabus deleted successfully");
            } else {
                response.sendRedirect("syllabus/create?action=list&error=Failed to delete syllabus");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
        }
    }

    // ==================== CREATE SYLLABUS ====================
    private void createSyllabus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        String title = request.getParameter("title");
        String changeType = request.getParameter("changeType");
        String description = request.getParameter("description");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please select a course");
            showCreateForm(request, response);
            return;
        }

        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Syllabus title is required");
            showCreateForm(request, response);
            return;
        }

        try {
            Long courseId = Long.parseLong(courseIdStr);
            Course course = courseDAO.getById(courseId);
            if (course == null) {
                request.setAttribute("error", "Selected course not found");
                showCreateForm(request, response);
                return;
            }

            // SỬ DỤNG CONSTRUCTOR VỚI 2 THAM SỐ
            Syllabus syllabus = new Syllabus(courseId, title.trim());

            if (syllabusDAO.create(syllabus)) {
                // Tạo version đầu tiên - SỬ DỤNG CONSTRUCTOR ĐÚNG
                SyllabusVersion version = new SyllabusVersion(
                        syllabus.getSyllabusId(),
                        "v1.0",
                        changeType != null ? changeType : "NEW",
                        1L
                );
                version.setDescriptionOfChanges(description != null ? description : "Initial version");

                if (versionDAO.create(version)) {
                    response.sendRedirect("syllabus/create?action=edit&id=" + syllabus.getSyllabusId()
                            + "&success=Syllabus created successfully");
                } else {
                    request.setAttribute("error", "Failed to create syllabus version");
                    showCreateForm(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to create syllabus");
                showCreateForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input format");
            showCreateForm(request, response);
        }
    }

    // ==================== EDIT SYLLABUS ====================
    private void editSyllabus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String syllabusIdStr = request.getParameter("syllabusId");
        String title = request.getParameter("title");
        String versionNumber = request.getParameter("versionNumber");
        String changeType = request.getParameter("changeType");
        String description = request.getParameter("description");

        if (syllabusIdStr == null || syllabusIdStr.trim().isEmpty()) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
            return;
        }

        try {
            Long syllabusId = Long.parseLong(syllabusIdStr);
            Syllabus syllabus = syllabusDAO.getById(syllabusId);

            if (syllabus == null) {
                response.sendRedirect("syllabus/create?action=list&error=Syllabus not found");
                return;
            }

            syllabus.setTitle(title.trim());
            if (versionNumber != null && !versionNumber.trim().isEmpty()) {
                syllabus.setCurrentVersion(versionNumber.trim());
            }
            syllabus.setUpdatedBy(1L);

            if (syllabusDAO.update(syllabus)) {
                SyllabusVersion latestVersion = versionDAO.getLatestBySyllabusId(syllabusId);

                if (latestVersion != null && latestVersion.getStatus().equals("DRAFT")) {
                    latestVersion.setChangeType(changeType);
                    latestVersion.setDescriptionOfChanges(description);
                    latestVersion.setUpdatedBy(1L);
                    versionDAO.update(latestVersion);
                } else {
                    String newVersionNumber = versionNumber != null && !versionNumber.trim().isEmpty()
                            ? versionNumber.trim() : "v1.1";
                    SyllabusVersion newVersion = new SyllabusVersion(
                            syllabusId,
                            newVersionNumber,
                            changeType != null ? changeType : "MINOR",
                            1L
                    );
                    newVersion.setDescriptionOfChanges(description != null ? description : "Updated version");
                    versionDAO.create(newVersion);
                }

                response.sendRedirect("syllabus/create?action=edit&id=" + syllabusId
                        + "&success=Syllabus updated successfully");
            } else {
                request.setAttribute("error", "Failed to update syllabus");
                showEditForm(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
        }
    }

    // ==================== SAVE DRAFT ====================
    private void saveDraft(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String syllabusIdStr = request.getParameter("syllabusId");
        String title = request.getParameter("title");
        String versionNumber = request.getParameter("versionNumber");
        String changeType = request.getParameter("changeType");
        String description = request.getParameter("description");

        if (syllabusIdStr == null || syllabusIdStr.trim().isEmpty()) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
            return;
        }

        try {
            Long syllabusId = Long.parseLong(syllabusIdStr);
            Syllabus syllabus = syllabusDAO.getById(syllabusId);

            if (syllabus == null) {
                response.sendRedirect("syllabus/create?action=list&error=Syllabus not found");
                return;
            }

            syllabus.setTitle(title.trim());
            syllabus.setUpdatedBy(1L);
            syllabusDAO.update(syllabus);

            SyllabusVersion latestVersion = versionDAO.getLatestBySyllabusId(syllabusId);

            if (latestVersion != null && latestVersion.getStatus().equals("DRAFT")) {
                latestVersion.setChangeType(changeType);
                latestVersion.setDescriptionOfChanges(description);
                latestVersion.setUpdatedBy(1L);
                versionDAO.update(latestVersion);
            } else {
                String newVersionNumber = versionNumber != null && !versionNumber.trim().isEmpty()
                        ? versionNumber.trim() : "v1.1";
                SyllabusVersion newVersion = new SyllabusVersion(
                        syllabusId,
                        newVersionNumber,
                        changeType != null ? changeType : "MINOR",
                        1L
                );
                newVersion.setDescriptionOfChanges(description != null ? description : "Draft version");
                versionDAO.create(newVersion);
            }

            response.sendRedirect("syllabus/create?action=edit&id=" + syllabusId
                    + "&success=Draft saved successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect("syllabus/create?action=list&error=Invalid syllabus ID");
        }
    }
}
