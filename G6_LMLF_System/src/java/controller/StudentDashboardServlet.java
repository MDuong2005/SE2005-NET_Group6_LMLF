package controller;

import dao.StudentLearningPathDAO;
import dao.StudentPrerequisiteDAO;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.StudentLearningPathResult;
import model.StudentPrerequisiteResult;
import model.User;
import utils.SessionUtil;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student-dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    private StudentLearningPathDAO learningPathDAO;
    private StudentPrerequisiteDAO prerequisiteDAO;

    @Override
    public void init() {
        learningPathDAO = new StudentLearningPathDAO();
        prerequisiteDAO = new StudentPrerequisiteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = SessionUtil.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!user.hasRole("STUDENT")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Student access required.");
            return;
        }

        String page = request.getParameter("page");
        String jspPath;
        String cssFile = "student/student.css";

        if ("learning-path".equals(page)) {
            jspPath = "student/learning-path.jsp";
            cssFile = "student/learning-path.css";
            loadLearningPath(request);
        } else if ("prerequisite".equals(page)) {
            jspPath = "student/prerequisite.jsp";
            cssFile = "student/prerequisite.css";
            loadPrerequisite(request);
        } else {
            jspPath = "student/dashboard.jsp";
        }

        request.setAttribute("contentPage", jspPath);
        request.setAttribute("cssFile", cssFile);
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void loadLearningPath(HttpServletRequest request) {
        String subjectCode = normalizeSubjectCode(request.getParameter("subjectCode"));
        boolean searched = request.getParameter("subjectCode") != null;
        request.setAttribute("subjectCode", subjectCode);
        request.setAttribute("searched", searched);

        if (!searched) {
            request.setAttribute("learningPathResults", Collections.emptyList());
            return;
        }
        if (subjectCode.isEmpty()) {
            request.setAttribute("validationError", "Enter a subject code.");
            request.setAttribute("learningPathResults", Collections.emptyList());
            return;
        }
        if (!subjectCode.matches("[A-Z0-9_-]{1,20}")) {
            request.setAttribute("validationError", "Subject code is invalid.");
            request.setAttribute("learningPathResults", Collections.emptyList());
            return;
        }

        List<StudentLearningPathResult> results
                = learningPathDAO.searchBySubjectCode(subjectCode);
        long publishedSyllabusCount = results.stream()
                .filter(StudentLearningPathResult::isPublishedSyllabusAvailable)
                .count();
        request.setAttribute("learningPathResults", results);
        request.setAttribute("publishedSyllabusCount", publishedSyllabusCount);
    }

    private String normalizeSubjectCode(String value) {
        return value == null ? "" : value.trim().toUpperCase(Locale.ROOT);
    }

    private void loadPrerequisite(HttpServletRequest request) {
        String subjectCode = normalizeSubjectCode(request.getParameter("subjectCode"));
        boolean searched = request.getParameter("subjectCode") != null;
        request.setAttribute("subjectCode", subjectCode);
        request.setAttribute("searched", searched);

        if (!searched) {
            request.setAttribute("prerequisiteResults", Collections.emptyList());
            return;
        }
        if (subjectCode.isEmpty()) {
            request.setAttribute("validationError", "Enter a subject code.");
            request.setAttribute("prerequisiteResults", Collections.emptyList());
            return;
        }
        if (!subjectCode.matches("[A-Z0-9_-]{1,20}")) {
            request.setAttribute("validationError", "Subject code is invalid.");
            request.setAttribute("prerequisiteResults", Collections.emptyList());
            return;
        }

        List<StudentPrerequisiteResult> results
                = prerequisiteDAO.searchBySubjectCode(subjectCode);
        request.setAttribute("prerequisiteResults", results);
        request.setAttribute("publishedSyllabusCount", results.size());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
