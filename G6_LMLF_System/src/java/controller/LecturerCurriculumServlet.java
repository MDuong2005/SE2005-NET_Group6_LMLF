package controller;

import dao.CurriculumDAO;
import model.Curriculum;
import model.Course;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "LecturerCurriculumServlet", urlPatterns = {"/lecturer/curriculum"})
public class LecturerCurriculumServlet extends HttpServlet {

    private CurriculumDAO curriculumDAO;

    @Override
    public void init() throws ServletException {
        curriculumDAO = new CurriculumDAO();
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
        
        List<Curriculum> curriculums = curriculumDAO.getAll(); // Or get only Active ones if needed
        request.setAttribute("curriculums", curriculums);
        
        // Use the unified layout
        request.setAttribute("contentPage", "lecturer/curriculum/list.jsp");
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
            Curriculum curriculum = curriculumDAO.getById(curriculumId);
            
            if (curriculum == null) {
                response.sendRedirect(request.getContextPath() + "/lecturer/curriculum?error=NotFound");
                return;
            }
            
            List<Course> courses = curriculumDAO.getAvailableCoursesForCurriculum(curriculumId);
            
            request.setAttribute("curriculum", curriculum);
            request.setAttribute("availableCourses", courses);
            
            request.setAttribute("contentPage", "lecturer/curriculum/detail.jsp");
            request.setAttribute("cssFile", "lecturer/lecturer.css");
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lecturer/curriculum?error=InvalidID");
        }
    }
}
