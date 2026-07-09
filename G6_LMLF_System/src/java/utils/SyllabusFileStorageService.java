package utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class SyllabusFileStorageService {

    public String saveExcelFile(Part filePart, Long versionId) throws IOException {
        String originalFileName = getSubmittedFileName(filePart);

        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            originalFileName = "syllabus.xlsx";
        }

        String safeFileName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");

        String baseDir = System.getProperty("user.home")
                + File.separator + "lmlf_uploads"
                + File.separator + "syllabus"
                + File.separator + "version_" + versionId;

        File folder = new File(baseDir);

        if (!folder.exists()) {
            folder.mkdirs();
        }

        File savedFile = new File(folder, safeFileName);

        Files.copy(
                filePart.getInputStream(),
                savedFile.toPath(),
                StandardCopyOption.REPLACE_EXISTING
        );

        return savedFile.getAbsolutePath();
    }

    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");

        if (header == null) {
            return null;
        }

        for (String content : header.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 1)
                        .trim()
                        .replace("\"", "");
            }
        }

        return null;
    }
}