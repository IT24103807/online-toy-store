<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Cards - Toy Store</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <div class="container">
            <h1>My Saved Cards</h1>
            
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <c:choose>
                        <c:when test="${param.success == 'card-added'}">Card added successfully!</c:when>
                        <c:when test="${param.success == 'card-deleted'}">Card deleted successfully!</c:when>
                        <c:when test="${param.success == 'default-set'}">Default card updated successfully!</c:when>
                    </c:choose>
                </div>
            </c:if>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    <c:choose>
                        <c:when test="${param.error == 'add-failed'}">Failed to add card. Please try again.</c:when>
                        <c:when test="${param.error == 'delete-failed'}">Failed to delete card. Please try again.</c:when>
                        <c:when test="${param.error == 'update-failed'}">Failed to update card. Please try again.</c:when>
                        <c:when test="${param.error == 'card-not-found'}">Card not found.</c:when>
                        <c:when test="${param.error == 'invalid-date'}">Invalid expiry date format. Please use MM/YY.</c:when>
                    </c:choose>
                </div>
            </c:if>
            
            <div class="card-list">
                <c:forEach items="${cards}" var="card">
                    <div class="card-item">
                        <div class="card-header">
                            <h3>${card.cardHolderName}</h3>
                            <c:if test="${card.isDefault}">
                                <span class="badge">Default</span>
                            </c:if>
                        </div>
                        <div class="card-details">
                            <p>Card Number: ${card.maskedCardNumber}</p>
                            <p>Expiry Date: ${card.expiryDate}</p>
                        </div>
                        <div class="card-actions">
                            <c:if test="${not card.isDefault}">
                                <form action="${pageContext.request.contextPath}/cards" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="setDefault">
                                    <input type="hidden" name="cardId" value="${card.id}">
                                    <button type="submit" class="btn btn-primary">Set as Default</button>
                                </form>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/cards" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="cardId" value="${card.id}">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this card?')">Delete</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty cards}">
                    <div class="empty-state">
                        <p>You haven't saved any cards yet.</p>
                    </div>
                </c:if>
            </div>
            
            <div class="add-card-section">
                <a href="${pageContext.request.contextPath}/cards/add" class="btn btn-primary">Add New Card</a>
            </div>
        </div>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </body>
</html> 