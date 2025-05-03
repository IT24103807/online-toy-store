<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Card - Toy Store</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <div class="container">
            <h1>Add New Card</h1>
            
            <form action="${pageContext.request.contextPath}/cards" method="post" class="card-form">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" required 
                           pattern="[0-9]{16}" maxlength="16"
                           placeholder="Enter 16-digit card number">
                </div>
                
                <div class="form-group">
                    <label for="cardHolderName">Cardholder Name</label>
                    <input type="text" id="cardHolderName" name="cardHolderName" required
                           placeholder="Enter name as it appears on card">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="expiryDate">Expiry Date</label>
                        <input type="text" id="expiryDate" name="expiryDate" required
                               pattern="(0[1-9]|1[0-2])\/([0-9]{2})"
                               placeholder="MM/YY">
                    </div>
                    
                    <div class="form-group">
                        <label for="cvv">CVV</label>
                        <input type="text" id="cvv" name="cvv" required
                               pattern="[0-9]{3,4}" maxlength="4"
                               placeholder="3 or 4 digits">
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" name="isDefault">
                        Set as default card
                    </label>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Card</button>
                    <a href="${pageContext.request.contextPath}/cards" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
        
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        
        <script>
            // Format card number input
            document.getElementById('cardNumber').addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length > 16) value = value.slice(0, 16);
                e.target.value = value;
            });
            
            // Format expiry date input
            document.getElementById('expiryDate').addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length > 4) value = value.slice(0, 4);
                if (value.length > 2) {
                    value = value.slice(0, 2) + '/' + value.slice(2);
                }
                e.target.value = value;
            });
            
            // Format CVV input
            document.getElementById('cvv').addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length > 4) value = value.slice(0, 4);
                e.target.value = value;
            });
        </script>
    </body>
</html> 