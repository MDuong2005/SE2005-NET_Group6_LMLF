<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/designer/designer.css">

    <style>
        .panel {
            background: #fff;
            border: 1px solid #e8ecf1;
            border-radius: 1rem;
            padding: 1.25rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 1rem;
        }

        .grid {
            display: grid;
            grid-template-columns: 180px 1fr;
            gap: .65rem;
            margin-top: 1rem;
        }

        .label {
            font-weight: 700;
            color: #64748b;
        }

        .muted {
            color: #64748b;
        }

        .badge {
            display: inline-flex;
            padding: .25rem .55rem;
            border-radius: 999px;
            font-size: .75rem;
            font-weight: 800;
            background: #e5e7eb;
        }

        .badge.PENDING {
            background: #fef3c7;
            color: #92400e;
        }

        .badge.ACCEPTED,
        .badge.ACTIVE,
        .badge.IN_PROGRESS {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .badge.SUBMITTED {
            background: #e0e7ff;
            color: #3730a3;
        }

        .badge.REJECTED {
            background: #fee2e2;
            color: #991b1b;
        }

        .actions {
            display: flex;
            gap: .5rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }

        .btn {
            display: inline-flex;
            padding: .55rem .8rem;
            border-radius: .65rem;
            border: 0;
            text-decoration: none;
            font-weight: 700;
            cursor: pointer;
        }

        .btn-primary {
            background: #f26f21;
            color: white;
        }

        .btn-green {
            background: #16a34a;
            color: white;
        }

        .btn-red {
            background: #dc2626;
            color: white;
        }

        .btn-gray {
            background: #f1f5f9;
            color: #334155;
        }

        .upload-box {
            background: #fff;
            border: 1px dashed #f26f21;
            border-radius: 1rem;
            padding: 1.25rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            font-weight: 700;
            margin-bottom: .35rem;
            color: #334155;
        }

        .form-control {
            width: 100%;
            padding: .7rem;
            border: 1px solid #cbd5e1;
            border-radius: .65rem;
        }

        textarea.form-control {
            resize: vertical;
        }

        .alert {
            padding: .8rem 1rem;
            border-radius: .75rem;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success">Thành công: ${param.success}</div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-error">Có lỗi: ${param.error}</div>
            </c:if>

            <div class="panel">
                <h1>${task.courseCode} - ${task.courseName}</h1>
                <p class="muted">Chi tiết assignment và submit file Excel syllabus.</p>

                <div class="grid">
                    <div class="label">Status</div>
                    <div>
                        <span class="badge ${task.assignmentStatus}">
                            ${task.assignmentStatus}
                        </span>
                    </div>

                    <div class="label">Semester</div>
                    <div>${task.semester} - ${task.academicYear}</div>

                    <div class="label">Credits</div>
                    <div>${task.credits}</div>

                    <div class="label">Reviewer</div>
                    <div>
                        ${empty task.reviewerName ? '-' : task.reviewerName}
                        ${empty task.reviewerEmail ? '' : '('}${task.reviewerEmail}${empty task.reviewerEmail ? '' : ')'}
                    </div>

                    <div class="label">Assigned at</div>
                    <div>${task.assignedAt}</div>

                    <div class="label">Due date</div>
                    <div>${empty task.dueDate ? '-' : task.dueDate}</div>

                    <div class="label">Syllabus</div>
                    <div>
                        ${empty task.syllabusTitle ? 'Chưa tạo, hệ thống sẽ tự tạo khi submit lần đầu.' : task.syllabusTitle}
                    </div>

                    <div class="label">Current version</div>
                    <div>${empty task.versionNumber ? 'Chưa submit' : task.versionNumber}</div>

                    <div class="label">Version status</div>
                    <div>${empty task.versionStatus ? '-' : task.versionStatus}</div>

                    <div class="label">Submitted file</div>
                    <div>
                        <c:choose>
                            <c:when test="${not empty task.submissionFileId}">
                                <a href="${pageContext.request.contextPath}/designer/download?fileId=${task.submissionFileId}">
                                    ${task.submissionFileName}
                                </a>
                            </c:when>
                            <c:otherwise>
                                Chưa có
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="actions">
                    <c:if test="${task.pending}">
                        <form method="post"
                              action="${pageContext.request.contextPath}/designer/accept">
                            <input type="hidden"
                                   name="assignmentId"
                                   value="${task.assignmentId}">
                            <button class="btn btn-green" type="submit">
                                Accept Assignment
                            </button>
                        </form>

                        <form method="post"
                              action="${pageContext.request.contextPath}/designer/reject">
                            <input type="hidden"
                                   name="assignmentId"
                                   value="${task.assignmentId}">
                            <button class="btn btn-red"
                                    type="submit"
                                    onclick="return confirm('Từ chối assignment này?')">
                                Reject
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${not empty task.templateFileId}">
                        <a class="btn btn-gray"
                           href="${pageContext.request.contextPath}/designer/download?fileId=${task.templateFileId}">
                            Download Template
                        </a>
                    </c:if>

                    <c:if test="${not empty task.syllabusId}">
                        <a class="btn btn-gray"
                           href="${pageContext.request.contextPath}/designer/version-history?syllabusId=${task.syllabusId}">
                            Version History
                        </a>
                    </c:if>

                    <c:if test="${not empty task.submittedVersionId}">
                        <a class="btn btn-gray"
                           href="${pageContext.request.contextPath}/designer/review-result?versionId=${task.submittedVersionId}">
                            Review Result
                        </a>
                    </c:if>
                </div>
            </div>

            <c:choose>
                <c:when test="${task.uploadAllowed}">
                    <div class="upload-box">
                        <h2>Upload / Resubmit Syllabus Excel</h2>
                        <p class="muted">
                            Mỗi lần submit sẽ tạo một version mới: 1.0, 1.1, 1.2...
                        </p>

                        <form method="post"
                              action="${pageContext.request.contextPath}/designer/upload"
                              enctype="multipart/form-data">

                            <input type="hidden"
                                   name="assignmentId"
                                   value="${task.assignmentId}">

                            <div class="form-group">
                                <label>Description of changes</label>
                                <textarea class="form-control"
                                          name="description"
                                          rows="4"
                                          placeholder="Ví dụ: Initial submission / Update learning outcomes theo comment của reviewer..."></textarea>
                            </div>

                            <div class="form-group">
                                <label>Excel file (.xls, .xlsx)</label>
                                <input class="form-control"
                                       type="file"
                                       name="syllabusFile"
                                       accept=".xls,.xlsx"
                                       required>
                            </div>

                            <button class="btn btn-primary" type="submit">
                                Submit Syllabus
                            </button>
                        </form>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="panel">
                        <strong>Không thể upload ở trạng thái hiện tại.</strong>
                        <p class="muted">
                            Nếu assignment đang PENDING, hãy Accept trước.
                            Nếu đã REJECTED bởi chính bạn hoặc COMPLETED, không thể submit nữa.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>