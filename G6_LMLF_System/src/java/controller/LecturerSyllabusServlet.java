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
        
        List<Map<String, Object>> syllabuses = syllabusDAO.getPublishedSyllabuses();
        request.setAttribute("syllabuses", syllabuses);
        
        // Use the unified layout
        request.setAttribute("contentPage", "lecturer/syllabus/list.jsp");
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
            
            request.setAttribute("syllabus", syllabus);
            
            request.setAttribute("contentPage", "lecturer/syllabus/detail.jsp");
            request.setAttribute("cssFile", "lecturer/lecturer.css");
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lecturer/syllabus?error=InvalidID");
        }
    }
}
