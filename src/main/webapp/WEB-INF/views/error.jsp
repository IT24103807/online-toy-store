<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error - ToyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 5rem;
            background-color: #f8f9fa;
        }
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container">
            <h1 class="text-danger mb-4">Oops! Something went wrong</h1>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <strong>Error:</strong> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty exception and pageContext.errorData.statusCode == 500}">
                <div class="alert alert-warning">
                    <strong>Exception:</strong> ${exception.message}
                </div>
            </c:if>
            
            <p>We're sorry, but an error occurred while processing your request.</p>
            
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary me-2">
                    Return to Home
                </a>
                <a href="javascript:history.back()" class="btn btn-outline-secondary">
                    Go Back
                </a>
            </div>
            
            <!-- Only show stack trace in development -->
            <c:if test="${pageContext.request.serverName == 'localhost' or pageContext.request.serverName == '127.0.0.1'}">
                <div class="mt-4">
                    <button class="btn btn-sm btn-link" type="button" data-bs-toggle="collapse" data-bs-target="#stacktrace">
                        Show Technical Details
                    </button>
                    <div class="collapse mt-2" id="stacktrace">
                        <div class="card card-body bg-light">
                            <c:if test="${not empty exception}">
                                <pre><c:forEach items="${exception.stackTrace}" var="trace">${trace}
</c:forEach></pre>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
