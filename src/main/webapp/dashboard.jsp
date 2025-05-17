<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ToyStore</title>
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
        .dashboard-card {
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
        .list-group-item.active {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
    </style>
</head>
<body>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-user me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-1"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Success/Error Messages -->
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                <c:choose>
                    <c:when test="${param.success == 'account-deleted'}">Your account has been successfully deleted. Thank you for using ToyStore!</c:when>
                    <c:when test="${param.success == 'profile-updated'}">Profile updated successfully!</c:when>
                    <c:when test="${param.success == 'password-changed'}">Password changed successfully!</c:when>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                <c:choose>
                    <c:when test="${param.error == 'wrong-password'}">Current password is incorrect.</c:when>
                    <c:when test="${param.error == 'password-change-failed'}">Failed to change password. Please try again.</c:when>
                    <c:when test="${param.error == 'delete-failed'}">Failed to delete account. Please try again.</c:when>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

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
                <!-- Profile Section -->
                <div id="profile" class="dashboard-section">
                    <div class="row mb-4">
                        <div class="col-lg-4 mb-4 mb-lg-0">
                            <div class="card dashboard-card text-center h-100">
                                <div class="card-body">
                                    <h5 class="card-title">Total Products</h5>
                                    <h2 class="card-text" id="totalToys">${totalToys}</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 mb-4 mb-lg-0">
                            <div class="card dashboard-card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">Profile Information</h5>
                                    <form action="${pageContext.request.contextPath}/dashboard" method="post">
                                        <input type="hidden" name="action" value="updateProfile">
                                        <div class="mb-2">
                                            <label class="form-label">Full Name</label>
                                            <input type="text" class="form-control" name="fullName" value="${sessionScope.user.fullName}">
                                        </div>
                                        <div class="mb-2">
                                            <label class="form-label">Email</label>
                                            <input type="email" class="form-control" name="email" value="${sessionScope.user.email}">
                                        </div>
                                        <div class="mb-2">
                                            <label class="form-label">Username</label>
                                            <input type="text" class="form-control" value="${sessionScope.user.username}" readonly>
                                        </div>
                                        <button type="submit" class="btn btn-primary w-100 mt-2">Update Profile</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 mb-4 mb-lg-0">
                            <div class="card dashboard-card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">Change Password</h5>
                                    <form action="${pageContext.request.contextPath}/dashboard" method="post" onsubmit="return validatePasswordForm()">
                                        <input type="hidden" name="action" value="changePassword">
                                        <div class="mb-2">
                                            <label class="form-label">Current Password</label>
                                            <input type="password" class="form-control" name="currentPassword" required>
                                        </div>
                                        <div class="mb-2">
                                            <label class="form-label">New Password</label>
                                            <input type="password" class="form-control" name="newPassword" id="newPassword" required>
                                        </div>
                                        <div class="mb-2">
                                            <label class="form-label">Confirm New Password</label>
                                            <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" required>
                                        </div>
                                        <button type="submit" class="btn btn-primary w-100 mt-2">Change Password</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Orders Section -->
                <div id="orders" class="dashboard-section" style="display: none;">
                    <div class="card dashboard-card">
                        <div class="card-body">
                            <h5 class="card-title">Order History</h5>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Order ID</th>
                                            <th>Date</th>
                                            <th>Total</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orders}" var="order">
                                            <tr>
                                                <td>${order.id}</td>
                                                <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                                <td>$${order.totalAmount}</td>
                                                <td>
                                                    <span class="badge bg-${order.orderStatus == 'PENDING' ? 'warning' : 
                                                                          order.orderStatus == 'PROCESSING' ? 'info' :
                                                                          order.orderStatus == 'SHIPPED' ? 'primary' :
                                                                          order.orderStatus == 'DELIVERED' ? 'success' : 'danger'}">
                                                        ${order.orderStatus}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/orders/${order.id}" 
                                                       class="btn btn-sm btn-info">
                                                        <i class="fas fa-eye"></i> View Details
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty orders}">
                                            <tr>
                                                <td colspan="5" class="text-center">No orders found</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Wishlist Section -->
                <div id="wishlist" class="dashboard-section" style="display: none;">
                    <h3 class="mb-4">My Wishlist</h3>
                    <div class="row">
                        <div class="col-12">
                            <p class="text-center">Your wishlist is empty</p>
                        </div>
                    </div>
                </div>

                <!-- Settings Section -->
                <div id="settings" class="dashboard-section" style="display: none;">
                    <h3 class="mb-4">Account Settings</h3>
                    <div class="card mb-4">
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
                <!-- Delete Account Button -->
                <div class="text-end mt-4">
                    <button type="button" class="btn btn-danger" style="font-weight:bold;" onclick="showDeleteAccountModal()">
                        <i class="fas fa-trash-alt me-1"></i>Delete Account
                    </button>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-light mt-5 py-3">
        <div class="container text-center">
            <p>&copy; 2024 ToyStore. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function showSection(sectionId) {
            document.querySelectorAll('.dashboard-section').forEach(section => {
                section.style.display = 'none';
            });
            document.getElementById(sectionId).style.display = 'block';
            
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

        // Auto-refresh dashboard statistics every 30 seconds
        function refreshStatistics() {
            fetch('${pageContext.request.contextPath}/dashboard/stats')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('totalToys').textContent = data.totalToys;
                    document.getElementById('lowStockCount').textContent = data.lowStockCount;
                    document.getElementById('newArrivalsCount').textContent = data.newArrivalsCount;
                })
                .catch(error => console.error('Error refreshing statistics:', error));
        }

        // Refresh every 30 seconds
        setInterval(refreshStatistics, 30000);
    </script>

    <!-- Place the modal at the end of the file if not already present -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete Account</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning mb-3">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Important:</strong> This action cannot be undone. All your data will be permanently removed.
                    </div>
                    <form action="${pageContext.request.contextPath}/profile" method="post" id="delete-account-form">
                        <input type="hidden" name="action" value="delete">
                        <div class="mb-3">
                            <label class="form-label">Enter your current password to confirm deletion</label>
                            <input type="password" class="form-control" name="password" required>
                            <div class="form-text">
                                This is required to confirm your identity before proceeding with account deletion.
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="delete-account-form" class="btn btn-danger">
                        <i class="fas fa-trash-alt me-1"></i>Delete Account
                    </button>
                </div>
            </div>
        </div>
    </div>
    <script>
    function showDeleteAccountModal() {
        const modal = new bootstrap.Modal(document.getElementById('deleteAccountModal'));
        modal.show();
    }
    </script>
</body>
</html> 