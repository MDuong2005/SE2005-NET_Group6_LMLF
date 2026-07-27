package controller;

import dao.StudentSyllabusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import model.SyllabusEditorData;
import model.User;
import utils.SessionUtil;


@WebServlet(name = "StudentSyllabusServlet", urlPatterns = {"/student/syllabus"})
public class StudentSyllabusServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private StudentSyllabusDAO syllabusDAO;

    @Override
    public void init() {
        syllabusDAO = new StudentSyllabusDAO();
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
            case "clo-plo-mapping" -> showCloPloMapping(request, response);
            default -> response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action.");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = normalize(request.getParameter("search"));
        int page = positiveInt(request.getParameter("page"), 1);
        int totalRecords = syllabusDAO.countPublishedSyllabuses(search);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalRecords / PAGE_SIZE));
        page = Math.min(page, totalPages);

        request.setAttribute(
                "syllabuses",
                syllabusDAO.findPublishedSyllabuses(search, page, PAGE_SIZE)
        );
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("contentPage", "student/syllabus/list.jsp");
        request.setAttribute("cssFile", "student/catalog.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long syllabusId = requiredId(request, response);
        if (syllabusId < 1) {
            return;
        }
        Map<String, Object> syllabus = syllabusDAO.findPublishedSyllabus(syllabusId);
        if (syllabus == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Published syllabus not found.");
            return;
        }

        try {
            long versionId = ((Number) syllabus.get("versionId")).longValue();
            request.setAttribute("syllabus", syllabus);
            request.setAttribute(
                    "syllabusData",
                    syllabusDAO.findPublishedSyllabusData(versionId)
            );
            request.getRequestDispatcher("/views/student/syllabus/detail.jsp")
                    .forward(request, response);
        } catch (SQLException exception) {
            throw new ServletException("Unable to load published syllabus details.", exception);
        }
    }

    private void showCloPloMapping(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long syllabusId = requiredId(request, response);
        if (syllabusId < 1) {
            return;
        }
        Map<String, Object> syllabus = syllabusDAO.findPublishedSyllabus(syllabusId);
        if (syllabus == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Published syllabus not found.");
            return;
        }

        try {
            long versionId = ((Number) syllabus.get("versionId")).longValue();
            SyllabusEditorData data = syllabusDAO.findPublishedSyllabusData(versionId);
            request.setAttribute("syllabus", syllabus);
            request.setAttribute("syllabusData", data);
            request.getRequestDispatcher("/views/student/syllabus/clo-plo-mapping.jsp")
                    .forward(request, response);
        } catch (SQLException exception) {
            throw new ServletException("Unable to load published CLO-PLO mapping.", exception);
        }
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid syllabus id.");
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
