<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Toy - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%-- Reuse your existing navbar or dashboard header --%>
<jsp:include page="/WEB-INF/views/admin/navbar.jsp" />

<div class="container mt-4">
    <h2>Edit Toy: ${editToy.name}</h2>
    <form action="${pageContext.request.contextPath}/admin/toys/${editToy.id}" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="edit">

        <div class="mb-3">
            <label>Name</label>
            <input class="form-control" type="text" name="name" value="${editToy.name}" required>
        </div>
        <div class="mb-3">
            <label>Description</label>
            <textarea class="form-control" name="description">${editToy.description}</textarea>
        </div>
        <div class="mb-3">
            <label>Brand</label>
            <input class="form-control" type="text" name="brand" value="${editToy.brand}">
        </div>
        <div class="mb-3">
            <label>Category</label>
            <input class="form-control" type="text" name="category" value="${editToy.category}">
        </div>
        <div class="mb-3">
            <label>Age Range</label>
            <input class="form-control" type="text" name="ageRange" value="${editToy.ageRange}">
        </div>
        <div class="mb-3">
            <label>Price</label>
            <input class="form-control" type="number" step="0.01" name="price" value="${editToy.price}">
        </div>
        <div class="mb-3">
            <label>Stock Quantity</label>
            <input class="form-control" type="number" name="stockQuantity" value="${editToy.stockQuantity}">
        </div>
        <div class="mb-3">
            <label>Current Image</label>
            <div class="mb-2">
                <img src="${pageContext.request.contextPath}/images/${editToy.imageUrl}" 
                     alt="${editToy.name}" 
                     style="max-width: 200px; max-height: 200px;"
                     id="currentImage">
            </div>
            <div class="mb-2">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="imageType" id="imageUpload" value="upload" checked>
                    <label class="form-check-label" for="imageUpload">Upload New Image</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="imageType" id="imageUrl" value="url">
                    <label class="form-check-label" for="imageUrl">Use Image URL</label>
                </div>
            </div>
            <div id="uploadSection">
                <input class="form-control" type="file" name="image" accept="image/*" onchange="previewImage(this)">
                <div class="mt-2">
                    <img id="imagePreview" style="max-width: 200px; max-height: 200px; display: none;">
                </div>
            </div>
            <div id="urlSection" style="display: none;">
                <input type="url" class="form-control" name="imageUrl" placeholder="Enter image URL">
            </div>
        </div>
        <div class="mb-3">
            <label>Dimensions</label>
            <input class="form-control" type="text" name="dimensions" value="${editToy.dimensions}">
        </div>
        <div class="mb-3">
            <label>Weight (kg)</label>
            <input class="form-control" type="number" step="0.01" name="weight" value="${editToy.weight}">
        </div>
        <div class="mb-3">
            <label>Material</label>
            <input class="form-control" type="text" name="material" value="${editToy.material}">
        </div>
        <div class="mb-3 form-check">
            <input class="form-check-input" type="checkbox" name="requiresAssembly" id="requiresAssembly" ${editToy.requiresAssembly ? 'checked' : ''}>
            <label class="form-check-label" for="requiresAssembly">Requires Assembly</label>
        </div>
        <div class="mb-3">
            <label>Assembly Time (mins)</label>
            <input class="form-control" type="number" name="assemblyTime" value="${editToy.assemblyTime}">
        </div>
        <div class="mb-3 form-check">
            <input class="form-check-input" type="checkbox" name="hasBatteries" id="hasBatteries" ${editToy.hasBatteries ? 'checked' : ''}>
            <label class="form-check-label" for="hasBatteries">Has Batteries</label>
        </div>
        <div class="mb-3">
            <label>Battery Type</label>
            <input class="form-control" type="text" name="batteryType" value="${editToy.batteryType}">
        </div>
        <div class="mb-3">
            <label>Minimum Age</label>
            <input class="form-control" type="number" name="minimumAge" value="${editToy.minimumAge}">
        </div>
        <div class="mb-3 form-check">
            <input class="form-check-input" type="checkbox" name="hasWarranty" id="hasWarranty" ${editToy.hasWarranty ? 'checked' : ''}>
            <label class="form-check-label" for="hasWarranty">Has Warranty</label>
        </div>
        <div class="mb-3">
            <label>Warranty (months)</label>
            <input class="form-control" type="number" name="warrantyMonths" value="${editToy.warrantyMonths}">
        </div>

        <button type="submit" class="btn btn-success">Save Changes</button>
        <a href="${pageContext.request.contextPath}/admin/toys" class="btn btn-secondary">Cancel</a>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function previewImage(input) {
    const preview = document.getElementById('imagePreview');
    const currentImage = document.getElementById('currentImage');
    
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
            currentImage.style.display = 'none';
        }
        
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.style.display = 'none';
        currentImage.style.display = 'block';
    }
}

// Handle image type selection
document.querySelectorAll('input[name="imageType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const uploadSection = document.getElementById('uploadSection');
        const urlSection = document.getElementById('urlSection');
        if (this.value === 'upload') {
            uploadSection.style.display = 'block';
            urlSection.style.display = 'none';
        } else {
            uploadSection.style.display = 'none';
            urlSection.style.display = 'block';
        }
    });
});
</script>
</body>
</html>
