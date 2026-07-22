package controller;

import dao.AcademicSyllabusDAO;
import dao.SyllabusVersionDAO;
import model.SyllabusEditorData;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
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
        String versionIdParam = request.getParameter("versionId");
        HttpSession session = request.getSession();

        if (!"publish".equals(action) && !"archive".equals(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action");
            return;
        }

        try {
            long syllabusId = Long.parseLong(idParam);
            Long requestedVersionId = versionIdParam == null || versionIdParam.isBlank()
                    ? null : Long.parseLong(versionIdParam);
            Map<String, Object> syllabus = syllabusDAO.getSyllabusDetail(syllabusId, requestedVersionId);

            if (syllabus == null || syllabus.isEmpty()) {
                session.setAttribute("syllabusError", "Syllabus not found.");
            } else if ("archive".equals(action)) {
                if (!"PUBLISHED".equalsIgnoreCase(String.valueOf(syllabus.get("status")))) {
                    session.setAttribute("syllabusError",
                            "Only a PUBLISHED syllabus can be archived. Current status: "
                            + syllabus.get("status") + ".");
                } else if (syllabusVersionDAO.archiveCurrentPublishedVersion(syllabusId)) {
                    session.setAttribute("syllabusSuccess", "Syllabus archived successfully.");
                } else {
                    session.setAttribute("syllabusError",
                            "Unable to archive this syllabus. Its status may no longer be PUBLISHED.");
                }
            } else if (!"APPROVED".equalsIgnoreCase(String.valueOf(syllabus.get("status")))
                    && !"ARCHIVED".equalsIgnoreCase(String.valueOf(syllabus.get("status")))) {
                session.setAttribute("syllabusError",
                        "Only a syllabus with APPROVED or ARCHIVED status can be published. Current status: "
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
                    + "/academic/syllabus?action=detail&id=" + syllabusId
                    + (requestedVersionId == null ? "" : "&versionId=" + requestedVersionId));
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
                case "clo-plo-mapping":
                    viewCloPloMapping(request, response);
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
        String status = request.getParameter("status");
        if (status == null) status = "";
        
        int page = 1;
        int pageSize = 5;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int totalRecords = syllabusDAO.getTotalSyllabuses(search, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        
        List<Map<String, Object>> syllabuses = syllabusDAO.getSyllabuses(search, status, page, pageSize);
        int pageStart = syllabuses.isEmpty() ? 0 : (page - 1) * pageSize + 1;
        int pageEnd = syllabuses.isEmpty() ? 0 : pageStart + syllabuses.size() - 1;
        
        request.setAttribute("syllabuses", syllabuses);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageStart", pageStart);
        request.setAttribute("pageEnd", pageEnd);
        request.setAttribute("search", search);
        request.setAttribute("statusFilter", status);
        
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
            String versionIdParam = request.getParameter("versionId");
            Long requestedVersionId = versionIdParam == null || versionIdParam.isBlank()
                    ? null : Long.parseLong(versionIdParam);
            Map<String, Object> syllabus = syllabusDAO.getSyllabusDetail(syllabusId, requestedVersionId);
            
            if (syllabus == null || syllabus.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/academic/syllabus?error=NotFound");
                return;
            }
            
            if (syllabus.get("versionId") != null) {
                long versionId = (Long) syllabus.get("versionId");
                SyllabusEditorData syllabusData = syllabusDAO.getCompleteSyllabusData(versionId);
                request.setAttribute("syllabusData", syllabusData);
            }
            
            request.setAttribute("syllabus", syllabus);

            HttpSession session = request.getSession(false);
            if (session != null) {
                request.setAttribute("syllabusSuccess", session.getAttribute("syllabusSuccess"));
                request.setAttribute("syllabusError", session.getAttribute("syllabusError"));
                session.removeAttribute("syllabusSuccess");
                session.removeAttribute("syllabusError");
            }
            
            // The lecturer detail screen is a standalone page. Forward the
            // academic detail directly as well so both screens share the same
            // header, page width and table layout instead of nesting this one
            // inside the dashboard shell.
            request.getRequestDispatcher("/views/academic/syllabus-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/academic/syllabus?error=InvalidID");
        } catch (SQLException e) {
            throw new ServletException("Unable to load complete syllabus details.", e);
        }
    }

    private void viewCloPloMapping(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath()
                    + "/academic/syllabus?error=InvalidID");
            return;
        }

        try {
            long syllabusId = Long.parseLong(idParam);
            String versionIdParam = request.getParameter("versionId");
            Long requestedVersionId = versionIdParam == null || versionIdParam.isBlank()
                    ? null : Long.parseLong(versionIdParam);
            Map<String, Object> syllabus
                    = syllabusDAO.getSyllabusDetail(syllabusId, requestedVersionId);

            if (syllabus == null || syllabus.isEmpty()
                    || syllabus.get("versionId") == null) {
                response.sendRedirect(request.getContextPath()
                        + "/academic/syllabus?error=NotFound");
                return;
            }

            long versionId = ((Number) syllabus.get("versionId")).longValue();
            SyllabusEditorData syllabusData
                    = syllabusDAO.getCompleteSyllabusData(versionId);
            request.setAttribute("syllabus", syllabus);
            request.setAttribute("syllabusData", syllabusData);
            request.getRequestDispatcher(
                    "/views/academic/syllabus-clo-plo-mapping.jsp"
            ).forward(request, response);
        } catch (NumberFormatException exception) {
            response.sendRedirect(request.getContextPath()
                    + "/academic/syllabus?error=InvalidID");
        } catch (SQLException exception) {
            throw new ServletException(
                    "Unable to load Academic CLO-PLO mapping details.",
                    exception
            );
        }
    }
}
