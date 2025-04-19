<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management - Toy Store Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">Toy Store</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/toys">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">Reports</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> ${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Product Management</h5>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addToyModal">
                            <i class="fas fa-plus"></i> Add Product
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Image</th>
                                        <th>Name</th>
                                        <th>Brand</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Stock</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${toys}" var="toy">
                                        <tr>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/images/${toy.imageUrl}" 
                                                     alt="${toy.name}" 
                                                     style="width: 50px; height: 50px; object-fit: contain;">
                                            </td>
                                            <td>${toy.name}</td>
                                            <td>${toy.brand}</td>
                                            <td>${toy.category}</td>
                                            <td>$${toy.price}</td>
                                            <td>
                                                <span class="badge bg-${toy.stockQuantity < 10 ? 'danger' : 'success'}">
                                                    ${toy.stockQuantity}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/toys/${toy.id}" 
                                                   class="btn btn-sm btn-primary">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button class="btn btn-sm btn-danger" 
                                                        onclick="deleteToy('${toy.id}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div class="modal fade" id="addToyModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/toys" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Name</label>
                                    <input type="text" class="form-control" name="name" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Brand</label>
                                    <input type="text" class="form-control" name="brand" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Category</label>
                                    <input type="text" class="form-control" name="category" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Age Range</label>
                                    <input type="text" class="form-control" name="ageRange" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Price</label>
                                    <input type="number" step="0.01" class="form-control" name="price" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Stock Quantity</label>
                                    <input type="number" class="form-control" name="stockQuantity" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Product Image</label>
                                    <div class="mb-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="imageType" id="imageUpload" value="upload" checked>
                                            <label class="form-check-label" for="imageUpload">Upload Image</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="imageType" id="imageUrl" value="url">
                                            <label class="form-check-label" for="imageUrl">Image URL</label>
                                        </div>
                                    </div>
                                    <div id="uploadSection">
                                        <input type="file" class="form-control" name="image" accept="image/*">
                                        <div class="mt-2">
                                            <img id="newImagePreview" style="max-width: 200px; max-height: 200px; display: none;">
                                        </div>
                                    </div>
                                    <div id="urlSection" style="display: none;">
                                        <input type="url" class="form-control" name="imageUrl" placeholder="Enter image URL">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" name="description" rows="3" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Dimensions</label>
                                    <input type="text" class="form-control" name="dimensions" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Weight (kg)</label>
                                    <input type="number" step="0.01" class="form-control" name="weight" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Material</label>
                                    <input type="text" class="form-control" name="material" required>
                                </div>
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" name="requiresAssembly" id="requiresAssembly">
                                        <label class="form-check-label" for="requiresAssembly">Requires Assembly</label>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Assembly Time (minutes)</label>
                                    <input type="number" class="form-control" name="assemblyTime" value="0">
                                </div>
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" name="hasBatteries" id="hasBatteries">
                                        <label class="form-check-label" for="hasBatteries">Requires Batteries</label>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Battery Type</label>
                                    <input type="text" class="form-control" name="batteryType">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Minimum Age</label>
                                    <input type="number" class="form-control" name="minimumAge" required>
                                </div>
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" name="hasWarranty" id="hasWarranty">
                                        <label class="form-check-label" for="hasWarranty">Has Warranty</label>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Warranty Months</label>
                                    <input type="number" class="form-control" name="warrantyMonths" value="0">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteToy(toyId) {
            if (confirm('Are you sure you want to delete this product?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/toys';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const toyIdInput = document.createElement('input');
                toyIdInput.type = 'hidden';
                toyIdInput.name = 'toyId';
                toyIdInput.value = toyId;
                
                form.appendChild(actionInput);
                form.appendChild(toyIdInput);
                document.body.appendChild(form);
                form.submit();
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

        // Handle image preview
        document.querySelector('input[name="image"]').addEventListener('change', function(e) {
            const preview = document.getElementById('newImagePreview');
            if (e.target.files && e.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(e.target.files[0]);
            } else {
                preview.style.display = 'none';
            }
        });

        // Handle form submission
        document.querySelector('form').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const imageType = document.querySelector('input[name="imageType"]:checked').value;
            
            if (imageType === 'upload') {
                const imageFile = document.querySelector('input[name="image"]').files[0];
                if (imageFile) {
                    try {
                        // Upload the image first
                        const uploadFormData = new FormData();
                        uploadFormData.append('image', imageFile);
                        
                        const response = await fetch('${pageContext.request.contextPath}/admin/toys/upload-image', {
                            method: 'POST',
                            body: uploadFormData
                        });
                        
                        if (!response.ok) {
                            throw new Error('Image upload failed');
                        }
                        
                        const imageFileName = await response.text();
                        formData.set('imageUrl', imageFileName);
                        
                        // Submit the main form
                        this.submit();
                    } catch (error) {
                        alert('Error uploading image: ' + error.message);
                    }
                } else {
                    alert('Please select an image file');
                }
            } else {
                // If using URL, just submit the form
                this.submit();
            }
        });
    </script>
</body>
</html> 