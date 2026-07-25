package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * The old "/course-detail" page was a static placeholder mockup (no DB data),
 * so it has been retired. Real course info is available through the
 * curriculum/syllabus browsers. Any hit here is redirected to the role-based
 * dashboard instead of showing the fake page.
 */
@WebServlet(name = "CourseDetailServlet", urlPatterns = {"/course-detail"})
public class CourseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
