package controller;

import dao.SyllabusAssignmentDAO;
import model.SyllabusAssignment;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/assigned-roles")
public class LecturerTasksServlet extends HttpServlet {

    private final SyllabusAssignmentDAO assignDAO = new SyllabusAssignmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("LECTURER")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Fetch assignments
        List<SyllabusAssignment> assignments = assignDAO.getAssignmentsByUser(currentUser.getUserId());
        
        // Calculate stats
        long totalTasks = assignments.size();
        long pendingCount = assignments.stream().filter(a -> "PENDING".equalsIgnoreCase(a.getAssignmentStatus())).count();
        long inProgressCount = assignments.stream().filter(a -> "ACTIVE".equalsIgnoreCase(a.getAssignmentStatus()) || "IN_PROGRESS".equalsIgnoreCase(a.getAssignmentStatus())).count();
        long completedCount = assignments.stream().filter(a -> "COMPLETED".equalsIgnoreCase(a.getAssignmentStatus())).count();

        // Assign mock data for the UI that doesn't exist in DB
        // Priority, Due Date
        
        request.setAttribute("tasks", assignments);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("completedCount", completedCount);

        request.setAttribute("contentPage", "lecturer/tasks.jsp");
        request.setAttribute("cssFile", "lecturer/lecturer.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
