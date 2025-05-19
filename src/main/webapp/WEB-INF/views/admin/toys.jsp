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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #6a4fb6;
            --secondary-color: #b6e0fe;
            --accent-color: #f7b6c2;
            --background-light: #f8f9fa;
            --border-radius: 24px;
            --box-shadow: 0 4px 24px 0 rgba(106, 79, 182, 0.10);
        }
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--background-light);
            color: var(--primary-color);
        }
        .navbar {
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            background: #fff;
            margin: 1.5rem auto 2rem auto;
            max-width: 1100px;
            padding: 0.7rem 2rem;
        }
        .navbar-brand {
            font-size: 1.5rem;
            color: var(--primary-color);
            font-weight: 700;
            letter-spacing: 1px;
        }
        .nav-link {
            color: var(--primary-color) !important;
            font-weight: 600;
            border-radius: 32px;
            padding: 0.4rem 1.2rem;
            margin-left: 0.5rem;
            background: transparent;
            transition: background 0.2s, color 0.2s;
        }
        .nav-link:hover, .nav-link.active {
            background: var(--accent-color);
            color: var(--secondary-color) !important;
        }
        .dropdown-menu {
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            border: none;
            padding: 0.5rem;
        }
        .dropdown-item {
            border-radius: 16px;
            padding: 0.5rem 1rem;
            color: var(--primary-color);
            font-weight: 500;
        }
        .dropdown-item:hover {
            background: var(--secondary-color);
            color: #fff;
        }
        .card {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
            background: #fff;
            margin-bottom: 1.5rem;
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-2px);
        }
        .container {
            max-width: 1100px;
        }
        .modal-dialog {
            max-width: 600px;
        }
        .toy-image-preview {
            max-width: 200px;
            max-height: 200px;
            display: none;
            margin-top: 10px;
        }
        .nav-link.active {
            background: #e9aebe; /* more visible, less pastel pink */
            color: #fff !important;
            border-radius: 18px; /* less curve for pill shape */
            font-weight: 700;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-store me-2"></i>Toy Store Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                        <i class="fas fa-chart-line me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                        <i class="fas fa-users me-1"></i>Users
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/toys">
                        <i class="fas fa-cube me-1"></i>Products
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
                        <i class="fas fa-tags me-1"></i>Categories
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                        <i class="fas fa-shopping-cart me-1"></i>Orders
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-1"></i>${sessionScope.user.fullName}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile">
                            <i class="fas fa-user-cog me-2"></i>Profile
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a></li>
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
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#toyModal">
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
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${toys}" var="toy">
                                <tr data-toy-id="${toy.id}">
                                    <td>
                                        <img src="${pageContext.request.contextPath}/uploads/toys/${toy.imageUrl}"
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
                                                <span class="badge bg-${toy.active ? 'success' : 'secondary'}">
                                                        ${toy.active ? 'Active' : 'Inactive'}
                                                </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-primary"
                                                onclick="editToy('${toy.id}', '${toy.name}', '${toy.description}', '${toy.brand}', '${toy.category}', '${toy.price}', '${toy.stockQuantity}', '${toy.imageUrl}', '${toy.active}', '${toy.ageRange}')">
                                            <i class="fas fa-edit"></i>
                                        </button>
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

<!-- Add/Edit Product Modal -->
<div class="modal fade" id="toyModal" tabindex="-1" aria-labelledby="toyModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="toyModalLabel">Add New Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/toys" method="post" enctype="multipart/form-data" id="toyForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="toyId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="name" class="form-label">Name</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="">Select Category</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.name}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="price" class="form-label">Price</label>
                        <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                    </div>
                    <div class="mb-3">
                        <label for="stockQuantity" class="form-label">Stock Quantity</label>
                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" required>
                    </div>
                    <div class="mb-3">
                        <label for="image" class="form-label">Product Image</label>
                        <input type="file" class="form-control" id="image" name="image" accept="image/*" onchange="previewImage(this)">
                        <img id="imagePreview" class="toy-image-preview" alt="Preview">
                        <input type="hidden" id="currentImage" name="currentImage">
                    </div>
                    <div class="mb-3">
                        <label for="isActive" class="form-label">Status</label>
                        <select class="form-control" id="isActive" name="isActive">
                            <option value="true" selected>Active</option>
                            <option value="false">Inactive</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="ageRange" class="form-label">Age Range</label>
                        <select class="form-select" id="ageRange" name="ageRange" required>
                            <option value="">Select Age Range</option>
                            <option value="0-2">0-2 years</option>
                            <option value="3-5">3-5 years</option>
                            <option value="6-8">6-8 years</option>
                            <option value="9-11">9-11 years</option>
                            <option value="12+">12+ years</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function deleteToy(toyId) {
        if (confirm('Are you sure you want to delete this toy?')) {
            fetch('${pageContext.request.contextPath}/admin/toys/delete?id=' + toyId, {
                method: 'POST'
            })
                .then(response => {
                    if (response.ok) {
                        // Refresh the page after successful deletion
                        window.location.reload();
                    } else {
                        showAlert('Failed to delete toy. Please try again.', 'danger');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('An error occurred while deleting the toy.', 'danger');
                });
        }
    }

    function editToy(toyId, name, description, brand, category, price, stockQuantity, imageUrl, isActive, ageRange) {
        const modal = new bootstrap.Modal(document.getElementById('toyModal'));
        document.getElementById('toyModalLabel').textContent = 'Edit Product';
        document.getElementById('toyId').value = toyId;
        document.getElementById('name').value = name;
        document.getElementById('description').value = description;
        document.getElementById('category').value = category;
        document.getElementById('price').value = price;
        document.getElementById('stockQuantity').value = stockQuantity;
        document.getElementById('currentImage').value = imageUrl;
        document.getElementById('isActive').value = isActive;
        if (ageRange && document.getElementById('ageRange')) {
            document.getElementById('ageRange').value = ageRange;
        }
        document.getElementById('formAction').value = 'update';

        // Clear the file input
        document.getElementById('image').value = '';

        // Show current image if exists
        if (imageUrl) {
            document.getElementById('imagePreview').src = '${pageContext.request.contextPath}/uploads/toys/' + imageUrl;
            document.getElementById('imagePreview').style.display = 'block';
        } else {
            document.getElementById('imagePreview').style.display = 'none';
        }

        modal.show();
    }

    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        const currentImage = document.getElementById('currentImage');

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
                // Clear the current image value when a new image is selected
                currentImage.value = '';
            }
            reader.readAsDataURL(input.files[0]);
        } else if (currentImage.value) {
            // If no new file selected but there's a current image, show it
            preview.src = '${pageContext.request.contextPath}/uploads/toys/' + currentImage.value;
            preview.style.display = 'block';
        } else {
            preview.style.display = 'none';
        }
    }

    // Reset form when modal is closed
    document.getElementById('toyModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('toyForm').reset();
        document.getElementById('imagePreview').style.display = 'none';
        document.getElementById('toyModalLabel').textContent = 'Add New Product';
        document.getElementById('formAction').value = 'add';
        document.getElementById('toyId').value = '';
        document.getElementById('currentImage').value = '';
    });

    // Handle form submission
    document.getElementById('toyForm').addEventListener('submit', function(e) {
        const action = document.getElementById('formAction').value;
        const toyId = document.getElementById('toyId').value;

        if (action === 'update' && !toyId) {
            e.preventDefault();
            showAlert('Invalid toy ID for update', 'danger');
            return;
        }

        // Validate required fields
        const requiredFields = ['name', 'description', 'brand', 'category', 'price', 'stockQuantity'];
        for (const field of requiredFields) {
            const input = document.getElementById(field);
            if (!input.value.trim()) {
                e.preventDefault();
                showAlert(`Please fill in the ${field} field`, 'danger');
                return;
            }
        }
    });
</script>
</body>
</html> 