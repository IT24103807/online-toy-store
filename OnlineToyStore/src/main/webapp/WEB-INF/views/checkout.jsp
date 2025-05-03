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
                                    <label class="form-label">Saved Cards</label>
                                    <div class="saved-cards mb-3">
                                        <c:forEach var="card" items="${savedCards}">
                                            <div class="card mb-2">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input saved-card-radio" 
                                                               type="radio" name="savedCardId" 
                                                               value="${card.id}" id="card${card.id}">
                                                        <label class="form-check-label" for="card${card.id}">
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <div>
                                                                    <strong>${card.cardHolderName}</strong>
                                                                    <div class="text-muted">
                                                                        **** **** **** ${card.cardNumber.substring(card.cardNumber.length() - 4)}
                                                                        <span class="ms-2">Exp: ${card.expiryDate}</span>
                                                                    </div>
                                                                </div>
                                                                <button type="button" class="btn btn-outline-danger btn-sm" 
                                                                        onclick="deleteCard('${card.id}')">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </div>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="radio" name="savedCardId" 
                                               id="newCard" value="new" checked>
                                        <label class="form-check-label" for="newCard">
                                            Use a new card
                                        </label>
                                    </div>
                                </div>

                                <div id="newCardDetails">
                                    <div class="mb-3">
                                        <label for="cardHolderName" class="form-label">Card Holder Name</label>
                                        <input type="text" class="form-control" id="cardHolderName" 
                                               name="cardHolderName" required>
                                    </div>
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
                                    <div class="mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="saveCard" 
                                                   name="saveCard">
                                            <label class="form-check-label" for="saveCard">
                                                Save this card for future purchases
                                            </label>
                                        </div>
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
            const baseTotal = parseFloat('${total}');
            const newTotal = isGiftWrapped ? baseTotal + 5.00 : baseTotal;
            document.querySelector('.order-summary strong:last-child').textContent = 
                '$' + newTotal.toFixed(2);
        }

        function placeOrder() {
            console.log('Starting placeOrder function');
            const form = document.getElementById('checkoutForm');
            if (!form) {
                console.error('Checkout form not found');
                return;
            }

            // Get all form inputs
            const shippingAddress = document.getElementById('shippingAddress').value;
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            const isGiftWrapped = document.getElementById('isGiftWrapped').checked;
            const giftMessage = document.getElementById('giftMessage').value;
            const couponCode = document.getElementById('couponCode').value;

            const data = {
                shippingAddress: shippingAddress,
                paymentMethod: paymentMethod,
                isGiftWrapped: isGiftWrapped,
                giftMessage: giftMessage,
                couponCode: couponCode
            };

            console.log('Form data collected:', data);

            // Add card details based on selection
            const savedCardId = document.querySelector('input[name="savedCardId"]:checked').value;
            if (savedCardId && savedCardId !== 'new') {
                data.savedCardId = savedCardId;
                console.log('Using saved card:', savedCardId);
            } else {
                data.cardHolderName = document.getElementById('cardHolderName').value;
                data.cardNumber = document.getElementById('cardNumber').value;
                data.expiryDate = document.getElementById('expiryDate').value;
                data.cvv = document.getElementById('cvv').value;
                data.saveCard = document.getElementById('saveCard').checked;
                console.log('Using new card details');
            }

            // Validate required fields
            if (!data.shippingAddress) {
                console.error('Missing shipping address');
                alert('Please enter a shipping address');
                return;
            }

            if (data.paymentMethod === 'CREDIT_CARD') {
                if (!savedCardId || savedCardId === 'new') {
                    if (!data.cardHolderName || !data.cardNumber || !data.expiryDate || !data.cvv) {
                        console.error('Missing credit card details');
                        alert('Please fill in all credit card details');
                        return;
                    }
                }
            }

            console.log('Sending order data to server:', data);

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            })
            .then(response => {
                console.log('Server response received:', response);
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(text || 'Failed to place order');
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Order response data:', data);
                if (data.success) {
                    // Redirect to order confirmation page
                    window.location.href = data.redirectUrl;
                } else {
                    throw new Error(data.message || 'Failed to place order');
                }
            })
            .catch(error => {
                console.error('Error in placeOrder:', error);
                alert(error.message || 'Failed to place order. Please try again.');
            });
        }

        // Add event listener after the DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded');
            const placeOrderBtn = document.querySelector('.order-summary .btn-primary');
            if (placeOrderBtn) {
                console.log('Place order button found');
                placeOrderBtn.addEventListener('click', function(e) {
                    console.log('Place order button clicked');
                    e.preventDefault();
                    placeOrder();
                });
            } else {
                console.error('Place order button not found');
            }
        });

        function deleteCard(cardId) {
            if (confirm('Are you sure you want to delete this card?')) {
                fetch('${pageContext.request.contextPath}/cards', {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'cardId=' + encodeURIComponent(cardId)
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        throw new Error('Failed to delete card');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to delete card. Please try again.');
                });
            }
        }
    </script>
</body>
</html> 