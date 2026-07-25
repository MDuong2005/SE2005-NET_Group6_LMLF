package controller;

import dao.LecturerMaterialDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import model.LecturerMaterial;
import model.User;
import utils.EmailUtil;
import utils.SessionUtil;

@WebServlet(name = "LecturerMaterialServlet", urlPatterns = {"/lecturer/materials"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 50,       // 50MB
    maxRequestSize = 1024 * 1024 * 100    // 100MB
)
public class LecturerMaterialServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "C:\\LMLF_Uploads\\";

    @Override
    public void init() throws ServletException {
        // Create upload directory if it doesn't exist
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = SessionUtil.getCurrentUser(request);
        if (user == null || !"ACTIVE".equals(user.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LecturerMaterialDAO dao = new LecturerMaterialDAO();
        
        String tab = request.getParameter("tab");
        if (!"shared".equals(tab)) {
            tab = "my";
        }

        String search = request.getParameter("search");
        search = search == null ? "" : search.trim();

        String category = request.getParameter("category");
        category = category == null ? "" : category.trim();
        
        if ("shared".equals(tab)) {
            List<LecturerMaterial> sharedList = dao.getSharedWithMe(
                    user.getEmail(),
                    search,
                    category
            );
            request.setAttribute("materialList", sharedList);
        } else {
            List<LecturerMaterial> myList = dao.getMyMaterials(
                    user.getUserId(),
                    search,
                    category
            );
            request.setAttribute("materialList", myList);
        }
        
        request.setAttribute("activeTab", tab);
        request.setAttribute("search", search);
        request.setAttribute("selectedCategory", category);
        request.setAttribute(
                "availableCategories",
                dao.getAvailableCategories(
                        user.getUserId(),
                        user.getEmail(),
                        "shared".equals(tab)
                )
        );
        request.setAttribute(
                "availableCourses",
                dao.getAvailableCourses()
        );
        
        request.setAttribute("contentPage", "lecturer/materials.jsp");
        request.setAttribute("cssFile", "lecturer/lecturer.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = SessionUtil.getCurrentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        LecturerMaterialDAO dao = new LecturerMaterialDAO();

        try {
            if ("upload".equals(action)) {
                handleUpload(request, user, dao);
            } else if ("share".equals(action)) {
                handleShare(request, user, dao);
            } else if ("delete".equals(action)) {
                handleDelete(request, user, dao);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/lecturer/materials");
    }

    private void handleUpload(HttpServletRequest request, User user, LecturerMaterialDAO dao) throws Exception {
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String materialType = request.getParameter("materialType"); // "FILE" or "LINK"

        long courseId;
        try {
            courseId = Long.parseLong(
                    request.getParameter("courseId")
            );
        } catch (NumberFormatException exception) {
            throw new Exception("A valid course is required.");
        }

        if (!dao.courseExists(courseId)) {
            throw new Exception("The selected course does not exist.");
        }
        
        LecturerMaterial material = new LecturerMaterial();
        material.setCourseId(courseId);
        material.setLecturerId(user.getUserId());
        material.setTitle(title);
        material.setCategory(category);
        material.setMaterialType(materialType);

        if ("FILE".equals(materialType)) {
            Part filePart = request.getPart("fileUpload");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                // Clean filename to prevent issues
                fileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
                File file = new File(UPLOAD_DIR, fileName);
                
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                
                // Save the absolute path or a mapped URL. For local serving, we can just save the absolute path 
                // and create a download servlet later, or if it's served via Tomcat, a relative path.
                // For this project, we'll save the absolute path and assume a DownloadServlet will serve it.
                material.setFileUrl(file.getAbsolutePath());
            } else {
                throw new Exception("File is required for FILE material type.");
            }
        } else if ("LINK".equals(materialType)) {
            String linkUrl = request.getParameter("linkUrl");
            if (linkUrl == null || linkUrl.trim().isEmpty()) {
                throw new Exception("URL is required for LINK material type.");
            }
            material.setFileUrl(linkUrl.trim());
        }

        dao.addMaterial(material);
        request.getSession().setAttribute("successMsg", "Material uploaded successfully!");
    }

    private void handleShare(HttpServletRequest request, User user, LecturerMaterialDAO dao) throws Exception {
        long materialId = Long.parseLong(request.getParameter("materialId"));
        String requestedEmail = request.getParameter("shareEmail");
        String shareEmail = dao.findLecturerEmail(requestedEmail);

        if (shareEmail == null) {
            request.getSession().setAttribute(
                    "errorMsg",
                    "Cannot share material. The user "
                    + requestedEmail
                    + " is not a Lecturer."
            );
            return;
        }
        
        // Ownership is enforced inside the DAO: the share only succeeds when the
        // material belongs to the current lecturer, so another lecturer's
        // materialId cannot be shared by tampering with the request.
        boolean success = dao.shareMaterial(materialId, shareEmail, user.getUserId());
        if (success) {
            String materialTitle = request.getParameter("materialTitle");
            String materialType = request.getParameter("materialType");
            EmailUtil.sendMaterialShareNotification(shareEmail, user.getEmail(), materialTitle, materialType);
            request.getSession().setAttribute("successMsg", "Material shared successfully with " + shareEmail);
        } else {
            request.getSession().setAttribute("errorMsg", "Cannot share this material. It may not belong to you or it was already shared.");
        }
    }
    
    private void handleDelete(HttpServletRequest request, User user, LecturerMaterialDAO dao) throws Exception {
        long materialId = Long.parseLong(request.getParameter("materialId"));
        dao.deleteMaterial(materialId, user.getUserId());
        request.getSession().setAttribute("successMsg", "Material deleted successfully.");
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
