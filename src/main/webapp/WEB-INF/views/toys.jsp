<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Toys - ToyStore</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/toys">Toys</a>
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
        <div class="row mb-4">
            <div class="col-md-6">
                <h2>Our Toys</h2>
            </div>
            <div class="col-md-6">
                <div class="d-flex justify-content-end">
                    <form class="d-flex" action="${pageContext.request.contextPath}/toys" method="get">
                        <input type="text" name="search" class="form-control me-2" 
                               placeholder="Search toys..." value="${param.search}">
                        <button class="btn btn-primary" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Filters</h5>
                        <form action="${pageContext.request.contextPath}/toys" method="get">
                            <div class="mb-3">
                                <label class="form-label">Brand</label>
                                <select class="form-select" name="brand">
                                    <option value="">All Brands</option>
                                    <option value="LEGO" ${param.brand == 'LEGO' ? 'selected' : ''}>LEGO</option>
                                    <option value="Barbie" ${param.brand == 'Barbie' ? 'selected' : ''}>Barbie</option>
                                    <option value="Hot Wheels" ${param.brand == 'Hot Wheels' ? 'selected' : ''}>Hot Wheels</option>
                                    <option value="Nerf" ${param.brand == 'Nerf' ? 'selected' : ''}>Nerf</option>
                                    <option value="Play-Doh" ${param.brand == 'Play-Doh' ? 'selected' : ''}>Play-Doh</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Age Range</label>
                                <select class="form-select" name="ageRange">
                                    <option value="">All Ages</option>
                                    <option value="3+" ${param.ageRange == '3+' ? 'selected' : ''}>3+</option>
                                    <option value="6-12" ${param.ageRange == '6-12' ? 'selected' : ''}>6-12</option>
                                    <option value="8+" ${param.ageRange == '8+' ? 'selected' : ''}>8+</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Apply Filters</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="row">
                    <c:choose>
                        <c:when test="${empty toys}">
                            <div class="col-12">
                                <div class="alert alert-info" role="alert">
                                    No toys found. Try different search criteria.
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="toy" items="${toys}">
                                <div class="col-md-4 mb-4">
                                    <div class="card h-100">
                                        <div class="toy-image" style="height: 200px; overflow: hidden;">
                                            <img src="${pageContext.request.contextPath}/images/${toy.imageUrl}" 
                                                 alt="${toy.name}" 
                                                 class="img-fluid"
                                                 style="width: 100%; height: 100%; object-fit: cover;"
                                                 onerror="this.src='${pageContext.request.contextPath}/images/toy-placeholder.jpg'">
                                        </div>
                                        <div class="card-body">
                                            <h5 class="card-title">${toy.name}</h5>
                                            <p class="card-text">${toy.description}</p>
                                            <p class="card-text">
                                                <small class="text-muted">
                                                    Brand: ${toy.brand}<br>
                                                    Age Range: ${toy.ageRange}
                                                </small>
                                            </p>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="h5 mb-0">$<fmt:formatNumber value="${toy.price}" pattern="#,##0.00"/></span>
                                                <button class="btn btn-primary" onclick="addToCart('${toy.id}')">
                                                    Add to Cart
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
    </script>
</body>
</html> 