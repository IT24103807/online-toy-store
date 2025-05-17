<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Order Details</h5>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6>Order Information</h6>
                                <p><strong>Order ID:</strong> ${order.id}</p>
                                <p><strong>Order Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
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
                                <h6>Shipping Information</h6>
                                <p><strong>Shipping Address:</strong> ${order.shippingAddress}</p>
                                <p><strong>Payment Method:</strong> ${order.paymentMethod}</p>
                                <c:if test="${not empty order.trackingNumber}">
                                    <p><strong>Tracking Number:</strong> ${order.trackingNumber}</p>
                                </c:if>
                                <c:if test="${not empty order.estimatedDeliveryDate}">
                                    <p><strong>Estimated Delivery:</strong> 
                                        <fmt:formatDate value="${order.estimatedDeliveryDate}" pattern="yyyy-MM-dd"/>
                                    </p>
                                </c:if>
                            </div>
                        </div>

                        <h6>Order Items</h6>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Item</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${order.items}" var="item">
                                        <tr>
                                            <td>${item.toyName}</td>
                                            <td>$${item.unitPrice}</td>
                                            <td>${item.quantity}</td>
                                            <td>$${item.unitPrice * item.quantity}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                        <td>$${order.subtotal}</td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>Tax:</strong></td>
                                        <td>$${order.tax}</td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>Shipping:</strong></td>
                                        <td>$${order.shippingCost}</td>
                                    </tr>
                                    <c:if test="${order.discountAmount > 0}">
                                        <tr>
                                            <td colspan="3" class="text-end"><strong>Discount:</strong></td>
                                            <td>-$${order.discountAmount}</td>
                                        </tr>
                                    </c:if>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                        <td><strong>$${order.totalAmount}</strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 