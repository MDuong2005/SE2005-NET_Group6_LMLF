package controller;

import dao.SyllabusDAO;
import dao.SyllabusAssignmentDAO;
import dao.SyllabusVersionDAO;
import model.Syllabus;
import model.SyllabusVersion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/syllabus/submit")
public class SubmitSyllabusServlet extends HttpServlet {

    private SyllabusDAO syllabusDAO;
    private SyllabusVersionDAO versionDAO;
    private SyllabusAssignmentDAO assignmentDAO;

    @Override
    public void init() {
        syllabusDAO = new SyllabusDAO();
        versionDAO = new SyllabusVersionDAO();
        assignmentDAO = new SyllabusAssignmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("list".equals(action)) {
                listPendingSyllabuses(request, response);
            } else {
                showSubmitForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            listPendingSyllabuses(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("submit".equals(action)) {
                submitSyllabus(request, response);
            } else {
                showSubmitForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            listPendingSyllabuses(request, response);
        }
    }

    private void showSubmitForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                Long syllabusId = Long.parseLong(idParam);
                Syllabus syllabus = syllabusDAO.getById(syllabusId);
                
                if (syllabus == null) {
                    response.sendRedirect("submit?action=list&error=Syllabus not found");
                    return;
                }
                
                List<SyllabusVersion> versions = versionDAO.getBySyllabusId(syllabusId);
                
                request.setAttribute("syllabus", syllabus);
                request.setAttribute("versions", versions);
                request.setAttribute("pageTitle", "Submit Syllabus - " + syllabus.getTitle());
                request.getRequestDispatcher("/views/designer/syllabus/submit.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect("submit?action=list&error=Invalid syllabus ID");
                return;
            }
        }
        
        listPendingSyllabuses(request, response);
    }

    private void listPendingSyllabuses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Syllabus> allSyllabuses = syllabusDAO.getAll();
        List<Syllabus> draftSyllabuses = allSyllabuses.stream()
            .filter(s -> "DRAFT".equals(s.getStatus()))
            .collect(Collectors.toList());
        
        request.setAttribute("syllabuses", draftSyllabuses);
        request.setAttribute("totalSyllabuses", draftSyllabuses.size());
        request.setAttribute("pageTitle", "Submit Syllabus for Review");
        request.getRequestDispatcher("/views/designer/syllabus/submit.jsp").forward(request, response);
    }

    // ==================== SUBMIT SYLLABUS ====================
    private void submitSyllabus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String syllabusIdStr = request.getParameter("syllabusId");
        String versionIdStr = request.getParameter("versionId");
        
        if (syllabusIdStr == null || syllabusIdStr.trim().isEmpty()) {
            response.sendRedirect("submit?action=list&error=Invalid syllabus ID");
            return;
        }
        
        if (versionIdStr == null || versionIdStr.trim().isEmpty()) {
            response.sendRedirect("submit?action=list&error=Please select a version to submit");
            return;
        }
        
        try {
            Long syllabusId = Long.parseLong(syllabusIdStr);
            Long versionId = Long.parseLong(versionIdStr);
            
            Syllabus syllabus = syllabusDAO.getById(syllabusId);
            if (syllabus == null) {
                response.sendRedirect("submit?action=list&error=Syllabus not found");
                return;
            }
            
            SyllabusVersion version = versionDAO.getById(versionId);
            if (version == null) {
                response.sendRedirect("submit?action=list&error=Version not found");
                return;
            }
            
            if (!"DRAFT".equals(version.getStatus())) {
                response.sendRedirect("submit?action=list&error=Only DRAFT versions can be submitted");
                return;
            }
            
            // Bước 1: Submit version
            if (versionDAO.submit(versionId)) {
                
                // Bước 2: Tạo Syllabus Assignment
                long designerId = 1;
                boolean assignmentCreated = assignmentDAO.createAssignmentForCourse(
                    syllabus.getCourseId(), 
                    designerId
                );
                
                if (assignmentCreated) {
                    System.out.println("✅ Created syllabus_assignment for course: " + syllabus.getCourseId());
                } else {
                    System.out.println("ℹ️ Assignment already exists or no reviewer found for course: " + syllabus.getCourseId());
                }
                
                // ✅ CHUYỂN VỀ TRANG LIST (My Syllabuses)
                response.sendRedirect("create?action=list&success=Syllabus submitted successfully for review");
            } else {
                response.sendRedirect("submit?action=list&error=Failed to submit syllabus");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("submit?action=list&error=Invalid input format");
        }
    }
}