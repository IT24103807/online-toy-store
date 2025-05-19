package com.toystore.model;

public class OrderItem {
    private String id;
    private String orderId;
    private String toyId;
    private String toyName;
    private int quantity;
    private double unitPrice;
    private double discount;

    public OrderItem() {
    }

    public OrderItem(String id, String orderId, String toyId, String toyName, int quantity, double unitPrice) {
        this.id = id;
        this.orderId = orderId;
        this.toyId = toyId;
        this.toyName = toyName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.discount = 0.0;
    }



    @Override
    public int hashCode() {
        return super.hashCode();


    }

    // Getters and Setters
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }



    public String getOrderId() {
        return orderId;
    }
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }



    public String getToyId() {
        return toyId;
    }
    public void setToyId(String toyId) {
        this.toyId = toyId;
    }



    public String getToyName() {
        return toyName;
    }
    public void setToyName(String toyName) {
        this.toyName = toyName;
    }



    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }



    public double getUnitPrice() {
        return unitPrice;
    }
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }



    public double getDiscount() {
        return discount;
    }
    public void setDiscount(double discount) {
        this.discount = discount;
    }


    // Business logic methods
    public double getSubtotal() {
        return quantity * unitPrice * (1 - discount);
    }

    @Override
    public String toString() {
        return String.format("%s,%s,%s,%s,%d,%.2f,%.2f",
            id, orderId, toyId, toyName, quantity, unitPrice, discount);
    }
} 