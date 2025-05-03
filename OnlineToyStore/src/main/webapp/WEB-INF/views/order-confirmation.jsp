<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .confirmation-icon {
            font-size: 4rem;
            color: #28a745;
        }
        .order-details {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }
    </style>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="text-center mb-4">
            <i class="bi bi-check-circle-fill confirmation-icon"></i>
            <h2 class="mt-3">Order Confirmed!</h2>
            <p class="text-muted">Thank you for your purchase. Your order has been successfully placed.</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="order-details">
                    <h4 class="mb-4">Order Details</h4>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p><strong>Order Number:</strong> ${order.id}</p>
                            <p><strong>Order Date:</strong> ${order.orderDate}</p>
                            <p><strong>Status:</strong> 
                                <span class="badge bg-${order.orderStatus == 'PENDING' ? 'warning' : 
                                                       order.orderStatus == 'PROCESSING' ? 'info' :
                                                       order.orderStatus == 'SHIPPED' ? 'primary' :
                                                       order.orderStatus == 'DELIVERED' ? 'success' : 'danger'}">
                                    ${order.orderStatus}
                                </span>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Shipping Address:</strong></p>
                            <p>${order.shippingAddress}</p>
                        </div>
                    </div>

                    <h5 class="mb-3">Items Ordered</h5>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr>
                                        <td>${item.toyName}</td>
                                        <td>${item.quantity}</td>
                                        <td>$<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                        <td>$<fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#,##0.00"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-6 offset-md-6">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span>$<fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tax:</span>
                                <span>$<fmt:formatNumber value="${order.tax}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <span>$<fmt:formatNumber value="${order.shippingCost}" pattern="#,##0.00"/></span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <strong>Total:</strong>
                                <strong>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/toys" class="btn btn-primary">
                        Continue Shopping
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary ms-2">
                        View Order History
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 