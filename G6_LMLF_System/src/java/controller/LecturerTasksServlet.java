package controller;

import dao.LecturerTaskDAO;
import model.LecturerTask;
import model.User;
import utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "LecturerTasksServlet", urlPatterns = {"/assigned-roles"})
public class LecturerTasksServlet extends HttpServlet {

    private final LecturerTaskDAO taskDAO = new LecturerTaskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("LECTURER")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Fetch assignments
        List<LecturerTask> assignments = taskDAO.getTasksByUser(
                currentUser.getUserId()
        );
        
        // Calculate stats
        long totalTasks = assignments.size();
        long pendingCount = countByStatusGroup(assignments, "PENDING");
        long inProgressCount = countByStatusGroup(assignments, "INPROGRESS");
        long completedCount = countByStatusGroup(assignments, "COMPLETED");
        long closedCount = countByStatusGroup(assignments, "CLOSED");
        
        request.setAttribute("tasks", assignments);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("closedCount", closedCount);

        request.setAttribute("contentPage", "lecturer/tasks.jsp");
        request.setAttribute("cssFile", "lecturer/lecturer.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private long countByStatusGroup(
            List<LecturerTask> assignments,
            String statusGroup
    ) {
        return assignments.stream()
                .filter(assignment -> statusGroup.equalsIgnoreCase(
                        assignment.getTaskStatusGroup()
                ))
                .count();
    }
}
