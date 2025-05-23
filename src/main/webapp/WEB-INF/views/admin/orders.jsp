<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Toy Store Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #6a4fb6;
            --secondary-color: #b6e0fe;
            --accent-color: #f7b6c2;
            --background-light: #f8f9fa;
            --border-radius: 24px;
            --box-shadow: 0 4px 24px 0 rgba(106, 79, 182, 0.10);
        }
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--background-light);
            color: var(--primary-color);
        }
        .navbar {
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            background: #fff;
            margin: 1.5rem auto 2rem auto;
            max-width: 1100px;
            padding: 0.7rem 2rem;
        }
        .navbar-brand {
            font-size: 1.5rem;
            color: var(--primary-color);
            font-weight: 700;
            letter-spacing: 1px;
        }
        .nav-link {
            color: var(--primary-color) !important;
            font-weight: 600;
            border-radius: 32px;
            padding: 0.4rem 1.2rem;
            margin-left: 0.5rem;
            background: transparent;
            transition: background 0.2s, color 0.2s;
        }
        .nav-link:hover, .nav-link.active {
            background: var(--accent-color);
            color: var(--secondary-color) !important;
        }
        .dropdown-menu {
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            border: none;
            padding: 0.5rem;
        }
        .dropdown-item {
            border-radius: 16px;
            padding: 0.5rem 1rem;
            color: var(--primary-color);
            font-weight: 500;
        }
        .dropdown-item:hover {
            background: var(--secondary-color);
            color: #fff;
        }
        .card {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
            background: #fff;
            margin-bottom: 1.5rem;
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-2px);
        }
        .container {
            max-width: 1100px;
        }
        .nav-link.active {
            background: #e9aebe; /* more visible, less pastel pink */
            color: #fff !important;
            border-radius: 18px; /* less curve for pill shape */
            font-weight: 700;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-store me-2"></i>Toy Store Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-chart-line me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users me-1"></i>Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/toys">
                            <i class="fas fa-cube me-1"></i>Products
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                            <i class="fas fa-tags me-1"></i>Categories
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-cart me-1"></i>Orders
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                                <i class="fas fa-user-cog me-2"></i>Profile
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Order Management</h5>
                        <div>
                            <select class="form-select" id="orderFilter" onchange="filterOrders()">
                                <option value="all">All Orders</option>
                                <option value="pending">Pending</option>
                                <option value="processing">Processing</option>
                                <option value="shipped">Shipped</option>
                                <option value="delivered">Delivered</option>
                                <option value="cancelled">Cancelled</option>
                            </select>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="order">
                                        <tr data-status="${order.orderStatus}">
                                            <td>${order.id}</td>
                                            <td>${order.user != null ? order.user.fullName : 'Unknown User'}</td>
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
                                                <a href="${pageContext.request.contextPath}/admin/orders/${order.id}" 
                                                   class="btn btn-sm btn-info">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <button class="btn btn-sm btn-primary" 
                                                        onclick="updateStatus('${order.id}')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Update Status Modal -->
    <div class="modal fade" id="updateStatusModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Order Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="orderId" id="updateOrderId">
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="status" required>
                                <option value="PENDING">Pending</option>
                                <option value="PROCESSING">Processing</option>
                                <option value="SHIPPED">Shipped</option>
                                <option value="DELIVERED">Delivered</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateStatus(orderId) {
            document.getElementById('updateOrderId').value = orderId;
            new bootstrap.Modal(document.getElementById('updateStatusModal')).show();
        }

        function filterOrders() {
            const status = document.getElementById('orderFilter').value;
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                if (status === 'all' || row.dataset.status === status) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html> 