<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${toy.name} - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
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
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/images/${toy.imageUrl}" 
                         alt="${toy.name}" 
                         class="card-img-top"
                         style="height: 400px; object-fit: cover;"
                         onerror="this.src='${pageContext.request.contextPath}/images/toy-placeholder.jpg'">
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h1 class="card-title">${toy.name}</h1>
                        <div class="rating mb-3">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="bi bi-star${i <= toy.rating ? '-fill' : ''} text-warning"></i>
                            </c:forEach>
                            <span class="ms-2">(${toy.reviewCount} reviews)</span>
                        </div>
                        <p class="h3 mb-4">$<fmt:formatNumber value="${toy.price}" pattern="#,##0.00"/></p>
                        <p class="card-text">${toy.description}</p>
                        <div class="mb-4">
                            <p><strong>Brand:</strong> ${toy.brand}</p>
                            <p><strong>Age Range:</strong> ${toy.ageRange}</p>
                            <p><strong>Stock:</strong> ${toy.stockQuantity} available</p>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn btn-primary" onclick="addToCart('${toy.id}')">
                                Add to Cart
                            </button>
                            <a href="${pageContext.request.contextPath}/toys" class="btn btn-outline-secondary">
                                Back to Toys
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h3 class="card-title mb-4">Customer Reviews</h3>
                        
                        <c:if test="${not empty sessionScope.user}">
                            <div class="mb-4">
                                <button class="btn btn-outline-primary" 
                                        type="button" 
                                        data-bs-toggle="collapse" 
                                        data-bs-target="#reviewForm">
                                    <i class="bi bi-pencil"></i> Write a Review
                                </button>
                                
                                <div class="collapse mt-3" id="reviewForm">
                                    <div class="card card-body">
                                        <form action="${pageContext.request.contextPath}/reviews" method="post">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="toyId" value="${toy.id}">
                                            
                                            <div class="mb-3">
                                                <label class="form-label">Rating</label>
                                                <div class="rating-input">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <input type="radio" name="rating" value="${i}" id="rating${i}" required>
                                                        <label for="rating${i}"><i class="bi bi-star"></i></label>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="comment" class="form-label">Your Review</label>
                                                <textarea class="form-control" id="comment" name="comment" rows="4" required 
                                                          placeholder="Share your experience with this toy..."></textarea>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="verifiedPurchase" id="verifiedPurchase">
                                                    <label class="form-check-label" for="verifiedPurchase">
                                                        I purchased this item
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <button type="submit" class="btn btn-primary">Submit Review</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${empty toy.reviews}">
                                <div class="alert alert-info">
                                    No reviews yet. Be the first to review this toy!
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="reviews-list">
                                    <c:forEach items="${toy.reviews}" var="review">
                                        <div class="review-item border-bottom pb-3 mb-3">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <div>
                                                    <h6 class="mb-1">${review.userName}</h6>
                                                    <div class="stars text-warning mb-1">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <i class="bi bi-star${i <= review.rating ? '-fill' : ''}"></i>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                                <div class="text-muted small">
                                                    <fmt:formatDate value="${review.createdAt}" pattern="MMM d, yyyy"/>
                                                    <c:if test="${review.verifiedPurchase}">
                                                        <span class="badge bg-success ms-2">Verified Purchase</span>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <p class="mb-2">${review.comment}</p>
                                            <c:if test="${sessionScope.user.id == review.userId}">
                                                <form action="${pageContext.request.contextPath}/reviews" method="post" 
                                                      onsubmit="return confirm('Are you sure you want to delete this review?');"
                                                      class="text-end">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="reviewId" value="${review.id}">
                                                    <input type="hidden" name="toyId" value="${toy.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
        function addToCart(toyId) {
            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'toyId=' + encodeURIComponent(toyId) + '&quantity=1'
            })
            .then(response => {
                if (response.ok) {
                    alert('Added to cart successfully!');
                } else {
                    throw new Error('Failed to add to cart');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to add to cart. Please try again.');
            });
        }

        // Add JavaScript for rating input interaction
        document.querySelectorAll('.rating-input input').forEach(input => {
            input.addEventListener('change', function() {
                const labels = this.parentElement.querySelectorAll('label');
                const value = parseInt(this.value);
                labels.forEach((label, index) => {
                    const starClass = index < value ? 'bi-star-fill' : 'bi-star';
                    label.innerHTML = `<i class="bi ${starClass}"></i>`;
                });
            });
        });
    </script>
</body>
</html> 