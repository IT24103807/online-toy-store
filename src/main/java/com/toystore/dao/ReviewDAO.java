package com.toystore.dao;

import com.toystore.model.Review;
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.stream.Collectors;

public class ReviewDAO {
    private static final String REVIEWS_FILE = "data/reviews.txt";
    private Map<String, Review> reviews;
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public ReviewDAO() {
        reviews = new HashMap<>();
        loadReviews();
    }

    private void loadReviews() {
        File file = new File(REVIEWS_FILE);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                Review review = new Review(
                    parts[0],  // id
                    parts[1],  // toyId
                    parts[2],  // userId
                    parts[3],  // userName
                    Integer.parseInt(parts[4]),  // rating
                    parts[5],  // title
                    parts[6],  // comment
                    Boolean.parseBoolean(parts[8])  // isVerifiedPurchase
                );
                review.setReviewDate(dateFormat.parse(parts[7]));
                review.setApproved(Boolean.parseBoolean(parts[9]));
                review.setHelpfulVotes(Integer.parseInt(parts[10]));
                review.setLastModifiedDate(dateFormat.parse(parts[11]));
                reviews.put(review.getId(), review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void saveReviews() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(REVIEWS_FILE))) {
            for (Review review : reviews.values()) {
                writer.println(review.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public Review getReviewById(String id) {
        return reviews.get(id);
    }

    public List<Review> getAllReviews() {
        return new ArrayList<>(reviews.values());
    }

    public List<Review> getReviewsByToyId(String toyId) {
        return reviews.values().stream()
            .filter(r -> r.getToyId().equals(toyId) && r.isApproved())
            .sorted((r1, r2) -> r2.getReviewDate().compareTo(r1.getReviewDate()))
            .collect(Collectors.toList());
    }

    public List<Review> getReviewsByUserId(String userId) {
        return reviews.values().stream()
            .filter(r -> r.getUserId().equals(userId))
            .sorted((r1, r2) -> r2.getReviewDate().compareTo(r1.getReviewDate()))
            .collect(Collectors.toList());
    }

    public List<Review> getPendingReviews() {
        return reviews.values().stream()
            .filter(r -> !r.isApproved())
            .sorted((r1, r2) -> r2.getReviewDate().compareTo(r1.getReviewDate()))
            .collect(Collectors.toList());
    }

    public List<Review> getHighQualityReviews(String toyId) {
        return reviews.values().stream()
            .filter(r -> r.getToyId().equals(toyId) && 
                        r.isApproved() && 
                        r.isHighQualityReview())
            .sorted((r1, r2) -> Integer.compare(r2.getHelpfulVotes(), r1.getHelpfulVotes()))
            .collect(Collectors.toList());
    }

    public double getAverageRating(String toyId) {
        List<Review> toyReviews = getReviewsByToyId(toyId);
        if (toyReviews.isEmpty()) {
            return 0.0;
        }
        return toyReviews.stream()
            .mapToInt(Review::getRating)
            .average()
            .orElse(0.0);
    }

    public boolean addReview(Review review) {
        if (getReviewById(review.getId()) != null) {
            return false;
        }
        reviews.put(review.getId(), review);
        saveReviews();
        return true;
    }

    public boolean updateReview(Review review) {
        if (!reviews.containsKey(review.getId())) {
            return false;
        }
        reviews.put(review.getId(), review);
        saveReviews();
        return true;
    }

    public boolean deleteReview(String id) {
        if (reviews.remove(id) != null) {
            saveReviews();
            return true;
        }
        return false;
    }

    public boolean approveReview(String id) {
        Review review = reviews.get(id);
        if (review != null) {
            review.setApproved(true);
            saveReviews();
            return true;
        }
        return false;
    }

    public boolean incrementHelpfulVotes(String id) {
        Review review = reviews.get(id);
        if (review != null) {
            review.incrementHelpfulVotes();
            saveReviews();
            return true;
        }
        return false;
    }
} 