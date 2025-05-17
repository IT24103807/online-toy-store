<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">My Orders</h5>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty orders}">
                            <div class="text-center py-4">
                                <i class="fas fa-shopping-bag fa-3x text-muted mb-3"></i>
                                <h5>No Orders Found</h5>
                                <p class="text-muted">You haven't placed any orders yet.</p>
                                <a href="${pageContext.request.contextPath}/toys" class="btn btn-primary">
                                    <i class="fas fa-shopping-cart"></i> Start Shopping
                                </a>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty orders}">
                            <div class="table-responsive">
                                <table class="table table-hover">
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
                                        <c:forEach items="${orders}" var="order">
                                            <tr>
                                                <td>#${order.id}</td>
                                                <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/></td>
                                                <td>${order.items.size()} items</td>
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
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye"></i> View Details
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 