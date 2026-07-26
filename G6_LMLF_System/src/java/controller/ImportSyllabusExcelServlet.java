package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import utils.ImportExcle;

@WebServlet(name = "ImportSyllabusExcelServlet", urlPatterns = {"/syllabus/import-excel"})
@MultipartConfig
public class ImportSyllabusExcelServlet extends HttpServlet {

    private ImportExcle importService;

    @Override
    public void init() {
        importService = new ImportExcle();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/review/import-excel.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String versionIdRaw = request.getParameter("versionId");

        if (versionIdRaw == null || versionIdRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/syllabus/import-excel?error=missing_version");
            return;
        }

        try {
            Long versionId = Long.parseLong(versionIdRaw);

            Part filePart = request.getPart("excelFile");

            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath()
                        + "/syllabus/import-excel?versionId=" + versionId
                        + "&error=missing_file");
                return;
            }

            try (InputStream inputStream = filePart.getInputStream()) {
                int importedCount = importService.importExcelToVersion(inputStream, versionId);

                response.sendRedirect(request.getContextPath()
                        + "/review?action=evaluate&versionId=" + versionId
                        + "&imported=" + importedCount);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/syllabus/import-excel?error=invalid_version");
        }
    }
}