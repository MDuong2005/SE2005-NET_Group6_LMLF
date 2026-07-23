package controller;

import dao.StudentCurriculumDAO;
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

/**
 * Public, unauthenticated catalog for Guest visitors.
 *
 * A Guest has no account and no role. This servlet only ever reads, and it
 * reuses the Student DAOs whose queries already enforce the public visibility
 * rules (curriculum: active + not deleted; syllabus: PUBLISHED). Only doGet is
 * implemented, so any POST returns 405. It never touches /student, /lecturer or
 * /admin routes and never creates a session.
 */
@WebServlet(
    name = "GuestCatalogServlet",
    urlPatterns = {
        "/guest",
        "/guest/curriculum",
        "/guest/syllabus"
    }
)
public class GuestCatalogServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private StudentCurriculumDAO curriculumDAO;
    private StudentSyllabusDAO syllabusDAO;

    @Override
    public void init() {
        curriculumDAO = new StudentCurriculumDAO();
        syllabusDAO = new StudentSyllabusDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        switch (path) {
            case "/guest" -> showHome(request, response);
            case "/guest/curriculum" -> handleCurriculum(request, response);
            case "/guest/syllabus" -> handleSyllabus(request, response);
            default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ---------------------------------------------------------------- home

    private void showHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/guest/home.jsp").forward(request, response);
    }

    // ---------------------------------------------------------- curriculum

    private void handleCurriculum(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = normalize(request.getParameter("id"));
        if (idParam.isEmpty()) {
            listCurriculums(request, response);
        } else {
            curriculumDetail(request, response);
        }
    }

    private void listCurriculums(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = normalize(request.getParameter("search"));
        int page = positiveInt(request.getParameter("page"), 1);
        int totalRecords = curriculumDAO.countVisibleCurriculums(search);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalRecords / PAGE_SIZE));
        page = Math.min(page, totalPages);

        request.setAttribute("catalogType", "curriculum");
        request.setAttribute("items", curriculumDAO.findVisibleCurriculums(search, page, PAGE_SIZE));
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/views/guest/catalog.jsp").forward(request, response);
    }

    private void curriculumDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long id = requiredId(request, response);
        if (id < 1) {
            return;
        }
        Map<String, Object> curriculum = curriculumDAO.findVisibleCurriculum(id);
        if (curriculum == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Active curriculum not found.");
            return;
        }
        request.setAttribute("detailType", "curriculum");
        request.setAttribute("curriculum", curriculum);
        request.setAttribute("ploList", curriculumDAO.findPlos(id));
        request.setAttribute("subjectList", curriculumDAO.findSubjects(id));
        request.getRequestDispatcher("/views/guest/detail.jsp").forward(request, response);
    }

    // ------------------------------------------------------------ syllabus

    private void handleSyllabus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = normalize(request.getParameter("id"));
        if (idParam.isEmpty()) {
            listSyllabuses(request, response);
        } else {
            syllabusDetail(request, response);
        }
    }

    private void listSyllabuses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = normalize(request.getParameter("search"));
        int page = positiveInt(request.getParameter("page"), 1);
        int totalRecords = syllabusDAO.countPublishedSyllabuses(search);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalRecords / PAGE_SIZE));
        page = Math.min(page, totalPages);

        request.setAttribute("catalogType", "syllabus");
        request.setAttribute("items", syllabusDAO.findPublishedSyllabuses(search, page, PAGE_SIZE));
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/views/guest/catalog.jsp").forward(request, response);
    }

    private void syllabusDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        long id = requiredId(request, response);
        if (id < 1) {
            return;
        }
        Map<String, Object> syllabus = syllabusDAO.findPublishedSyllabus(id);
        if (syllabus == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Published syllabus not found.");
            return;
        }
        try {
            // The published version id is taken from the DAO result, never from
            // the request, so a Guest cannot point the detail at a draft version.
            long versionId = ((Number) syllabus.get("versionId")).longValue();
            request.setAttribute("detailType", "syllabus");
            request.setAttribute("syllabus", syllabus);
            SyllabusEditorData syllabusData = syllabusDAO.findPublishedSyllabusData(versionId);
            request.setAttribute("syllabusData", syllabusData);
            request.getRequestDispatcher("/views/guest/detail.jsp").forward(request, response);
        } catch (SQLException exception) {
            throw new ServletException("Unable to load the published syllabus.", exception);
        }
    }

    // ------------------------------------------------------------- helpers

    private long requiredId(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            long id = Long.parseLong(normalize(request.getParameter("id")));
            if (id < 1) {
                throw new NumberFormatException();
            }
            return id;
        } catch (NumberFormatException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id.");
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
