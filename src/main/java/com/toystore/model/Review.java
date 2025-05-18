package com.toystore.model;

import java.util.Date;

public class Review {
    private String id;
    private String toyId;
    private String userId;
    private String userName;
    private int rating;
    private String title;
    private String comment;
    private Date reviewDate;
    private boolean isVerifiedPurchase;
    private boolean isApproved;
    private int helpfulVotes;
    private Date lastModifiedDate;

    public Review() {
        this.reviewDate = new Date();
        this.lastModifiedDate = new Date();
        this.isApproved = false;
        this.helpfulVotes = 0;
    }

    public Review(String id, String toyId, String userId, String userName, int rating,
                 String title, String comment, boolean isVerifiedPurchase) {
        this();
        this.id = id;
        this.toyId = toyId;
        this.userId = userId;
        this.userName = userName;
        this.rating = rating;
        this.title = title;
        this.comment = comment;
        this.isVerifiedPurchase = isVerifiedPurchase;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getToyId() { return toyId; }
    public void setToyId(String toyId) { this.toyId = toyId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Date getReviewDate() { return reviewDate; }
    public void setReviewDate(Date reviewDate) { this.reviewDate = reviewDate; }

    public boolean isVerifiedPurchase() { return isVerifiedPurchase; }
    public void setVerifiedPurchase(boolean verifiedPurchase) { isVerifiedPurchase = verifiedPurchase; }

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean approved) { 
        isApproved = approved;
        this.lastModifiedDate = new Date();
    }

    public int getHelpfulVotes() { return helpfulVotes; }
    public void setHelpfulVotes(int helpfulVotes) { this.helpfulVotes = helpfulVotes; }

    public Date getLastModifiedDate() { return lastModifiedDate; }
    public void setLastModifiedDate(Date lastModifiedDate) { this.lastModifiedDate = lastModifiedDate; }

    public void incrementHelpfulVotes() {
        this.helpfulVotes++;
        this.lastModifiedDate = new Date();
    }

    public boolean isHighQualityReview() {
        return this.comment != null && 
               this.comment.length() >= 50 && 
               this.isVerifiedPurchase && 
               this.helpfulVotes >= 5;
    }

    @Override
    public String toString() {
        return String.format("%s,%s,%s,%s,%d,%s,%s,%s,%b,%b,%d,%s",
            id, toyId, userId, userName, rating, title, comment, reviewDate,
            isVerifiedPurchase, isApproved, helpfulVotes, lastModifiedDate);
    }
} 