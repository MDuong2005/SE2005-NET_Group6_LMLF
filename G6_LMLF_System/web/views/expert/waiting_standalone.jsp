<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Waiting for Assignment - LMLF</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #fff7ed 0%, #ffedd5 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .waiting-container {
            background: white;
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }

        .icon-wrapper {
            width: 80px;
            height: 80px;
            background: #ffedd5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: #ea580c;
        }

        .icon-wrapper svg {
            width: 40px;
            height: 40px;
        }

        h1 {
            color: #9a3412;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        p.subtitle {
            color: #4b5563;
            font-size: 1.1rem;
            line-height: 1.5;
            margin-bottom: 2rem;
        }

        .status-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 600;
            color: #334155;
            margin-bottom: 0.75rem;
        }

        .pulse-dot {
            width: 10px;
            height: 10px;
            background-color: #f97316;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(249, 115, 22, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(249, 115, 22, 0); }
            100% { box-shadow: 0 0 0 0 rgba(249, 115, 22, 0); }
        }

        .status-box p {
            color: #64748b;
            font-size: 0.95rem;
            margin: 0;
            line-height: 1.5;
        }

        .actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
            border: none;
            font-size: 1rem;
        }

        .btn-primary {
            background: #f97316;
            color: white;
        }

        .btn-primary:hover {
            background: #ea580c;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
        }
    </style>
</head>
<body>
    <div class="waiting-container">
        <div class="icon-wrapper">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>
        
        <h1>Welcome, ${sessionScope.user.firstName}!</h1>
        <p class="subtitle">Your expert account is active, but you don't have any assignments yet.</p>
        
        <div class="status-box">
            <div class="status-indicator">
                <div class="pulse-dot"></div>
                <span>Waiting for Assignment</span>
            </div>
            <p>Please wait for the Academic Office to assign a syllabus to you. Once assigned, refreshing this page will automatically redirect you to your workspace.</p>
        </div>
        
        <div class="actions">
            <button onclick="window.location.reload();" class="btn btn-primary">Refresh Status</button>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Logout</a>
        </div>
    </div>
</body>
</html>
