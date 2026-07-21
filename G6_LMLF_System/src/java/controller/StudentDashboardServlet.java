package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student-dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String page = request.getParameter("page");
        String jspPath;
        
        if ("learning-path".equals(page)) {
            jspPath = "student/learning-path.jsp";
        } else if ("prerequisite".equals(page)) {
            jspPath = "student/prerequisite.jsp";
        } else {
            jspPath = "student/dashboard.jsp";
        }
        
        request.setAttribute("contentPage", jspPath);
        request.setAttribute("cssFile", "student/student.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
