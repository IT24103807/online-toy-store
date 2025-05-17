<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <!-- Optional: Show toy info if present -->
            <c:if test="${not empty toy}">
                <div class="card shadow-sm mb-4">
                    <div class="row g-0 align-items-center">
                        <div class="col-md-5 p-4">
                            <img src="${pageContext.request.contextPath}/images/${toy.imageUrl}" alt="${toy.name}" class="img-fluid rounded w-100 mb-3 mb-md-0" style="max-height:320px; object-fit:cover;">
                        </div>
                        <div class="col-md-7 p-4">
                            <h2 class="mb-3">${toy.name}</h2>
                            <p class="mb-2 text-muted">${toy.description}</p>
                            <ul class="list-group list-group-flush mb-3">
                                <li class="list-group-item"><strong>Brand:</strong> ${toy.brand}</li>
                                <li class="list-group-item"><strong>Age Range:</strong> ${toy.ageRange}</li>
                                <li class="list-group-item"><strong>Price:</strong> $<fmt:formatNumber value="${toy.price}" pattern="#0.00"/></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:if>
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h3 class="mb-3">Reviews</h3>
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <div class="alert alert-info mb-0">No reviews yet. Be the first to review this toy!</div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group mb-4">
                                <c:forEach var="review" items="${reviews}">
                                    <div class="list-group-item mb-3 p-4 shadow-sm rounded">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <span class="fw-semibold">${review.userName}</span>
                                                <span class="text-muted small ms-2">${review.reviewDate}</span>
                                            </div>
                                            <div>
                                                <c:forEach var="i" begin="1" end="5">
                                                    <c:choose>
                                                        <c:when test="${i <= review.rating}">
                                                            <i class="fa fa-star text-warning"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa fa-star text-secondary"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="fw-bold mb-1">${review.title}</div>
                                        <div>${review.comment}</div>
                                        <c:if test="${not empty user && user.id == review.userId}">
                                            <form action="${pageContext.request.contextPath}/reviews" method="post" class="d-inline">
                                                <input type="hidden" name="reviewId" value="${review.id}" />
                                                <button type="submit" name="action" value="edit" class="btn btn-link btn-sm">Edit</button>
                                                <button type="submit" name="action" value="delete" class="btn btn-link btn-sm text-danger" onclick="return confirm('Delete this review?');">Delete</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${not empty user}">
                        <!-- Add/Edit Review Form can be included here if needed -->
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Bootstrap JS (optional) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</body>
</html>
