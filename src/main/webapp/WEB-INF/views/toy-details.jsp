<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${toy.name} - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/modern-theme.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ff4fa2;
            --secondary-color: #4a90e2;
            --accent-color: #29b6f6;
            --background-light: #f8f9fa;
            --text-dark: #333;
            --border-radius: 8px;
            --box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: var(--text-dark);
        }

        .header-bar {
            background-color: var(--background-light);
            font-size: 0.9rem;
        }

        .navbar {
            box-shadow: var(--box-shadow);
        }

        .brand-logo {
            font-size: 1.8rem;
            color: var(--primary-color);
            text-decoration: none;
        }

        .product-image {
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            transition: transform 0.3s ease;
        }

        .product-image:hover {
            transform: scale(1.02);
        }

        .details-card {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: darken(var(--primary-color), 10%);
            border-color: darken(var(--primary-color), 10%);
        }

        .review-card {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
            transition: transform 0.3s ease;
        }

        .review-card:hover {
            transform: translateY(-2px);
        }

        .rating-stars {
            color: #ffc107;
        }

        .badge-custom {
            background-color: var(--background-light);
            color: var(--text-dark);
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 20px;
        }
    </style>
</head>
<body>
    <!-- Header Bar -->
    <div class="header-bar py-2 px-3 d-flex justify-content-between align-items-center">
        <div>
            <i class="fas fa-truck me-2"></i> Free Shipping on Orders Over $50
        </div>
        <div>
            <i class="fas fa-phone me-1"></i> +1 (555) 123-4567
            <span class="mx-2">|</span>
            <i class="fas fa-envelope me-1"></i> support@toystore.com
        </div>
    </div>

    <!-- Main Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white">
        <div class="container">
            <a class="brand-logo d-flex align-items-center" href="${pageContext.request.contextPath}/">
                <img src="https://img.icons8.com/clouds/100/000000/teddy-bear.png" alt="ToyStore Logo" style="height: 40px;" class="me-2">
                <span class="fw-bold">ToyStore</span>
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav ms-auto">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                    <i class="fas fa-user me-1"></i> Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                    <i class="fas fa-shopping-cart me-1"></i> Cart
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                    <i class="fas fa-sign-in-alt me-1"></i> Login
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">
                                    <i class="fas fa-user-plus me-1"></i> Register
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Debug Info (if needed) -->
    <c:if test="${not empty param.debug}">
        <div class="container mt-3">
            <div class="alert alert-warning">
                <h5>Debug Info:</h5>
                <p>User ID in session: ${sessionScope.userId}</p>
                <p>User Name in session: ${sessionScope.userName}</p>
                <p>Toy ID: ${toy.id}</p>
            </div>
        </div>
    </c:if>

    <!-- Product Details Section -->
    <div class="container py-5">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/toys" class="text-decoration-none">Toys</a></li>
                <li class="breadcrumb-item active" aria-current="page">${toy.name}</li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-lg-6 mb-4 mb-lg-0">
                <div class="position-sticky" style="top: 2rem;">
                    <img src="${pageContext.request.contextPath}/images/${toy.imageUrl}" 
                         alt="${toy.name}" 
                         class="img-fluid product-image w-100 mb-4"
                         style="max-height: 500px; object-fit: contain;"
                         onerror="this.src='${pageContext.request.contextPath}/images/toy-placeholder.jpg'">
                </div>
            </div>
            <div class="col-lg-6">
                <div class="details-card card p-4">
                    <h1 class="display-6 mb-4">${toy.name}</h1>
                    
                    <div class="mb-4">
                        <div class="d-flex align-items-center mb-3">
                            <div class="rating-stars me-3">
                                <c:forEach var="i" begin="1" end="5">
                                    <c:choose>
                                        <c:when test="${i <= averageRating}">
                                            <i class="fas fa-star"></i>
                                        </c:when>
                                        <c:when test="${i - averageRating > 0 && i - averageRating <= 0.5}">
                                            <i class="fas fa-star-half-alt"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <span class="text-muted">${averageRating}/5 (${fn:length(reviews)} reviews)</span>
                        </div>
                        
                        <h2 class="h1 mb-4">$<fmt:formatNumber value="${toy.price}" pattern="#,##0.00"/></h2>
                        
                        <div class="mb-4">
                            <span class="badge-custom me-2">
                                <i class="fas fa-tag me-2"></i>${toy.brand}
                            </span>
                            <span class="badge-custom">
                                <i class="fas fa-child me-2"></i>${toy.ageRange}
                            </span>
                        </div>

                        <p class="lead mb-4">${toy.description}</p>

                        <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-4">
                            <input type="hidden" name="toyId" value="${toy.id}">
                            <div class="row g-3 align-items-center">
                                <div class="col-auto">
                                    <div class="input-group input-group-sm" style="max-width: 110px;">
                                        <button class="btn btn-outline-secondary" type="button"
                                                onclick="changeQuantity(-1)"><i class="fas fa-minus"></i></button>
                                        <input type="number" class="form-control text-center" name="quantity" id="quantityInput"
                                               value="1" min="1" max="${toy.stockQuantity}" style="min-width: 40px; max-width: 50px;">
                                        <button class="btn btn-outline-secondary" type="button"
                                                onclick="changeQuantity(1)"><i class="fas fa-plus"></i></button>
                                    </div>
                                </div>
                                <div class="col">
                                    <button type="submit" class="btn btn-primary btn-lg w-100">
                                        <i class="fas fa-cart-plus me-2"></i>Add to Cart
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reviews Section -->
        <div class="mt-5">
            <h2 class="mb-4">Customer Reviews</h2>
            
            <!-- Success Message -->
            <c:if test="${not empty sessionScope.reviewSuccess}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    ${sessionScope.reviewSuccess}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("reviewSuccess"); %>
            </c:if>
            
            <!-- Add Review Button -->
            <c:if test="${not empty user && empty userReview}">
                <button class="btn btn-outline-primary mb-4" data-bs-toggle="collapse" data-bs-target="#reviewForm">
                    <i class="fas fa-pen me-2"></i>Write a Review
                </button>
            </c:if>

            <!-- Review Form -->
            <c:if test="${not empty user}">
                <div class="collapse ${not empty userReview ? 'show' : ''}" id="reviewForm">
                    <div class="card details-card p-4 mb-4">
                        <h5 class="mb-4">${empty userReview ? 'Write Your Review' : 'Edit Your Review'}</h5>
                        <form action="${pageContext.request.contextPath}/reviews" method="post" id="reviewForm">
                            <input type="hidden" name="toyId" value="${toy.id}" />
                            <c:if test="${not empty userReview}">
                                <input type="hidden" name="reviewId" value="${userReview.id}" />
                            </c:if>
                            
                            <div class="mb-3">
                                <label class="form-label">Rating <span class="text-danger">*</span></label>
                                <div class="rating-select">
                                    <select name="rating" class="form-select" required>
                                        <option value="">Select Rating</option>
                                        <c:forEach begin="1" end="5" var="star">
                                            <option value="${star}" ${userReview.rating == star ? 'selected' : ''}>
                                                ${star} Star${star > 1 ? 's' : ''}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" name="title" class="form-control" 
                                       value="${userReview.title}" minlength="3" maxlength="50" required
                                       placeholder="Summarize your review">
                                <div class="form-text">Minimum 3 characters, maximum 50 characters</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Your Review <span class="text-danger">*</span></label>
                                <textarea name="comment" class="form-control" rows="4" 
                                          minlength="10" maxlength="300" required
                                          placeholder="What did you like or dislike about this toy?">${userReview.comment}</textarea>
                                <div class="form-text">Minimum 10 characters, maximum 300 characters</div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane me-2"></i>
                                    ${empty userReview ? 'Submit Review' : 'Update Review'}
                                </button>
                                <button type="button" class="btn btn-link text-muted" data-bs-toggle="collapse" data-bs-target="#reviewForm">
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:if>

            <!-- Reviews List -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="col-12">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                No reviews yet. Be the first to review this toy!
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <div class="col-md-6 mb-4">
                                <div class="review-card card h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div>
                                                <h6 class="mb-0">${review.userName}</h6>
                                                <small class="text-muted">${review.reviewDate}</small>
                                            </div>
                                            <div class="rating-stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="${i <= review.rating ? 'fas' : 'far'} fa-star"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <h5 class="card-title mb-3">${review.title}</h5>
                                        <p class="card-text mb-3">${review.comment}</p>
                                        
                                        <c:if test="${not empty user && user.id == review.userId}">
                                            <div class="border-top pt-3">
                                                <form action="${pageContext.request.contextPath}/reviews" method="post" class="d-inline">
                                                    <input type="hidden" name="reviewId" value="${review.id}" />
                                                    <button type="submit" name="action" value="edit" 
                                                            class="btn btn-sm btn-link text-decoration-none">
                                                        <i class="fas fa-edit me-1"></i>Edit
                                                    </button>
                                                    <button type="submit" name="action" value="delete" 
                                                            class="btn btn-sm btn-link text-danger text-decoration-none"
                                                            onclick="return confirm('Are you sure you want to delete this review?');">
                                                        <i class="fas fa-trash-alt me-1"></i>Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Login Prompt for Reviews -->
            <c:if test="${empty user}">
                <div class="alert alert-info d-flex align-items-center">
                    <i class="fas fa-info-circle me-3 fs-4"></i>
                    <div>
                        Please <a href="${pageContext.request.contextPath}/login" class="alert-link">login</a> to write a review.
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4 mb-md-0">
                    <h5 class="mb-3">About ToyStore</h5>
                    <p class="text-muted">Bringing joy to children and families with our carefully curated selection of toys and games.</p>
                </div>
                <div class="col-md-4 mb-4 mb-md-0">
                    <h5 class="mb-3">Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/toys" class="text-muted text-decoration-none">Shop</a></li>
                        <li><a href="${pageContext.request.contextPath}/about" class="text-muted text-decoration-none">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact" class="text-muted text-decoration-none">Contact</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5 class="mb-3">Contact Us</h5>
                    <ul class="list-unstyled text-muted">
                        <li><i class="fas fa-map-marker-alt me-2"></i> 123 Toy Street, Fun City, FC 12345</li>
                        <li><i class="fas fa-phone me-2"></i> +1 (555) 123-4567</li>
                        <li><i class="fas fa-envelope me-2"></i> support@toystore.com</li>
                    </ul>
                </div>
            </div>
            <hr class="mt-4 mb-3 border-secondary">
            <div class="text-center text-muted">
                <small>&copy; 2024 ToyStore. All rights reserved.</small>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function changeQuantity(delta) {
        var input = document.getElementById('quantityInput');
        var value = parseInt(input.value) || 1;
        var min = parseInt(input.min) || 1;
        var max = parseInt(input.max) || 10;
        value += delta;
        if (value < min) value = min;
        if (value > max) value = max;
        input.value = value;
    }
    </script>
</body>
</html>