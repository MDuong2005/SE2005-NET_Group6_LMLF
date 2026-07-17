package controller;

import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for serving static UI prototypes for the Lecturer Module
 */
@WebServlet("/lecturer-ui")
public class LecturerUIServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("LECTURER")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String page = request.getParameter("page");
        if (page == null) {
            page = "dashboard";
        }
        
        String jspPath = "lecturer/dashboard.jsp"; // Default
        
        switch (page) {
            case "curriculum":
                jspPath = "lecturer/curriculum.jsp";
                break;
            case "syllabus":
                jspPath = "lecturer/syllabus.jsp";
                break;
            case "materials":
                jspPath = "lecturer/materials.jsp";
                break;
            case "notifications":
                jspPath = "lecturer/notifications.jsp";
                break;
            case "profile":
                jspPath = "lecturer/profile.jsp";
                break;
        }

        request.setAttribute("contentPage", jspPath);
        request.setAttribute("cssFile", "lecturer/lecturer.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
