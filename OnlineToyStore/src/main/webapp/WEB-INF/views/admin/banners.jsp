<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Banners - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        body { background: #17252A; color: #FEFFFF; }
        .banner-grid { display: flex; flex-wrap: wrap; gap: 2rem; justify-content: center; }
        .banner-card {
            background: #2B7A78;
            border-radius: 16px;
            box-shadow: 0 2px 15px rgba(44, 62, 80, 0.18);
            padding: 1.5rem;
            text-align: center;
            width: 220px;
        }
        .banner-card img {
            width: 180px;
            height: 100px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 1rem;
            background: #DEF2F1;
        }
        .banner-card .filename {
            color: #DEF2F1;
            font-size: 0.95em;
            margin-bottom: 0.7rem;
        }
        .banner-card .btn {
            margin: 0 0.2rem;
        }
        .add-banner-form {
            background: #2B7A78;
            border-radius: 16px;
            box-shadow: 0 2px 15px rgba(44, 62, 80, 0.18);
            padding: 2rem 1.5rem;
            margin: 2rem auto 2.5rem auto;
            max-width: 400px;
        }
        .add-banner-form label { color: #3AAFA9; font-weight: 600; }
    </style>
</head>
<body>
<jsp:include page="panel.jsp" />
<div class="container mt-5">
    <h2 class="mb-4" style="color:#3AAFA9; font-weight:800;">Manage Banners</h2>
    <form class="add-banner-form mb-5" action="${pageContext.request.contextPath}/admin/banners" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="bannerFile" class="form-label">Add New Banner</label>
            <input type="file" class="form-control" id="bannerFile" name="bannerFile" accept="image/*" required>
        </div>
        <button type="submit" class="btn btn-register-home">Upload Banner</button>
    </form>
    <div class="banner-grid">
        <c:forEach var="banner" items="${banners}">
            <div class="banner-card">
                <img src="${pageContext.request.contextPath}/images/banner/${banner}" alt="Banner Preview">
                <div class="filename">${banner}</div>
                <form action="${pageContext.request.contextPath}/admin/banners" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="filename" value="${banner}">
                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                </form>
                <form action="${pageContext.request.contextPath}/admin/banners" method="post" enctype="multipart/form-data" style="display:inline;">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="filename" value="${banner}">
                    <input type="file" name="newBanner" accept="image/*" style="display:inline;width:120px;">
                    <button type="submit" class="btn btn-info btn-sm">Replace</button>
                </form>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html> 