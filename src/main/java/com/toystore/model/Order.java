package com.toystore.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.toystore.model.User;

public class Order {
    private String id;
    private String userId;
    private User user;
    private List<OrderItem> items;
    private double subtotal;
    private double tax;
    private double shippingCost;
    private double totalAmount;
    private String shippingAddress;
    private String paymentMethod;
    private String orderStatus;
    private Date orderDate;
    private Date lastModifiedDate;
    private String trackingNumber;
    private Date estimatedDeliveryDate;
    private int loyaltyPointsEarned;
    private String couponCode;
    private double discountAmount;

    public Order() {
        this.items = new ArrayList<>();
        this.orderDate = new Date();
        this.lastModifiedDate = new Date();
        this.orderStatus = "PENDING";
    }

    public Order(String id, String userId, String shippingAddress, String paymentMethod, String couponCode) {
        this();
        this.id = id;
        this.userId = userId;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.couponCode = couponCode;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getTax() { return tax; }
    public void setTax(double tax) { this.tax = tax; }

    public double getShippingCost() { return shippingCost; }
    public void setShippingCost(double shippingCost) { this.shippingCost = shippingCost; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
        this.lastModifiedDate = new Date();
    }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public Date getLastModifiedDate() { return lastModifiedDate; }
    public void setLastModifiedDate(Date lastModifiedDate) { this.lastModifiedDate = lastModifiedDate; }

    public String getTrackingNumber() { return trackingNumber; }
    public void setTrackingNumber(String trackingNumber) { this.trackingNumber = trackingNumber; }

    public Date getEstimatedDeliveryDate() { return estimatedDeliveryDate; }
    public void setEstimatedDeliveryDate(Date estimatedDeliveryDate) { this.estimatedDeliveryDate = estimatedDeliveryDate; }

    public int getLoyaltyPointsEarned() { return loyaltyPointsEarned; }
    public void setLoyaltyPointsEarned(int loyaltyPointsEarned) { this.loyaltyPointsEarned = loyaltyPointsEarned; }

    public String getCouponCode() { return couponCode; }
    public void setCouponCode(String couponCode) { this.couponCode = couponCode; }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    // Business logic methods
    public void addItem(OrderItem item) {
        this.items.add(item);
        calculateTotals();
    }

    public void removeItem(OrderItem item) {
        this.items.remove(item);
        calculateTotals();
    }

    public void calculateTotals() {
        // Calculate subtotal
        this.subtotal = items.stream()
                .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                .sum();

        // Apply discount if coupon code exists
        if (this.couponCode != null && !this.couponCode.isEmpty()) {
            this.discountAmount = this.subtotal * 0.1; // 10% discount
            this.subtotal -= this.discountAmount;
        }

        // Calculate tax (assuming 8% tax rate)
        this.tax = this.subtotal * 0.08;

        // Calculate shipping cost (flat rate)
        this.shippingCost = 5.99;

        // Calculate total
        this.totalAmount = this.subtotal + this.tax + this.shippingCost;

        // Calculate loyalty points (1 point per dollar spent)
        this.loyaltyPointsEarned = (int) this.totalAmount;

        this.lastModifiedDate = new Date();
    }

    public boolean canBeCancelled() {
        return "PENDING".equals(this.orderStatus) || "PROCESSING".equals(this.orderStatus);
    }

    public boolean isDelivered() {
        return "DELIVERED".equals(this.orderStatus);
    }

    @Override
    public String toString() {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return String.format("%s,%s,%s,%.2f,%.2f,%.2f,%.2f,%s,%s,%s,%s,%s,%s,%s,%d,%s,%.2f,%s,%.2f",
                id,
                userId,
                orderDate != null ? sdf.format(orderDate) : "null",
                subtotal,
                tax,
                shippingCost,
                totalAmount,
                shippingAddress != null ? shippingAddress : "null",
                paymentMethod != null ? paymentMethod : "null",
                orderStatus != null ? orderStatus : "null",
                orderDate != null ? sdf.format(orderDate) : "null",
                lastModifiedDate != null ? sdf.format(lastModifiedDate) : "null",
                trackingNumber != null ? trackingNumber : "null",
                estimatedDeliveryDate != null ? sdf.format(estimatedDeliveryDate) : "null",
                loyaltyPointsEarned,
                couponCode != null ? couponCode : "null",
                discountAmount,
                "null", // placeholder for missing field 18
                0.00     // placeholder for missing field 19
        );
    }
} 