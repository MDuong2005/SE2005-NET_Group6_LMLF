package controller;

import dao.StudentCurriculumDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.User;
import utils.SessionUtil;

/** Student-owned, read-only curriculum browser. */
@WebServlet(name = "StudentCurriculumServlet", urlPatterns = {"/student/curriculum"})
public class StudentCurriculumServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private StudentCurriculumDAO curriculumDAO;

    @Override
    public void init() {
        curriculumDAO = new StudentCurriculumDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireStudent(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isBlank() || "list".equals(action)) {
            showList(request, response);
            return;
        }

        switch (action) {
            case "detail" -> showDetail(request, response);
            case "mapping" -> showMapping(request, response);
            case "po" -> showProgramOutcomes(request, response);
            default -> response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action.");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = normalize(request.getParameter("search"));
        int page = positiveInt(request.getParameter("page"), 1);
        int totalRecords = curriculumDAO.countVisibleCurriculums(search);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalRecords / PAGE_SIZE));
        page = Math.min(page, totalPages);

        request.setAttribute(
                "curriculums",
                curriculumDAO.findVisibleCurriculums(search, page, PAGE_SIZE)
        );
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("contentPage", "student/curriculum/list.jsp");
        request.setAttribute("cssFile", "student/catalog.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long curriculumId = requiredId(request, response);
        if (curriculumId < 1) {
            return;
        }
        Map<String, Object> curriculum = curriculumDAO.findVisibleCurriculum(curriculumId);
        if (curriculum == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Active curriculum not found.");
            return;
        }

        request.setAttribute("curriculum", curriculum);
        request.setAttribute("ploList", curriculumDAO.findPlos(curriculumId));
        request.setAttribute("subjectList", curriculumDAO.findSubjects(curriculumId));
        request.getRequestDispatcher("/views/student/curriculum/detail.jsp")
                .forward(request, response);
    }

    private void showMapping(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long curriculumId = requiredId(request, response);
        if (curriculumId < 1) {
            return;
        }
        Map<String, Object> curriculum = curriculumDAO.findVisibleCurriculum(curriculumId);
        if (curriculum == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Active curriculum not found.");
            return;
        }

        List<Map<String, Object>> subjects = curriculumDAO.findSubjects(curriculumId);
        LinkedHashMap<String, List<Map<String, Object>>> subjectsByBlock
                = new LinkedHashMap<>();
        for (Map<String, Object> subject : subjects) {
            Object value = subject.get("knowledgeBlock");
            String block = value == null || value.toString().isBlank()
                    ? "Other"
                    : value.toString();
            subjectsByBlock.computeIfAbsent(block, key -> new java.util.ArrayList<>())
                    .add(subject);
        }

        request.setAttribute("curriculum", curriculum);
        request.setAttribute("ploList", curriculumDAO.findPlos(curriculumId));
        request.setAttribute("subjectsByBlock", subjectsByBlock);
        request.setAttribute("matrixKeys", curriculumDAO.findCoursePloMappings(curriculumId));
        request.getRequestDispatcher("/views/student/curriculum/mapping.jsp")
                .forward(request, response);
    }

    private void showProgramOutcomes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long curriculumId = requiredId(request, response);
        if (curriculumId < 1) {
            return;
        }
        Map<String, Object> curriculum = curriculumDAO.findVisibleCurriculum(curriculumId);
        if (curriculum == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Active curriculum not found.");
            return;
        }

        request.setAttribute("curriculum", curriculum);
        request.setAttribute("poList", curriculumDAO.findPos(curriculumId));
        request.setAttribute("ploList", curriculumDAO.findPlos(curriculumId));
        request.setAttribute("ploPoKeys", curriculumDAO.findPloPoMappings(curriculumId));
        request.getRequestDispatcher("/views/student/curriculum/po.jsp")
                .forward(request, response);
    }

    private boolean requireStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = SessionUtil.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!user.hasRole("STUDENT")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Student access required.");
            return false;
        }
        return true;
    }

    private long requiredId(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            long id = Long.parseLong(normalize(request.getParameter("id")));
            if (id < 1) {
                throw new NumberFormatException();
            }
            return id;
        } catch (NumberFormatException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid curriculum id.");
            return -1;
        }
    }

    private int positiveInt(String value, int fallback) {
        try {
            int parsed = Integer.parseInt(normalize(value));
            return parsed > 0 ? parsed : fallback;
        } catch (NumberFormatException exception) {
            return fallback;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
