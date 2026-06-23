package controller;

import dao.SyllabusVersionDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "VersionHistoryServlet", urlPatterns = {"/version-history"})
public class VersionHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String syllabusIdRaw = request.getParameter("syllabusId");

            if (syllabusIdRaw == null || syllabusIdRaw.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Missing syllabus ID.");
                request.getRequestDispatcher("/views/version-history.jsp")
                        .forward(request, response);
                return;
            }

            long syllabusId = Long.parseLong(syllabusIdRaw);

            SyllabusVersionDAO dao = new SyllabusVersionDAO();
            List<Map<String, Object>> versionHistory =
                    dao.getVersionHistory(syllabusId);

            request.setAttribute("versionHistory", versionHistory);
            request.setAttribute("syllabusId", syllabusId);

            request.getRequestDispatcher("/views/version-history.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Cannot load version history.");
            request.getRequestDispatcher("/views/version-history.jsp")
                    .forward(request, response);
        }
    }
}