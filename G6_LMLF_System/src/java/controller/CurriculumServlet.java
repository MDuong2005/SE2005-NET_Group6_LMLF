package controller;

import dao.CurriculumDAO;
import dao.MajorDAO;
import dao.CourseDAO;
import model.Curriculum;
import model.Major;
import model.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * CurriculumServlet maps the "/curriculum" URL to "views/curriculum.jsp".
 */
@WebServlet(name = "CurriculumServlet", urlPatterns = {"/curriculum"})
public class CurriculumServlet extends HttpServlet {

    private CurriculumDAO curriculumDAO;
    private MajorDAO majorDAO;
    private CourseDAO courseDAO;

    @Override
    public void init() {
        curriculumDAO = new CurriculumDAO();
        majorDAO = new MajorDAO();
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // KHÔNG CẦN ĐĂNG NHẬP
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listCurriculums(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "view":
                case "detail":
                    viewCurriculum(request, response);
                    break;
                case "delete":
                    deleteCurriculum(request, response);
                    break;
                case "restore":
                    restoreCurriculum(request, response);
                    break;
                case "addCourse":
                    showAddCourseForm(request, response);
                    break;
                case "removeCourse":
                    removeCourse(request, response);
                    break;
                case "assignSemester":
                    showAssignSemesterForm(request, response);
                    break;
                default:
                    listCurriculums(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            listCurriculums(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // KHÔNG CẦN ĐĂNG NHẬP
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createCurriculum(request, response);
            } else if ("addCourse".equals(action)) {
                addCourseToCurriculum(request, response);
            } else if ("assignSemester".equals(action)) {
                assignSemester(request, response);
            } else {
                listCurriculums(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            listCurriculums(request, response);
        }
    }

    // ==================== LIST CURRICULUMS ====================
    private void listCurriculums(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Curriculum> curriculums = curriculumDAO.getAll();
        List<Major> majors = majorDAO.getAllMajors();
        request.setAttribute("curriculums", curriculums);
        request.setAttribute("majors", majors);
        request.setAttribute("totalCurriculums", curriculums.size());
        request.getRequestDispatcher("/views/academic/curriculum/curriculum.jsp").forward(request, response);
    }

    // ==================== SHOW CREATE FORM ====================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Major> majors = majorDAO.getAllMajors();
        request.setAttribute("mode", "create");
        request.setAttribute("pageTitle", "Create New Curriculum");
        request.setAttribute("majors", majors);
        request.getRequestDispatcher("/views/academic/curriculum/curriculum.jsp").forward(request, response);
    }

    // ==================== CREATE CURRICULUM ====================
    private void createCurriculum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String majorIdStr = request.getParameter("majorId");
        String version = request.getParameter("version");
        String totalSemestersStr = request.getParameter("totalSemesters");
        
        // Validate
        if (majorIdStr == null || majorIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please select a major");
            showCreateForm(request, response);
            return;
        }
        
        if (version == null || version.trim().isEmpty()) {
            request.setAttribute("error", "Version is required");
            showCreateForm(request, response);
            return;
        }
        
        if (totalSemestersStr == null || totalSemestersStr.trim().isEmpty()) {
            request.setAttribute("error", "Total semesters is required");
            showCreateForm(request, response);
            return;
        }
        
        try {
            Long majorId = Long.parseLong(majorIdStr);
            int totalSemesters = Integer.parseInt(totalSemestersStr.trim());
            
            if (totalSemesters < 1 || totalSemesters > 12) {
                request.setAttribute("error", "Total semesters must be between 1 and 12");
                showCreateForm(request, response);
                return;
            }
            
            // Kiểm tra major tồn tại
            Major major = majorDAO.getMajorById(majorId);
            if (major == null) {
                request.setAttribute("error", "Selected major not found");
                showCreateForm(request, response);
                return;
            }
            
            Curriculum curriculum = new Curriculum(majorId, version.trim(), totalSemesters);
            
            if (curriculumDAO.create(curriculum)) {
                response.sendRedirect("curriculum?action=list&success=Curriculum created successfully");
            } else {
                request.setAttribute("error", "Failed to create curriculum. Version may already exist for this major.");
                showCreateForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input format");
            showCreateForm(request, response);
        }
    }

    // ==================== VIEW CURRICULUM ====================
    private void viewCurriculum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(idParam);
            Curriculum curriculum = curriculumDAO.getById(curriculumId);
            
            if (curriculum == null) {
                response.sendRedirect("curriculum?action=list&error=Curriculum not found");
                return;
            }
            
            List<Course> availableCourses = curriculumDAO.getAvailableCoursesForCurriculum(curriculumId);
            
            request.setAttribute("mode", "view");
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("availableCourses", availableCourses);
            request.setAttribute("pageTitle", "View Curriculum - " + curriculum.getVersion());

            String requestedAction = request.getParameter("action");
            String targetPage = "detail".equals(requestedAction)
                    ? "/views/academic/curriculum/curriculum-detail.jsp"
                    : "/views/academic/curriculum/curriculum.jsp";

            request.getRequestDispatcher(targetPage).forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
        }
    }

    // ==================== DELETE CURRICULUM (Xóa mềm) ====================
    private void deleteCurriculum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(idParam);
            Curriculum curriculum = curriculumDAO.getById(curriculumId);
            
            if (curriculum == null) {
                response.sendRedirect("curriculum?action=list&error=Curriculum not found");
                return;
            }
            
            if (curriculumDAO.softDelete(curriculumId)) {
                response.sendRedirect("curriculum?action=list&success=Curriculum deleted successfully");
            } else {
                response.sendRedirect("curriculum?action=list&error=Failed to delete curriculum");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
        }
    }

    // ==================== RESTORE CURRICULUM ====================
    private void restoreCurriculum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(idParam);
            if (curriculumDAO.restore(curriculumId)) {
                response.sendRedirect("curriculum?action=list&success=Curriculum restored successfully");
            } else {
                response.sendRedirect("curriculum?action=list&error=Failed to restore curriculum");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
        }
    }

    // ==================== SHOW ADD COURSE FORM ====================
    private void showAddCourseForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(idParam);
            Curriculum curriculum = curriculumDAO.getById(curriculumId);
            
            if (curriculum == null) {
                response.sendRedirect("curriculum?action=list&error=Curriculum not found");
                return;
            }
            
            List<Course> availableCourses = curriculumDAO.getAvailableCoursesForCurriculum(curriculumId);
            
            request.setAttribute("mode", "addCourse");
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("availableCourses", availableCourses);
            request.setAttribute("pageTitle", "Add Course to Curriculum");
            request.getRequestDispatcher("/views/academic/curriculum/curriculum.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
        }
    }

    // ==================== ADD COURSE TO CURRICULUM ====================
    private void addCourseToCurriculum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String curriculumIdStr = request.getParameter("curriculumId");
        String courseIdStr = request.getParameter("courseId");
        String semesterStr = request.getParameter("semester");
        
        if (curriculumIdStr == null || curriculumIdStr.trim().isEmpty() ||
            courseIdStr == null || courseIdStr.trim().isEmpty() ||
            semesterStr == null || semesterStr.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=All fields are required");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(curriculumIdStr);
            Long courseId = Long.parseLong(courseIdStr);
            Integer semester = Integer.parseInt(semesterStr.trim());
            
            if (semester < 1) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&error=Semester must be at least 1");
                return;
            }
            
            // Kiểm tra curriculum tồn tại
            Curriculum curriculum = curriculumDAO.getById(curriculumId);
            if (curriculum == null) {
                response.sendRedirect("curriculum?action=list&error=Curriculum not found");
                return;
            }
            
            // Kiểm tra semester không vượt quá total semesters
            if (semester > curriculum.getTotalSemesters()) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + 
                    "&error=Semester cannot exceed " + curriculum.getTotalSemesters());
                return;
            }
            
            if (curriculumDAO.addCourseToCurriculum(curriculumId, courseId, semester)) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&success=Course added successfully");
            } else {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&error=Course already exists in this curriculum");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid input format");
        }
    }

    // ==================== REMOVE COURSE ====================
    private void removeCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String curriculumIdStr = request.getParameter("curriculumId");
        String courseIdStr = request.getParameter("courseId");
        
        if (curriculumIdStr == null || curriculumIdStr.trim().isEmpty() ||
            courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=Invalid parameters");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(curriculumIdStr);
            Long courseId = Long.parseLong(courseIdStr);
            
            if (curriculumDAO.removeCourseFromCurriculum(curriculumId, courseId)) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&success=Course removed successfully");
            } else {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&error=Failed to remove course");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid parameters");
        }
    }

    // ==================== SHOW ASSIGN SEMESTER FORM ====================
    private void showAssignSemesterForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String curriculumIdStr = request.getParameter("curriculumId");
        String courseIdStr = request.getParameter("courseId");
        
        if (curriculumIdStr == null || curriculumIdStr.trim().isEmpty() ||
            courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=Invalid parameters");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(curriculumIdStr);
            Long courseId = Long.parseLong(courseIdStr);
            
            Curriculum curriculum = curriculumDAO.getById(curriculumId);
            if (curriculum == null) {
                response.sendRedirect("curriculum?action=list&error=Curriculum not found");
                return;
            }
            
            // Tìm course trong curriculum để lấy semester hiện tại
            model.CurriculumCourse targetCourse = null;
            for (model.CurriculumCourse cc : curriculum.getCourses()) {
                if (cc.getCourseId().equals(courseId)) {
                    targetCourse = cc;
                    break;
                }
            }
            
            if (targetCourse == null) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&error=Course not found in curriculum");
                return;
            }
            
            request.setAttribute("mode", "assignSemester");
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("course", targetCourse.getCourse());
            request.setAttribute("currentSemester", targetCourse.getSemester());
            request.setAttribute("pageTitle", "Assign Semester for " + targetCourse.getCourse().getCode());
            request.getRequestDispatcher("/views/academic/curriculum/curriculum.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid parameters");
        }
    }

    // ==================== ASSIGN SEMESTER ====================
    private void assignSemester(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String curriculumIdStr = request.getParameter("curriculumId");
        String courseIdStr = request.getParameter("courseId");
        String semesterStr = request.getParameter("semester");
        
        if (curriculumIdStr == null || curriculumIdStr.trim().isEmpty() ||
            courseIdStr == null || courseIdStr.trim().isEmpty() ||
            semesterStr == null || semesterStr.trim().isEmpty()) {
            response.sendRedirect("curriculum?action=list&error=All fields are required");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(curriculumIdStr);
            Long courseId = Long.parseLong(courseIdStr);
            Integer semester = Integer.parseInt(semesterStr.trim());
            
            if (semester < 1) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&error=Semester must be at least 1");
                return;
            }
            
            Curriculum curriculum = curriculumDAO.getById(curriculumId);
            if (curriculum == null) {
                response.sendRedirect("curriculum?action=list&error=Curriculum not found");
                return;
            }
            
            if (semester > curriculum.getTotalSemesters()) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + 
                    "&error=Semester cannot exceed " + curriculum.getTotalSemesters());
                return;
            }
            
            if (curriculumDAO.updateCourseSemester(curriculumId, courseId, semester)) {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&success=Semester updated successfully");
            } else {
                response.sendRedirect("curriculum?action=view&id=" + curriculumId + "&error=Failed to update semester");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid input format");
        }
    }
}