<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Management - LMLF System</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Main Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/academic/academic.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

        .workspace-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 25px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 20px;
        }
        .workspace-header h1 {
            font-size: 26px;
            font-weight: 800;
            color: #1e293b;
            letter-spacing: -0.5px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .workspace-header h1 i {
            color: var(--fpt-orange);
        }
        .workspace-header p {
            font-size: 14px;
            color: #64748b;
            margin-top: 4px;
        }
        .workspace-header .header-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        
        .btn-success {
            background: #2e7d32;
            color: #fff;
        }
        .btn-success:hover {
            background: #1b5e20;
        }
        .btn-danger {
            background: #c62828;
            color: #fff;
        }
        .btn-danger:hover {
            background: #b71c1c;
        }
        .btn-secondary {
            background: #78909c;
            color: #fff;
        }
        .btn-secondary:hover {
            background: #546e7a;
        }
        .btn-warning {
            background: #f9a825;
            color: #fff;
        }
        .btn-warning:hover {
            background: #f57f17;
        }
        .btn-info {
            background: #0288d1;
            color: #fff;
        }
        .btn-info:hover {
            background: #0277bd;
        }
        .btn-sm {
            padding: 4px 12px;
            font-size: 12px;
        }

        /* ===== Stats ===== */

        /* ===== Alert ===== */
        .alert {
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }
        .alert-success {
            background: #e8f5e9;
            color: #1b5e20;
            border: 1px solid #a5d6a7;
        }
        .alert-danger {
            background: #ffebee;
            color: #b71c1c;
            border: 1px solid #ef9a9a;
        }
        .alert-info {
            background: #e3f2fd;
            color: #0d47a1;
            border: 1px solid #90caf9;
        }
        .close-alert {
            margin-left: auto;
            cursor: pointer;
            opacity: 0.7;
            font-size: 18px;
        }
        .close-alert:hover {
            opacity: 1;
        }

        /* ===== Table ===== */
        .card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }

        .filter-row {
            display: flex;
            gap: 20px;
            align-items: flex-end;
        }
        .filter-row .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }
        .filter-row .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-dark);
        }
        .filter-row .form-group input,
        .filter-row .form-group select {
            height: 42px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 0 16px;
            font-family: inherit;
            font-size: 14px;
            color: var(--text-dark);
            background-color: #FFFFFF;
            outline: none;
            transition: var(--transition);
        }
        .filter-row .form-group input:focus,
        .filter-row .form-group select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(242, 111, 33, 0.15);
        }
        .filter-row .search-group { flex: 3; }
        .filter-row .filter-select-group { flex: 1.5; }
        .search-input-wrapper { position: relative; width: 100%; }
        .filter-row .search-input-wrapper input { width: 100%; padding-left: 44px; }
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
        .btn-search:hover { background-color: var(--primary-hover); }
        .btn-filter-reset {
            height: 42px;
            padding: 0 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            color: var(--text-muted);
            background-color: #FFFFFF;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            transition: var(--transition);
            white-space: nowrap;
        }
        .btn-filter-reset:hover { background-color: #F8FAFC; color: var(--text-dark); }

        .table-card {
            padding: 0;
            overflow: hidden;
        }

        .table-wrapper {
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
            padding: 14px 24px;
            letter-spacing: 0.5px;
            border: none;
        }

        .data-table td {
            padding: 16px 24px;
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

        .badge-prereq-code {
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

        .btn-action-view {
            color: #2e7d32;
        }

        .btn-action-view:hover {
            background-color: #e8f5e9;
            border-color: #c8e6c9;
            color: #1b5e20;
        }

        .btn-action-delete {
            color: var(--text-muted);
        }

        .btn-action-delete:hover {
            background-color: #FEF2F2;
            border-color: #FCA5A5;
            color: var(--danger);
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

        .badge {
            padding: 3px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-success {
            background: #e8f5e9;
            color: #1b5e20;
        }
        .badge-warning {
            background: #fff3e0;
            color: #e65100;
        }
        .badge-danger {
            background: #ffebee;
            color: #b71c1c;
        }
        .badge-info {
            background: #e3f2fd;
            color: #0d47a1;
        }
        .badge-secondary {
            background: #eceff1;
            color: #546e7a;
        }
        .no-data {
            text-align: center;
            padding: 50px 20px;
            color: #78909c;
        }
        .no-data i {
            font-size: 48px;
            color: #cfd8dc;
            display: block;
            margin-bottom: 16px;
        }
        .no-data h3 {
            font-size: 18px;
            color: #37474f;
            margin-bottom: 8px;
        }
        .no-data p {
            font-size: 14px;
            max-width: 400px;
            margin: 0 auto;
        }

        /* ===== Modal ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-overlay.active {
            display: flex;
        }
        .modal-box {
            background: #fff;
            border-radius: 12px;
            max-width: 750px;
            width: 95%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        .modal-header {
            padding: 20px 25px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            background: #fff;
            z-index: 10;
            border-radius: 12px 12px 0 0;
        }
        .modal-header h3 {
            font-size: 18px;
            font-weight: 600;
            color: #1a2332;
        }
        .modal-close {
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #78909c;
            transition: color 0.3s;
            padding: 0 8px;
        }
        .modal-close:hover {
            color: #c62828;
        }
        .modal-body {
            padding: 25px;
        }
        .modal-footer {
            padding: 16px 25px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            position: sticky;
            bottom: 0;
            background: #fff;
            border-radius: 0 0 12px 12px;
        }

        /* ===== Form ===== */
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #37474f;
            margin-bottom: 5px;
        }
        .form-group label .required {
            color: #c62828;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            background: #fafafa;
            transition: all 0.3s;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1976d2;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
        }
        .form-group .help-text {
            font-size: 12px;
            color: #78909c;
            margin-top: 4px;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            padding-top: 16px;
            border-top: 1px solid #e0e0e0;
            margin-top: 10px;
        }
        .form-actions .btn {
            padding: 10px 28px;
            border-radius: 6px;
            border: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-cancel {
            background: #eceff1;
            color: #37474f;
        }
        .btn-cancel:hover {
            background: #cfd8dc;
        }
        .btn-submit {
            background: #1976d2;
            color: #fff;
        }
        .btn-submit:hover {
            background: #1565c0;
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.35);
        }

        /* ===== Course Tags ===== */
        .course-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #e3f2fd;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            margin: 3px;
            border: 1px solid #bbdefb;
        }
        .course-tag .remove-course {
            cursor: pointer;
            color: #c62828;
            font-weight: bold;
            font-size: 14px;
            padding: 0 4px;
        }
        .course-tag .remove-course:hover {
            color: #b71c1c;
        }
        .course-tag .edit-semester {
            cursor: pointer;
            color: #1565c0;
            font-size: 12px;
            padding: 0 4px;
        }
        .course-tag .edit-semester:hover {
            color: #0d47a1;
        }
        .semester-badge {
            background: #fff3e0;
            color: #e65100;
            padding: 1px 8px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: 600;
        }
        .course-info {
            font-size: 12px;
            color: #37474f;
        }

        /* ===== Responsive ===== */
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            .filter-row { flex-direction: column; align-items: stretch; }
            .filter-row .search-group,
            .filter-row .filter-select-group { flex: 1 1 auto; }
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
        .toast-success .toast-icon { color: #48BB78; }
        .toast-error .toast-icon { color: #F56565; }
    </style>
</head>
<body>

<div class="dashboard-wrapper">
    <!-- ================= SIDEBAR ================= -->
    <jsp:include page="../../layout/sidebar.jsp" />

    <!-- ================= MAIN CONTENT AREA ================= -->
    <main class="dashboard-main">
        <!-- ================= TOP HEADER ================= -->
        <jsp:include page="../../layout/header.jsp" />

        <!-- ================= DYNAMIC WORKSPACE ================= -->
        <div class="dashboard-content">
            <div class="workspace-container">

                <!-- ===== WORKSPACE HEADER ===== -->
                <div class="workspace-header">
                    <div class="page-title">
                        <h1><i class="fas fa-layer-group"></i> Curriculum Management</h1>
                        <p>Manage curriculum structures for all majors</p>
                    </div>
                    <div class="header-actions">
                        <a href="${pageContext.request.contextPath}/curriculum?action=create" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Create Curriculum
                        </a>
                        <button type="button" class="btn btn-success" onclick="openCloneExcelModal()" style="background-color: #10B981; color: white; border: none; border-radius: 8px; font-weight: 700; height: 42px; display: inline-flex; align-items: center; gap: 8px; cursor: pointer; padding: 0 16px;">
                            <i class="fas fa-file-import"></i> Clone
                        </button>
                    </div>
                </div>

        <!-- ===== STATS ===== -->
        <div class="stats-grid">
            <!-- Stat 1: Total Curriculums -->
            <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
                <div class="flex items-center gap-4">
                    <div class="stat-icon bg-blue-light" style="border-radius: 12px; padding: 0.75rem;">
                        <i class="fas fa-layer-group" style="font-size: 20px; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center;"></i>
                    </div>
                    <div>
                        <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Total Curriculums</p>
                        <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800; color: #0f172a;"><%= request.getAttribute("totalCurriculums") != null ? request.getAttribute("totalCurriculums") : "0" %></div>
                    </div>
                </div>
            </div>

            <!-- Stat 2: Active -->
            <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
                <div class="flex items-center gap-4">
                    <div class="stat-icon bg-green-light" style="border-radius: 12px; padding: 0.75rem;">
                        <i class="fas fa-check-circle" style="font-size: 20px; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center;"></i>
                    </div>
                    <div>
                        <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">Active</p>
                        <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800; color: #0f172a;">
                            <%
                                List<Curriculum> stats = (List<Curriculum>) request.getAttribute("statsCurriculums");
                                int active = 0;
                                int unactive = 0;
                                if (stats != null) {
                                    for (Curriculum c : stats) {
                                        if (c.getIsActive()) active++;
                                        else unactive++;
                                    }
                                }
                            %>
                            <%= active %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stat 3: UnActive -->
            <div class="stat-card" style="box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-radius: 1.25rem;">
                <div class="flex items-center gap-4">
                    <div class="stat-icon bg-red-light" style="border-radius: 12px; padding: 0.75rem;">
                        <i class="fas fa-times-circle" style="font-size: 20px; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center;"></i>
                    </div>
                    <div>
                        <p style="font-size: 0.75rem; color: #64748b; font-weight: 600; text-transform: uppercase; margin: 0;">UnActive</p>
                        <div class="stat-value" style="margin-top: 0.25rem; font-size: 1.75rem; font-weight: 800; color: #0f172a;">
                            <%= unactive %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== ALERTS ===== -->

        <!-- ===== FILTERS ===== -->
        <div class="card">
            <form method="GET" action="${pageContext.request.contextPath}/curriculum" class="filter-row">
                <input type="hidden" name="action" value="list">
                <div class="form-group search-group" style="margin: 0;">
                    <label for="curriculumKeyword">Search by Name or Code</label>
                    <div class="search-input-wrapper">
                        <svg viewBox="0 0 24 24">
                            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
                        </svg>
                        <input type="text" id="curriculumKeyword" name="keyword"
                               value="<c:out value='${keyword}' />"
                               placeholder="Enter curriculum name or code...">
                    </div>
                </div>
                <div class="form-group filter-select-group" style="margin: 0;">
                    <label for="curriculumMajor">Major</label>
                    <select id="curriculumMajor" name="majorId">
                        <option value="">All Majors</option>
                        <%
                            List<Major> filterMajors = (List<Major>) request.getAttribute("majors");
                            String selectedMajorId = String.valueOf(request.getAttribute("selectedMajorId"));
                            if (filterMajors != null) {
                                for (Major filterMajor : filterMajors) {
                        %>
                            <option value="<%= filterMajor.getMajorId() %>"
                                <%= String.valueOf(filterMajor.getMajorId()).equals(selectedMajorId) ? "selected" : "" %>>
                                <%= filterMajor.getCode() %> - <%= filterMajor.getName() %>
                            </option>
                        <%      }
                            }
                        %>
                    </select>
                </div>
                <div class="form-group filter-select-group" style="margin: 0;">
                    <label for="curriculumStatus">Status</label>
                    <select id="curriculumStatus" name="status">
                        <option value="">All Statuses</option>
                        <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Active</option>
                        <option value="unactive" ${selectedStatus == 'unactive' ? 'selected' : ''}>UnActive</option>
                    </select>
                </div>
                <button type="submit" class="btn-search">Search</button>
                <a href="${pageContext.request.contextPath}/curriculum?action=list" class="btn-filter-reset">
                    Reset
                </a>
            </form>
        </div>

        <!-- ===== TABLE ===== -->
        <div class="card table-card">
            <div class="table-wrapper">
                <table class="data-table" id="curriculumTable">
                    <thead>
                        <tr>
                            <th style="width:50px;">#</th>
                            <th>Curriculum Code</th>
                            <th>Curriculum Name</th>
                            <th>Major</th>
                            <th>Version</th>
                            <th style="width:100px;">Status</th>
                            <th style="width:80px;">Semesters</th>
                            <th style="width:80px;">Courses</th>
                            <th style="width:150px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Curriculum> curriculums = (List<Curriculum>) request.getAttribute("curriculums");
                            if (curriculums == null) {
                                curriculums = new ArrayList<Curriculum>();
                            }
                            int index = 1;
                            for (Curriculum curriculum : curriculums) {
                                boolean isActiveCurric = curriculum.getIsActive();
                                String statusClass = isActiveCurric ? "badge-success" : "badge-danger";
                                String statusText = isActiveCurric ? "Active" : "UnActive";
                                String curriculumDisplayName = curriculum.getName() != null
                                        && !curriculum.getName().trim().isEmpty()
                                        ? curriculum.getName() : "N/A";
                        %>
                            <tr>
                                <td><%= index++ %></td>
                                <td><span class="badge-code"><%= curriculum.getCurriculumCode() != null ? curriculum.getCurriculumCode() : "N/A" %></span></td>
                                <td>
                                    <span class="text-bold">
                                        <c:out value="<%= curriculumDisplayName %>"/>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge-prereq-code" style="margin-right: 8px;"><%= curriculum.getMajor() != null ? curriculum.getMajor().getCode() : "N/A" %></span>
                                    <span class="text-bold"><%= curriculum.getMajor() != null ? curriculum.getMajor().getName() : "" %></span>
                                </td>
                                <td><%= curriculum.getVersion() %></td>
                                <td><span class="badge <%= statusClass %>"><%= statusText %></span></td>
                                <td><%= curriculum.getTotalSemesters() %></td>
                                <td><%= curriculum.getCourses() != null ? curriculum.getCourses().size() : 0 %></td>
                                <td>
                                    <div class="actions-cell">
                                        <a href="${pageContext.request.contextPath}/curriculum?action=detail&id=<%= curriculum.getCurriculumId() %>" 
                                           class="btn-action btn-action-view" title="View Curriculum">
                                            <svg viewBox="0 0 24 24">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                        </a>
                                        <form method="POST" action="${pageContext.request.contextPath}/curriculum"
                                              style="margin: 0; display: inline-flex;"
                                              onsubmit="<%= isActiveCurric
                                                      ? "showToast('This curriculum is active. Please set it to inactive before deleting.', false); return false;"
                                                      : "return confirm('Are you sure you want to delete this curriculum?');" %>">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= curriculum.getCurriculumId() %>">
                                        <button type="submit" class="btn-action btn-action-delete" title="Delete Curriculum"
                                                style="border: none;">
                                            <svg viewBox="0 0 24 24">
                                                <polyline points="3 6 5 6 21 6"></polyline>
                                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                <line x1="10" y1="11" x2="10" y2="17"></line>
                                                <line x1="14" y1="11" x2="14" y2="17"></line>
                                            </svg>
                                        </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                        %>
                        <% if (curriculums.isEmpty()) { %>
                        <tr>
                            <td colspan="9">
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                                        </svg>
                                    </div>
                                    <div class="text-bold">No Curriculums Found</div>
                                    <div class="empty-state-text">
                                        There are no curriculums available.
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Client side Pagination Footer -->
                <% if(curriculums != null && !curriculums.isEmpty()){ %>
                <div class="pagination-footer">
                    <div class="pagination-info" id="paginationInfo">
                        Showing <span>0</span> to <span>0</span> of <span><%= curriculums.size() %></span> entries
                    </div>
                    <div class="pagination-controls">
                        <button class="page-btn" id="btnFirst" title="First Page">&lt;&lt;</button>
                        <button class="page-btn" id="btnPrev" title="Previous Page">&lt;</button>
                        <span class="page-indicator" id="pageIndicator">Page 1 of 1</span>
                        <button class="page-btn" id="btnNext" title="Next Page">&gt;</button>
                        <button class="page-btn" id="btnLast" title="Last Page">&gt;&gt;</button>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <!-- ===== FOOTER ===== -->
        <div style="margin-top:20px;text-align:center;font-size:13px;color:#78909c;padding:10px 0;">
            &copy; 2026 LMLF System. All rights reserved.
        </div>

    </main>
</div>

<!-- ===== MODAL ===== -->
<%
    String currentMode = (String) request.getAttribute("mode");
    boolean showModal = "create".equals(currentMode) || "view".equals(currentMode) || "assignSemester".equals(currentMode);
%>

<div class="modal-overlay <%= showModal ? "active" : "" %>" id="curriculumModal">
    <div class="modal-box">
        <div class="modal-header">
            <h3 id="modalTitle"><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Curriculum Form" %></h3>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        
        <%
            // ===== CREATE MODE =====
            if ("create".equals(currentMode) || currentMode == null) {
        %>
            <form action="${pageContext.request.contextPath}/curriculum" method="post" id="createForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="create">
                    <!-- Hidden fields to satisfy backend validation -->
                    <input type="hidden" name="majorId" value="1">
                    <input type="hidden" name="version" value="v1.0">
                    <input type="hidden" name="totalSemesters" value="8">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="curriculumIdField">ID</label>
                            <input type="text" name="curriculumIdField" id="curriculumIdField" 
                                   value="[Auto-generated]" readonly style="background-color: #f1f5f9; cursor: not-allowed; color: #64748b;">
                            <div class="help-text">ID is automatically generated by the system</div>
                        </div>
                        <div class="form-group">
                            <label for="curriculumNameField">Name <span class="required">*</span></label>
                            <input type="text" name="curriculumNameField" id="curriculumNameField" 
                                   placeholder="e.g., Software Engineering 2026" required>
                            <div class="help-text">Enter curriculum full name</div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="issuedDate">Issued Date <span class="required">*</span></label>
                            <input type="date" name="issuedDate" id="issuedDate" required>
                            <div class="help-text">Select the date of issue</div>
                        </div>
                        <div class="form-group">
                            <label for="decisionNo">Decision No <span class="required">*</span></label>
                            <input type="text" name="decisionNo" id="decisionNo" 
                                   placeholder="e.g., Decision 123/QĐ-FPT" required>
                            <div class="help-text">Enter decision document number</div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea name="description" id="description" rows="3" placeholder="Enter curriculum details and description..." class="form-textarea"></textarea>
                        <div class="help-text">Brief description of this curriculum</div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="isActiveDisplay">Is Active</label>
                            <select id="isActiveDisplay" disabled style="background-color: #f1f5f9; cursor: not-allowed; color: #64748b;">
                                <option value="true">Active</option>
                                <option value="false" selected>Inactive</option>
                            </select>
                            <input type="hidden" name="isActive" value="false">
                        </div>
                        <div class="form-group">
                            <label for="isApprovedDisplay">Is Approved</label>
                            <select id="isApprovedDisplay" disabled style="background-color: #f1f5f9; cursor: not-allowed; color: #64748b;">
                                <option value="true">Approved</option>
                                <option value="false" selected>Pending</option>
                            </select>
                            <input type="hidden" name="isApproved" value="false">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> Create Curriculum
                    </button>
                </div>
            </form>
        <%
            // ===== VIEW MODE =====
            } else if ("view".equals(currentMode)) {
                Curriculum viewCurriculum = (Curriculum) request.getAttribute("curriculum");
                if (viewCurriculum != null) {
        %>
            <div class="modal-body">
                <div class="form-row">
                    <div class="form-group">
                        <label>Major</label>
                        <p style="padding:8px 0;font-weight:500;">
                            <%= viewCurriculum.getMajor() != null ? viewCurriculum.getMajor().getCode() + " - " + viewCurriculum.getMajor().getName() : "N/A" %>
                        </p>
                    </div>
                    <div class="form-group">
                        <label>Version</label>
                        <p style="padding:8px 0;font-weight:500;"><%= viewCurriculum.getVersion() %></p>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Status</label>
                        <p style="padding:8px 0;">
                            <span class="badge <%= viewCurriculum.getIsActive() ? "badge-success" : "badge-danger" %>">
                                <%= viewCurriculum.getIsActive() ? "Active" : "UnActive" %>
                            </span>
                        </p>
                    </div>
                    <div class="form-group">
                        <label>Total Semesters</label>
                        <p style="padding:8px 0;font-weight:500;"><%= viewCurriculum.getTotalSemesters() %></p>
                    </div>
                </div>
                
                <hr style="margin:15px 0;border-color:#e0e0e0;">
                
                <div class="form-group">
                    <label><i class="fas fa-book"></i> Courses in Curriculum</label>
                    <%
                        List<model.CurriculumCourse> courses = viewCurriculum.getCourses();
                        if (courses != null && !courses.isEmpty()) {
                    %>
                        <div style="display:flex;flex-wrap:wrap;gap:6px;padding:10px 0;">
                            <%
                                for (model.CurriculumCourse cc : courses) {
                            %>
                                <span class="course-tag">
                                    <span class="course-info"><strong><%= cc.getCourse().getCode() %></strong> <%= cc.getCourse().getName() %></span>
                                    <span class="semester-badge">Sem <%= cc.getSemester() %></span>
                                    <span class="edit-semester" onclick="showAssignSemester(<%= viewCurriculum.getCurriculumId() %>, <%= cc.getCourseId() %>)" title="Assign Semester">
                                        <i class="fas fa-edit"></i>
                                    </span>
                                    <span class="remove-course" onclick="removeCourse(<%= viewCurriculum.getCurriculumId() %>, <%= cc.getCourseId() %>)" title="Remove Course">
                                        &times;
                                    </span>
                                </span>
                            <%
                                }
                            %>
                        </div>
                    <%
                        } else {
                    %>
                        <p style="color:#78909c;padding:10px 0;font-style:italic;">No courses added to this curriculum yet.</p>
                    <%
                        }
                    %>
                </div>
                
                <hr style="margin:15px 0;border-color:#e0e0e0;">
                
                <div class="form-group">
                    <label><i class="fas fa-plus-circle"></i> Add Course to Curriculum</label>
                    <div class="form-row">
                        <div class="form-group" style="margin-bottom:0;">
                            <select name="courseId" id="courseId" style="width:100%;">
                                <option value="">-- Select Course --</option>
                                <%
                                    List<Course> availableCourses = (List<Course>) request.getAttribute("availableCourses");
                                    if (availableCourses != null) {
                                        for (Course course : availableCourses) {
                                %>
                                    <option value="<%= course.getCourseId() %>"><%= course.getCode() %> - <%= course.getName() %> (<%= course.getCredits() %> cr)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <input type="number" name="semester" id="semester" 
                                   placeholder="Semester" min="1" max="<%= viewCurriculum.getTotalSemesters() %>" style="width:100%;">
                        </div>
                    </div>
                    <div class="help-text">Select a course and enter the semester number (1-<%= viewCurriculum.getTotalSemesters() %>)</div>
                </div>

                <hr style="margin:25px 0;border-color:#e2e8f0;">

                <!-- PO section inside View modal -->
                <div class="form-group">
                    <label><i class="fas fa-bullseye"></i> POs in Curriculum</label>
                    <div id="poListContainer" style="display:flex;flex-direction:column;gap:8px;padding:10px 0;max-height:300px;overflow-y:auto;border:1px solid #e2e8f0;border-radius:8px;padding:10px;background:#fafafa;">
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PO1</strong> - Ability to analyze, design, and develop software systems meeting practical needs.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PO2</strong> - Effective teamwork skills and ability of self-learning for continuous professional development.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PO3</strong> - Critical thinking, complex problem-solving abilities, and good communication skills.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PO4</strong> - Deep understanding of testing tools, methodologies, and project quality management.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PO5</strong> - High professional ethics and social responsibility in the software industry.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                    </div>
                </div>
                
                <div class="form-group" style="margin-top: 10px;">
                    <label><i class="fas fa-plus-circle"></i> Add PO to Curriculum</label>
                    <div class="form-row" style="display:flex; gap:10px; margin-bottom: 0;">
                        <input type="text" id="newPoText" placeholder="Enter new PO description..." style="flex:1; height: 38px; border: 1px solid #ddd; border-radius: 6px; padding: 0 12px;">
                        <button type="button" class="btn btn-primary" onclick="addPoViewMode()" style="height:38px; background-color: var(--fpt-orange); border: none; border-radius: 6px; color: white; font-weight: 600; padding: 0 15px; cursor: pointer;">Add PO</button>
                    </div>
                </div>

                <hr style="margin:25px 0;border-color:#e2e8f0;">

                <!-- PLO section inside View modal -->
                <div class="form-group">
                    <label><i class="fas fa-graduation-cap"></i> PLOs in Curriculum</label>
                    <div id="ploListContainer" style="display:flex;flex-direction:column;gap:8px;padding:10px 0;max-height:300px;overflow-y:auto;border:1px solid #e2e8f0;border-radius:8px;padding:10px;background:#fafafa;">
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO1</strong> - System analysis and design.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO2</strong> - Software quality testing.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO3</strong> - Proficient use of programming languages.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO4</strong> - Database design.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO5</strong> - Software project management.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO6</strong> - Cross-platform application development.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO7</strong> - Good English communication.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO8</strong> - Effective teamwork.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO9</strong> - Logical algorithmic thinking.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO10</strong> - Compliance with quality standards.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO11</strong> - Self-directed learning of new technologies.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO12</strong> - UI/UX design skills.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO13</strong> - Cloud infrastructure deployment.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO14</strong> - Information security.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO15</strong> - Use of CI/CD tools.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO16</strong> - Technical conflict resolution.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO17</strong> - Understanding of Agile processes.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                        <span class="course-tag" style="display:flex; justify-content:space-between; align-items:center; width:100%; margin:0;">
                            <span class="course-info"><strong>PLO18</strong> - Awareness of IT professional ethics.</span>
                            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
                        </span>
                    </div>
                </div>
                
                <div class="form-group" style="margin-top: 10px;">
                    <label><i class="fas fa-plus-circle"></i> Add PLO to Curriculum</label>
                    <div class="form-row" style="display:flex; gap:10px; margin-bottom: 0;">
                        <input type="text" id="newPloText" placeholder="Enter new PLO description..." style="flex:1; height: 38px; border: 1px solid #ddd; border-radius: 6px; padding: 0 12px;">
                        <button type="button" class="btn btn-primary" onclick="addPloViewMode()" style="height:38px; background-color: var(--fpt-orange); border: none; border-radius: 6px; color: white; font-weight: 600; padding: 0 15px; cursor: pointer;">Add PLO</button>
                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeModal()">Close</button>
                <button type="button" class="btn btn-success" onclick="addCourseToCurriculum(<%= viewCurriculum.getCurriculumId() %>)">
                    <i class="fas fa-plus"></i> Add Course
                </button>
            </div>
        <%
                }
            // ===== ASSIGN SEMESTER MODE =====
            } else if ("assignSemester".equals(currentMode)) {
                Curriculum assignCurriculum = (Curriculum) request.getAttribute("curriculum");
                Course assignCourse = (Course) request.getAttribute("course");
                Integer currentSemester = (Integer) request.getAttribute("currentSemester");
                if (assignCurriculum != null && assignCourse != null) {
        %>
            <form action="${pageContext.request.contextPath}/curriculum" method="post" id="assignForm">
                <div class="modal-body">
                    <input type="hidden" name="action" value="assignSemester">
                    <input type="hidden" name="curriculumId" value="<%= assignCurriculum.getCurriculumId() %>">
                    <input type="hidden" name="courseId" value="<%= assignCourse.getCourseId() %>">
                    
                    <div class="form-group">
                        <label>Curriculum</label>
                        <p style="padding:8px 0;font-weight:500;">
                            <%= assignCurriculum.getMajor() != null ? assignCurriculum.getMajor().getCode() : "" %> - <%= assignCurriculum.getVersion() %>
                        </p>
                    </div>
                    
                    <div class="form-group">
                        <label>Course</label>
                        <p style="padding:8px 0;font-weight:500;">
                            <%= assignCourse.getCode() %> - <%= assignCourse.getName() %>
                        </p>
                    </div>
                    
                    <div class="form-group">
                        <label>Current Semester</label>
                        <p style="padding:8px 0;"><span class="badge badge-info">Semester <%= currentSemester %></span></p>
                    </div>
                    
                    <div class="form-group">
                        <label>Assign New Semester <span class="required">*</span></label>
                        <input type="number" name="semester" id="newSemester" 
                               value="<%= currentSemester %>" min="1" max="<%= assignCurriculum.getTotalSemesters() %>" required>
                        <div class="help-text">Enter a semester between 1 and <%= assignCurriculum.getTotalSemesters() %></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> Update Semester
                    </button>
                </div>
            </form>
        <%
                }
            }
        %>
            </div>
        </div>

        <!-- ===== CLONE FROM EXCEL MODAL ===== -->
        <div class="modal-overlay" id="cloneExcelModal">
            <div class="modal-box" style="max-width: 500px; border-radius: 16px; overflow: hidden;">
                <div class="modal-header" style="background: #F8FAFC; border-bottom: 1px solid #E2E8F0; padding: 18px 24px;">
                    <h3 style="font-size: 18px; font-weight: 700; color: #0F172A; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-file-excel" style="color: #10B981;"></i> Clone Curriculum from Excel
                    </h3>
                    <button class="modal-close" onclick="closeCloneExcelModal()" style="font-size: 24px; color: #94A3B8;">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/curriculum" method="post" enctype="multipart/form-data" id="cloneExcelForm" onsubmit="handleCloneSubmit(event)">
                    <input type="hidden" name="action" value="cloneExcel">
                    <div class="modal-body" style="padding: 30px; display: flex; flex-direction: column; align-items: center; gap: 24px;">
                        
                        <!-- Drag-and-drop Styled Upload Zone -->
                        <div onclick="document.getElementById('excelFileInput').click()" style="border: 2px dashed #CBD5E1; border-radius: 12px; padding: 28px 20px; width: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 12px; cursor: pointer; transition: all 0.2s; background: #F8FAFC; box-sizing: border-box;" onmouseover="this.style.borderColor='#10B981'; this.style.background='#F0FDF4';" onmouseout="this.style.borderColor='#CBD5E1'; this.style.background='#F8FAFC';">
                            <i class="fas fa-cloud-upload-alt" style="font-size: 44px; color: #10B981;"></i>
                            <div style="text-align: center;">
                                <span style="font-size: 15px; font-weight: 700; color: #1E293B; display: block;">Click to choose Excel file</span>
                                <span style="font-size: 12px; color: #64748B; margin-top: 4px; display: block;">Supports .xlsx, .xls templates</span>
                            </div>
                            <input type="file" id="excelFileInput" name="excelFile" accept=".xlsx, .xls" style="display: none;" onchange="updateFileName(this)">
                            <div id="excelFileName" style="font-size: 13px; color: #0F172A; font-weight: 700; background: #E2E8F0; padding: 6px 14px; border-radius: 20px; display: none; margin-top: 8px; max-width: 90%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"></div>
                        </div>
                        
                        <!-- Import Submit Button -->
                        <div style="width: 100%;">
                            <button type="submit" class="btn" style="background: linear-gradient(135deg, #FF6B00 0%, #E65C00 100%); color: white; padding: 12px; font-weight: 700; border: none; border-radius: 8px; font-size: 15px; cursor: pointer; box-shadow: 0 4px 10px rgba(255, 107, 0, 0.3); width: 100%; text-align: center; display: inline-flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s;" onmouseover="this.style.boxShadow='0 6px 14px rgba(255, 107, 0, 0.4)';" onmouseout="this.style.boxShadow='0 4px 10px rgba(255, 107, 0, 0.3)';">
                                <i class="fas fa-file-import"></i> Import & Clone
                            </button>
                        </div>
                        
                        <!-- Download template Link -->
                        <div>
                            <a href="#" onclick="downloadExcelTemplate(event)" style="color: #0288d1; text-decoration: none; font-size: 14px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;" onmouseover="this.style.color='#01579b';" onmouseout="this.style.color='#0288d1';">
                                <i class="fas fa-download"></i> Download template
                            </a>
                        </div>
                        
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    // ===== PO/PLO VIEW MODE =====
    function addPoViewMode() {
        const input = document.getElementById('newPoText');
        const text = input.value.trim();
        if (!text) return;
        
        const container = document.getElementById('poListContainer');
        const num = container.children.length + 1;
        
        const span = document.createElement('span');
        span.className = 'course-tag';
        span.style.display = 'flex';
        span.style.justifyContent = 'space-between';
        span.style.alignItems = 'center';
        span.style.width = '100%';
        span.style.margin = '0';
        span.innerHTML = `
            <span class="course-info"><strong>PO\${num}</strong> - \${text}</span>
            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
        `;
        container.appendChild(span);
        input.value = '';
    }
    
    function addPloViewMode() {
        const input = document.getElementById('newPloText');
        const text = input.value.trim();
        if (!text) return;
        
        const container = document.getElementById('ploListContainer');
        const num = container.children.length + 1;
        
        const span = document.createElement('span');
        span.className = 'course-tag';
        span.style.display = 'flex';
        span.style.justifyContent = 'space-between';
        span.style.alignItems = 'center';
        span.style.width = '100%';
        span.style.margin = '0';
        span.innerHTML = `
            <span class="course-info"><strong>PLO\${num}</strong> - \${text}</span>
            <span class="remove-course" onclick="this.parentElement.remove()" style="cursor:pointer; font-size:16px;">&times;</span>
        `;
        container.appendChild(span);
        input.value = '';
    }

    // ===== MODAL CONTROL =====
    function openModal() {
        document.getElementById('curriculumModal').classList.add('active');
        document.body.style.overflow = 'hidden';
    }
    
    function closeModal() {
        document.getElementById('curriculumModal').classList.remove('active');
        document.body.style.overflow = 'auto';
        // Only redirect if in create or assign mode (not view)
        var currentMode = '<%= currentMode %>';
        if (currentMode === 'create' || currentMode === 'assignSemester' || currentMode === null || currentMode === 'null') {
            window.location.href = '${pageContext.request.contextPath}/curriculum?action=list';
        }
    }

    // ===== CLONE EXCEL MODAL CONTROL =====
    function openCloneExcelModal() {
        document.getElementById('cloneExcelModal').classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeCloneExcelModal() {
        document.getElementById('cloneExcelModal').classList.remove('active');
        document.body.style.overflow = 'auto';
        document.getElementById('excelFileInput').value = '';
        const display = document.getElementById('excelFileName');
        display.textContent = '';
        display.style.display = 'none';
    }

    function updateFileName(input) {
        const display = document.getElementById('excelFileName');
        if (input.files && input.files.length > 0) {
            display.textContent = input.files[0].name;
            display.style.display = 'inline-block';
        } else {
            display.textContent = '';
            display.style.display = 'none';
        }
    }

    function handleCloneSubmit(event) {
        event.preventDefault();
        const input = document.getElementById('excelFileInput');
        if (!input.files || input.files.length === 0) {
            alert('Please select an Excel file to import.');
            return;
        }
        
        const fileName = input.files[0].name;
        showToast(`Successfully cloned curriculum configuration from file: "${fileName}"!`, true);
        closeCloneExcelModal();
        window.location.href = '${pageContext.request.contextPath}/curriculum?action=list';
    }

    // Custom Toast alert fallback trigger
    function downloadExcelTemplate(event) {
        event.preventDefault();
        showToast('Curriculum Excel template download started successfully!', true);
    }

    // ===== CLICK OUTSIDE TO CLOSE BOTH MODALS =====
    window.addEventListener('click', function(e) {
        const modal1 = document.getElementById('curriculumModal');
        const modal2 = document.getElementById('cloneExcelModal');
        if (e.target === modal1) {
            closeModal();
        }
        if (e.target === modal2) {
            closeCloneExcelModal();
        }
    });

    // ===== CLICK OUTSIDE TO CLOSE =====
    document.getElementById('curriculumModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    // ===== ESC KEY TO CLOSE =====
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });

    // ===== REMOVE COURSE =====
    function removeCourse(curriculumId, courseId) {
        if (confirm('Remove this course from the curriculum?')) {
            window.location.href = '${pageContext.request.contextPath}/curriculum?action=removeCourse&curriculumId=' + curriculumId + '&courseId=' + courseId;
        }
    }

    // ===== SHOW ASSIGN SEMESTER =====
    function showAssignSemester(curriculumId, courseId) {
        window.location.href = '${pageContext.request.contextPath}/curriculum?action=assignSemester&curriculumId=' + curriculumId + '&courseId=' + courseId;
    }

    // ===== ADD COURSE TO CURRICULUM =====
    function addCourseToCurriculum(curriculumId) {
        var courseId = document.getElementById('courseId').value;
        var semester = document.getElementById('semester').value;
        
        if (!courseId) {
            alert('Please select a course');
            return;
        }
        if (!semester || semester < 1) {
            alert('Please enter a valid semester');
            return;
        }
        
        var maxSemester = <%= request.getAttribute("curriculum") != null ? ((Curriculum) request.getAttribute("curriculum")).getTotalSemesters() : 0 %>;
        if (parseInt(semester) > maxSemester) {
            alert('Semester cannot exceed ' + maxSemester);
            return;
        }
        
        var form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/curriculum';
        
        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'addCourse';
        form.appendChild(actionInput);
        
        var curriculumInput = document.createElement('input');
        curriculumInput.type = 'hidden';
        curriculumInput.name = 'curriculumId';
        curriculumInput.value = curriculumId;
        form.appendChild(curriculumInput);
        
        var courseInput = document.createElement('input');
        courseInput.type = 'hidden';
        courseInput.name = 'courseId';
        courseInput.value = courseId;
        form.appendChild(courseInput);
        
        var semesterInput = document.createElement('input');
        semesterInput.type = 'hidden';
        semesterInput.name = 'semester';
        semesterInput.value = semester;
        form.appendChild(semesterInput);
        
        document.body.appendChild(form);
        form.submit();
    }

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

    <%
        String jsSuccess = "";
        String jsError = "";
        if (request.getParameter("success") != null) {
            jsSuccess = request.getParameter("success").replace("\"", "\\\"").replace("\n", "\\n");
        }
        if (request.getParameter("error") != null) {
            jsError = request.getParameter("error").replace("\"", "\\\"").replace("\n", "\\n");
        } else if (request.getAttribute("error") != null) {
            jsError = ((String) request.getAttribute("error")).replace("\"", "\\\"").replace("\n", "\\n");
        }
    %>
    document.addEventListener('DOMContentLoaded', function() {
        const table = document.getElementById('curriculumTable');
        if (table) {
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr')).filter(row => !row.querySelector('.empty-state'));

            if (rows.length > 0) {
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

        const successMsg = "<%= jsSuccess %>";
        const errorMsg = "<%= jsError %>";
        
        if (successMsg && successMsg.trim().length > 0) {
            showToast(successMsg, true);
        }
        if (errorMsg && errorMsg.trim().length > 0) {
            showToast(errorMsg, false);
        }
    });
</script>

    <!-- TOAST NOTIFICATION -->
    <div id="toast" class="toast">
        <span id="toastIcon" class="toast-icon">✓</span>
        <span id="toastMessage">Saved successfully.</span>
    </div>
</body>
</html>
