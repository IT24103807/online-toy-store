<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">ToyStore</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/toys">Toys</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">Cart</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-3">
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Welcome, ${sessionScope.user.fullName}!</h5>
                        <p class="card-text text-muted">${sessionScope.user.email}</p>
                    </div>
                </div>

                <div class="list-group">
                    <a href="#" class="list-group-item list-group-item-action active" onclick="showSection('profile')">
                        <i class="bi bi-person-circle me-2"></i>Profile
                    </a>
                    <a href="#" class="list-group-item list-group-item-action" onclick="showSection('orders')">
                        <i class="bi bi-bag me-2"></i>Orders
                    </a>
                    <a href="#" class="list-group-item list-group-item-action" onclick="showSection('wishlist')">
                        <i class="bi bi-heart me-2"></i>Wishlist
                    </a>
                    <a href="#" class="list-group-item list-group-item-action" onclick="showSection('settings')">
                        <i class="bi bi-gear me-2"></i>Settings
                    </a>
                </div>
            </div>

            <div class="col-md-9">
                <c:if test="${param.success != null}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <c:choose>
                            <c:when test="${param.success == 'profile-updated'}">Profile updated successfully!</c:when>
                            <c:when test="${param.success == 'password-changed'}">Password changed successfully!</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <c:choose>
                            <c:when test="${param.error == 'update-failed'}">Failed to update profile. Please try again.</c:when>
                            <c:when test="${param.error == 'wrong-password'}">Current password is incorrect.</c:when>
                            <c:when test="${param.error == 'password-change-failed'}">Failed to change password. Please try again.</c:when>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div id="profile-section" class="dashboard-section">
                    <h3 class="mb-4">Profile Information</h3>
                    <div class="card">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/dashboard" method="post">
                                <input type="hidden" name="action" value="updateProfile">
                                <div class="mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" class="form-control" name="fullName" value="${sessionScope.user.fullName}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="${sessionScope.user.email}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Username</label>
                                    <input type="text" class="form-control" value="${sessionScope.user.username}" readonly>
                                </div>
                                <button type="submit" class="btn btn-primary">Update Profile</button>
                            </form>
                        </div>
                    </div>

                    <h3 class="mb-4 mt-5">Change Password</h3>
                    <div class="card">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/dashboard" method="post" onsubmit="return validatePasswordForm()">
                                <input type="hidden" name="action" value="changePassword">
                                <div class="mb-3">
                                    <label class="form-label">Current Password</label>
                                    <input type="password" class="form-control" name="currentPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">New Password</label>
                                    <input type="password" class="form-control" name="newPassword" id="newPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Change Password</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div id="orders-section" class="dashboard-section" style="display: none;">
                    <h3 class="mb-4">Order History</h3>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Date</th>
                                    <th>Items</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="6" class="text-center">No orders found</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="wishlist-section" class="dashboard-section" style="display: none;">
                    <h3 class="mb-4">My Wishlist</h3>
                    <div class="row">
                        <div class="col-12">
                            <p class="text-center">Your wishlist is empty</p>
                        </div>
                    </div>
                </div>

                <div id="settings-section" class="dashboard-section" style="display: none;">
                    <h3 class="mb-4">Account Settings</h3>
                    <div class="card">
                        <div class="card-body">
                            <h5>Notification Preferences</h5>
                            <form>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="emailNotifications">
                                    <label class="form-check-label" for="emailNotifications">
                                        Email notifications for orders
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="promotionalEmails">
                                    <label class="form-check-label" for="promotionalEmails">
                                        Promotional emails
                                    </label>
                                </div>
                                <button type="submit" class="btn btn-primary mt-3">Save Preferences</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-light mt-5 py-3">
        <div class="container text-center">
            <p>&copy; 2024 ToyStore. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showSection(sectionId) {
            document.querySelectorAll('.dashboard-section').forEach(section => {
                section.style.display = 'none';
            });
            document.getElementById(sectionId + '-section').style.display = 'block';
            
            document.querySelectorAll('.list-group-item').forEach(item => {
                item.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        function validatePasswordForm() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                alert('New passwords do not match!');
                return false;
            }
            return true;
        }
    </script>
</body>
</html> 