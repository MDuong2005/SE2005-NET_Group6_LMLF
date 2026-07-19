package controller;

import com.google.gson.Gson;
import constant.RoleConstants;
import dao.DesignerDAO;
import dao.DesignerSyllabusEditorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DesignerTask;
import model.SyllabusEditorData;
import model.User;
import service.SyllabusExcelImportService;
import utils.SessionUtil;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet(name="DesignerSyllabusEditorServlet", urlPatterns={"/designer/editor", "/designer/editor/import", "/designer/editor/save", "/designer/editor/submit"})
@MultipartConfig(fileSizeThreshold=1024*1024, maxFileSize=20L*1024L*1024L, maxRequestSize=25L*1024L*1024L)
public class DesignerSyllabusEditorServlet extends HttpServlet {
    private static final Path UPLOAD_DIR = Paths.get(System.getProperty("user.home"), "lmlf_uploads", "designer_imports");
    private final DesignerDAO designerDAO = new DesignerDAO();
    private final DesignerSyllabusEditorDAO editorDAO = new DesignerSyllabusEditorDAO();
    private final SyllabusExcelImportService importService = new SyllabusExcelImportService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = requireDesigner(request, response); if (user == null) return;
        long assignmentId = parseLong(request.getParameter("assignmentId"));
        if (assignmentId <= 0) { response.sendRedirect(request.getContextPath()+"/designer/tasks?error=missing_assignment"); return; }
        try {
            DesignerTask task = designerDAO.getTaskDetail(assignmentId, user.getUserId());
            if (task == null) { response.sendError(404, "Assignment not found."); return; }
            if (!task.isUploadAllowed()) { response.sendError(403, "This assignment cannot be edited."); return; }
            long versionId = editorDAO.getOrCreateDraftVersion(assignmentId, user.getUserId());
            SyllabusEditorData data = editorDAO.load(versionId, user.getUserId());
            request.setAttribute("task", task);
            request.setAttribute("versionId", versionId);
            request.setAttribute("editorJson", gson.toJson(data));
            request.getRequestDispatcher("/views/designer/syllabus/editor.jsp").forward(request, response);
        } catch (SQLException e) { throw new ServletException("Cannot open syllabus editor.", e); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = requireDesigner(request, response); if (user == null) return;
        String path = request.getServletPath();
        try {
if ("/designer/editor/import".equals(path)) importExcel(request, response, user);
            else if ("/designer/editor/save".equals(path)) saveDraft(request, response, user);
            else if ("/designer/editor/submit".equals(path)) submit(request, response, user);
            else response.sendError(405);
        } catch (SQLException e) {
            request.getSession().setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath()+"/designer/editor?assignmentId="+parseLong(request.getParameter("assignmentId")));
        }
    }

    private void importExcel(HttpServletRequest request, HttpServletResponse response, User user) throws SQLException, IOException, ServletException {
        long assignmentId=parseLong(request.getParameter("assignmentId")); long versionId=parseLong(request.getParameter("versionId"));
        Part part=request.getPart("syllabusFile");
        if(part==null||part.getSize()==0) throw new SQLException("Please select an Excel file.");
        String original=Paths.get(part.getSubmittedFileName()).getFileName().toString();
        if(!original.toLowerCase().endsWith(".xlsx")) throw new SQLException("Only .xlsx files are supported by the structured importer.");
        Files.createDirectories(UPLOAD_DIR);
        Path stored=UPLOAD_DIR.resolve("assignment_"+assignmentId+"_"+UUID.randomUUID()+".xlsx");
        Files.copy(part.getInputStream(),stored,StandardCopyOption.REPLACE_EXISTING);
        Long fileId=null;
        try(InputStream in=Files.newInputStream(stored)){
            SyllabusEditorData imported=importService.parse(in);
            editorDAO.saveImportedDraft(
                    assignmentId,
                    versionId,
                    user.getUserId(),
                    imported
            );
            fileId=editorDAO.saveImportedFile(assignmentId,versionId,user.getUserId(),original,stored.toAbsolutePath().toString(),part.getSize(),part.getContentType());
            editorDAO.logImport(assignmentId,versionId,fileId,user.getUserId(),"SUCCESS",7,0,0,null);
            request.getSession().setAttribute(
                    "successMessage",
                    "Academic Office template imported successfully. "
                    + "Academic Information is now locked for manual web editing."
            );
        }catch(Exception e){
            editorDAO.logImport(assignmentId,versionId,fileId,user.getUserId(),"FAILED",0,0,7,e.getMessage());
            Files.deleteIfExists(stored);
            if(e instanceof SQLException) throw (SQLException)e;
            throw new ServletException("Cannot parse Excel file.",e);
        }
        response.sendRedirect(request.getContextPath()+"/designer/editor?assignmentId="+assignmentId);
    }

    private void saveDraft(HttpServletRequest request,HttpServletResponse response,User user)throws SQLException,IOException{
        long assignmentId=parseLong(request.getParameter("assignmentId")); long versionId=parseLong(request.getParameter("versionId"));
        SyllabusEditorData data=parseData(request.getParameter("editorJson"));
        editorDAO.saveDraft(assignmentId,versionId,user.getUserId(),data);
request.getSession().setAttribute("successMessage","Draft saved successfully.");
        response.sendRedirect(request.getContextPath()+"/designer/editor?assignmentId="+assignmentId);
    }

    private void submit(HttpServletRequest request,HttpServletResponse response,User user)throws SQLException,IOException{
        long assignmentId=parseLong(request.getParameter("assignmentId")); long versionId=parseLong(request.getParameter("versionId"));
        SyllabusEditorData data=parseData(request.getParameter("editorJson"));
        editorDAO.submit(assignmentId,versionId,user.getUserId(),data,request.getParameter("description"));
        request.getSession().setAttribute("successMessage","Syllabus submitted for review successfully.");
        response.sendRedirect(request.getContextPath()+"/designer/tasks?status=submitted");
    }

    private SyllabusEditorData parseData(String json)throws SQLException{
        if(json==null||json.isBlank())throw new SQLException("Editor data is missing.");
        try{return gson.fromJson(json,SyllabusEditorData.class);}catch(Exception e){throw new SQLException("Editor data is invalid.",e);}
    }

    private User requireDesigner(HttpServletRequest request,HttpServletResponse response)throws IOException,ServletException{
        User user=SessionUtil.getCurrentUser(request);
        if(user==null){response.sendRedirect(request.getContextPath()+"/login");return null;}
        if(!user.hasRole(RoleConstants.DESIGNER)){response.setStatus(403);request.getRequestDispatcher("/views/error/403.jsp").forward(request,response);return null;}
        return user;
    }
    private long parseLong(String s){try{return Long.parseLong(s);}catch(Exception e){return -1;}}
}