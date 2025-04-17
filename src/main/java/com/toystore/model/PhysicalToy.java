package com.toystore.model;

public class PhysicalToy extends Toy {
    private String dimensions;
    private double weight;
    private String material;
    private boolean requiresAssembly;
    private int assemblyTime; // in minutes
    private boolean hasBatteries;
    private String batteryType;
    private int minimumAge;
    private boolean hasWarranty;
    private int warrantyMonths;

    public PhysicalToy() {
        super();
    }

    public PhysicalToy(String id, String name, String description, String brand, String category,
                      String ageRange, double price, int stockQuantity, String imageUrl,
                      String dimensions, double weight, String material, boolean requiresAssembly,
                      int assemblyTime, boolean hasBatteries, String batteryType, int minimumAge,
                      boolean hasWarranty, int warrantyMonths) {
        super(id, name, description, brand, category, ageRange, price, stockQuantity, imageUrl);
        this.dimensions = dimensions;
        this.weight = weight;
        this.material = material;
        this.requiresAssembly = requiresAssembly;
        this.assemblyTime = assemblyTime;
        this.hasBatteries = hasBatteries;
        this.batteryType = batteryType;
        this.minimumAge = minimumAge;
        this.hasWarranty = hasWarranty;
        this.warrantyMonths = warrantyMonths;
    }

    // Getters and Setters
    public String getDimensions() { return dimensions; }
    public void setDimensions(String dimensions) { this.dimensions = dimensions; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public String getMaterial() { return material; }
    public void setMaterial(String material) { this.material = material; }

    public boolean isRequiresAssembly() { return requiresAssembly; }
    public void setRequiresAssembly(boolean requiresAssembly) { this.requiresAssembly = requiresAssembly; }

    public int getAssemblyTime() { return assemblyTime; }
    public void setAssemblyTime(int assemblyTime) { this.assemblyTime = assemblyTime; }

    public boolean isHasBatteries() { return hasBatteries; }
    public void setHasBatteries(boolean hasBatteries) { this.hasBatteries = hasBatteries; }

    public String getBatteryType() { return batteryType; }
    public void setBatteryType(String batteryType) { this.batteryType = batteryType; }

    public boolean isHasWarranty() { return hasWarranty; }
    public void setHasWarranty(boolean hasWarranty) { this.hasWarranty = hasWarranty; }

    public int getWarrantyMonths() { return warrantyMonths; }
    public void setWarrantyMonths(int warrantyMonths) { this.warrantyMonths = warrantyMonths; }

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
        return this.requiresAssembly;
    }

    @Override
    public int getMinimumAge() {
        return this.minimumAge;
    }

    @Override
    public String toString() {
        return super.toString() + String.format(",%s,%.2f,%s,%b,%d,%b,%s,%d,%b,%d",
            dimensions, weight, material, requiresAssembly, assemblyTime,
            hasBatteries, batteryType, minimumAge, hasWarranty, warrantyMonths);
    }
} 