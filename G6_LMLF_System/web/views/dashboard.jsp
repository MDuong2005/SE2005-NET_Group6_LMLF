<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMLF System - Curriculum Portal</title>
    <!-- Dynamic CSS for Dashboard Layout based on role -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/${cssFile}">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Custom scrollbar adjustments */
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        ::-webkit-scrollbar-track {
            background: transparent;
        }
        ::-webkit-scrollbar-thumb {
            background: rgba(156, 163, 175, 0.3);
            border-radius: 4px;
        }
        .lines-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;  
            overflow: hidden;
        }
    </style>
</head>
<body>
    
    <!-- Khung bọc lưới giao diện chính -->
    <div class="dashboard-wrapper">
        
        <!-- ================= SIDEBAR ================= -->
        <jsp:include page="layout/sidebar.jsp" />

        <!-- ================= KHU VỰC NỘI DUNG CHÍNH ================= -->
        <main class="dashboard-main">
            
            <!-- THANH ĐẦU TRANG HEADER -->
            <jsp:include page="layout/header.jsp" />

            <!-- NỘI DUNG ĐỘNG ĐƯỢC NHÚNG TÙY THEO ROLE -->
            <div class="dashboard-content">
                <jsp:include page="${contentPage}" />
            </div>
            
        </main>
    </div>
</body>
</html>
