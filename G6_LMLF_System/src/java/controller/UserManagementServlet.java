package controller;

import dao.RoleDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Role;
import model.User;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import utils.SessionUtil;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/admin/users"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB in memory before buffering to disk
        maxFileSize = 5 * 1024 * 1024,        // 5 MB per file
        maxRequestSize = 6 * 1024 * 1024      // 6 MB total request
)
public class UserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security check
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null || !currentUser.hasRole("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        switch (action) {
            case "create":
                createUser(request, response);
                break;
            case "edit":
                updateUser(request, response);
                break;
            case "ban":
            case "unban":
                toggleStatus(request, response, action);
                break;
            case "importUsers":
                importUsers(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/users");
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userDAO.getAllUsersWithRoles();
        List<Role> roles = getSystemRoles();
        request.setAttribute("users", users);
        request.setAttribute("roles", roles);
        request.setAttribute("contentPage", "admin/user/user_list.jsp");
        request.setAttribute("cssFile", "admin/admin.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Role> roles = getSystemRoles();
        request.setAttribute("roles", roles);
        request.setAttribute("contentPage", "admin/user/create_user.jsp");
        request.setAttribute("cssFile", "admin/admin.css");
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        try {
            long userId = Long.parseLong(idParam);
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            List<Role> roles = getSystemRoles();
            List<Role> currentRoles = roleDAO.getRolesByUserId(userId);
            if (!currentRoles.isEmpty()) {
                request.setAttribute("currentRoleId", currentRoles.get(0).getRoleId());
            }
            
            request.setAttribute("editUser", user);
            request.setAttribute("roles", roles);
            request.setAttribute("contentPage", "admin/user/edit_user.jsp");
            request.setAttribute("cssFile", "admin/admin.css");
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private List<Role> getSystemRoles() {
        List<Role> allRoles = roleDAO.getAllRoles();
        List<Role> systemRoles = new ArrayList<>();
        for (Role r : allRoles) {
            if (!r.getRoleName().equalsIgnoreCase("DESIGNER") && !r.getRoleName().equalsIgnoreCase("REVIEWER")) {
                systemRoles.add(r);
            }
        }
        return systemRoles;
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = utils.ValidationUtil.sanitize(request.getParameter("username"));
        String firstName = utils.ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = utils.ValidationUtil.sanitize(request.getParameter("lastName"));
        String email = utils.ValidationUtil.sanitize(request.getParameter("email"));
        
        // Backend Validation
        if (!utils.ValidationUtil.isValidUsername(username) || !utils.ValidationUtil.isValidEmail(email) || 
            !utils.ValidationUtil.isNotEmpty(firstName) || !utils.ValidationUtil.isNotEmpty(lastName)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=create&error=invalid_data");
            return;
        }

        if (userDAO.getUserByEmail(email) != null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=create&error=email_exists");
            return;
        }
        
        if (userDAO.getUserByEmail(username) != null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=create&error=username_exists");
            return;
        }

        long roleId = 0;
        try {
            roleId = Long.parseLong(request.getParameter("roleId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=create&error=invalid_role");
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setEmail(email);
        newUser.setPasswordHash(null); // Internal users use Google Login
        newUser.setAuthProvider("GOOGLE");
        newUser.setExternal(false);
        newUser.setMustChangePassword(false);
        newUser.setStatus("ACTIVE");

        long generatedId = userDAO.insertUser(newUser);
        if (generatedId > 0) {
            userDAO.assignRole(generatedId, roleId);
            
            String newUserJson = "{\"username\":\"" + newUser.getUsername() + "\", \"email\":\"" + newUser.getEmail() + "\"}";
            utils.AuditUtil.logAction(request, "CREATE_USER", "users", generatedId, null, newUserJson);
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    /**
     * Bulk-create internal users from an uploaded .xlsx file.
     * Expected columns (row 1 is a header and is skipped):
     *   A=username, B=first_name, C=last_name, D=email, E=role
     * Each valid row becomes a GOOGLE-auth internal user (no password),
     * mirroring {@link #createUser}. Invalid rows are skipped and reported.
     */
    private void importUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ctx = request.getContextPath();

        Part filePart = request.getPart("excelFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect(ctx + "/admin/users?error=no_file");
            return;
        }

        String submitted = filePart.getSubmittedFileName();
        if (submitted == null || !submitted.toLowerCase().endsWith(".xlsx")) {
            response.sendRedirect(ctx + "/admin/users?error=bad_format");
            return;
        }

        // Cache role name -> id once, so we don't query per row.
        List<Role> allRoles = getSystemRoles();

        List<User> toInsert = new ArrayList<>();
        List<Long> roleIds = new ArrayList<>();
        List<String> rowLabels = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        Set<String> emailsInFile = new HashSet<>();

        try (InputStream is = filePart.getInputStream();
             Workbook workbook = new XSSFWorkbook(is)) {

            Sheet sheet = workbook.getSheetAt(0);
            DataFormatter fmt = new DataFormatter();

            for (int r = 1; r <= sheet.getLastRowNum(); r++) {   // r=1 skips the header row
                Row row = sheet.getRow(r);
                if (row == null) {
                    continue;
                }

                String username = utils.ValidationUtil.sanitize(cell(row, 0, fmt));
                String firstName = utils.ValidationUtil.sanitize(cell(row, 1, fmt));
                String lastName = utils.ValidationUtil.sanitize(cell(row, 2, fmt));
                String email = utils.ValidationUtil.sanitize(cell(row, 3, fmt));
                String roleName = cell(row, 4, fmt).trim();

                // Skip fully blank rows silently.
                if (username.isEmpty() && firstName.isEmpty() && lastName.isEmpty()
                        && email.isEmpty() && roleName.isEmpty()) {
                    continue;
                }

                int excelRow = r + 1;  // 1-based row number as seen in Excel
                String label = "Row " + excelRow + " (" + (email.isEmpty() ? username : email) + ")";

                if (!utils.ValidationUtil.isValidUsername(username)) {
                    errors.add(label + ": invalid username (3-20 chars, letters/digits/underscore).");
                    continue;
                }
                if (!utils.ValidationUtil.isValidEmail(email)) {
                    errors.add(label + ": invalid email.");
                    continue;
                }
                if (!utils.ValidationUtil.isNotEmpty(firstName) || !utils.ValidationUtil.isNotEmpty(lastName)) {
                    errors.add(label + ": first name and last name are required.");
                    continue;
                }

                Role role = findRole(allRoles, roleName);
                if (role == null) {
                    errors.add(label + ": unknown role '" + roleName + "'.");
                    continue;
                }

                String emailKey = email.toLowerCase();
                if (!emailsInFile.add(emailKey)) {
                    errors.add(label + ": duplicate email within the file.");
                    continue;
                }
                if (userDAO.existsByEmail(email)) {
                    errors.add(label + ": email already exists in the system.");
                    continue;
                }

                User u = new User();
                u.setUsername(username);
                u.setFirstName(firstName);
                u.setLastName(lastName);
                u.setEmail(email);
                u.setPasswordHash(null);        // internal users sign in with Google
                u.setAuthProvider("GOOGLE");
                u.setExternal(false);
                u.setMustChangePassword(false);
                u.setStatus("ACTIVE");

                toInsert.add(u);
                roleIds.add(role.getRoleId());
                rowLabels.add(label);
            }

        } catch (Exception e) {
            System.err.println("UserManagementServlet - import parse error: " + e.getMessage());
            response.sendRedirect(ctx + "/admin/users?error=parse_failed");
            return;
        }

        int imported = 0;
        int failed = errors.size();
        if (!toInsert.isEmpty()) {
            UserDAO.BatchResult result = userDAO.insertUsersBatch(toInsert, roleIds, rowLabels);
            imported = result.imported;
            failed += result.failed;
            errors.addAll(result.errors);
        }

        if (!errors.isEmpty()) {
            request.getSession().setAttribute("importErrors", errors);
        }
        response.sendRedirect(ctx + "/admin/users?imported=" + imported + "&failed=" + failed);
    }

    /** Read a cell as trimmed text, tolerating missing cells and numeric formats. */
    private String cell(Row row, int index, DataFormatter fmt) {
        Cell c = row.getCell(index);
        if (c == null) {
            return "";
        }
        return fmt.formatCellValue(c).trim();
    }

    /** Case-insensitive role lookup from a pre-loaded list (no per-row query). */
    private Role findRole(List<Role> roles, String name) {
        if (name == null || name.isEmpty()) {
            return null;
        }
        for (Role r : roles) {
            if (r.getRoleName() != null && r.getRoleName().equalsIgnoreCase(name)) {
                return r;
            }
        }
        return null;
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        long userId;
        long roleId;
        try {
            userId = Long.parseLong(request.getParameter("userId"));
            roleId = Long.parseLong(request.getParameter("roleId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        String firstName = utils.ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = utils.ValidationUtil.sanitize(request.getParameter("lastName"));
        String status = utils.ValidationUtil.sanitize(request.getParameter("status"));

        // Backend Validation
        if (!utils.ValidationUtil.isNotEmpty(firstName) || !utils.ValidationUtil.isNotEmpty(lastName)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&id=" + userId + "&error=invalid_data");
            return;
        }

        User userToUpdate = userDAO.getUserById(userId);
        if (userToUpdate != null) {
            String oldData = "{\"firstName\":\"" + userToUpdate.getFirstName() + "\", \"lastName\":\"" + userToUpdate.getLastName() + "\", \"status\":\"" + userToUpdate.getStatus() + "\"}";
            
            userToUpdate.setFirstName(firstName);
            userToUpdate.setLastName(lastName);
            userToUpdate.setStatus(status);
            userDAO.updateUser(userToUpdate);
            
            userDAO.removeAllRoles(userId);
            userDAO.assignRole(userId, roleId);
            
            String newData = "{\"firstName\":\"" + userToUpdate.getFirstName() + "\", \"lastName\":\"" + userToUpdate.getLastName() + "\", \"status\":\"" + userToUpdate.getStatus() + "\"}";
            utils.AuditUtil.logAction(request, "UPDATE_USER", "users", userId, oldData, newData);
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        try {
            long userId = Long.parseLong(request.getParameter("id"));
            String status = action.equals("ban") ? "BANNED" : "ACTIVE";
            String logActionName = action.equals("ban") ? "BAN_USER" : "UNBAN_USER";
            
            userDAO.updateUserStatus(userId, status);
            
            String newData = "{\"status\":\"" + status + "\"}";
            utils.AuditUtil.logAction(request, logActionName, "users", userId, null, newData);
        } catch (NumberFormatException e) {
            // ignore
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
