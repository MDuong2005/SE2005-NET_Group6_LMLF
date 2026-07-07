<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String versionId = request.getParameter("versionId");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Import Syllabus Excel</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f8fafc;
            padding: 40px;
        }

        .card {
            max-width: 600px;
            margin: auto;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 28px;
        }

        h2 {
            margin-bottom: 10px;
        }

        p {
            color: #64748b;
        }

        .field {
            margin-bottom: 18px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
        }

        button {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 10px;
            background: #ff6b00;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 16px;
            font-weight: bold;
        }

        .note {
            background: #fff7ed;
            border: 1px solid #fed7aa;
            color: #9a3412;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 16px;
            font-size: 14px;
        }
    </style>
</head>

<body>
<div class="card">
    <h2>Import Syllabus Excel</h2>
    <p>Upload Excel file divided by syllabus sections.</p>

    <div class="note">
        Required sheets:
        01_ACADEMIC_INFO,
        02_LEARNING_OUTCOMES,
        03_STUDENT_TASKS,
        04_LEARNING_MATERIALS,
        05_COURSE_SCHEDULE,
        06_COURSE_ASSESSMENT,
        07_ITU_TERM,
        08_VERSION_INFO
    </div>

    <% if (error != null) { %>
        <div class="error">
            Error: <%= error %>
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/syllabus/import-excel"
          method="post"
          enctype="multipart/form-data">

        <div class="field">
            <label>Version ID</label>
            <input type="number"
                   name="versionId"
                   value="<%= versionId == null ? "" : versionId %>"
                   required>
        </div>

        <div class="field">
            <label>Excel File</label>
            <input type="file"
                   name="excelFile"
                   accept=".xlsx"
                   required>
        </div>

        <button type="submit">Import Excel</button>
    </form>
</div>
</body>
</html>