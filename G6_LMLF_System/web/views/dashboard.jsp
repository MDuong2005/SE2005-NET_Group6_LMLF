<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMLF System - Curriculum Portal</title>
    <!-- Tailwind CSS CDN for modern rapid utility styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F8FAFC;
        }
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
<body class="text-slate-800 antialiased min-h-screen">
    
    <!-- Khung bọc lưới giao diện chính -->
    <div class="flex h-screen overflow-hidden">
        
        <!-- ================= SIDEBAR ================= -->
        <jsp:include page="layout/sidebar.jsp" />

        <!-- ================= KHU VỰC NỘI DUNG CHÍNH ================= -->
        <main class="flex-1 flex flex-col min-w-0 h-screen overflow-hidden">
            
            <!-- THANH ĐẦU TRANG HEADER -->
            <jsp:include page="layout/header.jsp" />

            <!-- NỘI DUNG ĐỘNG ĐƯỢC NHÚNG TÙY THEO ROLE -->
            <jsp:include page="${contentPage}" />
            
        </main>
    </div>
</body>
</html>
