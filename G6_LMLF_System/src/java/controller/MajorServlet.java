package controller;

import dao.MajorDAO;
import model.Major;
import model.User;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MajorServlet", urlPatterns = {"/major"})
public class MajorServlet extends HttpServlet {

private final MajorDAO majorDAO = new MajorDAO();
private static final String JSP_PATH = "/views/academic/major.jsp";

@Override
protected void doGet(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if (action == null) {
        action = "list";
    }

    switch (action) {

        case "create":
            request.setAttribute("action", "create");
            request.setAttribute("majorList", majorDAO.getAllMajors());
            request.getRequestDispatcher(
                    JSP_PATH)
                    .forward(request, response);
            break;

        case "edit":
            showEditForm(request, response);
            break;

        case "delete":
            deleteMajor(request, response);
            break;

        case "search":
            listMajors(request, response);
            break;

        default:
            listMajors(request, response);
            break;
    }
}

@Override
protected void doPost(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if (action == null) {
        action = "";
    }

    switch (action) {

        case "create":
            createMajor(request, response);
            break;

        case "edit":
            updateMajor(request, response);
            break;

        case "delete":
            deleteMajor(request, response);
            break;

        default:
            response.sendRedirect(
                    request.getContextPath() + "/major");
            break;
    }
}

private void listMajors(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    String keyword = request.getParameter("keyword");
    List<Major> majorList = majorDAO.searchMajor(keyword);

    request.setAttribute("majorList", majorList);
    request.setAttribute("keyword", keyword == null ? "" : keyword.trim());

    request.getRequestDispatcher(
            JSP_PATH)
            .forward(request, response);
}

private void createMajor(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    String code = request.getParameter("code");
    String name = request.getParameter("name");
    String description = request.getParameter("description");

    if (code == null || code.trim().isEmpty()
            || name == null || name.trim().isEmpty()) {

        request.setAttribute("errorMessage", "Code and Name are required.");
        request.setAttribute("action", "create");
        request.setAttribute("majorList", majorDAO.getAllMajors());
        request.setAttribute("code", code);
        request.setAttribute("name", name);
        request.setAttribute("description", description);

        request.getRequestDispatcher(
                JSP_PATH)
                .forward(request, response);

        return;
    }

    if (majorDAO.isCodeExists(code)) {

        request.setAttribute("errorMessage", "Major code already exists.");
        request.setAttribute("action", "create");
        request.setAttribute("majorList", majorDAO.getAllMajors());
        request.setAttribute("code", code);
        request.setAttribute("name", name);
        request.setAttribute("description", description);

        request.getRequestDispatcher(
                JSP_PATH)
                .forward(request, response);

        return;
    }

    User currentUser =
            (User) request.getSession()
                    .getAttribute("user");

    Major major = new Major();

    major.setCode(code);
    major.setName(name);
    major.setDescription(description);

    if (currentUser != null) {
        major.setCreatedBy(
                currentUser.getUserId());
    }

    boolean success =
            majorDAO.addMajor(major);

    if (success) {

        response.sendRedirect(
                request.getContextPath()
                + "/major");

    } else {

        request.setAttribute("errorMessage", "Failed to create major.");
        request.setAttribute("action", "create");
        request.setAttribute("majorList", majorDAO.getAllMajors());
        request.setAttribute("code", code);
        request.setAttribute("name", name);
        request.setAttribute("description", description);

        request.getRequestDispatcher(
                JSP_PATH)
                .forward(request, response);
    }
}

private void showEditForm(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    long id = Long.parseLong(
            request.getParameter("id"));

    Major major =
            majorDAO.getMajorById(id);

    request.setAttribute("major", major);
    request.setAttribute("action", "edit");
    request.setAttribute("majorList", majorDAO.getAllMajors());

    request.getRequestDispatcher(
            JSP_PATH)
            .forward(request, response);
}

private void updateMajor(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    long majorId =
            Long.parseLong(
                    request.getParameter("majorId"));

    String description =
            request.getParameter("description");

    Major major = majorDAO.getMajorById(majorId);
    if (major == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Major not found");
        return;
    }
    major.setDescription(description);

    boolean success =
            majorDAO.updateMajor(major);

    if (success) {

        response.sendRedirect(
                request.getContextPath()
                + "/major");

    } else {

        request.setAttribute("errorMessage", "Update failed.");
        request.setAttribute("action", "edit");
        request.setAttribute("major", major);
        request.setAttribute("majorList", majorDAO.getAllMajors());

        request.getRequestDispatcher(
                JSP_PATH)
                .forward(request, response);
    }
}

private void deleteMajor(HttpServletRequest request,
        HttpServletResponse response)
        throws IOException {

    long majorId =
            Long.parseLong(
                    request.getParameter("id"));

    majorDAO.deleteMajor(majorId);

    response.sendRedirect(
            request.getContextPath()
            + "/major");
}

@Override
public String getServletInfo() {
    return "Major Management Servlet";
}

}
