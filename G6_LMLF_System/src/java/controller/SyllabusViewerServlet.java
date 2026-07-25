package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * The old "/syllabus-viewer" page was a static placeholder mockup (no DB data),
 * so it has been retired. Real syllabus viewing is handled by the
 * lecturer/student syllabus browsers. Any hit here is redirected to the
 * role-based dashboard instead of showing the fake page.
 */
@WebServlet(name = "SyllabusViewerServlet", urlPatterns = {"/syllabus-viewer"})
public class SyllabusViewerServlet extends HttpServlet {

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
