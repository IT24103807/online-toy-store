<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - ToyStore</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/cart">Cart</a>
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

    <div class="container mt-4">
        <h2>Shopping Cart</h2>
        
        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="alert alert-info" role="alert">
                    Your cart is empty. <a href="${pageContext.request.contextPath}/toys" class="alert-link">Continue shopping</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cartItems}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/${item.toy.imageUrl}" 
                                                 alt="${item.toy.name}"
                                                 style="width: 50px; height: 50px; object-fit: contain;">
                                            <div class="ms-3">
                                                <h6 class="mb-0">${item.toy.name}</h6>
                                                <small class="text-muted">${item.toy.brand}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>$<fmt:formatNumber value="${item.toy.price}" pattern="#,##0.00"/></td>
                                    <td>
                                        <div class="input-group" style="width: 120px;">
                                            <button class="btn btn-outline-secondary" type="button" 
                                                    onclick="updateQuantity('${item.toy.id}', ${item.quantity - 1})">-</button>
                                            <input type="number" class="form-control text-center" value="${item.quantity}" 
                                                   min="1" max="${item.toy.stockQuantity}"
                                                   onchange="updateQuantity('${item.toy.id}', this.value)">
                                            <button class="btn btn-outline-secondary" type="button"
                                                    onclick="updateQuantity('${item.toy.id}', ${item.quantity + 1})">+</button>
                                        </div>
                                    </td>
                                    <td>$<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                    <td>
                                        <button class="btn btn-danger btn-sm" onclick="removeItem('${item.toy.id}')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                <td>$<fmt:formatNumber value="${total}" pattern="#,##0.00"/></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/toys" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Continue Shopping
                    </a>
                    <button class="btn btn-primary" onclick="checkout()">
                        Proceed to Checkout <i class="bi bi-arrow-right"></i>
                    </button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateQuantity(toyId, newQuantity) {
            if (newQuantity < 1) {
                removeItem(toyId);
                return;
            }

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `toyId=${toyId}&quantity=${newQuantity}`
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert('Failed to update quantity. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to update quantity. Please try again.');
            });
        }

        function removeItem(toyId) {
            if (!confirm('Are you sure you want to remove this item from your cart?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `toyId=${toyId}`
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert('Failed to remove item. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to remove item. Please try again.');
            });
        }

        function checkout() {
            window.location.href = '${pageContext.request.contextPath}/checkout';
        }
    </script>
</body>
</html> 