package controller;

import dao.LecturerSyllabusDAO;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "LecturerSyllabusServlet", urlPatterns = {"/lecturer/syllabus"})
public class LecturerSyllabusServlet extends HttpServlet {

    private LecturerSyllabusDAO syllabusDAO;

    @Override
    public void init() throws ServletException {
        syllabusDAO = new LecturerSyllabusDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // Must be logged in as LECTURER
        if (!SessionUtil.isLoggedIn(request)) {
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
        
        // Use the user's custom layout
        request.setAttribute("contentPage", "lecturer/syllabus.jsp");
        request.setAttribute("cssFile", "lecturer/lecturer.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void viewSyllabusDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/lecturer/syllabus?error=InvalidID");
            return;
        }
        
        try {
            Long syllabusId = Long.parseLong(idParam);
            Map<String, Object> syllabus = syllabusDAO.getSyllabusDetail(syllabusId);
            
            if (syllabus == null || syllabus.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/lecturer/syllabus?error=NotFound");
                return;
            }
            
            if (syllabus.get("versionId") != null) {
                long versionId = (Long) syllabus.get("versionId");
                List<Map<String, Object>> studentTasks = syllabusDAO.getSyllabusStudentTasks(versionId);
                request.setAttribute("studentTasks", studentTasks);
            }
            
            request.setAttribute("syllabus", syllabus);
            
            // Forward directly to the standalone custom detail page
            request.getRequestDispatcher("/views/syllabus/syllabus-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lecturer/syllabus?error=InvalidID");
        }
    }
}
