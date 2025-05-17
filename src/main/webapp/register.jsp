<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/modern-theme.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ff4fa2;
            --secondary-color: #4a90e2;
            --accent-color: #29b6f6;
            --background-light: #f8f9fa;
            --text-dark: #333;
            --border-radius: 8px;
            --box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        }
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: var(--text-dark);
        }
        .header-bar {
            background-color: var(--background-light);
            font-size: 0.9rem;
        }
        .navbar {
            box-shadow: var(--box-shadow);
        }
        .brand-logo {
            font-size: 1.8rem;
            color: var(--primary-color);
            text-decoration: none;
        }
        .register-card {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
        }
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        .btn-primary:hover {
            background-color: #e13c8d;
            border-color: #e13c8d;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Header Bar -->
    <div class="header-bar py-2 px-3 d-flex justify-content-between align-items-center">
        <div>
            <i class="fas fa-truck me-2"></i> Free Shipping on Orders Over $50
        </div>
        <div>
            <i class="fas fa-phone me-1"></i> +1 (555) 123-4567
            <span class="mx-2">|</span>
            <i class="fas fa-envelope me-1"></i> support@toystore.com
        </div>
    </div>
    <!-- Main Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white">
        <div class="container">
            <a class="brand-logo d-flex align-items-center" href="${pageContext.request.contextPath}/">
                <img src="https://img.icons8.com/clouds/100/000000/teddy-bear.png" alt="ToyStore Logo" style="height: 40px;" class="me-2">
                <span class="fw-bold">ToyStore</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/toys">
                            <i class="fas fa-cube me-1"></i> Toys
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart me-1"></i> Cart
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">
                            <i class="fas fa-sign-in-alt me-1"></i> Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register">
                            <i class="fas fa-user-plus me-1"></i> Register
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card register-card">
                    <div class="card-body">
                        <h2 class="card-title text-center mb-4">Create Account</h2>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-user-plus me-1"></i>Register
                                </button>
                            </div>
                        </form>
                        <div class="text-center mt-3">
                            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="bg-light py-3 mt-5">
        <div class="container text-center">
            <p>&copy; 2024 ToyStore. All rights reserved.</p>
        </div>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html> 