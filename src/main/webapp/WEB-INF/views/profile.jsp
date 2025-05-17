<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">ToyStore</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> ${user.fullName}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-body">
                        <h2 class="card-title text-center mb-4">Profile</h2>
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                ${success}
                            </div>
                        </c:if>

                        <div class="tab-content">
                            <!-- Profile Information -->
                            <div class="tab-pane fade show active" id="profile-info">
                                <h4 class="mb-4">Profile Information</h4>
                                <div class="table-responsive">
                                    <table class="table">
                                        <tr>
                                            <th>Username:</th>
                                            <td>${user.username}</td>
                                        </tr>
                                        <tr>
                                            <th>Full Name:</th>
                                            <td>${user.fullName}</td>
                                        </tr>
                                        <tr>
                                            <th>Email:</th>
                                            <td>${user.email}</td>
                                        </tr>
                                        <tr>
                                            <th>Role:</th>
                                            <td>${user['class'].simpleName}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <!-- Change Password -->
                            <div class="tab-pane fade" id="change-password">
                                <h4 class="mb-4">Change Password</h4>
                                <form action="${pageContext.request.contextPath}/profile" method="post">
                                    <input type="hidden" name="action" value="updatePassword">
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Current Password</label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">New Password</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary">Change Password</button>
                                    </div>
                                </form>
                            </div>

                            <!-- Delete Account -->
                            <div class="tab-pane fade" id="delete-account">
                                <h4 class="mb-4">Delete Account</h4>
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle"></i> This action cannot be undone. All your data will be permanently deleted.
                                </div>
                                <form action="${pageContext.request.contextPath}/profile" method="post">
                                    <input type="hidden" name="action" value="deleteAccount">
                                    <div class="mb-3">
                                        <label for="deletePassword" class="form-label">Enter your password to confirm:</label>
                                        <input type="password" class="form-control" id="deletePassword" name="password" required>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-danger">Delete Account</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Profile Tabs -->
                        <ul class="nav nav-tabs mt-4" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" data-bs-toggle="tab" href="#profile-info">Profile Info</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-bs-toggle="tab" href="#change-password">Change Password</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-bs-toggle="tab" href="#delete-account">Delete Account</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="fixed-bottom bg-light py-3">
        <div class="container text-center">
            <p>&copy; 2024 ToyStore. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/your-code.js"></script>
</body>
</html>
