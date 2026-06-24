package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Course;
import model.CoursePrerequisite;
import model.User;
import dao.CourseDAO;
import dao.CoursePrerequisiteDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/course-prerequisite")
public class CoursePrerequisiteServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private CoursePrerequisiteDAO prerequisiteDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        prerequisiteDAO = new CoursePrerequisiteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        if (!checkAccess(req, resp)) {
            return;
        }

        String action = req.getParameter("action");
        String keyword = req.getParameter("keyword");
        String filterCourseIdStr = req.getParameter("filterCourseId");

        // Handle deletion via GET request
        if ("delete".equals(action)) {
            handleDelete(req, resp);
            return;
        }

        // Load specific mapping if action is edit
        if ("edit".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr);
                    CoursePrerequisite cp = prerequisiteDAO.getById(id);
                    req.setAttribute("prerequisite", cp);
                    req.setAttribute("action", "edit");
                } catch (NumberFormatException e) {
                    req.setAttribute("errorMessage", "Invalid prerequisite ID");
                }
            }
        }

        // Fetch prerequisites list
        List<CoursePrerequisite> prerequisiteList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            prerequisiteList = prerequisiteDAO.search(keyword.trim());
            req.setAttribute("keyword", keyword);
        } else {
            prerequisiteList = prerequisiteDAO.listAll();
        }

        // Apply filterCourseId if selected
        if (filterCourseIdStr != null && !filterCourseIdStr.trim().isEmpty()) {
            try {
                Long filterCourseId = Long.parseLong(filterCourseIdStr.trim());
                req.setAttribute("filterCourseId", filterCourseId);
                prerequisiteList.removeIf(item -> item.getPrerequisiteCourseId() != filterCourseId.longValue());
            } catch (NumberFormatException e) {
                // ignore invalid param
            }
        }

        // Fetch all courses for selectors
        List<Course> courseList = courseDAO.listAll();

        req.setAttribute("prerequisiteList", prerequisiteList);
        req.setAttribute("courseList", courseList);
        req.getRequestDispatcher("/views/academic/course_prerequisite.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        if (!checkAccess(req, resp)) {
            return;
        }

        String action = req.getParameter("action");

        if ("create".equals(action)) {
            handleCreate(req, resp);
        } else if ("edit".equals(action)) {
            handleEdit(req, resp);
        } else if ("delete".equals(action)) {
            handleDelete(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/course-prerequisite");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String courseIdStr = req.getParameter("courseId");
        String prereqCourseIdStr = req.getParameter("prerequisiteCourseId");

        req.setAttribute("action", "create");
        req.setAttribute("tempCourseId", courseIdStr);
        req.setAttribute("tempPrereqCourseId", prereqCourseIdStr);

        if (courseIdStr == null || courseIdStr.trim().isEmpty() || 
            prereqCourseIdStr == null || prereqCourseIdStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please select both Course and Prerequisite Course.");
            forwardToPrereqList(req, resp);
            return;
        }

        try {
            Long courseId = Long.parseLong(courseIdStr.trim());
            Long prereqCourseId = Long.parseLong(prereqCourseIdStr.trim());

            if (courseId.equals(prereqCourseId)) {
                req.setAttribute("errorMessage", "A course cannot be a prerequisite of itself.");
                forwardToPrereqList(req, resp);
                return;
            }

            if (prerequisiteDAO.isDuplicate(courseId, prereqCourseId)) {
                req.setAttribute("errorMessage", "This prerequisite mapping already exists in the system.");
                forwardToPrereqList(req, resp);
                return;
            }

            CoursePrerequisite cp = new CoursePrerequisite();
            cp.setCourseId(courseId);
            cp.setPrerequisiteCourseId(prereqCourseId);

            boolean result = prerequisiteDAO.create(cp);

            if (result) {
                req.getSession().setAttribute("successMessage", "Added prerequisite mapping successfully!");
                resp.sendRedirect(req.getContextPath() + "/course-prerequisite");
            } else {
                req.setAttribute("errorMessage", "Failed to save prerequisite mapping. Please try again.");
                forwardToPrereqList(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid parameters provided.");
            forwardToPrereqList(req, resp);
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String prerequisiteIdStr = req.getParameter("prerequisiteId");
        String courseIdStr = req.getParameter("courseId");
        String prereqCourseIdStr = req.getParameter("prerequisiteCourseId");

        req.setAttribute("action", "edit");

        if (prerequisiteIdStr == null || prerequisiteIdStr.trim().isEmpty() ||
            courseIdStr == null || courseIdStr.trim().isEmpty() || 
            prereqCourseIdStr == null || prereqCourseIdStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Missing required fields.");
            forwardToPrereqList(req, resp);
            return;
        }

        try {
            Long prerequisiteId = Long.parseLong(prerequisiteIdStr.trim());
            Long courseId = Long.parseLong(courseIdStr.trim());
            Long prereqCourseId = Long.parseLong(prereqCourseIdStr.trim());

            CoursePrerequisite existing = prerequisiteDAO.getById(prerequisiteId);
            if (existing == null) {
                req.setAttribute("errorMessage", "Prerequisite mapping not found.");
                forwardToPrereqList(req, resp);
                return;
            }

            req.setAttribute("prerequisite", existing);

            if (courseId.equals(prereqCourseId)) {
                req.setAttribute("errorMessage", "A course cannot be a prerequisite of itself.");
                forwardToPrereqList(req, resp);
                return;
            }

            if (prerequisiteDAO.isDuplicate(courseId, prereqCourseId, prerequisiteId)) {
                req.setAttribute("errorMessage", "This prerequisite mapping already exists in the system.");
                forwardToPrereqList(req, resp);
                return;
            }

            existing.setCourseId(courseId);
            existing.setPrerequisiteCourseId(prereqCourseId);

            boolean result = prerequisiteDAO.update(existing);

            if (result) {
                req.getSession().setAttribute("successMessage", "Updated prerequisite mapping successfully!");
                resp.sendRedirect(req.getContextPath() + "/course-prerequisite");
            } else {
                req.setAttribute("errorMessage", "Failed to update mapping.");
                forwardToPrereqList(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid numeric inputs.");
            forwardToPrereqList(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Invalid prerequisite ID.");
            forwardToPrereqList(req, resp);
            return;
        }

        try {
            Long id = Long.parseLong(idStr.trim());
            CoursePrerequisite existing = prerequisiteDAO.getById(id);

            if (existing == null) {
                req.setAttribute("errorMessage", "Prerequisite mapping not found.");
                forwardToPrereqList(req, resp);
                return;
            }

            boolean result = prerequisiteDAO.delete(id);

            if (result) {
                req.getSession().setAttribute("successMessage", "Deleted prerequisite mapping successfully!");
                resp.sendRedirect(req.getContextPath() + "/course-prerequisite");
            } else {
                req.setAttribute("errorMessage", "Failed to delete mapping.");
                forwardToPrereqList(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid prerequisite ID.");
            forwardToPrereqList(req, resp);
        }
    }

    private void forwardToPrereqList(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        List<CoursePrerequisite> prerequisiteList = prerequisiteDAO.listAll();
        List<Course> courseList = courseDAO.listAll();

        req.setAttribute("prerequisiteList", prerequisiteList);
        req.setAttribute("courseList", courseList);
        req.getRequestDispatcher("/views/academic/course_prerequisite.jsp").forward(req, resp);
    }

    private boolean checkAccess(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            loggedInUser = new User();
            loggedInUser.setUserId(1L);
            loggedInUser.setFirstName("Academic");
            loggedInUser.setLastName("Office");
            loggedInUser.setEmail("academic@fpt.edu.vn");
            
            // Add academic office role for testing
            model.Role r = new model.Role();
            r.setRoleId(2L);
            r.setRoleName("ACADEMIC_OFFICE");
            List<model.Role> rolesList = new java.util.ArrayList<>();
            rolesList.add(r);
            loggedInUser.setRoles(rolesList);
            
            session.setAttribute("user", loggedInUser);
        }

        if (!loggedInUser.hasRole("ACADEMIC_OFFICE") && !loggedInUser.hasRole("ADMIN")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return false;
        }
        return true;
    }
}
