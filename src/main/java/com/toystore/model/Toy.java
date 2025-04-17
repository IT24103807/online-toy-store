package com.toystore.model;

import java.util.Date;

public abstract class Toy {
    private String id;
    private String name;
    private String description;
    private String brand;
    private String category;
    private String ageRange;
    private double price;
    private int stockQuantity;
    private String imageUrl;
    private Date addedDate;
    private Date lastModifiedDate;
    private boolean isActive;
    private double rating;
    private int reviewCount;

    public Toy() {
        this.addedDate = new Date();
        this.lastModifiedDate = new Date();
        this.isActive = true;
        this.rating = 0.0;
        this.reviewCount = 0;
    }

    public Toy(String id, String name, String description, String brand, String category,
              String ageRange, double price, int stockQuantity, String imageUrl) {
        this();
        this.id = id;
        this.name = name;
        this.description = description;
        this.brand = brand;
        this.category = category;
        this.ageRange = ageRange;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getAgeRange() { return ageRange; }
    public void setAgeRange(String ageRange) { this.ageRange = ageRange; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Date getAddedDate() { return addedDate; }
    public void setAddedDate(Date addedDate) { this.addedDate = addedDate; }

    public Date getLastModifiedDate() { return lastModifiedDate; }
    public void setLastModifiedDate(Date lastModifiedDate) { this.lastModifiedDate = lastModifiedDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { 
        isActive = active;
        this.lastModifiedDate = new Date();
    }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    // Business logic methods
    public boolean isInStock() {
        return stockQuantity > 0;
    }

    public boolean isLowStock() {
        return stockQuantity < 5;
    }

    public void updateRating(int newRating) {
        double totalRating = (rating * reviewCount) + newRating;
        reviewCount++;
        rating = totalRating / reviewCount;
        this.lastModifiedDate = new Date();
    }

    public void adjustStock(int quantity) {
        this.stockQuantity += quantity;
        this.lastModifiedDate = new Date();
    }

    // Abstract methods that child classes must implement
    public abstract double calculateDiscount(CustomerUser customer);
    public abstract boolean requiresAssembly();
    public abstract int getMinimumAge();

    @Override
    public String toString() {
        return String.format("%s,%s,%s,%s,%s,%s,%.2f,%d,%s,%s,%s,%b,%.1f,%d",
            id, name, description, brand, category, ageRange, price, stockQuantity,
            imageUrl, addedDate, lastModifiedDate, isActive, rating, reviewCount);
    }
} 