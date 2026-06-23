package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Course;
import dao.CourseDAO;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/course")
public class CourseServlet extends HttpServlet {
    
    private CourseDAO courseDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        String keyword = req.getParameter("keyword");
        
        // Nếu có action=edit, lấy course để edit
        if ("edit".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr);
                    Course course = courseDAO.getById(id);
                    req.setAttribute("course", course);
                    req.setAttribute("action", "edit");
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "Invalid course ID");
                }
            }
        }
        
        // Lấy danh sách courses
        List<Course> courseList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            courseList = courseDAO.search(keyword.trim());
            req.setAttribute("keyword", keyword);
        } else {
            courseList = courseDAO.listAll();
        }
        
        req.setAttribute("courseList", courseList);
        req.getRequestDispatcher("/views/curriculum/course.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String action = req.getParameter("action");
        
        if ("create".equals(action)) {
            handleCreate(req, resp);
        } else if ("edit".equals(action)) {
            handleEdit(req, resp);
        } else if ("delete".equals(action)) {
            handleDelete(req, resp);
        } else {
            // Mặc định quay về danh sách
            resp.sendRedirect(req.getContextPath() + "/course");
        }
    }
    
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String code = req.getParameter("code");
        String name = req.getParameter("name");
        String creditsStr = req.getParameter("credits");
        
        // Lưu lại giá trị để hiển thị khi có lỗi
        req.setAttribute("code", code);
        req.setAttribute("name", name);
        req.setAttribute("credits", creditsStr);
        req.setAttribute("action", "create");
        
        // Validate
        if (code == null || code.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Mã môn học không được để trống");
            forwardToCourseList(req, resp);
            return;
        }
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Tên môn học không được để trống");
            forwardToCourseList(req, resp);
            return;
        }
        if (creditsStr == null || creditsStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Số tín chỉ không được để trống");
            forwardToCourseList(req, resp);
            return;
        }
        
        try {
            Integer credits = Integer.parseInt(creditsStr.trim());
            if (credits <= 0) {
                req.setAttribute("errorMessage", "Số tín chỉ phải lớn hơn 0");
                forwardToCourseList(req, resp);
                return;
            }
            
            // Kiểm tra trùng mã
            if (courseDAO.isCodeExists(code.trim())) {
                req.setAttribute("errorMessage", "Mã môn học '" + code.trim() + "' đã tồn tại trong hệ thống");
                forwardToCourseList(req, resp);
                return;
            }
            
            // Tạo mới
            Course course = new Course();
            course.setCode(code.trim().toUpperCase());
            course.setName(name.trim());
            course.setCredits(credits);
            course.setCreatedAt(LocalDateTime.now());
            
            boolean result = courseDAO.create(course);
            
            if (result) {
                // Thành công -> quay về danh sách với thông báo thành công
                req.getSession().setAttribute("successMessage", "Thêm môn học '" + code.trim() + "' thành công!");
                resp.sendRedirect(req.getContextPath() + "/course");
            } else {
                req.setAttribute("errorMessage", "Lỗi khi thêm môn học. Vui lòng thử lại!");
                forwardToCourseList(req, resp);
            }
            
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Số tín chỉ không hợp lệ");
            forwardToCourseList(req, resp);
        }
    }
    
    private void handleEdit(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String idStr = req.getParameter("courseId");
        String code = req.getParameter("code");
        String name = req.getParameter("name");
        String creditsStr = req.getParameter("credits");
        
        req.setAttribute("action", "edit");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "ID môn học không hợp lệ");
            forwardToCourseList(req, resp);
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr.trim());
            Course existing = courseDAO.getById(id);
            
            if (existing == null) {
                req.setAttribute("errorMessage", "Không tìm thấy môn học");
                forwardToCourseList(req, resp);
                return;
            }
            
            req.setAttribute("course", existing);
            
            // Validate
            if (code == null || code.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Mã môn học không được để trống");
                forwardToCourseList(req, resp);
                return;
            }
            if (name == null || name.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Tên môn học không được để trống");
                forwardToCourseList(req, resp);
                return;
            }
            if (creditsStr == null || creditsStr.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Số tín chỉ không được để trống");
                forwardToCourseList(req, resp);
                return;
            }
            
            Integer credits = Integer.parseInt(creditsStr.trim());
            if (credits <= 0) {
                req.setAttribute("errorMessage", "Số tín chỉ phải lớn hơn 0");
                forwardToCourseList(req, resp);
                return;
            }
            
            // Kiểm tra trùng mã (trừ chính nó)
            if (!existing.getCode().equals(code.trim()) && courseDAO.isCodeExists(code.trim(), id)) {
                req.setAttribute("errorMessage", "Mã môn học '" + code.trim() + "' đã tồn tại trong hệ thống");
                forwardToCourseList(req, resp);
                return;
            }
            
            // Cập nhật
            existing.setCode(code.trim().toUpperCase());
            existing.setName(name.trim());
            existing.setCredits(credits);
            
            boolean result = courseDAO.update(existing);
            
            if (result) {
                req.getSession().setAttribute("successMessage", "Cập nhật môn học '" + code.trim() + "' thành công!");
                resp.sendRedirect(req.getContextPath() + "/course");
            } else {
                req.setAttribute("errorMessage", "Lỗi khi cập nhật môn học");
                forwardToCourseList(req, resp);
            }
            
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "ID hoặc số tín chỉ không hợp lệ");
            forwardToCourseList(req, resp);
        }
    }
    
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String idStr = req.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "ID môn học không hợp lệ");
            forwardToCourseList(req, resp);
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr.trim());
            Course existing = courseDAO.getById(id);
            
            if (existing == null) {
                req.setAttribute("errorMessage", "Không tìm thấy môn học");
                forwardToCourseList(req, resp);
                return;
            }
            
            boolean result = courseDAO.delete(id);
            
            if (result) {
                req.getSession().setAttribute("successMessage", "Xóa môn học '" + existing.getCode() + "' thành công!");
                resp.sendRedirect(req.getContextPath() + "/course");
            } else {
                req.setAttribute("errorMessage", "Lỗi khi xóa môn học");
                forwardToCourseList(req, resp);
            }
            
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "ID môn học không hợp lệ");
            forwardToCourseList(req, resp);
        }
    }
    
    private void forwardToCourseList(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Lấy lại danh sách courses
        List<Course> courseList = courseDAO.listAll();
        req.setAttribute("courseList", courseList);
        req.getRequestDispatcher("/views/curriculum/course.jsp").forward(req, resp);
    }
}