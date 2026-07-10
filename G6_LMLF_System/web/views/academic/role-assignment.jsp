<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="model.Course" %>
            <%@page import="model.User" %>
                <%@page import="model.SyllabusAssignment" %>
                    <% List<SyllabusAssignment> assignmentList = (List<SyllabusAssignment>)
                            request.getAttribute("assignmentList");
                            List<Course> courses = (List<Course>) request.getAttribute("courses");
                                    List<User> lecturers = (List<User>) request.getAttribute("lecturers");
                                            String errorMessage = (String) request.getAttribute("errorMessage");
                                            String action = (String) request.getAttribute("action");
                                            if (action == null) {
                                            action = "";
                                            }

                                            // Extract and clear success message from session
                                            String successMessage = (String) session.getAttribute("successMessage");
                                            if (successMessage != null) {
                                            session.removeAttribute("successMessage");
                                            } else {
                                            successMessage = "";
                                            }
                                            if (errorMessage == null) {
                                            errorMessage = "";
                                            }

                                            // Retain form values for error feedback
                                            String tempCourseId = (String) request.getAttribute("tempCourseId");
                                            String tempDesignerId = (String) request.getAttribute("tempDesignerId");
                                            String tempReviewerId = (String) request.getAttribute("tempReviewerId");
                                            String tempSemester = (String) request.getAttribute("tempSemester");
                                            String tempYear = (String) request.getAttribute("tempYear");
                                            String tempStatus = (String) request.getAttribute("tempStatus");
                                            if (tempYear == null || tempYear.isEmpty()) {
                                            tempYear = "2026";
                                            }

                                            SyllabusAssignment editAssignment = (SyllabusAssignment)
                                            request.getAttribute("assignment");
                                            SyllabusAssignment detailAssignment = (SyllabusAssignment)
                                            request.getAttribute("detailAssignment");
                                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                                            %>

                                            <!DOCTYPE html>
                                            <html lang="en">

                                            <head>
                                                <meta charset="UTF-8">
                                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                                <title>Syllabus Role Assignments - LMLF</title>
                                                <!-- Google Fonts -->
                                                <link rel="preconnect" href="https://fonts.googleapis.com">
                                                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                                                <link
                                                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                                                    rel="stylesheet">
                                                <!-- Main Stylesheet -->
                                                <link rel="stylesheet"
                                                    href="${pageContext.request.contextPath}/assets/css/academic/academic.css">

                                                <style>
                                                    /* Custom scoped workspace variables mapped to FPT Academic theme */
                                                    :root {
                                                        --primary: var(--fpt-orange, #FF6B00);
                                                        --primary-hover: var(--fpt-orange-hover, #E05E00);
                                                        --primary-light: var(--fpt-orange-light, #FFF0E6);
                                                        --border-color: #E2E8F0;
                                                        --bg-card: #FFFFFF;
                                                        --text-dark: #1E293B;
                                                        --text-muted: #64748B;
                                                        --danger: #EF4444;
                                                        --danger-hover: #DC2626;
                                                        --radius-lg: 12px;
                                                        --radius-md: 8px;
                                                        --radius-sm: 6px;
                                                        --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                                                        --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                                                        --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
                                                        --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                                                    }

                                                    /* Scoped styles for the core workspace area */
                                                    .workspace-container {
                                                        display: flex;
                                                        flex-direction: column;
                                                        gap: 24px;
                                                    }

                                                    .workspace-header {
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: space-between;
                                                    }

                                                    .workspace-header h1 {
                                                        font-size: 26px;
                                                        font-weight: 800;
                                                        color: var(--text-dark);
                                                        letter-spacing: -0.5px;
                                                        margin: 0;
                                                    }

                                                    .btn-primary {
                                                        background-color: var(--primary);
                                                        color: #FFFFFF;
                                                        border: none;
                                                        height: 42px;
                                                        padding: 0 20px;
                                                        border-radius: var(--radius-md);
                                                        font-weight: 700;
                                                        font-size: 14px;
                                                        cursor: pointer;
                                                        display: inline-flex;
                                                        align-items: center;
                                                        gap: 8px;
                                                        transition: var(--transition);
                                                        box-shadow: var(--shadow-sm);
                                                        text-decoration: none;
                                                    }

                                                    .btn-primary:hover {
                                                        background-color: var(--primary-hover);
                                                    }

                                                    .card {
                                                        background-color: var(--bg-card);
                                                        border: 1px solid var(--border-color);
                                                        border-radius: var(--radius-lg);
                                                        padding: 24px;
                                                        box-shadow: var(--shadow-sm);
                                                    }

                                                    /* Filter block styling */
                                                    .filter-row {
                                                        display: flex;
                                                        gap: 20px;
                                                        align-items: flex-end;
                                                    }

                                                    .form-group {
                                                        display: flex;
                                                        flex-direction: column;
                                                        gap: 8px;
                                                        flex: 1;
                                                    }

                                                    .form-group label {
                                                        font-size: 13px;
                                                        font-weight: 700;
                                                        color: var(--text-dark);
                                                    }

                                                    .form-select,
                                                    .form-input {
                                                        height: 42px;
                                                        border: 1px solid var(--border-color);
                                                        border-radius: var(--radius-md);
                                                        padding: 0 16px;
                                                        font-family: inherit;
                                                        font-size: 14px;
                                                        color: var(--text-dark);
                                                        outline: none;
                                                        transition: var(--transition);
                                                        background-color: #FFFFFF;
                                                    }

                                                    .form-select:focus,
                                                    .form-input:focus {
                                                        border-color: var(--primary);
                                                        box-shadow: 0 0 0 3px rgba(242, 111, 33, 0.15);
                                                    }

                                                    .search-group {
                                                        flex: 3;
                                                    }

                                                    .search-input-wrapper {
                                                        position: relative;
                                                        width: 100%;
                                                    }

                                                    .search-input-wrapper .form-input {
                                                        padding-left: 44px;
                                                        width: 100%;
                                                    }

                                                    .search-input-wrapper svg {
                                                        position: absolute;
                                                        left: 14px;
                                                        top: 50%;
                                                        transform: translateY(-50%);
                                                        width: 18px;
                                                        height: 18px;
                                                        fill: var(--text-muted);
                                                        pointer-events: none;
                                                    }

                                                    .btn-search {
                                                        height: 42px;
                                                        padding: 0 24px;
                                                        background-color: var(--primary);
                                                        color: #FFFFFF;
                                                        border: none;
                                                        border-radius: var(--radius-md);
                                                        font-weight: 700;
                                                        font-size: 14px;
                                                        cursor: pointer;
                                                        transition: var(--transition);
                                                    }

                                                    .btn-search:hover {
                                                        background-color: var(--primary-hover);
                                                    }

                                                    /* Data Grid Tables */
                                                    .table-card {
                                                        padding: 0;
                                                        overflow-x: auto;
                                                    }

                                                    .data-table {
                                                        width: 100%;
                                                        border-collapse: collapse;
                                                        text-align: left;
                                                    }

                                                    .data-table th {
                                                        background-color: var(--primary);
                                                        color: #FFFFFF;
                                                        font-weight: 700;
                                                        font-size: 14px;
                                                        padding: 14px 10px;
                                                        letter-spacing: 0.5px;
                                                        border: none;
                                                    }

                                                    .data-table td {
                                                        padding: 12px 10px;
                                                        border-bottom: 1px solid var(--border-color);
                                                        font-size: 14px;
                                                        color: var(--text-dark);
                                                    }

                                                    .data-table tbody tr {
                                                        transition: var(--transition);
                                                    }

                                                    .data-table tbody tr:hover {
                                                        background-color: #F8FAFC;
                                                    }

                                                    .data-table tbody tr:last-child td {
                                                        border-bottom: none;
                                                    }

                                                    .badge-code {
                                                        display: inline-block;
                                                        background-color: var(--primary);
                                                        color: #FFFFFF;
                                                        font-size: 12px;
                                                        font-weight: 700;
                                                        padding: 4px 10px;
                                                        border-radius: 4px;
                                                        letter-spacing: 0.5px;
                                                    }

                                                    .badge-semester {
                                                        display: inline-block;
                                                        background-color: #ECEFF1;
                                                        color: #455A64;
                                                        font-size: 12px;
                                                        font-weight: 700;
                                                        padding: 4px 10px;
                                                        border-radius: 4px;
                                                        letter-spacing: 0.5px;
                                                        border: 1px solid #CFD8DC;
                                                    }

                                                    .badge-year {
                                                        display: inline-block;
                                                        background-color: #E2E8F0;
                                                        color: #475569;
                                                        font-size: 12px;
                                                        font-weight: 700;
                                                        padding: 4px 10px;
                                                        border-radius: 4px;
                                                        letter-spacing: 0.5px;
                                                    }

                                                    .text-bold {
                                                        font-weight: 700;
                                                    }

                                                    .actions-cell {
                                                        display: flex;
                                                        gap: 12px;
                                                        align-items: center;
                                                    }

                                                    .btn-action {
                                                        display: inline-flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        width: 36px;
                                                        height: 36px;
                                                        border-radius: var(--radius-md);
                                                        border: 1px solid var(--border-color);
                                                        background-color: #FFFFFF;
                                                        transition: var(--transition);
                                                        cursor: pointer;
                                                        text-decoration: none;
                                                    }

                                                    .btn-action-edit {
                                                        color: var(--primary);
                                                    }

                                                    .btn-action-edit:hover {
                                                        background-color: var(--primary-light);
                                                        border-color: var(--primary);
                                                        color: var(--primary-hover);
                                                    }

                                                    .btn-action-detail {
                                                        color: #3B82F6;
                                                    }

                                                    .btn-action-detail:hover {
                                                        background-color: #EFF6FF;
                                                        border-color: #3B82F6;
                                                        color: #1D4ED8;
                                                    }

                                                    .btn-action svg {
                                                        width: 18px;
                                                        height: 18px;
                                                        stroke: currentColor;
                                                        fill: none;
                                                        stroke-width: 2;
                                                        stroke-linecap: round;
                                                        stroke-linejoin: round;
                                                    }

                                                    /* Empty State */
                                                    .empty-state {
                                                        padding: 48px;
                                                        text-align: center;
                                                        display: flex;
                                                        flex-direction: column;
                                                        align-items: center;
                                                        justify-content: center;
                                                        gap: 16px;
                                                    }

                                                    .empty-state-icon {
                                                        width: 64px;
                                                        height: 64px;
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        border-radius: 50%;
                                                        background-color: var(--primary-light);
                                                        color: var(--primary);
                                                    }

                                                    .empty-state-text {
                                                        color: var(--text-muted);
                                                        font-size: 14px;
                                                        font-weight: 500;
                                                        max-width: 400px;
                                                    }

                                                    /* Pagination style */
                                                    .pagination-footer {
                                                        border-top: 1px solid var(--border-color);
                                                        padding: 16px 24px;
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: space-between;
                                                        background-color: #FFFFFF;
                                                    }

                                                    .pagination-info {
                                                        font-size: 14px;
                                                        color: var(--text-muted);
                                                    }

                                                    .pagination-info span {
                                                        font-weight: 700;
                                                        color: var(--text-dark);
                                                    }

                                                    .pagination-controls {
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 8px;
                                                    }

                                                    .page-btn {
                                                        width: 36px;
                                                        height: 36px;
                                                        border: 1px solid var(--border-color);
                                                        background-color: #FFFFFF;
                                                        color: var(--text-dark);
                                                        border-radius: 6px;
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        font-weight: 600;
                                                        cursor: pointer;
                                                        transition: var(--transition);
                                                    }

                                                    .page-btn:hover:not(:disabled) {
                                                        border-color: var(--primary);
                                                        color: var(--primary);
                                                        background-color: var(--primary-light);
                                                    }

                                                    .page-btn:disabled {
                                                        opacity: 0.4;
                                                        cursor: not-allowed;
                                                    }

                                                    .page-indicator {
                                                        font-size: 14px;
                                                        font-weight: 600;
                                                        color: var(--text-dark);
                                                        margin: 0 12px;
                                                    }

                                                    /* Modals and Overlays */
                                                    .modal-overlay {
                                                        position: fixed;
                                                        top: 0;
                                                        left: 0;
                                                        right: 0;
                                                        bottom: 0;
                                                        background-color: rgba(15, 23, 42, 0.6);
                                                        backdrop-filter: blur(4px);
                                                        display: none;
                                                        align-items: center;
                                                        justify-content: center;
                                                        z-index: 1000;
                                                        padding: 24px;
                                                    }

                                                    .modal-overlay.open {
                                                        display: flex;
                                                    }

                                                    .modal-container {
                                                        background-color: #FFFFFF;
                                                        width: 100%;
                                                        max-width: 520px;
                                                        border-radius: var(--radius-lg);
                                                        box-shadow: var(--shadow-lg);
                                                        overflow: hidden;
                                                        animation: modalIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                                                    }

                                                    @keyframes modalIn {
                                                        from {
                                                            transform: scale(0.95);
                                                            opacity: 0;
                                                        }

                                                        to {
                                                            transform: scale(1);
                                                            opacity: 1;
                                                        }
                                                    }

                                                    .modal-header {
                                                        padding: 20px 24px;
                                                        border-bottom: 1px solid var(--border-color);
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: space-between;
                                                    }

                                                    .modal-header h3 {
                                                        font-size: 18px;
                                                        font-weight: 700;
                                                        color: var(--text-dark);
                                                    }

                                                    .modal-close {
                                                        background: none;
                                                        border: none;
                                                        cursor: pointer;
                                                        color: var(--text-muted);
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        border-radius: 50%;
                                                        width: 32px;
                                                        height: 32px;
                                                        transition: var(--transition);
                                                    }

                                                    .modal-close:hover {
                                                        background-color: #F1F5F9;
                                                        color: var(--text-dark);
                                                    }

                                                    .modal-body {
                                                        padding: 24px;
                                                        max-height: 480px;
                                                        overflow-y: auto;
                                                    }

                                                    .modal-footer {
                                                        padding: 16px 24px;
                                                        border-top: 1px solid var(--border-color);
                                                        background-color: #F8FAFC;
                                                        display: flex;
                                                        justify-content: flex-end;
                                                        gap: 12px;
                                                    }

                                                    .btn-secondary {
                                                        background-color: #FFFFFF;
                                                        color: var(--text-muted);
                                                        border: 1px solid var(--border-color);
                                                        height: 42px;
                                                        padding: 0 20px;
                                                        border-radius: var(--radius-md);
                                                        font-weight: 600;
                                                        font-size: 14px;
                                                        cursor: pointer;
                                                        transition: var(--transition);
                                                        text-decoration: none;
                                                        display: inline-flex;
                                                        align-items: center;
                                                    }

                                                    .btn-secondary:hover {
                                                        background-color: #F1F5F9;
                                                        color: var(--text-dark);
                                                        border-color: #CBD5E1;
                                                    }

                                                    .modal-form {
                                                        display: flex;
                                                        flex-direction: column;
                                                        gap: 20px;
                                                    }

                                                    /* Alert notifications */
                                                    .alert-error {
                                                        background-color: #FEF2F2;
                                                        border: 1px solid #FCA5A5;
                                                        color: var(--danger);
                                                        padding: 12px 16px;
                                                        border-radius: var(--radius-md);
                                                        font-size: 14px;
                                                        font-weight: 500;
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 8px;
                                                        margin-bottom: 16px;
                                                    }

                                                    .alert-success {
                                                        background-color: #DCFCE7;
                                                        border: 1px solid #86EFAC;
                                                        color: #166534;
                                                        padding: 12px 16px;
                                                        border-radius: var(--radius-md);
                                                        font-size: 14px;
                                                        font-weight: 500;
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 8px;
                                                        margin-bottom: 16px;
                                                    }

                                                    /* Custom alert styling */
                                                    .toast {
                                                        position: fixed;
                                                        bottom: 24px;
                                                        right: 24px;
                                                        background-color: #2D3748;
                                                        color: white;
                                                        padding: 16px 24px;
                                                        border-radius: 10px;
                                                        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                                                        z-index: 1000;
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 12px;
                                                        transform: translateY(100px);
                                                        opacity: 0;
                                                        transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55);
                                                    }

                                                    .toast.show {
                                                        transform: translateY(0);
                                                        opacity: 1;
                                                    }

                                                    .toast-success {
                                                        border-left: 4px solid #48BB78;
                                                    }

                                                    .toast-error {
                                                        border-left: 4px solid #F56565;
                                                    }

                                                    .toast-icon {
                                                        font-weight: bold;
                                                        font-size: 18px;
                                                    }

                                                    .toast-success .toast-icon {
                                                        color: #48BB78;
                                                    }

                                                    .toast-error .toast-icon {
                                                        color: #F56565;
                                                    }

                                                    /* Redesigned two-column modal styles */
                                                    .modal-layout-grid {
                                                        display: grid;
                                                        grid-template-columns: 1.1fr 1fr;
                                                        gap: 24px;
                                                    }

                                                    .modal-col-left {
                                                        border-right: 1px solid var(--border-color);
                                                        padding-right: 24px;
                                                        display: flex;
                                                        flex-direction: column;
                                                        gap: 12px;
                                                    }

                                                    .modal-col-right {
                                                        display: flex;
                                                        flex-direction: column;
                                                        gap: 12px;
                                                        padding-left: 4px;
                                                    }

                                                    .modal-body .form-select,
                                                    .modal-body .form-input {
                                                        height: 38px;
                                                    }

                                                    .modal-body .form-group {
                                                        gap: 6px;
                                                        flex: none;
                                                    }

                                                    .info-alert-box {
                                                        background-color: #EFF6FF;
                                                        border: 1px solid #BFDBFE;
                                                        color: #1D4ED8;
                                                        border-radius: var(--radius-md);
                                                        padding: 14px 16px;
                                                        font-size: 13px;
                                                        line-height: 1.5;
                                                        display: flex;
                                                        gap: 10px;
                                                        align-items: flex-start;
                                                        margin-top: auto;
                                                    }

                                                    .info-alert-box svg {
                                                        width: 16px;
                                                        height: 16px;
                                                        stroke: currentColor;
                                                        fill: none;
                                                        stroke-width: 2.5;
                                                        margin-top: 2px;
                                                        flex-shrink: 0;
                                                    }

                                                    /* Custom Multiselect Dropdown Widget Styles */
                                                    .multiselect-wrapper {
                                                        position: relative;
                                                        width: 100%;
                                                    }

                                                    .multiselect-select-box {
                                                        min-height: 38px;
                                                        border: 1px solid var(--border-color);
                                                        border-radius: var(--radius-md);
                                                        padding: 6px 36px 6px 12px;
                                                        font-size: 14px;
                                                        display: flex;
                                                        flex-wrap: wrap;
                                                        gap: 6px;
                                                        background-color: #FFFFFF;
                                                        cursor: pointer;
                                                        position: relative;
                                                        transition: var(--transition);
                                                        align-items: center;
                                                    }

                                                    .multiselect-select-box:focus-within {
                                                        border-color: var(--primary);
                                                        box-shadow: 0 0 0 3px rgba(242, 111, 33, 0.15);
                                                    }

                                                    .multiselect-select-box::after {
                                                        content: "";
                                                        position: absolute;
                                                        right: 14px;
                                                        top: 50%;
                                                        transform: translateY(-50%);
                                                        border-left: 5px solid transparent;
                                                        border-right: 5px solid transparent;
                                                        border-top: 5px solid var(--text-muted);
                                                        pointer-events: none;
                                                    }

                                                    .multiselect-placeholder {
                                                        color: #94A3B8;
                                                        user-select: none;
                                                    }

                                                    .multiselect-dropdown-panel {
                                                        position: absolute;
                                                        left: 0;
                                                        right: 0;
                                                        top: calc(100% + 4px);
                                                        background-color: #FFFFFF;
                                                        border: 1px solid var(--border-color);
                                                        border-radius: var(--radius-md);
                                                        box-shadow: var(--shadow-lg);
                                                        z-index: 100;
                                                        display: none;
                                                        flex-direction: column;
                                                        overflow: hidden;
                                                        animation: fadeIn 0.15s ease;
                                                    }

                                                    .multiselect-dropdown-panel.open {
                                                        display: flex;
                                                    }

                                                    .multiselect-search-row {
                                                        padding: 10px 12px;
                                                        border-bottom: 1px solid var(--border-color);
                                                        background-color: #F8FAFC;
                                                        position: relative;
                                                    }

                                                    .multiselect-search-input {
                                                        width: 100%;
                                                        height: 34px;
                                                        border: 1px solid var(--border-color);
                                                        border-radius: var(--radius-sm);
                                                        padding: 0 10px 0 32px;
                                                        font-size: 13.5px;
                                                        outline: none;
                                                        box-sizing: border-box;
                                                        background-color: #FFFFFF;
                                                    }

                                                    .multiselect-search-input:focus {
                                                        border-color: var(--primary);
                                                    }

                                                    .multiselect-search-icon {
                                                        position: absolute;
                                                        left: 22px;
                                                        top: 20px;
                                                        width: 14px;
                                                        height: 14px;
                                                        fill: var(--text-muted);
                                                    }

                                                    .multiselect-options-list {
                                                        max-height: 200px;
                                                        overflow-y: auto;
                                                        display: flex;
                                                        flex-direction: column;
                                                        padding: 6px 0;
                                                    }

                                                    .multiselect-option {
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 10px;
                                                        padding: 8px 14px;
                                                        cursor: pointer;
                                                        transition: background-color 0.15s;
                                                        font-size: 13.5px;
                                                        color: var(--text-dark);
                                                        user-select: none;
                                                    }

                                                    .multiselect-option:hover {
                                                        background-color: #F1F5F9;
                                                    }

                                                    .multiselect-option input[type="checkbox"] {
                                                        width: 16px;
                                                        height: 16px;
                                                        cursor: pointer;
                                                    }

                                                    .multiselect-footer {
                                                        padding: 8px 14px;
                                                        border-top: 1px solid var(--border-color);
                                                        background-color: #F8FAFC;
                                                        display: flex;
                                                        justify-content: space-between;
                                                        align-items: center;
                                                        font-size: 12px;
                                                        color: var(--text-muted);
                                                        font-weight: 600;
                                                    }

                                                    .multiselect-clear-all {
                                                        color: var(--danger);
                                                        cursor: pointer;
                                                        text-decoration: none;
                                                    }

                                                    .multiselect-clear-all:hover {
                                                        text-decoration: underline;
                                                    }

                                                    .reviewer-tag {
                                                        background-color: #EFF6FF;
                                                        color: #1D4ED8;
                                                        border: 1px solid #BFDBFE;
                                                        padding: 2px 8px;
                                                        border-radius: var(--radius-sm);
                                                        font-size: 12px;
                                                        font-weight: 600;
                                                        display: inline-flex;
                                                        align-items: center;
                                                        gap: 4px;
                                                    }

                                                    .reviewer-tag .remove-tag {
                                                        cursor: pointer;
                                                        font-weight: 800;
                                                        color: #2563EB;
                                                    }

                                                    .reviewer-tag .remove-tag:hover {
                                                        color: #DC2626;
                                                    }

                                                    /* Multi-step Wizard Styles */
                                                    .step-progress {
                                                        display: flex;
                                                        justify-content: space-between;
                                                        align-items: center;
                                                        margin-bottom: 24px;
                                                        padding: 0 40px;
                                                        position: relative;
                                                    }

                                                    .step-progress-line {
                                                        position: absolute;
                                                        top: 18px;
                                                        left: 50px;
                                                        right: 50px;
                                                        height: 3px;
                                                        background-color: #E2E8F0;
                                                        z-index: 1;
                                                    }

                                                    .step-progress-active-line {
                                                        position: absolute;
                                                        top: 18px;
                                                        left: 50px;
                                                        width: 0%;
                                                        height: 3px;
                                                        background-color: var(--primary);
                                                        z-index: 2;
                                                        transition: width 0.3s ease;
                                                    }

                                                    .step-item {
                                                        display: flex;
                                                        flex-direction: column;
                                                        align-items: center;
                                                        z-index: 3;
                                                        position: relative;
                                                    }

                                                    .step-circle {
                                                        width: 36px;
                                                        height: 36px;
                                                        border-radius: 50%;
                                                        background-color: #E2E8F0;
                                                        color: #64748B;
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        font-weight: 700;
                                                        border: 3px solid white;
                                                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                                                        transition: all 0.3s ease;
                                                    }

                                                    .step-item.active .step-circle {
                                                        background-color: var(--primary);
                                                        color: white;
                                                    }

                                                    .step-title {
                                                        font-size: 12px;
                                                        font-weight: 600;
                                                        color: #64748B;
                                                        margin-top: 6px;
                                                        transition: all 0.3s ease;
                                                    }

                                                    .step-item.active .step-title {
                                                        color: var(--text-dark);
                                                        font-weight: 700;
                                                    }

                                                    .step-content {
                                                        padding: 8px 16px;
                                                    }

                                                    .dropzone-container {
                                                        border: 2px dashed #CBD5E1;
                                                        border-radius: 12px;
                                                        background-color: #F8FAFC;
                                                        padding: 32px 24px;
                                                        text-align: center;
                                                        cursor: pointer;
                                                        transition: all 0.2s ease;
                                                        margin-bottom: 24px;
                                                    }

                                                    .dropzone-container:hover,
                                                    .dropzone-container.dragover {
                                                        border-color: var(--primary);
                                                        background-color: #FFF7ED;
                                                    }

                                                    .dropzone-container.success {
                                                        border-color: #10B981;
                                                        background-color: #ECFDF5;
                                                    }

                                                    .upload-icon-wrapper {
                                                        width: 56px;
                                                        height: 56px;
                                                        background-color: #E6F4EA;
                                                        border-radius: 50%;
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        margin: 0 auto 16px auto;
                                                    }

                                                    .upload-title {
                                                        font-size: 16px;
                                                        font-weight: 700;
                                                        color: var(--text-dark);
                                                        margin: 0 0 4px 0;
                                                    }

                                                    .upload-sub {
                                                        font-size: 13px;
                                                        color: var(--text-muted);
                                                        margin: 0;
                                                    }

                                                </style>
                                            </head>

                                            <body>

                                                <div class="dashboard-wrapper">
                                                    <!-- ================= SIDEBAR ================= -->
                                                    <jsp:include page="../layout/sidebar.jsp" />

                                                    <!-- ================= MAIN CONTENT AREA ================= -->
                                                    <main class="dashboard-main">
                                                        <!-- ================= TOP HEADER ================= -->
                                                        <jsp:include page="../layout/header.jsp" />

                                                        <!-- ================= DYNAMIC WORKSPACE ================= -->
                                                        <div class="dashboard-content">
                                                            <div class="workspace-container">

                                                                <!-- General Workspace Header -->
                                                                <div class="workspace-header">
                                                                    <h1>Syllabus Role Assignments</h1>
                                                                    <button type="button" class="btn-primary"
                                                                        onclick="openCreateModal()">
                                                                        <svg width="18" height="18" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2.5" stroke-linecap="round"
                                                                            stroke-linejoin="round">
                                                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                                                        </svg>
                                                                        Add New Assignment
                                                                    </button>
                                                                </div>

                                                                <!-- Search Filter Row Card -->
                                                                <div class="card">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/role-assignment"
                                                                        method="get" class="filter-row">
                                                                        <div class="form-group search-group">
                                                                            <label for="searchKeyword">Search
                                                                                Assignments</label>
                                                                            <div class="search-input-wrapper">
                                                                                <svg viewBox="0 0 24 24">
                                                                                    <path
                                                                                        d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
                                                                                </svg>
                                                                                <input type="text" id="searchKeyword"
                                                                                    name="keyword" class="form-input"
                                                                                    placeholder="Search by course code, designer, reviewer..."
                                                                                    value="<%= request.getAttribute("keyword") == null ? "" : request.getAttribute("keyword") %>">
                                                                            </div>
                                                                        </div>

                                                                        <div class="form-group" style="flex: 1.5;">
                                                                            <label for="filterSemester">Filter by
                                                                                Semester</label>
                                                                            <select id="filterSemester"
                                                                                name="filterSemester"
                                                                                class="form-select"
                                                                                onchange="this.form.submit()">
                                                                                <% String
                                                                                    selectedFilterSemester=(String)
                                                                                    request.getAttribute("filterSemester");
                                                                                    if (selectedFilterSemester==null)
                                                                                    selectedFilterSemester="" ; %>
                                                                                    <option value="" <%=""
                                                                                        .equals(selectedFilterSemester)
                                                                                        ? "selected" : "" %>>-- All
                                                                                        Semesters --</option>
                                                                                    <option value="Spring" <%="Spring"
                                                                                        .equalsIgnoreCase(selectedFilterSemester)
                                                                                        ? "selected" : "" %>>Spring
                                                                                    </option>
                                                                                    <option value="Summer" <%="Summer"
                                                                                        .equalsIgnoreCase(selectedFilterSemester)
                                                                                        ? "selected" : "" %>>Summer
                                                                                    </option>
                                                                                    <option value="Fall" <%="Fall"
                                                                                        .equalsIgnoreCase(selectedFilterSemester)
                                                                                        ? "selected" : "" %>>Fall
                                                                                    </option>
                                                                            </select>
                                                                        </div>

                                                                        <div class="form-group" style="flex: 1.5;">
                                                                            <label for="filterYear">Filter by
                                                                                Year</label>
                                                                            <select id="filterYear" name="filterYear"
                                                                                class="form-select"
                                                                                onchange="this.form.submit()">
                                                                                <% Integer selectedFilterYear=(Integer)
                                                                                    request.getAttribute("filterYear");
                                                                                    %>
                                                                                    <option value=""
                                                                                        <%=selectedFilterYear==null
                                                                                        ? "selected" : "" %>>-- All
                                                                                        Years --</option>
                                                                                    <option value="2024"
                                                                                        <%=selectedFilterYear !=null &&
                                                                                        selectedFilterYear==2024
                                                                                        ? "selected" : "" %>>2024
                                                                                    </option>
                                                                                    <option value="2025"
                                                                                        <%=selectedFilterYear !=null &&
                                                                                        selectedFilterYear==2025
                                                                                        ? "selected" : "" %>>2025
                                                                                    </option>
                                                                                    <option value="2026"
                                                                                        <%=selectedFilterYear !=null &&
                                                                                        selectedFilterYear==2026
                                                                                        ? "selected" : "" %>>2026
                                                                                    </option>
                                                                                    <option value="2027"
                                                                                        <%=selectedFilterYear !=null &&
                                                                                        selectedFilterYear==2027
                                                                                        ? "selected" : "" %>>2027
                                                                                    </option>
                                                                                    <option value="2028"
                                                                                        <%=selectedFilterYear !=null &&
                                                                                        selectedFilterYear==2028
                                                                                        ? "selected" : "" %>>2028
                                                                                    </option>
                                                                            </select>
                                                                        </div>

                                                                        <button type="submit"
                                                                            class="btn-search">Search</button>
                                                                    </form>
                                                                </div>

                                                                <!-- Assignments Data Table Card -->
                                                                <div class="card table-card">
                                                                    <table class="data-table" id="assignmentTable">
                                                                        <thead>
                                                                            <tr>
                                                                                <th style="width: 80px;">ID</th>
                                                                                <th>Course</th>
                                                                                <th>Semester</th>
                                                                                <th>Academic Year</th>
                                                                                <th>Designer</th>
                                                                                <th>Reviewer</th>
                                                                                <th>Status</th>
                                                                                <th>Assigned At</th>
                                                                                <th style="width: 80px;">Actions</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <% if(assignmentList !=null &&
                                                                                !assignmentList.isEmpty()){
                                                                                for(SyllabusAssignment item :
                                                                                assignmentList){ // Format Status pill
                                                                                String
                                                                                status=item.getAssignmentStatus() !=null
                                                                                ? item.getAssignmentStatus() : "PENDING"
                                                                                ; String statusColor="#64748B" ; String
                                                                                statusBg="#F1F5F9" ; if
                                                                                ("PENDING".equals(status)) {
                                                                                statusColor="#D97706" ;
                                                                                statusBg="#FEF3C7" ; } else if
                                                                                ("ACCEPTED".equals(status) || "ACTIVE"
                                                                                .equals(status)) { statusColor="#059669"
                                                                                ; statusBg="#D1FAE5" ; } else if
                                                                                ("REJECTED".equals(status)) {
                                                                                statusColor="#DC2626" ;
                                                                                statusBg="#FEE2E2" ; } else if
                                                                                ("COMPLETED".equals(status)) {
                                                                                statusColor="#2563EB" ;
                                                                                statusBg="#DBEAFE" ; } String
                                                                                assignedAtStr="" ; if
                                                                                (item.getAssignedAt() !=null) {
                                                                                assignedAtStr=sdf.format(item.getAssignedAt());
                                                                                } %>
                                                                                <tr>
                                                                                    <td>
                                                                                        <%= item.getAssignmentId() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span class="badge-code">
                                                                                            <%= item.getCourseCode() %>
                                                                                        </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span class="badge-semester">
                                                                                            <%= item.getSemester() %>
                                                                                        </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span class="badge-year">
                                                                                            <%= item.getAcademicYear()
                                                                                                %>
                                                                                        </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span class="text-bold">
                                                                                            <%= item.getDesignerName()
                                                                                                %>
                                                                                        </span>
                                                                                        <br />
                                                                                        <small
                                                                                            style="color: var(--text-muted);">
                                                                                            <%= item.getDesignerEmail()
                                                                                                %>
                                                                                        </small>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span class="text-bold">
                                                                                            <%= item.getReviewerName()
                                                                                                %>
                                                                                        </span>
                                                                                        <br />
                                                                                        <small
                                                                                            style="color: var(--text-muted);">
                                                                                            <%= item.getReviewerEmail()
                                                                                                %>
                                                                                        </small>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span
                                                                                            style="display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 11px; font-weight: 800; text-transform: uppercase; color: <%= statusColor %>; background-color: <%= statusBg %>;">
                                                                                            <%= status %>
                                                                                        </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span
                                                                                            style="font-size: 13px; color: var(--text-dark); font-weight: 500;">
                                                                                            <%= assignedAtStr %>
                                                                                        </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div class="actions-cell">
                                                                                            <a href="${pageContext.request.contextPath}/role-assignment?action=detail&id=<%= item.getAssignmentId() %>"
                                                                                                class="btn-action btn-action-detail"
                                                                                                title="View Details">
                                                                                                <svg viewBox="0 0 24 24"
                                                                                                    width="16"
                                                                                                    height="16"
                                                                                                    fill="none"
                                                                                                    stroke="currentColor"
                                                                                                    stroke-width="2.5"
                                                                                                    stroke-linecap="round"
                                                                                                    stroke-linejoin="round">
                                                                                                    <path
                                                                                                        d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z">
                                                                                                    </path>
                                                                                                    <circle cx="12"
                                                                                                        cy="12" r="3">
                                                                                                    </circle>
                                                                                                </svg>
                                                                                            </a>
                                                                                            <a href="${pageContext.request.contextPath}/role-assignment?action=edit&id=<%= item.getAssignmentId() %>"
                                                                                                class="btn-action btn-action-edit"
                                                                                                title="Edit">
                                                                                                <svg
                                                                                                    viewBox="0 0 24 24">
                                                                                                    <path
                                                                                                        d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z">
                                                                                                    </path>
                                                                                                </svg>
                                                                                            </a>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } } else { %>
                                                                                    <tr>
                                                                                        <td colspan="9">
                                                                                            <div class="empty-state">
                                                                                                <div
                                                                                                    class="empty-state-icon">
                                                                                                    <svg width="32"
                                                                                                        height="32"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        viewBox="0 0 24 24">
                                                                                                        <path
                                                                                                            stroke-linecap="round"
                                                                                                            stroke-linejoin="round"
                                                                                                            stroke-width="2"
                                                                                                            d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                                                                                                    </svg>
                                                                                                </div>
                                                                                                <div class="text-bold">
                                                                                                    No Syllabus
                                                                                                    Assignments Found
                                                                                                </div>
                                                                                                <div
                                                                                                    class="empty-state-text">
                                                                                                    There are no
                                                                                                    syllabus role
                                                                                                    assignments matching
                                                                                                    the request.
                                                                                                </div>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } %>
                                                                        </tbody>
                                                                    </table>

                                                                    <!-- Client side Pagination Footer -->
                                                                    <% if(assignmentList !=null &&
                                                                        !assignmentList.isEmpty()){ %>
                                                                        <div class="pagination-footer">
                                                                            <div class="pagination-info"
                                                                                id="paginationInfo">
                                                                                Showing <span>0</span> to <span>0</span>
                                                                                of <span>
                                                                                    <%= assignmentList.size() %>
                                                                                </span> entries
                                                                            </div>
                                                                            <div class="pagination-controls">
                                                                                <button class="page-btn" id="btnFirst"
                                                                                    title="First Page">&lt;&lt;</button>
                                                                                <button class="page-btn" id="btnPrev"
                                                                                    title="Previous Page">&lt;</button>
                                                                                <span class="page-indicator"
                                                                                    id="pageIndicator">Page 1 of
                                                                                    1</span>
                                                                                <button class="page-btn" id="btnNext"
                                                                                    title="Next Page">&gt;</button>
                                                                                <button class="page-btn" id="btnLast"
                                                                                    title="Last Page">&gt;&gt;</button>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </main>
                                                </div>

                                                <!-- ================= ADD MAPPING MODAL ================= -->
                                                <div class="modal-overlay <%= "create".equals(action) ? "open" : "" %>"
                                                    id="createModal">
                                                    <div class="modal-container" style="max-width: 600px;">
                                                        <div class="modal-header" style="padding: 16px 24px;">
                                                            <h3
                                                                style="font-size: 20px; font-weight: 800; color: #0F172A; letter-spacing: -0.5px;">
                                                                Assign Syllabus Roles</h3>
                                                            <button class="modal-close"
                                                                onclick="closeModal('createModal')">
                                                                <svg width="20" height="20" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                                </svg>
                                                            </button>
                                                        </div>
                                                        <form
                                                            action="${pageContext.request.contextPath}/role-assignment?action=create"
                                                            method="post" enctype="multipart/form-data"
                                                            class="modal-form" onsubmit="return validateCreateForm()">
                                                            <div class="modal-body"
                                                                style="padding: 24px; max-height: 520px; overflow-y: auto;">

                                                                <!-- Wizard Progress Header -->
                                                                <div class="step-progress">
                                                                    <div class="step-progress-line"></div>
                                                                    <div id="stepProgressActiveLine"
                                                                        class="step-progress-active-line"></div>

                                                                    <!-- Step 1 Indicator -->
                                                                    <div class="step-item active" id="stepIndicator1">
                                                                        <div class="step-circle">1</div>
                                                                        <span class="step-title">Select Course</span>
                                                                    </div>

                                                                    <!-- Step 2 Indicator -->
                                                                    <div class="step-item" id="stepIndicator2">
                                                                        <div class="step-circle">2</div>
                                                                        <span class="step-title">Assign Roles</span>
                                                                    </div>

                                                                    <!-- Step 3 Indicator -->
                                                                    <div class="step-item" id="stepIndicator3">
                                                                        <div class="step-circle">3</div>
                                                                        <span class="step-title">Select Deadline</span>
                                                                    </div>

                                                                    <!-- Step 4 Indicator -->
                                                                    <div class="step-item" id="stepIndicator4">
                                                                        <div class="step-circle">4</div>
                                                                        <span class="step-title">Import Template</span>
                                                                    </div>
                                                                </div>

                                                                <!-- Step 1 Content -->
                                                                <div id="stepContent1" class="step-content">
                                                                    <!-- Course -->
                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="createCourseId">Course *</label>
                                                                        <select id="createCourseId" name="courseId"
                                                                            class="form-select" required>
                                                                            <option value="">-- Choose Course --
                                                                            </option>
                                                                            <% if(courses !=null) { for(Course c :
                                                                                courses) { boolean
                                                                                isSelected=String.valueOf(c.getCourseId()).equals(tempCourseId);
                                                                                %>
                                                                                <option value="<%= c.getCourseId() %>"
                                                                                    <%=isSelected ? "selected" : "" %>>
                                                                                    <%= c.getCode() %> - <%= c.getName()
                                                                                            %>
                                                                                </option>
                                                                                <% } } %>
                                                                        </select>
                                                                    </div>

                                                                    <!-- Semester -->
                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="createSemester">Semester *</label>
                                                                        <select id="createSemester" name="semester"
                                                                            class="form-select" required>
                                                                            <option value="Spring" <%="Spring"
                                                                                .equals(tempSemester) ? "selected" : ""
                                                                                %>>Spring</option>
                                                                            <option value="Summer" <%="Summer"
                                                                                .equals(tempSemester) ||
                                                                                tempSemester==null ? "selected" : "" %>
                                                                                >Summer</option>
                                                                            <option value="Fall" <%="Fall"
                                                                                .equals(tempSemester) ? "selected" : ""
                                                                                %>>Fall</option>
                                                                        </select>
                                                                    </div>

                                                                    <!-- Academic Year -->
                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="createYear">Academic Year *</label>
                                                                        <input type="number" id="createYear"
                                                                            name="academicYear" class="form-input"
                                                                            min="2020" max="2035"
                                                                            value="<%= tempYear %>" required />
                                                                    </div>
                                                                </div>

                                                                <!-- Step 2 Content -->
                                                                <div id="stepContent2" class="step-content"
                                                                    style="display: none;">
                                                                    <!-- Syllabus Designer -->
                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="createDesignerId">Syllabus Designer
                                                                            (Select one) *</label>
                                                                        <select id="createDesignerId" name="designerId"
                                                                            class="form-select"
                                                                            onchange="handleDesignerChange(this.value)"
                                                                            required>
                                                                            <option value="">-- Choose Lecturer --
                                                                            </option>
                                                                            <% if(lecturers !=null) { for(User u :
                                                                                lecturers) { String
                                                                                fullName=u.getFirstName() + " " +
                                                                                u.getLastName(); boolean
                                                                                isSelected=String.valueOf(u.getUserId()).equals(tempDesignerId);
                                                                                %>
                                                                                <option value="<%= u.getUserId() %>"
                                                                                    <%=isSelected ? "selected" : "" %>>
                                                                                    <%= fullName %> (<%= u.getEmail() %>
                                                                                            )</option>
                                                                                <% } } %>
                                                                        </select>
                                                                    </div>

                                                                    <!-- Syllabus Reviewer (Select one or more) -->
                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label>Syllabus Reviewer (Select one or more)
                                                                            *</label>
                                                                        <div class="multiselect-wrapper">
                                                                            <!-- Display selected tag badges or placeholder -->
                                                                            <div class="multiselect-select-box"
                                                                                id="reviewerSelectBox"
                                                                                onclick="toggleReviewerPanel(event)">
                                                                                <span class="multiselect-placeholder"
                                                                                    id="reviewerPlaceholder">--Choose
                                                                                    Reviewer--</span>
                                                                            </div>

                                                                            <!-- Search & Checkbox list panel -->
                                                                            <div class="multiselect-dropdown-panel"
                                                                                id="reviewerDropdownPanel">
                                                                                <div class="multiselect-search-row"
                                                                                    onclick="event.stopPropagation()">
                                                                                    <svg class="multiselect-search-icon"
                                                                                        viewBox="0 0 24 24">
                                                                                        <path
                                                                                            d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
                                                                                    </svg>
                                                                                    <input type="text"
                                                                                        class="multiselect-search-input"
                                                                                        id="reviewerSearchInput"
                                                                                        placeholder="Search reviewer..."
                                                                                        oninput="filterReviewersList(this.value)">
                                                                                </div>
                                                                                <div class="multiselect-options-list"
                                                                                    id="reviewerOptionsList"
                                                                                    onclick="event.stopPropagation()">
                                                                                    <% if(lecturers !=null) { for(User u
                                                                                        : lecturers) { String
                                                                                        fullName=u.getFirstName() + " "
                                                                                        + u.getLastName(); %>
                                                                                        <label
                                                                                            class="multiselect-option"
                                                                                            data-name="<%= fullName.toLowerCase() %> <%= u.getEmail().toLowerCase() %>"
                                                                                            id="reviewer-opt-<%= u.getUserId() %>">
                                                                                            <input type="checkbox"
                                                                                                name="reviewerId"
                                                                                                value="<%= u.getUserId() %>"
                                                                                                onchange="handleReviewerCheckboxChange(this, '<%= fullName %> (<%= u.getEmail() %>)')">
                                                                                            <span>
                                                                                                <%= fullName %> (<%=
                                                                                                        u.getEmail() %>)
                                                                                            </span>
                                                                                        </label>
                                                                                        <% } } %>
                                                                                </div>
                                                                                <div class="multiselect-footer"
                                                                                    onclick="event.stopPropagation()">
                                                                                    <span id="selectedReviewersText">0
                                                                                        reviewers selected</span>
                                                                                    <a href="javascript:void(0)"
                                                                                        class="multiselect-clear-all"
                                                                                        onclick="clearAllReviewers()">Clear
                                                                                        all</a>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Step 3 Content (Select Deadline) -->
                                                                <div id="stepContent3" class="step-content"
                                                                    style="display: none;">
                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="createDueDate">Deadline (Due Date) *</label>
                                                                        <input type="datetime-local" id="createDueDate"
                                                                            name="dueDate" class="form-input" required />
                                                                    </div>
                                                                </div>

                                                                <!-- Step 4 Content -->
                                                                <div id="stepContent4" class="step-content"
                                                                    style="display: none;">
                                                                    <div id="dropZone" class="dropzone-container">
                                                                        <input type="file" id="templateFileInput"
                                                                            name="templateFile" accept=".xlsx, .xls"
                                                                            style="display: none;"
                                                                            onchange="handleFileSelect(this)" />
                                                                        <div class="upload-icon-wrapper">
                                                                            <svg fill="none" stroke="#10B981"
                                                                                stroke-width="2" viewBox="0 0 24 24"
                                                                                width="28" height="28">
                                                                                <path stroke-linecap="round"
                                                                                    stroke-linejoin="round"
                                                                                    d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                                                                            </svg>
                                                                        </div>
                                                                        <h4 id="uploadTitle" class="upload-title">Click
                                                                            to choose Excel file</h4>
                                                                        <p id="uploadSub" class="upload-sub">Supports
                                                                            .xlsx, .xls templates</p>
                                                                    </div>
                                                                </div>

                                                            </div>
                                                            <div class="modal-footer"
                                                                style="padding: 16px 24px; justify-content: space-between;">
                                                                <div>
                                                                    <button type="button" class="btn-secondary"
                                                                        id="btnStepPrev"
                                                                        onclick="goToStep(currentStep - 1)"
                                                                        style="display: none;">Back</button>
                                                                </div>
                                                                <div style="display: flex; gap: 8px;">
                                                                    <button type="button" class="btn-secondary"
                                                                        id="btnCancelModal"
                                                                        onclick="closeModal('createModal')">Cancel</button>
                                                                    <button type="button" class="btn-primary"
                                                                        id="btnStepNext"
                                                                        onclick="handleStepNext()">Next</button>
                                                                    <button type="submit" class="btn-primary"
                                                                        id="btnSubmitForm"
                                                                        style="display: none; background-color: #EA580C; border-color: #EA580C;">
                                                                        <svg fill="none" stroke="currentColor"
                                                                            stroke-width="2.5" viewBox="0 0 24 24"
                                                                            width="16" height="16"
                                                                            style="display: inline-block; vertical-align: middle; margin-right: 6px;">
                                                                            <path stroke-linecap="round"
                                                                                stroke-linejoin="round"
                                                                                d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                                                                        </svg>
                                                                        <span style="vertical-align: middle;">Import &
                                                                            Clone</span>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                                </div>
                                                </div>

                                                <!-- ================= EDIT MAPPING MODAL ================= -->
                                                <div class="modal-overlay <%= "edit".equals(action) && editAssignment
                                                    !=null ? "open" : "" %>" id="editModal">
                                                    <div class="modal-container">
                                                        <div class="modal-header">
                                                            <h3>Edit Syllabus Role Assignment</h3>
                                                            <button class="modal-close"
                                                                onclick="closeModal('editModal')">
                                                                <svg width="20" height="20" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                                </svg>
                                                            </button>
                                                        </div>
                                                        <% if(editAssignment !=null) { %>
                                                            <form
                                                                action="${pageContext.request.contextPath}/role-assignment?action=edit"
                                                                method="post" class="modal-form"
                                                                onsubmit="return validateRoles('editDesignerId', 'editReviewerId')">
                                                                <input type="hidden" name="assignmentId"
                                                                    value="<%= editAssignment.getAssignmentId() %>">
                                                                <div class="modal-body">

                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="editCourseId">Course *</label>
                                                                        <select id="editCourseId" name="courseId"
                                                                            class="form-select" required>
                                                                            <% if(courses !=null) { for(Course c :
                                                                                courses) { boolean
                                                                                isSelected=c.getCourseId()==editAssignment.getCourseId();
                                                                                %>
                                                                                <option value="<%= c.getCourseId() %>"
                                                                                    <%=isSelected ? "selected" : "" %>>
                                                                                    <%= c.getCode() %> - <%= c.getName()
                                                                                            %>
                                                                                </option>
                                                                                <% } } %>
                                                                        </select>
                                                                    </div>

                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="editSemester">Semester *</label>
                                                                        <select id="editSemester" name="semester"
                                                                            class="form-select" required>
                                                                            <option value="Spring" <%="Spring"
                                                                                .equals(editAssignment.getSemester())
                                                                                ? "selected" : "" %>>Spring</option>
                                                                            <option value="Summer" <%="Summer"
                                                                                .equals(editAssignment.getSemester())
                                                                                ? "selected" : "" %>>Summer</option>
                                                                            <option value="Fall" <%="Fall"
                                                                                .equals(editAssignment.getSemester())
                                                                                ? "selected" : "" %>>Fall</option>
                                                                        </select>
                                                                    </div>

                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="editYear">Academic Year *</label>
                                                                        <input type="number" id="editYear"
                                                                            name="academicYear" class="form-input"
                                                                            min="2020" max="2035"
                                                                            value="<%= editAssignment.getAcademicYear() %>"
                                                                            required />
                                                                    </div>

                                                                    <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="editDesignerId">Syllabus Designer
                                                                            *</label>
                                                                        <select id="editDesignerId" name="designerId"
                                                                            class="form-select" required>
                                                                            <% if(lecturers !=null) { for(User u :
                                                                                lecturers) { String
                                                                                fullName=u.getFirstName() + " " +
                                                                                u.getLastName(); boolean
                                                                                isSelected=u.getUserId()==editAssignment.getDesignerId();
                                                                                %>
                                                                                <option value="<%= u.getUserId() %>"
                                                                                    <%=isSelected ? "selected" : "" %>>
                                                                                    <%= fullName %> (<%= u.getEmail() %>
                                                                                            )</option>
                                                                                <% } } %>
                                                                        </select>
                                                                    </div>

                                                                     <div class="form-group"
                                                                        style="margin-bottom: 16px;">
                                                                        <label for="editReviewerId">Syllabus Reviewer
                                                                            *</label>
                                                                        <select id="editReviewerId" name="reviewerId"
                                                                            class="form-select" required>
                                                                            <% if(lecturers !=null) { for(User u :
                                                                                lecturers) { String
                                                                                fullName=u.getFirstName() + " " +
                                                                                u.getLastName(); boolean
                                                                                isSelected=u.getUserId()==editAssignment.getReviewerId();
                                                                                %>
                                                                                <option value="<%= u.getUserId() %>"
                                                                                    <%=isSelected ? "selected" : "" %>>
                                                                                    <%= fullName %> (<%= u.getEmail() %>
                                                                                            )</option>
                                                                                <% } } %>
                                                                        </select>
                                                                    </div>

                                                                    <!-- Deadline (Due Date) -->
                                                                    <div class="form-group" style="margin-bottom: 16px;">
                                                                        <label for="editDueDate">Deadline (Due Date) *</label>
                                                                        <%
                                                                        String editDueDateStr = "";
                                                                        if (editAssignment.getDueDate() != null) {
                                                                            editDueDateStr = editAssignment.getDueDate().toString().substring(0, 16).replace(" ", "T");
                                                                        }
                                                                        %>
                                                                        <input type="datetime-local" id="editDueDate"
                                                                            name="dueDate" class="form-input" 
                                                                            value="<%= editDueDateStr %>" required />
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn-secondary"
                                                                        onclick="closeModal('editModal')">Cancel</button>
                                                                    <button type="submit" class="btn-primary">Update
                                                                        Assignment</button>
                                                                </div>
                                                            </form>
                                                            <% } %>
                                                    </div>
                                                </div>

                                                <!-- ================= DETAIL MAPPING MODAL ================= -->
                                                <div class="modal-overlay <%= "detail".equals(action) &&
                                                    detailAssignment !=null ? "open" : "" %>" id="detailModal">
                                                    <div class="modal-container" style="max-width: 600px;">
                                                        <div class="modal-header">
                                                            <h3>Syllabus Assignment Details</h3>
                                                            <button class="modal-close"
                                                                onclick="closeModal('detailModal')">
                                                                <svg width="20" height="20" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                                                </svg>
                                                            </button>
                                                        </div>
                                                        <% if(detailAssignment !=null) { %>
                                                            <div class="modal-body"
                                                                style="padding: 24px; font-size: 14px; line-height: 1.6; color: var(--text-dark);">
                                                                <div
                                                                    style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                                                                    <div>
                                                                        <strong
                                                                            style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 4px;">Assignment
                                                                            ID</strong>
                                                                        <span
                                                                            style="font-weight: 600; font-size: 16px;">
                                                                            <%= detailAssignment.getAssignmentId() %>
                                                                        </span>
                                                                    </div>
                                                                    <div>
                                                                        <strong
                                                                            style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 4px;">Status</strong>
                                                                        <% String
                                                                            status=detailAssignment.getAssignmentStatus()
                                                                            !=null ?
                                                                            detailAssignment.getAssignmentStatus()
                                                                            : "PENDING" ; String statusColor="#64748B" ;
                                                                            String statusBg="#F1F5F9" ; if
                                                                            ("PENDING".equals(status)) {
                                                                            statusColor="#D97706" ; statusBg="#FEF3C7" ;
                                                                            } else if ("ACCEPTED".equals(status)
                                                                            || "ACTIVE" .equals(status)) {
                                                                            statusColor="#059669" ; statusBg="#D1FAE5" ;
                                                                            } else if ("REJECTED".equals(status)) {
                                                                            statusColor="#DC2626" ; statusBg="#FEE2E2" ;
                                                                            } else if ("COMPLETED".equals(status)) {
                                                                            statusColor="#2563EB" ; statusBg="#DBEAFE" ;
                                                                            } %>
                                                                            <span
                                                                                style="display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 800; text-transform: uppercase; color: <%= statusColor %>; background-color: <%= statusBg %>;">
                                                                                <%= status %>
                                                                            </span>
                                                                    </div>
                                                                </div>

                                                                <div
                                                                    style="border-top: 1px solid var(--border-color); padding-top: 16px; margin-bottom: 20px;">
                                                                    <div style="margin-bottom: 12px;">
                                                                        <strong
                                                                            style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 4px;">Course</strong>
                                                                        <span
                                                                            style="font-weight: 600; font-size: 15px; display: inline-flex; align-items: center; gap: 8px;">
                                                                            <span class="badge-code" style="margin: 0;">
                                                                                <%= detailAssignment.getCourseCode() %>
                                                                            </span>
                                                                            <% if (detailAssignment.getCourseName()
                                                                                !=null &&
                                                                                !detailAssignment.getCourseName().isEmpty())
                                                                                { %>
                                                                                - <%= detailAssignment.getCourseName()
                                                                                    %>
                                                                                    <% } %>
                                                                        </span>
                                                                    </div>
                                                                    <div
                                                                        style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                                                        <div>
                                                                            <strong
                                                                                style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 4px;">Semester</strong>
                                                                            <span style="font-weight: 600;"
                                                                                class="badge-semester">
                                                                                <%= detailAssignment.getSemester() %>
                                                                            </span>
                                                                        </div>
                                                                        <div>
                                                                            <strong
                                                                                style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 4px;">Academic
                                                                                Year</strong>
                                                                            <span style="font-weight: 600;"
                                                                                class="badge-year">
                                                                                <%= detailAssignment.getAcademicYear()
                                                                                    %>
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div
                                                                    style="border-top: 1px solid var(--border-color); padding-top: 16px; margin-bottom: 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                                                    <div>
                                                                        <strong
                                                                            style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 6px;">Syllabus
                                                                            Designer</strong>
                                                                        <div
                                                                            style="background: #F8FAFC; border: 1px solid var(--border-color); padding: 10px; border-radius: var(--radius-md);">
                                                                            <span
                                                                                style="font-weight: 700; color: var(--text-dark); display: block;">
                                                                                <%= detailAssignment.getDesignerName()
                                                                                    %>
                                                                            </span>
                                                                            <small
                                                                                style="color: var(--text-muted); word-break: break-all;">
                                                                                <%= detailAssignment.getDesignerEmail()
                                                                                    %>
                                                                            </small>
                                                                        </div>
                                                                    </div>
                                                                    <div>
                                                                        <strong
                                                                            style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 6px;">Syllabus
                                                                            Reviewer</strong>
                                                                        <div
                                                                            style="background: #F8FAFC; border: 1px solid var(--border-color); padding: 10px; border-radius: var(--radius-md);">
                                                                            <span
                                                                                style="font-weight: 700; color: var(--text-dark); display: block;">
                                                                                <%= detailAssignment.getReviewerName()
                                                                                    %>
                                                                            </span>
                                                                            <small
                                                                                style="color: var(--text-muted); word-break: break-all;">
                                                                                <%= detailAssignment.getReviewerEmail()
                                                                                    %>
                                                                            </small>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div
                                                                    style="border-top: 1px solid var(--border-color); padding-top: 16px; display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                                                    <div>
                                                                        <strong
                                                                            style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 4px;">Assigned
                                                                            At</strong>
                                                                        <span
                                                                            style="font-weight: 600; color: var(--text-dark);">
                                                                            <%= detailAssignment.getAssignedAt() !=null
                                                                                ?
                                                                                sdf.format(detailAssignment.getAssignedAt())
                                                                                : "N/A" %>
                                                                        </span>
                                                                    </div>
                                                                    <div>
                                                                        <strong
                                                                            style="color: var(--text-muted); font-size: 12px; text-transform: uppercase; display: block; margin-bottom: 4px;">Deadline
                                                                            (Due Date)</strong>
                                                                        <span
                                                                            style="font-weight: 600; color: #DC2626;">
                                                                            <%= detailAssignment.getDueDate() !=null
                                                                                ?
                                                                                sdf.format(detailAssignment.getDueDate())
                                                                                : "No Deadline" %>
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn-primary"
                                                                    onclick="closeModal('detailModal')">Close</button>
                                                            </div>
                                                            <% } %>
                                                    </div>
                                                </div>

                                                <!-- Client-side Pagination & Modal Controllers JS -->
                                                <script>
                                                    let selectedReviewers = []; // array of {id, name}

                                                    function toggleReviewerPanel(e) {
                                                        e.stopPropagation();
                                                        document.getElementById('reviewerDropdownPanel').classList.toggle('open');
                                                    }

                                                    // Close dropdown when clicking outside
                                                    document.addEventListener('click', function (e) {
                                                        const panel = document.getElementById('reviewerDropdownPanel');
                                                        const selectBox = document.getElementById('reviewerSelectBox');
                                                        if (panel && !panel.contains(e.target) && !selectBox.contains(e.target)) {
                                                            panel.classList.remove('open');
                                                        }
                                                    });

                                                    function handleReviewerCheckboxChange(checkbox, fullName) {
                                                        const id = checkbox.value;
                                                        if (checkbox.checked) {
                                                            if (!selectedReviewers.some(r => r.id === id)) {
                                                                selectedReviewers.push({ id: id, name: fullName });
                                                            }
                                                        } else {
                                                            selectedReviewers = selectedReviewers.filter(r => r.id !== id);
                                                        }
                                                        renderReviewerTags();
                                                    }

                                                    function removeReviewerTag(id, event) {
                                                        if (event) {
                                                            event.stopPropagation();
                                                        }
                                                        selectedReviewers = selectedReviewers.filter(r => r.id !== id);

                                                        // Uncheck the checkbox in panel
                                                        const checkbox = document.querySelector('input[name="reviewerId"][value="' + id + '"]');
                                                        if (checkbox) {
                                                            checkbox.checked = false;
                                                        }

                                                        renderReviewerTags();
                                                    }

                                                    function clearAllReviewers() {
                                                        selectedReviewers = [];
                                                        const checkboxes = document.querySelectorAll('input[name="reviewerId"]');
                                                        checkboxes.forEach(cb => {
                                                            cb.checked = false;
                                                        });
                                                        renderReviewerTags();
                                                    }

                                                    function filterReviewersList(query) {
                                                        const lowerQuery = query.toLowerCase().trim();
                                                        const options = document.querySelectorAll('.multiselect-option');
                                                        options.forEach(opt => {
                                                            const name = opt.getAttribute('data-name');
                                                            if (name.includes(lowerQuery)) {
                                                                opt.style.display = 'flex';
                                                            } else {
                                                                opt.style.display = 'none';
                                                            }
                                                        });
                                                    }

                                                    function renderReviewerTags() {
                                                        const selectBox = document.getElementById('reviewerSelectBox');
                                                        const placeholder = document.getElementById('reviewerPlaceholder');
                                                        const countText = document.getElementById('selectedReviewersText');
                                                        if (!selectBox || !placeholder || !countText) return;

                                                        // Remove existing tag elements
                                                        const existingTags = selectBox.querySelectorAll('.reviewer-tag');
                                                        existingTags.forEach(t => t.remove());

                                                        if (selectedReviewers.length === 0) {
                                                            placeholder.style.display = 'block';
                                                            countText.textContent = '0 reviewers selected';
                                                        } else {
                                                            placeholder.style.display = 'none';
                                                            countText.textContent = selectedReviewers.length + ' reviewer' + (selectedReviewers.length > 1 ? 's' : '') + ' selected';

                                                            // Append tags
                                                            selectedReviewers.forEach(r => {
                                                                const tag = document.createElement('span');
                                                                tag.className = 'reviewer-tag';
                                                                tag.innerHTML = r.name + ' <span class="remove-tag" onclick="removeReviewerTag(\'' + r.id + '\', event)">&times;</span>';
                                                                selectBox.insertBefore(tag, null);
                                                            });
                                                        }
                                                    }

                                                    function handleDesignerChange(designerId) {
                                                        // Uncheck and disable the designer in reviewers list
                                                        const options = document.querySelectorAll('.multiselect-option');
                                                        options.forEach(opt => {
                                                            const checkbox = opt.querySelector('input[type="checkbox"]');
                                                            if (checkbox) {
                                                                if (checkbox.value === designerId) {
                                                                    checkbox.checked = false;
                                                                    checkbox.disabled = true;
                                                                    opt.style.opacity = '0.5';
                                                                    opt.style.cursor = 'not-allowed';
                                                                    // Remove from selected list if it was checked
                                                                    removeReviewerTag(designerId);
                                                                } else {
                                                                    checkbox.disabled = false;
                                                                    opt.style.opacity = '1';
                                                                    opt.style.cursor = 'pointer';
                                                                }
                                                            }
                                                        });
                                                    }

                                                    let currentStep = 1;

                                                    function goToStep(step) {
                                                        if (step < 1 || step > 4) return;

                                                        // Hide all step contents
                                                        document.getElementById('stepContent1').style.display = 'none';
                                                        document.getElementById('stepContent2').style.display = 'none';
                                                        document.getElementById('stepContent3').style.display = 'none';
                                                        document.getElementById('stepContent4').style.display = 'none';

                                                        // Show current step content
                                                        document.getElementById('stepContent' + step).style.display = 'block';

                                                        // Update active line width
                                                        const line = document.getElementById('stepProgressActiveLine');
                                                        if (step === 1) line.style.width = '0%';
                                                        else if (step === 2) line.style.width = '33.33%';
                                                        else if (step === 3) line.style.width = '66.67%';
                                                        else if (step === 4) line.style.width = '100%';

                                                        // Update step Indicators css
                                                        for (let i = 1; i <= 4; i++) {
                                                            const indicator = document.getElementById('stepIndicator' + i);
                                                            const circle = indicator.querySelector('.step-circle');
                                                            const title = indicator.querySelector('.step-title');

                                                            if (i < step) {
                                                                // Completed step
                                                                circle.style.backgroundColor = '#10B981'; // Green
                                                                circle.style.color = 'white';
                                                                circle.innerHTML = '✓';
                                                                title.style.color = '#10B981';
                                                                title.style.fontWeight = '700';
                                                            } else if (i === step) {
                                                                // Current step
                                                                circle.style.backgroundColor = '#F97316'; // Orange
                                                                circle.style.color = 'white';
                                                                circle.innerHTML = i;
                                                                title.style.color = '#1E293B';
                                                                title.style.fontWeight = '700';
                                                            } else {
                                                                // Future step
                                                                circle.style.backgroundColor = '#E2E8F0'; // Slate
                                                                circle.style.color = '#64748B';
                                                                circle.innerHTML = i;
                                                                title.style.color = '#64748B';
                                                                title.style.fontWeight = '600';
                                                            }
                                                        }

                                                        // Update buttons
                                                        currentStep = step;
                                                        if (currentStep === 1) {
                                                            document.getElementById('btnStepPrev').style.display = 'none';
                                                            document.getElementById('btnCancelModal').style.display = 'block';
                                                            document.getElementById('btnStepNext').style.display = 'block';
                                                            document.getElementById('btnSubmitForm').style.display = 'none';
                                                        } else if (currentStep === 2) {
                                                            document.getElementById('btnStepPrev').style.display = 'block';
                                                            document.getElementById('btnCancelModal').style.display = 'none';
                                                            document.getElementById('btnStepNext').style.display = 'block';
                                                            document.getElementById('btnSubmitForm').style.display = 'none';
                                                        } else if (currentStep === 3) {
                                                            document.getElementById('btnStepPrev').style.display = 'block';
                                                            document.getElementById('btnCancelModal').style.display = 'none';
                                                            document.getElementById('btnStepNext').style.display = 'block';
                                                            document.getElementById('btnSubmitForm').style.display = 'none';
                                                        } else if (currentStep === 4) {
                                                            document.getElementById('btnStepPrev').style.display = 'block';
                                                            document.getElementById('btnCancelModal').style.display = 'none';
                                                            document.getElementById('btnStepNext').style.display = 'none';
                                                            document.getElementById('btnSubmitForm').style.display = 'block';
                                                        }
                                                    }

                                                    function handleStepNext() {
                                                        if (currentStep === 1) {
                                                            // Validate Step 1
                                                            const course = document.getElementById('createCourseId').value;
                                                            if (!course) {
                                                                showToast("Please select a subject course.", false);
                                                                return;
                                                            }
                                                            const semester = document.getElementById('createSemester').value;
                                                            if (!semester) {
                                                                showToast("Please select a semester.", false);
                                                                return;
                                                            }
                                                            const year = document.getElementById('createYear').value;
                                                            if (!year || year < 2020 || year > 2035) {
                                                                showToast("Please enter a valid academic year between 2020 and 2035.", false);
                                                                return;
                                                            }
                                                            goToStep(2);
                                                        } else if (currentStep === 2) {
                                                            // Validate Step 2
                                                            const designer = document.getElementById('createDesignerId').value;
                                                            if (!designer) {
                                                                showToast("Please select a syllabus designer.", false);
                                                                return;
                                                            }
                                                            if (selectedReviewers.length === 0) {
                                                                showToast("Please select at least one syllabus reviewer.", false);
                                                                return;
                                                            }
                                                            goToStep(3);
                                                        } else if (currentStep === 3) {
                                                            // Validate Step 3
                                                            const dueDate = document.getElementById('createDueDate').value;
                                                            if (!dueDate) {
                                                                showToast("Please select a deadline.", false);
                                                                return;
                                                            }
                                                            goToStep(4);
                                                        }
                                                    }

                                                    function handleFileSelect(input) {
                                                        const file = input.files[0];
                                                        const dropZone = document.getElementById('dropZone');
                                                        if (file) {
                                                            const extension = file.name.split('.').pop().toLowerCase();
                                                            if (extension !== 'xlsx' && extension !== 'xls') {
                                                                showToast("Invalid file format. Please upload .xlsx or .xls file.", false);
                                                                input.value = '';
                                                                document.getElementById('uploadTitle').innerText = 'Click to choose Excel file';
                                                                document.getElementById('uploadSub').innerText = 'Supports .xlsx, .xls templates';
                                                                dropZone.className = 'dropzone-container';
                                                                return;
                                                            }
                                                            document.getElementById('uploadTitle').innerText = file.name;
                                                            document.getElementById('uploadSub').innerText = (file.size / 1024).toFixed(1) + ' KB';
                                                            dropZone.className = 'dropzone-container success';
                                                        }
                                                    }

                                                    function validateCreateForm() {
                                                        const course = document.getElementById('createCourseId').value;
                                                        const designer = document.getElementById('createDesignerId').value;
                                                        const fileInput = document.getElementById('templateFileInput');

                                                        if (!course) {
                                                            showToast("Please select a subject course.", false);
                                                            goToStep(1);
                                                            return false;
                                                        }
                                                        if (!designer) {
                                                            showToast("Please select a syllabus designer.", false);
                                                            goToStep(2);
                                                            return false;
                                                        }
                                                        if (selectedReviewers.length === 0) {
                                                            showToast("Please select at least one syllabus reviewer.", false);
                                                            goToStep(2);
                                                            return false;
                                                        }
                                                        if (!fileInput.files || fileInput.files.length === 0) {
                                                            showToast("Please select/upload an Excel template file to proceed.", false);
                                                            goToStep(3);
                                                            return false;
                                                        }
                                                        return true;
                                                    }

                                                    function openCreateModal() {
                                                        clearAllReviewers();
                                                        document.getElementById('createCourseId').value = '';
                                                        document.getElementById('createDesignerId').value = '';
                                                        document.getElementById('templateFileInput').value = '';
                                                        document.getElementById('uploadTitle').innerText = 'Click to choose Excel file';
                                                        document.getElementById('uploadSub').innerText = 'Supports .xlsx, .xls templates';
                                                        document.getElementById('dropZone').className = 'dropzone-container';
                                                        handleDesignerChange('');
                                                        document.getElementById('createModal').classList.add('open');
                                                        goToStep(1);
                                                    }

                                                    function closeModal(modalId) {
                                                        document.getElementById(modalId).classList.remove('open');
                                                        const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                                                        window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
                                                    }

                                                    function validateRoles(designerSelectId, reviewerSelectId) {
                                                        const designer = document.getElementById(designerSelectId).value;
                                                        const reviewer = document.getElementById(reviewerSelectId).value;
                                                        if (designer && reviewer && designer === reviewer) {
                                                            showToast("Syllabus Designer and Reviewer must be different accounts.", false);
                                                            return false;
                                                        }
                                                        return true;
                                                    }

                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        const table = document.getElementById('assignmentTable');
                                                        if (table) {
                                                            const tbody = table.querySelector('tbody');
                                                            const rows = Array.from(tbody.querySelectorAll('tr'));

                                                            const isNoData = rows.length === 1 && rows[0].cells.length === 1 && rows[0].querySelector('.empty-state');
                                                            if (!isNoData) {
                                                                const rowsPerPage = 5;
                                                                let currentPage = 1;
                                                                const totalPages = Math.ceil(rows.length / rowsPerPage);

                                                                function showPage(page) {
                                                                    currentPage = page;
                                                                    const start = (page - 1) * rowsPerPage;
                                                                    const end = Math.min(start + rowsPerPage, rows.length);

                                                                    rows.forEach((row, index) => {
                                                                        if (index >= start && index < end) {
                                                                            row.style.display = '';
                                                                        } else {
                                                                            row.style.display = 'none';
                                                                        }
                                                                    });

                                                                    document.getElementById('pageIndicator').textContent = 'Page ' + page + ' of ' + totalPages;
                                                                    document.getElementById('paginationInfo').innerHTML = 'Showing <span>' + (start + 1) + '</span> to <span>' + end + '</span> of <span>' + rows.length + '</span> entries';

                                                                    document.getElementById('btnFirst').disabled = (page === 1);
                                                                    document.getElementById('btnPrev').disabled = (page === 1);
                                                                    document.getElementById('btnNext').disabled = (page === totalPages);
                                                                    document.getElementById('btnLast').disabled = (page === totalPages);
                                                                }

                                                                document.getElementById('btnFirst').addEventListener('click', () => showPage(1));
                                                                document.getElementById('btnPrev').addEventListener('click', () => showPage(currentPage - 1));
                                                                document.getElementById('btnNext').addEventListener('click', () => showPage(currentPage + 1));
                                                                document.getElementById('btnLast').addEventListener('click', () => showPage(totalPages));

                                                                showPage(1);
                                                            }
                                                        }

                                                        // Drag and drop zone file handling
                                                        const dropZone = document.getElementById('dropZone');
                                                        if (dropZone) {
                                                            dropZone.addEventListener('click', () => {
                                                                document.getElementById('templateFileInput').click();
                                                            });
                                                            document.getElementById('templateFileInput').addEventListener('click', (e) => {
                                                                e.stopPropagation();
                                                            });

                                                            ['dragenter', 'dragover'].forEach(eventName => {
                                                                dropZone.addEventListener(eventName, (e) => {
                                                                    e.preventDefault();
                                                                    e.stopPropagation();
                                                                    dropZone.className = 'dropzone-container dragover';
                                                                }, false);
                                                            });

                                                            ['dragleave', 'drop'].forEach(eventName => {
                                                                dropZone.addEventListener(eventName, (e) => {
                                                                    e.preventDefault();
                                                                    e.stopPropagation();
                                                                    if (eventName === 'drop') {
                                                                        const dt = e.dataTransfer;
                                                                        const files = dt.files;
                                                                        if (files.length > 0) {
                                                                            document.getElementById('templateFileInput').files = files;
                                                                            handleFileSelect(document.getElementById('templateFileInput'));
                                                                        }
                                                                    } else {
                                                                        if (!document.getElementById('templateFileInput').files.length) {
                                                                            dropZone.className = 'dropzone-container';
                                                                        } else {
                                                                            dropZone.className = 'dropzone-container success';
                                                                        }
                                                                    }
                                                                }, false);
                                                            });
                                                        }

                                                        // Display Toast messages on Load
                                                        const successMsg = "<%= successMessage != null ? successMessage.replace("\"", "\\\"").replace("\n", "\\n") : "" %> ";
                                                    const errorMsg = "<%= errorMessage != null ? errorMessage.replace("\"", "\\\"").replace("\n", "\\n") : "" %> ";
                                                    if (successMsg && successMsg.trim().length > 0) {
                                                        showToast(successMsg, true);
                                                    }
                                                    if (errorMsg && errorMsg.trim().length > 0) {
                                                        showToast(errorMsg, false);
                                                    }
        });

                                                    function showToast(message, isSuccess = true) {
                                                        const toast = document.getElementById('toast');
                                                        const toastIcon = document.getElementById('toastIcon');
                                                        const toastMessage = document.getElementById('toastMessage');

                                                        toastMessage.textContent = message;
                                                        if (isSuccess) {
                                                            toastIcon.textContent = '✓';
                                                            toast.className = 'toast show toast-success';
                                                        } else {
                                                            toastIcon.textContent = '✕';
                                                            toast.className = 'toast show toast-error';
                                                        }

                                                        setTimeout(() => {
                                                            toast.classList.remove('show');
                                                        }, 3000);
                                                    }
                                                </script>

                                                <!-- TOAST NOTIFICATION -->
                                                <div id="toast" class="toast">
                                                    <span id="toastIcon" class="toast-icon">✓</span>
                                                    <span id="toastMessage">Saved successfully.</span>
                                                </div>
                                            </body>

                                            </html>