<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to ToyStore</title>
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

        .hero-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 100px 0;
            margin-bottom: 4rem;
        }

        .product-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }

        .product-img {
            height: 200px;
            object-fit: contain;
        }

        .brand-logo {
            font-size: 1.8rem;
            color: var(--primary-color);
            text-decoration: none;
        }

        .search-bar {
            max-width: 400px;
            border-radius: 20px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: darken(var(--primary-color), 10%);
            border-color: darken(var(--primary-color), 10%);
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
                <form class="d-flex mx-auto">
                    <input class="form-control search-bar me-2" type="search" placeholder="Search for toys..." aria-label="Search">
                    <button class="btn btn-outline-primary" type="submit"><i class="fas fa-search"></i></button>
                </form>

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

    <!-- Hero Section -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold mb-4">Discover the Magic of Play</h1>
            <p class="lead mb-4">Explore our collection of educational and fun toys for all ages</p>
            <a href="${pageContext.request.contextPath}/toys" class="btn btn-light btn-lg px-4">
                Shop Now <i class="fas fa-arrow-right ms-2"></i>
            </a>
        </div>
    </section>

    <!-- Featured Products -->
    <section class="container mb-5">
        <h2 class="text-center mb-4">Featured Toys</h2>
        <div class="row g-4">
            <c:forEach var="toy" items="${toys}">
                <div class="col-md-3">
                    <div class="card product-card h-100">
                        <img src="${toy.imageUrl}" class="card-img-top product-img p-3" alt="${toy.name}">
                        <div class="card-body text-center">
                            <h5 class="card-title">${toy.name}</h5>
                            <div class="rating-stars mb-2">
                                <c:choose>
                                    <c:when test="${toy.rating > 0}">
                                        <c:set var="fullStars" value="${toy.rating - (toy.rating % 1)}" />
                                        <c:set var="hasHalfStar" value="${toy.rating - fullStars >= 0.5}" />
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= fullStars}">
                                                    <i class="fas fa-star text-warning"></i>
                                                </c:when>
                                                <c:when test="${i == fullStars + 1 && hasHalfStar}">
                                                    <i class="fas fa-star-half-alt text-warning"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star text-warning"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <span class="text-muted small ms-1">
                                            <fmt:formatNumber value="${toy.rating}" maxFractionDigits="1"/>/5
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">No ratings yet</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="h5 mb-3">$${toy.price}</p>
                            <a href="${pageContext.request.contextPath}/toys/${toy.id}" class="btn btn-outline-primary">
                                View Details
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Features Section -->
    <section class="bg-light py-5 mb-5">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4 text-center">
                    <i class="fas fa-truck fa-3x mb-3 text-primary"></i>
                    <h4>Free Shipping</h4>
                    <p class="text-muted">On orders over $50</p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-undo fa-3x mb-3 text-primary"></i>
                    <h4>Easy Returns</h4>
                    <p class="text-muted">30-day return policy</p>
                </div>
                <div class="col-md-4 text-center">
                    <i class="fas fa-lock fa-3x mb-3 text-primary"></i>
                    <h4>Secure Shopping</h4>
                    <p class="text-muted">100% secure payment</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
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
</body>
</html>
