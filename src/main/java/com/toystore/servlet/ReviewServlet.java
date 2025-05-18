package com.toystore.servlet;

import com.toystore.dao.ReviewDAO;
import com.toystore.model.Review;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Date;
import java.util.UUID;

@WebServlet("/reviews")
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String toyId = request.getParameter("toyId");
        if (toyId != null) {
            List<Review> reviews = reviewDAO.getReviewsByToyId(toyId);
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("/WEB-INF/views/reviews.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing toyId");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        String reviewId = request.getParameter("reviewId");
        com.toystore.model.User user = (com.toystore.model.User) session.getAttribute("user");
        String userId = user.getId();
        // Handle delete action FIRST
        if ("delete".equals(action)) {
            if (reviewId != null && !reviewId.isEmpty()) {
                Review review = reviewDAO.getReviewById(reviewId);
                if (review != null && review.getUserId().equals(userId)) {
                    reviewDAO.deleteReview(reviewId);
                    session.setAttribute("reviewSuccess", "Your review has been deleted.");
                    response.sendRedirect(request.getContextPath() + "/toys/" + review.getToyId());
                    return;
                } else {
                    handleError(request, response, "Review not found or access denied");
                    return;
                }
            } else {
                handleError(request, response, "Missing reviewId for deletion");
                return;
            }
        }
        
        // Debug: Log all parameters
        System.out.println("=== Review Submission Parameters ===");
        request.getParameterMap().forEach((key, values) -> 
            System.out.println(key + " = " + String.join(", ", values))
        );
        
        // Debug: Log session attributes
        System.out.println("=== Session Attributes ===");
        java.util.Enumeration<String> attrNames = session.getAttributeNames();
        while (attrNames.hasMoreElements()) {
            String name = attrNames.nextElement();
            System.out.println(name + " = " + session.getAttribute(name));
        }
        
        try {
            String toyId = request.getParameter("toyId");
            int rating = Integer.parseInt(request.getParameter("rating"));
            String title = request.getParameter("title");
            String comment = request.getParameter("comment");
            
            if (userId == null || toyId == null) {
                throw new ServletException("Missing required parameters");
            }
            
            Review review;
            
            if (reviewId != null && !reviewId.isEmpty()) {
                // Update existing review
                review = reviewDAO.getReviewById(reviewId);
                if (review == null || !review.getUserId().equals(userId)) {
                    throw new ServletException("Review not found or access denied");
                }
                review.setRating(rating);
                review.setTitle(title);
                review.setComment(comment);
                review.setLastModifiedDate(new Date());
                reviewDAO.updateReview(review);
            } else {
                // Create new review with UUID
                review = new Review();
                review.setId(UUID.randomUUID().toString());
                review.setToyId(toyId);
                review.setUserId(userId);
                review.setUserName(user.getFullName());
                review.setRating(rating);
                review.setTitle(title);
                review.setComment(comment);
                review.setVerifiedPurchase(false);
                review.setApproved(true); // Auto-approve for now
                reviewDAO.addReview(review);
            }
            
            // Set success message in session
            session.setAttribute("reviewSuccess", "Your review has been successfully " + 
                              (reviewId != null ? "updated" : "submitted") + "!");
            
            // Redirect back to toy details page
            response.sendRedirect(request.getContextPath() + "/toys/" + toyId);
            
        } catch (NumberFormatException e) {
            handleError(request, response, "Invalid rating value");
        } catch (Exception e) {
            handleError(request, response, "Error saving review: " + e.getMessage());
        }
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle review update
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle review deletion
    }
}
