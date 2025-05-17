package com.toystore.model;

public class PhysicalToy extends Toy {
    public PhysicalToy() {
        super();
    }

    public PhysicalToy(String id, String name, String description, String brand, String category,
                      String ageRange, double price, int stockQuantity, String imageUrl) {
        super(id, name, description, brand, category, ageRange, price, stockQuantity, imageUrl);
    }

    @Override
    public double calculateDiscount(CustomerUser customer) {
        double discount = 0.0;
        
        // Base discount based on membership
        if ("PREMIUM".equals(customer.getMembershipType())) {
            discount += 0.1; // 10% discount for premium members
        }
        
        // Additional discount for loyalty points
        if (customer.getLoyaltyPoints() > 1000) {
            discount += 0.05; // 5% additional discount for loyal customers
        }
        
        // Clearance discount for low stock items
        if (this.isLowStock()) {
            discount += 0.15; // 15% discount for clearance items
        }
        
        return Math.min(discount, 0.30); // Maximum 30% discount
    }

    @Override
    public boolean requiresAssembly() {
        return false; // Default to no assembly required
    }

    @Override
    public int getMinimumAge() {
        return 3; // Default minimum age
    }

    @Override
    public String toString() {
        return super.toString();
    }
} 