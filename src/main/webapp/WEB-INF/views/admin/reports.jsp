<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Reports - Toy Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card {
            margin-bottom: 20px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid rgba(0,0,0,.125);
        }
        .table th {
            background-color: #f8f9fa;
        }
        .stock-low {
            color: #dc3545;
        }
        .stock-medium {
            color: #ffc107;
        }
        .stock-high {
            color: #28a745;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/adminHeader.jsp" />
    
    <div class="container-fluid py-4">
        <h1 class="mb-4">Store Analytics Dashboard</h1>
        
        <!-- Date Range Filter -->
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="card-title mb-0">
                    <i class="fas fa-calendar me-2"></i>Date Range Filter
                </h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/reports" method="get" class="row g-3">
                    <div class="col-md-4">
                        <label for="startDate" class="form-label">Start Date</label>
                        <input type="date" class="form-control" id="startDate" name="startDate" 
                               value="${startDate}">
                    </div>
                    <div class="col-md-4">
                        <label for="endDate" class="form-label">End Date</label>
                        <input type="date" class="form-control" id="endDate" name="endDate" 
                               value="${endDate}">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-2"></i>Apply Filter
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="row">
            <!-- Sales Overview -->
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-chart-line me-2"></i>Sales Trend
                        </h5>
                    </div>
                    <div class="card-body">
                        <canvas id="salesChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Customer Demographics -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-users me-2"></i>Customer Demographics
                        </h5>
                    </div>
                    <div class="card-body">
                        <canvas id="demographicsChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Top Products -->
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-trophy me-2"></i>Top Selling Products
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Units Sold</th>
                                        <th>Revenue</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${topProducts}" var="product">
                                        <tr>
                                            <td>${product.name}</td>
                                            <td>${product.unitsSold}</td>
                                            <td>$<fmt:formatNumber value="${product.revenue}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Top Customers -->
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-star me-2"></i>Top Customers
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Customer</th>
                                        <th>Orders</th>
                                        <th>Total Spent</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${topCustomers}" var="customer">
                                        <tr>
                                            <td>${customer.fullName}</td>
                                            <td>${customer.orderCount}</td>
                                            <td>$<fmt:formatNumber value="${customer.totalSpent}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Inventory Status -->
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">
                    <i class="fas fa-boxes me-2"></i>Inventory Status
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Brand</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock Level</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${inventory}" var="toy">
                                <tr>
                                    <td>${toy.name}</td>
                                    <td>${toy.brand}</td>
                                    <td>${toy.category}</td>
                                    <td>$<fmt:formatNumber value="${toy.price}" pattern="#,##0.00"/></td>
                                    <td>${toy.quantity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${toy.quantity <= 5}">
                                                <span class="stock-low">
                                                    <i class="fas fa-exclamation-triangle"></i> Low Stock
                                                </span>
                                            </c:when>
                                            <c:when test="${toy.quantity <= 15}">
                                                <span class="stock-medium">
                                                    <i class="fas fa-exclamation-circle"></i> Medium Stock
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="stock-high">
                                                    <i class="fas fa-check-circle"></i> In Stock
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Sales Chart
        const salesCtx = document.getElementById('salesChart').getContext('2d');
        new Chart(salesCtx, {
            type: 'line',
            data: {
                labels: ${salesLabels},
                datasets: [{
                    label: 'Daily Sales',
                    data: ${salesData},
                    borderColor: 'rgb(75, 192, 192)',
                    tension: 0.1,
                    fill: false
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Daily Sales Trend'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });

        // Demographics Chart
        const demographicsCtx = document.getElementById('demographicsChart').getContext('2d');
        new Chart(demographicsCtx, {
            type: 'pie',
            data: {
                labels: ${demographicsLabels},
                datasets: [{
                    data: ${demographicsData},
                    backgroundColor: [
                        'rgb(255, 99, 132)',
                        'rgb(54, 162, 235)',
                        'rgb(255, 205, 86)'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    },
                    title: {
                        display: true,
                        text: 'Customer Distribution'
                    }
                }
            }
        });
    </script>
</body>
</html> 