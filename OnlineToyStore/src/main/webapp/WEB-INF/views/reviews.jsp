<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reviews - ToyStore</title>
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
            <div class="row mb-4">
                <div class="col-12">
                    <h2>Customer Reviews</h2>
                    <div class="rating-summary card p-3">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <div class="average-rating me-3">
                                    <span class="h3 mb-0">${averageRating}</span>
                                    <div class="stars text-warning">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="bi bi-star${i <= averageRating ? '-fill' : ''}"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="review-count text-muted">
                                    Based on ${reviewCount} reviews
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/toys" class="btn btn-outline-primary">
                                <i class="bi bi-arrow-left"></i> Back to Toys
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <c:choose>
                        <c:when test="${param.success == 'review-added'}">Review added successfully!</c:when>
                        <c:when test="${param.success == 'review-deleted'}">Review deleted successfully!</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <c:choose>
                        <c:when test="${param.error == 'add-failed'}">Failed to add review. Please try again.</c:when>
                        <c:when test="${param.error == 'delete-failed'}">Failed to delete review. Please try again.</c:when>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row">
                <c:if test="${not empty sessionScope.user}">
                    <div class="col-md-4 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Write a Review</h5>
                                <form action="${pageContext.request.contextPath}/reviews" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="toyId" value="${param.toyId}">
                                    
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
                                    
                                    <button type="submit" class="btn btn-primary w-100">Submit Review</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>

                <div class="${not empty sessionScope.user ? 'col-md-8' : 'col-12'}">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Customer Reviews</h5>
                            <c:choose>
                                <c:when test="${empty reviews}">
                                    <div class="alert alert-info">
                                        No reviews yet. Be the first to review this toy!
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="reviews-list">
                                        <c:forEach items="${reviews}" var="review">
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
                                                        <input type="hidden" name="toyId" value="${param.toyId}">
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