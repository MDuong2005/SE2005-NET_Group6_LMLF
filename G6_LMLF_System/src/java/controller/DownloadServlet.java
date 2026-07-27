package controller;

import dao.LecturerMaterialDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import model.LecturerMaterial;
import utils.SessionUtil;

@WebServlet(name = "DownloadServlet", urlPatterns = {"/download"})
public class DownloadServlet extends HttpServlet {

    private final LecturerMaterialDAO materialDAO = new LecturerMaterialDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        String pathParam = request.getParameter("path");

        File fileToDownload = null;
        String displayFileName = null;

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                long materialId = Long.parseLong(idParam.trim());
                LecturerMaterial material = materialDAO.getMaterialById(materialId);
                if (material != null && material.getFileUrl() != null) {
                    fileToDownload = new File(material.getFileUrl());
                    displayFileName = fileToDownload.getName();
                }
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }

        if (fileToDownload == null && pathParam != null && !pathParam.trim().isEmpty()) {
            String decodedPath = URLDecoder.decode(pathParam, StandardCharsets.UTF_8);
            fileToDownload = new File(decodedPath);
            displayFileName = fileToDownload.getName();
        }

        if (fileToDownload == null || !fileToDownload.exists() || !fileToDownload.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found or unreadable.");
            return;
        }

        // Clean output filename (remove timestamp prefix if present)
        if (displayFileName != null && displayFileName.contains("_")) {
            displayFileName = displayFileName.substring(displayFileName.indexOf("_") + 1);
        }

        String mimeType = getServletContext().getMimeType(fileToDownload.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        response.setContentLengthLong(fileToDownload.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + displayFileName + "\"");

        try (FileInputStream inStream = new FileInputStream(fileToDownload);
             OutputStream outStream = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
            outStream.flush();
        }
    }
}
