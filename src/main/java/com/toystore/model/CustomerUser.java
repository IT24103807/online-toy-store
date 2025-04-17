package com.toystore.model;

import java.util.Date;

public class CustomerUser extends User {
    private String membershipType;
    private Date memberSince;
    private int loyaltyPoints;
    private boolean hasActiveSubscription;

    public CustomerUser() {
        super();
    }

    public CustomerUser(String id, String username, String password, String fullName,
                       String email, String phoneNumber, String address, String membershipType) {
        super(id, username, password, fullName, email, phoneNumber, address, "default-avatar.jpg");
        this.membershipType = membershipType;
        this.memberSince = new Date();
        this.loyaltyPoints = 0;
        this.hasActiveSubscription = "PREMIUM".equals(membershipType);
    }

    public String getMembershipType() { return membershipType; }
    public void setMembershipType(String membershipType) { 
        this.membershipType = membershipType;
        this.hasActiveSubscription = "PREMIUM".equals(membershipType);
    }

    public Date getMemberSince() { return memberSince; }
    public void setMemberSince(Date memberSince) { this.memberSince = memberSince; }

    public int getLoyaltyPoints() { return loyaltyPoints; }
    public void setLoyaltyPoints(int loyaltyPoints) { this.loyaltyPoints = loyaltyPoints; }

    public boolean hasActiveSubscription() { return hasActiveSubscription; }

    public void addLoyaltyPoints(double purchaseAmount) {
        this.loyaltyPoints += (int)(purchaseAmount * ("PREMIUM".equals(membershipType) ? 2 : 1));
    }

    @Override
    public boolean canManageUsers() {
        return false;
    }

    @Override
    public boolean canManageProducts() {
        return false;
    }

    @Override
    public boolean canViewReports() {
        return false;
    }

    @Override
    public String toString() {
        return String.format("%s,%s,%s,%s,%s,%s,%s,%s,%b,%s,%s,%d,%b", 
            getId(), getUsername(), getPassword(), getFullName(), getEmail(),
            getPhoneNumber(), getAddress(), "CUSTOMER", isActive(),
            membershipType, memberSince, loyaltyPoints, hasActiveSubscription);
    }
} 