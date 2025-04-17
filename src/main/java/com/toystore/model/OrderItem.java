package com.toystore.model;

public class OrderItem {
    private String id;
    private String orderId;
    private String toyId;
    private String toyName;
    private int quantity;
    private double unitPrice;
    private double weight;
    private boolean isGiftWrapped;
    private String giftMessage;
    private double discount;

    public OrderItem() {
    }

    public OrderItem(String id, String orderId, String toyId, String toyName, int quantity,
                    double unitPrice, double weight, boolean isGiftWrapped, String giftMessage) {
        this.id = id;
        this.orderId = orderId;
        this.toyId = toyId;
        this.toyName = toyName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.weight = weight;
        this.isGiftWrapped = isGiftWrapped;
        this.giftMessage = giftMessage;
        this.discount = 0.0;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getToyId() { return toyId; }
    public void setToyId(String toyId) { this.toyId = toyId; }

    public String getToyName() { return toyName; }
    public void setToyName(String toyName) { this.toyName = toyName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public boolean isGiftWrapped() { return isGiftWrapped; }
    public void setGiftWrapped(boolean giftWrapped) { isGiftWrapped = giftWrapped; }

    public String getGiftMessage() { return giftMessage; }
    public void setGiftMessage(String giftMessage) { this.giftMessage = giftMessage; }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    // Business logic methods
    public double getSubtotal() {
        return quantity * unitPrice * (1 - discount);
    }

    public double getTotalWeight() {
        return quantity * weight;
    }

    @Override
    public String toString() {
        return String.format("%s,%s,%s,%s,%d,%.2f,%.2f,%b,%s,%.2f",
            id, orderId, toyId, toyName, quantity, unitPrice, weight,
            isGiftWrapped, giftMessage, discount);
    }
} 