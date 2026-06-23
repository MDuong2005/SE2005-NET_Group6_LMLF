<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>

<%
    Map<String, Object> versionDetail =
            (Map<String, Object>) request.getAttribute("versionDetail");

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Syllabus Evaluation</title>
</head>
<body>

<h2>Syllabus Evaluation</h2>

<% if ("comment_required".equals(error)) { %>
    <p style="color:red;">Reject comment is required.</p>
<% } %>

<% if (versionDetail != null && !versionDetail.isEmpty()) { %>

    <p><b>Course Code:</b> <%= versionDetail.get("course_code") %></p>
    <p><b>Course Name:</b> <%= versionDetail.get("course_name") %></p>
    <p><b>Syllabus Title:</b> <%= versionDetail.get("syllabus_title") %></p>
    <p><b>Version:</b> <%= versionDetail.get("version_number") %></p>
    <p><b>Change Type:</b> <%= versionDetail.get("change_type") %></p>
    <p><b>Description:</b> <%= versionDetail.get("description_of_changes") %></p>
    <p><b>Status:</b> <%= versionDetail.get("status") %></p>
    <p><b>Submitted At:</b> <%= versionDetail.get("submitted_at") %></p>

    <hr>

    <form action="${pageContext.request.contextPath}/review?action=approve" method="post">
        <input type="hidden" name="versionId" value="<%= versionDetail.get("version_id") %>">

        <label>Comment:</label><br>
        <textarea name="comment" rows="4" cols="60">Looks good</textarea><br><br>

        <button type="submit">Approve</button>
    </form>

    <br>

    <form action="${pageContext.request.contextPath}/review?action=reject" method="post">
        <input type="hidden" name="versionId" value="<%= versionDetail.get("version_id") %>">

        <label>Reject Comment:</label><br>
        <textarea name="comment" rows="4" cols="60" placeholder="Enter reason for rejection"></textarea><br><br>

        <button type="submit">Reject</button>
    </form>

    <br>

    <a href="${pageContext.request.contextPath}/review?action=pending">
        Back to Pending Reviews
    </a>

<% } else { %>

    <p>No version detail found.</p>
    <a href="${pageContext.request.contextPath}/review?action=pending">
        Back to Pending Reviews
    </a>

<% } %>

</body>
</html>