package controller;

import dao.CurriculumDAO;
import dao.MajorDAO;
import dao.CourseDAO;
import model.Curriculum;
import model.Major;
import model.Course;
import model.CurriculumPO;
import model.CurriculumPLO;
import model.CurriculumCourse;
import model.CurriculumPloPoMapping;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/curriculum")
public class CurriculumServlet extends HttpServlet {

    private CurriculumDAO curriculumDAO;
    private MajorDAO majorDAO;
    private CourseDAO courseDAO;
    private dao.CoursePrerequisiteDAO prerequisiteDAO;

    @Override
    public void init() {
        curriculumDAO = new CurriculumDAO();
        majorDAO = new MajorDAO();
        courseDAO = new CourseDAO();
        prerequisiteDAO = new dao.CoursePrerequisiteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
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
                    viewCurriculum(request, response);
                    break;
                case "detail":
                    viewCurriculumDetail(request, response);
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
                case "deletePO":
                    deletePO(request, response);
                    break;
                case "deletePLO":
                    deletePLO(request, response);
                    break;
                case "getPoPloJson":
                    getPoPloJson(request, response);
                    break;
                case "checkCodeUnique":
                    checkCodeUnique(request, response);
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
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createCurriculum(request, response);
            } else if ("createWizard".equals(action)) {
                createWizard(request, response);
            } else if ("addCourse".equals(action)) {
                addCourseToCurriculum(request, response);
            } else if ("assignSemester".equals(action)) {
                assignSemester(request, response);
            } else if ("addPO".equals(action)) {
                addPO(request, response);
            } else if ("addPLO".equals(action)) {
                addPLO(request, response);
            } else if ("toggleMapping".equals(action)) {
                toggleMapping(request, response);
            } else if ("toggleCoursePloMapping".equals(action)) {
                toggleCoursePloMapping(request, response);
            } else if ("updateActive".equals(action)) {
                updateActive(request, response);
            } else if ("delete".equals(action)) {
                deleteCurriculum(request, response);
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
        String keyword = request.getParameter("keyword");
        String majorParam = request.getParameter("majorId");
        String status = request.getParameter("status");
        Long majorId = null;
        Boolean isActive = null;

        try {
            if (majorParam != null && !majorParam.trim().isEmpty()) {
                majorId = Long.parseLong(majorParam);
            }
        } catch (NumberFormatException ignored) {
            majorParam = "";
        }
        if ("active".equalsIgnoreCase(status)) {
            isActive = true;
        } else if ("unactive".equalsIgnoreCase(status)) {
            isActive = false;
        }

        List<Curriculum> allCurriculums = curriculumDAO.getAll();
        List<Curriculum> curriculums = curriculumDAO.filter(keyword, majorId, isActive);
        List<Major> majors = majorDAO.getAllMajors();
        request.setAttribute("curriculums", curriculums);
        request.setAttribute("statsCurriculums", allCurriculums);
        request.setAttribute("majors", majors);
        request.setAttribute("totalCurriculums", allCurriculums.size());
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("selectedMajorId", majorParam == null ? "" : majorParam);
        request.setAttribute("selectedStatus", status == null ? "" : status);
        request.getRequestDispatcher("/views/academic/curriculum/curriculum.jsp").forward(request, response);
    }

    // ==================== SHOW CREATE FORM ====================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Major> majors = majorDAO.getAllMajors();
        List<Course> courses = courseDAO.listAll();
        List<Curriculum> curriculums = curriculumDAO.getAll();
        List<model.CoursePrerequisite> prerequisites = prerequisiteDAO.listAll();
        request.setAttribute("mode", "create");
        request.setAttribute("pageTitle", "Create New Curriculum");
        request.setAttribute("majors", majors);
        request.setAttribute("courses", courses);
        request.setAttribute("curriculums", curriculums);
        request.setAttribute("prerequisites", prerequisites);
        request.getRequestDispatcher("/views/academic/curriculum/add-curriculum.jsp").forward(request, response);
    }

    // ==================== CREATE CURRICULUM ====================
    private void createCurriculum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String majorIdStr = request.getParameter("majorId");
        String curriculumCode = request.getParameter("curriculumCode");
        String version = request.getParameter("version");
        String totalSemestersStr = request.getParameter("totalSemesters");
        
        if (majorIdStr == null || majorIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please select a major");
            showCreateForm(request, response);
            return;
        }
        
        if (curriculumCode == null || curriculumCode.trim().isEmpty()) {
            request.setAttribute("error", "Curriculum Code is required");
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
            
            Major major = majorDAO.getMajorById(majorId);
            if (major == null) {
                request.setAttribute("error", "Selected major not found");
                showCreateForm(request, response);
                return;
            }
            
            if (curriculumDAO.checkCodeExists(curriculumCode.trim())) {
                request.setAttribute("error", "Curriculum Code '" + curriculumCode.trim() + "' already exists.");
                showCreateForm(request, response);
                return;
            }
            
            Curriculum curriculum = new Curriculum(majorId, version.trim(), totalSemesters);
            curriculum.setCurriculumCode(curriculumCode.trim());
            
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

            if (curriculum.getIsActive()) {
                response.sendRedirect("curriculum?action=list&error=Active curriculums cannot be deleted. Please set the curriculum to UnActive first.");
                return;
            }
            
            List<Course> availableCourses = curriculumDAO.getAvailableCoursesForCurriculum(curriculumId);
            
            request.setAttribute("mode", "view");
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("availableCourses", availableCourses);
            request.getRequestDispatcher("/views/academic/curriculum/curriculum.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
        }
    }

    // ==================== VIEW CURRICULUM DETAIL ====================
    private void viewCurriculumDetail(HttpServletRequest request, HttpServletResponse response) 
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
            List<model.CoursePrerequisite> prerequisites = prerequisiteDAO.listAll();
            
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("availableCourses", availableCourses);
            request.setAttribute("prerequisites", prerequisites);
            request.setAttribute("pageTitle", "Curriculum Details - " + curriculum.getVersion());
            
            request.getRequestDispatcher("/views/academic/curriculum/curriculum-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("curriculum?action=list&error=Invalid curriculum ID");
        }
    }

    // ==================== DELETE CURRICULUM ====================
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

    // ==================== SAVE FROM WIZARD (AJAX JSON) ====================
    private void createWizard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            try (java.io.BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            
            Gson gson = new Gson();
            WizardData data = gson.fromJson(sb.toString(), WizardData.class);
            
            if (data == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"Empty payload\"}");
                return;
            }
            
            if (data.curriculumCode == null || data.curriculumCode.trim().isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Curriculum Code is required\"}");
                return;
            }
            
            if (curriculumDAO.checkCodeExists(data.curriculumCode.trim())) {
                response.getWriter().write("{\"success\":false,\"message\":\"Curriculum Code '" + data.curriculumCode.trim() + "' already exists.\"}");
                return;
            }
            
            Curriculum curriculum = new Curriculum();
            curriculum.setMajorId(data.majorId);
            curriculum.setCurriculumCode(data.curriculumCode);
            curriculum.setName(data.curriculumName);
            curriculum.setVersion("1.0");
            curriculum.setDecisionNo(data.decisionNo);
            if (data.issuedDate != null && !data.issuedDate.isEmpty()) {
                curriculum.setIssuedDate(java.sql.Date.valueOf(data.issuedDate));
            } else {
                curriculum.setIssuedDate(new java.sql.Date(System.currentTimeMillis()));
            }
            curriculum.setTotalCredits(data.totalCredits);
            curriculum.setTotalSemesters(data.totalSemesters);
            curriculum.setIsActive(false);
            
            List<CurriculumPO> pos = new ArrayList<>();
            if (data.pos != null) {
                for (PoDto dto : data.pos) {
                    String cleanCode = dto.id.replace("-", "");
                    pos.add(new CurriculumPO(null, cleanCode, dto.text));
                }
            }
            
            List<CurriculumPLO> plos = new ArrayList<>();
            if (data.plos != null) {
                for (PloDto dto : data.plos) {
                    String cleanCode = dto.id.replace("-", "");
                    plos.add(new CurriculumPLO(null, cleanCode, dto.text));
                }
            }
            
            List<CurriculumCourse> courses = new ArrayList<>();
            if (data.courses != null) {
                for (CourseDto dto : data.courses) {
                    Course course = courseDAO.getByCode(dto.code);
                    if (course != null) {
                        CurriculumCourse cc = new CurriculumCourse();
                        cc.setCourseId(course.getCourseId());
                        cc.setSemester(dto.semester);
                        cc.setKnowledgeBlock(dto.knowledgeBlock);
                        courses.add(cc);
                    }
                }
            }
            
            List<String[]> mappingCodes = new ArrayList<>();
            if (data.mappings != null) {
                for (MappingDto dto : data.mappings) {
                    String cleanPlo = dto.ploCode.replace("-", "");
                    String cleanPo = dto.poCode.replace("-", "");
                    mappingCodes.add(new String[]{cleanPlo, cleanPo});
                }
            }
            
            List<String[]> coursePloMappings = new ArrayList<>();
            if (data.coursePloMappings != null) {
                for (CoursePloMappingDto dto : data.coursePloMappings) {
                    String cleanPlo = dto.ploCode.replace("-", "");
                    coursePloMappings.add(new String[]{dto.courseCode, cleanPlo});
                }
            }
            
            try {
                boolean success = curriculumDAO.createWizardCurriculum(curriculum, pos, plos, courses, mappingCodes, coursePloMappings);
                if (success) {
                    response.getWriter().write("{\"success\":true,\"message\":\"Curriculum created successfully\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to save curriculum. Unknown error.\"}");
                }
            } catch (Exception dbEx) {
                dbEx.printStackTrace();
                String errMsg = dbEx.getMessage() != null ? dbEx.getMessage() : "Unknown database error";
                errMsg = errMsg.replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
                response.getWriter().write("{\"success\":false,\"message\":\"Database Error: " + errMsg + "\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String errMsg = e.getMessage() != null ? e.getMessage() : "Unknown server error";
            errMsg = errMsg.replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
            response.getWriter().write("{\"success\":false,\"message\":\"Error: " + errMsg + "\"}");
        }
    }

    // ==================== AJAX ACTIONS FOR POs/PLOs ====================
    private void addPO(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String curriculumIdStr = request.getParameter("curriculumId");
        String code = request.getParameter("code");
        String description = request.getParameter("description");
        
        if (curriculumIdStr != null && code != null && description != null) {
            try {
                Long curriculumId = Long.parseLong(curriculumIdStr.trim());
                CurriculumPO po = new CurriculumPO(curriculumId, code.trim().replace("-", ""), description.trim());
                if (curriculumDAO.addPO(po)) {
                    response.getWriter().write("{\"success\":true,\"poId\":" + po.getPoId() + "}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }

    private void deletePO(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String curriculumIdStr = request.getParameter("curriculumId");
        String code = request.getParameter("code");
        
        if (curriculumIdStr != null && code != null) {
            try {
                Long curriculumId = Long.parseLong(curriculumIdStr.trim());
                if (curriculumDAO.deletePO(curriculumId, code.trim())) {
                    response.getWriter().write("{\"success\":true}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }

    private void addPLO(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String curriculumIdStr = request.getParameter("curriculumId");
        String code = request.getParameter("code");
        String description = request.getParameter("description");
        
        if (curriculumIdStr != null && code != null && description != null) {
            try {
                Long curriculumId = Long.parseLong(curriculumIdStr.trim());
                CurriculumPLO plo = new CurriculumPLO(curriculumId, code.trim().replace("-", ""), description.trim());
                if (curriculumDAO.addPLO(plo)) {
                    response.getWriter().write("{\"success\":true,\"ploId\":" + plo.getPloId() + "}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }

    private void deletePLO(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String curriculumIdStr = request.getParameter("curriculumId");
        String code = request.getParameter("code");
        
        if (curriculumIdStr != null && code != null) {
            try {
                Long curriculumId = Long.parseLong(curriculumIdStr.trim());
                if (curriculumDAO.deletePLO(curriculumId, code.trim())) {
                    response.getWriter().write("{\"success\":true}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }

    private void toggleMapping(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String curriculumIdStr = request.getParameter("curriculumId");
        String ploCode = request.getParameter("ploCode");
        String poCode = request.getParameter("poCode");
        
        if (curriculumIdStr != null && ploCode != null && poCode != null) {
            try {
                Long curriculumId = Long.parseLong(curriculumIdStr.trim());
                if (curriculumDAO.toggleMapping(curriculumId, ploCode.trim(), poCode.trim())) {
                    response.getWriter().write("{\"success\":true}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }



    private void updateActive(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String idParam = request.getParameter("id");
        String activeParam = request.getParameter("isActive");
        
        if (idParam != null && activeParam != null) {
            try {
                Long id = Long.parseLong(idParam.trim());
                boolean isActive = Boolean.parseBoolean(activeParam.trim());
                
                if (curriculumDAO.updateActiveStatus(id, isActive)) {
                    response.getWriter().write("{\"success\":true}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }

    // ==================== GSON DATA DTO CLASSES ====================
    private static class WizardData {
        String curriculumCode;
        String curriculumName;
        Long majorId;
        String decisionNo;
        String issuedDate;
        String description;
        int totalSemesters;
        int totalCredits;
        List<PoDto> pos;
        List<PloDto> plos;
        List<CourseDto> courses;
        List<MappingDto> mappings;
        List<CoursePloMappingDto> coursePloMappings;
    }

    private void toggleCoursePloMapping(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String curriculumIdStr = request.getParameter("curriculumId");
        String courseCode = request.getParameter("courseCode");
        String ploCode = request.getParameter("ploCode");
        
        if (curriculumIdStr != null && courseCode != null && ploCode != null) {
            try {
                Long curriculumId = Long.parseLong(curriculumIdStr.trim());
                if (curriculumDAO.toggleCoursePloMapping(curriculumId, courseCode.trim(), ploCode.trim().replace("-", ""))) {
                    response.getWriter().write("{\"success\":true}");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }

    private void getPoPloJson(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long curriculumId = Long.parseLong(idParam.trim());
                Curriculum curriculum = curriculumDAO.getById(curriculumId);
                if (curriculum != null) {
                    Gson gson = new Gson();
                    PoPloResponse res = new PoPloResponse();
                    res.success = true;
                    res.pos = curriculum.getPos();
                    res.plos = curriculum.getPlos();
                    res.courses = curriculum.getCourses();
                    res.coursePloMappings = curriculum.getCoursePloMappings();
                    response.getWriter().write(gson.toJson(res));
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("{\"success\":false}");
    }

    private void checkCodeUnique(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            response.getWriter().write("{\"unique\":false,\"message\":\"Code is empty\"}");
            return;
        }
        
        boolean exists = curriculumDAO.checkCodeExists(code.trim());
        response.getWriter().write("{\"unique\":" + !exists + "}");
    }
    
    private static class PoPloResponse {
        boolean success;
        List<CurriculumPO> pos;
        List<CurriculumPLO> plos;
        List<CurriculumCourse> courses;
        List<String[]> coursePloMappings;
    }

    private static class PoDto {
        String id;
        String text;
    }

    private static class PloDto {
        String id;
        String text;
    }

    private static class CourseDto {
        String code;
        int semester;
        String knowledgeBlock;
    }

    private static class MappingDto {
        String ploCode;
        String poCode;
    }

    private static class CoursePloMappingDto {
        String courseCode;
        String ploCode;
    }
}
