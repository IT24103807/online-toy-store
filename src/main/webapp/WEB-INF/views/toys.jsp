<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Toys - ToyStore</title>
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

        .filter-card {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
        }

        .page-title {
            color: var(--primary-color);
            margin-bottom: 2rem;
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
                <form class="d-flex mx-auto" action="${pageContext.request.contextPath}/toys" method="get">
                    <input class="form-control search-bar me-2" type="search" name="search" 
                           placeholder="Search for toys..." value="${param.search}" aria-label="Search">
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

    <!-- Main Content -->
    <div class="container py-5">
        <h1 class="page-title text-center mb-5">Explore Our Toys</h1>
        
        <div class="row">
            <!-- Filters -->
            <div class="col-md-3 mb-4">
                <div class="card filter-card">
                    <div class="card-body">
                        <h5 class="card-title mb-4">Filters</h5>
                        <form action="${pageContext.request.contextPath}/toys" method="get">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Age Range</label>
                                <select class="form-select" name="ageRange">
                                    <option value="">All Ages</option>
                                    <option value="0-2" ${param.ageRange == '0-2' ? 'selected' : ''}>0-2 years</option>
                                    <option value="3-5" ${param.ageRange == '3-5' ? 'selected' : ''}>3-5 years</option>
                                    <option value="6-8" ${param.ageRange == '6-8' ? 'selected' : ''}>6-8 years</option>
                                    <option value="9-11" ${param.ageRange == '9-11' ? 'selected' : ''}>9-11 years</option>
                                    <option value="12+" ${param.ageRange == '12+' ? 'selected' : ''}>12+ years</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-bold">Category</label>
                                <select class="form-select" name="category">
                                    <option value="">All Categories</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.name}" ${param.category == cat.name ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-filter me-2"></i>Apply Filters
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="col-md-9">
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty toys}">
                            <div class="col-12">
                                <div class="alert alert-info" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No toys found. Try different search criteria.
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="toy" items="${toys}">
                                <div class="col-md-4 mb-4">
                                    <div class="card product-card h-100">
                                        <img src="${pageContext.request.contextPath}/images/${toy.imageUrl}" 
                                             class="card-img-top product-img p-3" 
                                             alt="${toy.name}"
                                             onerror="this.src='${pageContext.request.contextPath}/images/toy-placeholder.jpg'">
                                        <div class="card-body text-center">
                                            <h5 class="card-title mb-3">${toy.name}</h5>
                                            <p class="card-text text-muted mb-3">${toy.description}</p>
                                            <div class="mb-3">
                                                <span class="badge bg-light text-dark me-2">
                                                    <i class="fas fa-tag me-1"></i>${toy.brand}
                                                </span>
                                                <span class="badge bg-light text-dark">
                                                    <i class="fas fa-child me-1"></i>${toy.ageRange}
                                                </span>
                                            </div>
                                            <p class="h5 mb-3">$<fmt:formatNumber value="${toy.price}" pattern="#,##0.00"/></p>
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/toys/${toy.id}" 
                                                   class="btn btn-outline-primary">
                                                    <i class="fas fa-info-circle me-2"></i>View Details
                                                </a>
                                                <button class="btn btn-primary" onclick="addToCart('${toy.id}')">
                                                    <i class="fas fa-cart-plus me-2"></i>Add to Cart
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

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
    </script>
</body>
</html> 