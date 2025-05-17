<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Toy Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">Toy Store</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/toys">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="fas fa-tags me-1"></i>Categories
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">Reports</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> ${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row">
            <!-- Welcome Card -->
            <div class="col-md-12 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h2>Welcome, ${sessionScope.user.fullName}!</h2>
                        <p>This is your admin dashboard where you can manage the toy store.</p>
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="col-md-3 mb-4">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total Users</h5>
                        <h2 class="card-text" id="totalUsers">Loading...</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total Products</h5>
                        <h2 class="card-text" id="totalProducts">Loading...</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <h5 class="card-title">Orders Today</h5>
                        <h2 class="card-text" id="ordersToday">Loading...</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <h5 class="card-title">Revenue Today</h5>
                        <h2 class="card-text" id="revenueToday">Loading...</h2>
                    </div>
                </div>
            </div>

            <!-- Recent Activities -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Recent Orders</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group" id="recentOrders">
                            <div class="text-center">Loading...</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Low Stock Alert -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Low Stock Alert</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group" id="lowStockItems">
                            <div class="text-center">Loading...</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to load dashboard data
        function loadDashboardData() {
            // Load total users
            fetch('${pageContext.request.contextPath}/api/admin/stats/users')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('totalUsers').textContent = data.total;
                });

            // Load total products
            fetch('${pageContext.request.contextPath}/api/admin/stats/products')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('totalProducts').textContent = data.total;
                });

            // Load orders today
            fetch('${pageContext.request.contextPath}/api/admin/stats/orders/today')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('ordersToday').textContent = data.total;
                });

            // Load revenue today
            fetch('${pageContext.request.contextPath}/api/admin/stats/revenue/today')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('revenueToday').textContent = '$' + data.total;
                });

            // Load recent orders
            fetch('${pageContext.request.contextPath}/api/admin/orders/recent')
                .then(response => response.json())
                .then(data => {
                    const ordersHtml = data.orders.map(order => `
                        <a href="${pageContext.request.contextPath}/admin/orders/${order.id}" class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1">Order #${order.id}</h6>
                                <small>${order.date}</small>
                            </div>
                            <p class="mb-1">${order.customerName} - $${order.total}</p>
                            <small class="text-muted">${order.status}</small>
                        </a>
                    `).join('');
                    document.getElementById('recentOrders').innerHTML = ordersHtml || '<div class="text-center">No recent orders</div>';
                });

            // Load low stock items
            fetch('${pageContext.request.contextPath}/api/admin/products/low-stock')
                .then(response => response.json())
                .then(data => {
                    const itemsHtml = data.products.map(product => `
                        <a href="${pageContext.request.contextPath}/admin/toys/${product.id}" class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1">${product.name}</h6>
                                <small class="text-danger">${product.stock} left</small>
                            </div>
                            <p class="mb-1">SKU: ${product.sku}</p>
                        </a>
                    `).join('');
                    document.getElementById('lowStockItems').innerHTML = itemsHtml || '<div class="text-center">No low stock items</div>';
                });
        }

        // Load dashboard data when page loads
        document.addEventListener('DOMContentLoaded', loadDashboardData);

        // Refresh dashboard data every 5 minutes
        setInterval(loadDashboardData, 300000);
    </script>
</body>
</html> 