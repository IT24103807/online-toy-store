<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${empty toy ? 'Add New Toy' : 'Edit Toy'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container mt-4">
        <h2>${empty toy ? 'Add New Toy' : 'Edit Toy'}</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success" role="alert">
                ${success}
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/toys/manage" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="${empty toy ? 'add' : 'update'}">
            <input type="hidden" name="id" value="${toy.id}">
            
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" class="form-control" id="name" name="name" value="${toy.name}" required>
        </div>
            
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea class="form-control" id="description" name="description" rows="3" required>${toy.description}</textarea>
        </div>
            
            <div class="form-group">
                <label for="brand">Brand:</label>
                <input type="text" class="form-control" id="brand" name="brand" value="${toy.brand}" required>
        </div>
            
            <div class="form-group">
                <label for="category">Category:</label>
                <select class="form-control" id="category" name="category" required>
                    <option value="">Select Category</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.name}" ${toy.category == cat.name ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
        </div>
            
            <div class="form-group">
                <label for="ageRange">Age Range:</label>
                <select class="form-control" id="ageRange" name="ageRange" required>
                    <option value="">Select Age Range</option>
                    <option value="0-2" ${toy.ageRange == '0-2' ? 'selected' : ''}>0-2 years</option>
                    <option value="3-5" ${toy.ageRange == '3-5' ? 'selected' : ''}>3-5 years</option>
                    <option value="6-8" ${toy.ageRange == '6-8' ? 'selected' : ''}>6-8 years</option>
                    <option value="9-11" ${toy.ageRange == '9-11' ? 'selected' : ''}>9-11 years</option>
                    <option value="12+" ${toy.ageRange == '12+' ? 'selected' : ''}>12+ years</option>
                </select>
        </div>
            
            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" class="form-control" id="price" name="price" value="${toy.price}" step="0.01" required>
        </div>
            
            <div class="form-group">
                <label for="stockQuantity">Stock Quantity:</label>
                <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="${toy.stockQuantity}" required>
        </div>
            
            <div class="form-group">
                <label for="image">Image:</label>
                <input type="file" class="form-control" id="image" name="image" ${empty toy ? 'required' : ''}>
                <c:if test="${not empty toy.imageUrl}">
                    <img src="${pageContext.request.contextPath}/images/${toy.imageUrl}" alt="${toy.name}" class="img-thumbnail mt-2" style="max-width: 200px;">
                </c:if>
        </div>
            
            <div class="form-group">
                <label for="isActive">Active:</label>
                <select class="form-control" id="isActive" name="isActive">
                    <option value="true" ${toy.active ? 'selected' : ''}>Yes</option>
                    <option value="false" ${not toy.active ? 'selected' : ''}>No</option>
                </select>
        </div>

            <button type="submit" class="btn btn-primary">${empty toy ? 'Add Toy' : 'Update Toy'}</button>
        <a href="${pageContext.request.contextPath}/admin/toys" class="btn btn-secondary">Cancel</a>
    </form>
</div>

    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
