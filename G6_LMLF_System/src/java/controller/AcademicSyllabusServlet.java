package controller;

import dao.AcademicSyllabusDAO;
import dao.SyllabusVersionDAO;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AcademicSyllabusServlet", urlPatterns = {"/academic/syllabus"})
public class AcademicSyllabusServlet extends HttpServlet {

    private AcademicSyllabusDAO syllabusDAO;
    private SyllabusVersionDAO syllabusVersionDAO;

    @Override
    public void init() throws ServletException {
        syllabusDAO = new AcademicSyllabusDAO();
        syllabusVersionDAO = new SyllabusVersionDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.isLoggedIn(request)
                || !SessionUtil.getCurrentUser(request).hasRole("ACADEMIC_OFFICE")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();

        if (!"publish".equals(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action");
            return;
        }

        try {
            long syllabusId = Long.parseLong(idParam);
            Map<String, Object> syllabus = syllabusDAO.getSyllabusDetail(syllabusId);

            if (syllabus == null || syllabus.isEmpty()) {
                session.setAttribute("syllabusError", "Syllabus not found.");
            } else if (!"APPROVED".equalsIgnoreCase(String.valueOf(syllabus.get("status")))) {
                session.setAttribute("syllabusError",
                        "Only a syllabus with APPROVED status can be published. Current status: "
                        + syllabus.get("status") + ".");
            } else if (syllabus.get("versionId") == null) {
                session.setAttribute("syllabusError", "The syllabus has no approved version to publish.");
            } else {
                long versionId = ((Number) syllabus.get("versionId")).longValue();
                long publisherId = SessionUtil.getCurrentUser(request).getUserId();

                if (syllabusVersionDAO.publishVersion(versionId, publisherId)) {
                    session.setAttribute("syllabusSuccess", "Syllabus published successfully.");
                } else {
                    session.setAttribute("syllabusError",
                            "Unable to publish this syllabus. Its status may no longer be APPROVED.");
                }
            }

            response.sendRedirect(request.getContextPath()
                    + "/academic/syllabus?action=detail&id=" + syllabusId);
        } catch (NumberFormatException e) {
            session.setAttribute("syllabusError", "Invalid syllabus ID.");
            response.sendRedirect(request.getContextPath() + "/academic/syllabus");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // Must be logged in as ACADEMIC_OFFICE
        if (!SessionUtil.isLoggedIn(request) || !SessionUtil.getCurrentUser(request).hasRole("ACADEMIC_OFFICE")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listSyllabuses(request, response);
                    break;
                case "detail":
                    viewSyllabusDetail(request, response);
                    break;
                default:
                    listSyllabuses(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    private void listSyllabuses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String search = request.getParameter("search");
        if (search == null) search = "";
        
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int totalRecords = syllabusDAO.getTotalSyllabuses(search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        
        List<Map<String, Object>> syllabuses = syllabusDAO.getSyllabuses(search, page, pageSize);
        
        request.setAttribute("syllabuses", syllabuses);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        
        request.setAttribute("contentPage", "academic/syllabus.jsp");
        request.setAttribute("cssFile", "academic/academic.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void viewSyllabusDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/academic/syllabus?error=InvalidID");
            return;
        }
        
        try {
            Long syllabusId = Long.parseLong(idParam);
            Map<String, Object> syllabus = syllabusDAO.getSyllabusDetail(syllabusId);
            
            if (syllabus == null || syllabus.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/academic/syllabus?error=NotFound");
                return;
            }
            
            if (syllabus.get("versionId") != null) {
                long versionId = (Long) syllabus.get("versionId");
                List<Map<String, Object>> studentTasks = syllabusDAO.getSyllabusStudentTasks(versionId);
                request.setAttribute("studentTasks", studentTasks);
            }
            
            request.setAttribute("syllabus", syllabus);

            HttpSession session = request.getSession(false);
            if (session != null) {
                request.setAttribute("syllabusSuccess", session.getAttribute("syllabusSuccess"));
                request.setAttribute("syllabusError", session.getAttribute("syllabusError"));
                session.removeAttribute("syllabusSuccess");
                session.removeAttribute("syllabusError");
            }
            
            request.setAttribute("contentPage", "academic/syllabus-detail.jsp");
            request.setAttribute("cssFile", "academic/academic.css");
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/academic/syllabus?error=InvalidID");
        }
    }
}
