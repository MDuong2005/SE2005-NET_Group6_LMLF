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
                case "mapping":
                    viewMappingMatrix(request, response);
                    break;
                case "po":
                    viewPoManagement(request, response);
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
        if (search == null) {
            search = "";
        } else {
            search = search.trim();
        }

        long majorId = parsePositiveLong(request.getParameter("majorId"));
        
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
        
        int totalRecords = curriculumDAO.getTotalActiveCurriculums(search, majorId);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        
        List<Map<String, Object>> curriculums = curriculumDAO.getActiveCurriculums(
                search,
                majorId,
                page,
                pageSize
        );
        
        request.setAttribute("curriculums", curriculums);
        request.setAttribute("majors", curriculumDAO.getActiveCurriculumMajors());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("search", search);
        request.setAttribute("selectedMajorId", majorId);
        
        // Use the user's custom layout
        request.setAttribute("contentPage", "lecturer/curriculum.jsp");
        request.setAttribute("cssFile", "lecturer/lecturer.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private long parsePositiveLong(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0L;
        }
        try {
            long parsed = Long.parseLong(value.trim());
            return parsed > 0 ? parsed : 0L;
        } catch (NumberFormatException e) {
            return 0L;
        }
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

    /**
     * Standalone read-only Subject -> PLO mapping matrix page.
     * Reached from the detail page's "View Mapping subjects" button.
     */
    private void viewMappingMatrix(HttpServletRequest request, HttpServletResponse response)
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

            // Matrix data: subjects grouped by knowledge block (row order like the FPT sheet)
            // + the set of mapped "COURSE|PLO" keys used to tick the cells (read-only).
            java.util.Set<String> matrixKeys = curriculumDAO.getCoursePloMatrix(curriculumId);
            java.util.LinkedHashMap<String, java.util.List<Map<String, Object>>> subjectsByBlock =
                    groupSubjectsByBlock(subjectList);

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("ploList", ploList);
            request.setAttribute("subjectsByBlock", subjectsByBlock);
            request.setAttribute("matrixKeys", matrixKeys);

            request.getRequestDispatcher("/views/lecturer/curriculum/curriculum-mapping.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lecturer/curriculum?error=InvalidID");
        }
    }

    /**
     * Standalone read-only PO Management page: PO list + PLO list + the
     * "Mapping POs to PLOs" matrix. Reached from the detail page's "View PO"
     * button. All data comes straight from the curriculum tables.
     */
    private void viewPoManagement(HttpServletRequest request, HttpServletResponse response)
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

            List<Map<String, Object>> poList = curriculumDAO.getCurriculumPOs(curriculumId);
            List<Map<String, Object>> ploList = curriculumDAO.getCurriculumPLOs(curriculumId);

            // Set of mapped "PLO_CODE|PO_CODE" keys used to tick the matrix cells (read-only).
            java.util.Set<String> ploPoKeys = curriculumDAO.getPloPoMatrix(curriculumId);

            request.setAttribute("curriculum", curriculum);
            request.setAttribute("poList", poList);
            request.setAttribute("ploList", ploList);
            request.setAttribute("ploPoKeys", ploPoKeys);

            request.getRequestDispatcher("/views/lecturer/curriculum/curriculum-po.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lecturer/curriculum?error=InvalidID");
        }
    }

    /**
     * Group subjects by knowledge block in the fixed order used by the official
     * curriculum sheet. Blocks that end up empty are removed; any unknown/blank
     * block is bucketed under "Other" so nothing is silently dropped.
     */
    private java.util.LinkedHashMap<String, java.util.List<Map<String, Object>>> groupSubjectsByBlock(
            List<Map<String, Object>> subjectList) {
        String[] blockOrder = {
            "General knowledge and skills_Khối Kiến thức chung",
            "Major knowledge and skills_Khối kiến thức ngành",
            "Specialized knowledge and skills _Khối kiến thức chuyên ngành",
            "Elective combo knowledge and skills_Khối kiến thức combo lựa chọn"
        };
        java.util.LinkedHashMap<String, java.util.List<Map<String, Object>>> subjectsByBlock =
                new java.util.LinkedHashMap<>();
        for (String b : blockOrder) {
            subjectsByBlock.put(b, new java.util.ArrayList<>());
        }
        for (Map<String, Object> subject : subjectList) {
            Object kb = subject.get("knowledgeBlock");
            String block = (kb == null || kb.toString().trim().isEmpty()) ? "Other" : kb.toString();
            subjectsByBlock.computeIfAbsent(block, k -> new java.util.ArrayList<>()).add(subject);
        }
        subjectsByBlock.values().removeIf(java.util.List::isEmpty);
        return subjectsByBlock;
    }
}
