<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Not Found - EduEnroll</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }

        .error-container {
            text-align: center;
            background: white;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            max-height: 90vh;
            width: 90%;
            position: relative;
            overflow: hidden;
        }



        .error-icon {
            font-size: 80px;
            color: #3478F6;
            margin-bottom: 30px;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        .error-code {
            font-size: 60px;
            font-weight: 700;
            color: #3478F6;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(52, 120, 246, 0.2);
        }

        .error-title {
            font-size: 32px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }

        .error-message {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 15px 30px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            font-size: 16px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background-color: #3478F6;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2967E0;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(52, 120, 246, 0.3);
        }

        .btn-secondary {
            background-color: #f8f9fa;
            color: #333;
            border: 2px solid #e9ecef;
        }

        .btn-secondary:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
            transform: translateY(-2px);
        }

        .helpful-links {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #eee;
        }

        .helpful-links h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
        }

        .links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .link-item {
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
        }

        .link-item:hover {
            background-color: #e9ecef;
            transform: translateY(-2px);
        }

        .link-item i {
            color: #3478F6;
            margin-right: 10px;
            font-size: 18px;
        }

        @media (max-width: 768px) {
            .error-container {
                padding: 40px 20px;
                margin: 20px;
            }

            .error-code {
                font-size: 48px;
            }

            .error-title {
                font-size: 24px;
            }

            .error-message {
                font-size: 16px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 250px;
            }
        }

        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
            color: #3478F6;
        }

        .logo i {
            font-size: 32px;
            margin-right: 10px;
        }

        .logo span {
            font-size: 28px;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="logo">
            <i class="fas fa-graduation-cap"></i>
            <span>EduEnroll</span>
        </div>
        
        <div class="error-icon">
            <i class="fas fa-search"></i>
        </div>
        
        <div class="error-code">404</div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-message">
            Oops! The page you're looking for seems to have gone on a learning adventure. 
            Don't worry, let's get you back on track!
        </p>
        
        <div class="action-buttons">
            <a href="javascript:history.back()" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i>
                Go Back
            </a>
            <a href="<%= request.getContextPath() %>/" class="btn btn-primary">
                <i class="fas fa-home"></i>
                Back to Home
            </a>
        </div>
       
    </div>
</body>
</html>