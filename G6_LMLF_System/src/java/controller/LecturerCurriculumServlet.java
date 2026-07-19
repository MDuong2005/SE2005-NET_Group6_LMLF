package controller;

import dao.LecturerCurriculumDAO;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "LecturerCurriculumServlet", urlPatterns = {"/lecturer/curriculum"})
public class LecturerCurriculumServlet extends HttpServlet {

    private LecturerCurriculumDAO curriculumDAO;

    @Override
    public void init() throws ServletException {
        curriculumDAO = new LecturerCurriculumDAO();
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
                    listCurriculums(request, response);
                    break;
                case "detail":
                    viewCurriculumDetail(request, response);
                    break;
                default:
                    listCurriculums(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    private void listCurriculums(HttpServletRequest request, HttpServletResponse response) 
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
        
        int totalRecords = curriculumDAO.getTotalActiveCurriculums(search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        
        List<Map<String, Object>> curriculums = curriculumDAO.getActiveCurriculums(search, page, pageSize);
        
        request.setAttribute("curriculums", curriculums);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        
        // Use the user's custom layout
        request.setAttribute("contentPage", "lecturer/curriculum.jsp");
        request.setAttribute("cssFile", "lecturer/lecturer.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void viewCurriculumDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/lecturer/curriculum?error=InvalidID");
            return;
        }
        
        try {
            Long curriculumId = Long.parseLong(idParam);
            Map<String, Object> curriculum = curriculumDAO.getCurriculumDetail(curriculumId);
            
            if (curriculum == null || curriculum.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/lecturer/curriculum?error=NotFound");
                return;
            }
            
            List<Map<String, Object>> ploList = curriculumDAO.getCurriculumPLOs(curriculumId);
            List<Map<String, Object>> subjectList = curriculumDAO.getCurriculumSubjects(curriculumId);
            
            // Add to recently viewed in session
            jakarta.servlet.http.HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            java.util.List<java.util.Map<String, Object>> recentCurriculums = (java.util.List<java.util.Map<String, Object>>) session.getAttribute("recentCurriculums");
            if (recentCurriculums == null) {
                recentCurriculums = new java.util.ArrayList<>();
            }
            // Remove if exists to move to top
            recentCurriculums.removeIf(c -> c.get("curriculumId") != null && c.get("curriculumId").toString().equals(curriculum.get("curriculumId").toString()));
            
            // Create light version to save session memory
            java.util.Map<String, Object> lightCurr = new java.util.HashMap<>();
            lightCurr.put("curriculumId", curriculum.get("curriculumId"));
            lightCurr.put("curriculum_name", curriculum.get("curriculumName"));
            lightCurr.put("major_code", curriculum.get("majorCode"));
            
            recentCurriculums.add(0, lightCurr);
            if (recentCurriculums.size() > 5) {
                recentCurriculums.remove(recentCurriculums.size() - 1);
            }
            session.setAttribute("recentCurriculums", recentCurriculums);
            
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("ploList", ploList);
            request.setAttribute("subjectList", subjectList);
            
            // Forward directly to the standalone custom detail page
            request.getRequestDispatcher("/views/lecturer/curriculum/curriculum-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lecturer/curriculum?error=InvalidID");
        }
    }
}
