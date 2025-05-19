<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .order-summary {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }
        .form-check-input:checked {
            background-color: #0d6efd;
            border-color: #0d6efd;
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
                        <c:choose>
                            <c:when test="${sessionScope.role == 'ADMIN'}">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                                    <i class="fas fa-user-shield me-1"></i> Admin Dashboard
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-user me-1"></i> Dashboard
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2 class="mb-4">Checkout</h2>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Shipping Information</h5>
                    </div>
                    <div class="card-body">
                        <form id="checkoutForm">
                            <div class="mb-3">
                                <label for="shippingAddress" class="form-label">Shipping Address</label>
                                <textarea class="form-control" id="shippingAddress" name="shippingAddress" 
                                          rows="3" required></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Payment Method</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="creditCard" value="CREDIT_CARD" checked>
                                    <label class="form-check-label" for="creditCard">
                                        Credit Card
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" 
                                           id="paypal" value="PAYPAL">
                                    <label class="form-check-label" for="paypal">
                                        PayPal
                                    </label>
                                </div>
                            </div>

                            <div id="creditCardDetails">
                                <div class="mb-3">
                                    <label for="cardNumber" class="form-label">Card Number</label>
                                    <input type="text" class="form-control" id="cardNumber" 
                                           pattern="[0-9]{16}" placeholder="1234 5678 9012 3456" required>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="expiryDate" class="form-label">Expiry Date</label>
                                        <input type="text" class="form-control" id="expiryDate" 
                                               pattern="(0[1-9]|1[0-2])\/[0-9]{2}" placeholder="MM/YY" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="cvv" class="form-label">CVV</label>
                                        <input type="text" class="form-control" id="cvv" 
                                               pattern="[0-9]{3,4}" placeholder="123" required>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isGiftWrapped" 
                                           name="isGiftWrapped">
                                    <label class="form-check-label" for="isGiftWrapped">
                                        Gift Wrap (+$5.00)
                                    </label>
                                </div>
                            </div>

                            <div class="mb-3" id="giftMessageDiv" style="display: none;">
                                <label for="giftMessage" class="form-label">Gift Message</label>
                                <textarea class="form-control" id="giftMessage" name="giftMessage" 
                                          rows="2"></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="couponCode" class="form-label">Coupon Code</label>
                                <input type="text" class="form-control" id="couponCode" name="couponCode">
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="order-summary">
                    <h5 class="mb-4">Order Summary</h5>
                    <div class="mb-4">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="d-flex justify-content-between mb-2">
                                <span>${item.toy.name} (x${item.quantity})</span>
                                <span>$<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                            </div>
                        </c:forEach>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Subtotal</span>
                        <span>$<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Tax (8%)</span>
                        <span>$<fmt:formatNumber value="${tax}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Shipping</span>
                        <span>$<fmt:formatNumber value="${shipping}" pattern="#,##0.00"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2" id="giftWrapFee" style="display: none;">
                        <span>Gift Wrap Fee</span>
                        <span>$5.00</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-3">
                        <strong>Total</strong>
                        <strong>$<fmt:formatNumber value="${total}" pattern="#,##0.00"/></strong>
                    </div>
                    <button class="btn btn-primary w-100" onclick="placeOrder()">
                        Place Order
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('isGiftWrapped').addEventListener('change', function() {
            const giftMessageDiv = document.getElementById('giftMessageDiv');
            const giftWrapFee = document.getElementById('giftWrapFee');
            giftMessageDiv.style.display = this.checked ? 'block' : 'none';
            giftWrapFee.style.display = this.checked ? 'flex' : 'none';
            updateTotal();
        });

        document.getElementById('paymentMethod').addEventListener('change', function() {
            const creditCardDetails = document.getElementById('creditCardDetails');
            creditCardDetails.style.display = this.value === 'CREDIT_CARD' ? 'block' : 'none';
        });

        function updateTotal() {
            const isGiftWrapped = document.getElementById('isGiftWrapped').checked;
            const baseTotal = ${total};
            const newTotal = isGiftWrapped ? baseTotal + 5.00 : baseTotal;
            document.querySelector('.order-summary strong:last-child').textContent = 
                '$' + newTotal.toFixed(2);
        }

        function placeOrder() {
            const form = document.getElementById('checkoutForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            // Get all form data including payment details
            const formData = new FormData(form);
            const data = {
                shippingAddress: formData.get('shippingAddress'),
                paymentMethod: document.querySelector('input[name="paymentMethod"]:checked').value,
                isGiftWrapped: document.getElementById('isGiftWrapped').checked,
                giftMessage: document.getElementById('giftMessage').value,
                couponCode: document.getElementById('couponCode').value
            };

            // Add credit card details if credit card is selected
            if (data.paymentMethod === 'CREDIT_CARD') {
                data.cardNumber = document.getElementById('cardNumber').value;
                data.expiryDate = document.getElementById('expiryDate').value;
                data.cvv = document.getElementById('cvv').value;
            }

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(text || 'Failed to place order');
                    });
                }
                return response.json();
            })
            .then(result => {
                if (result.success) {
                    alert(result.message);
                    window.location.href = '${pageContext.request.contextPath}/orders/' + result.orderId;
                } else {
                    throw new Error(result.message || 'Failed to place order');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert(error.message || 'Failed to place order. Please try again.');
            });
        }
    </script>
</body>
</html> 