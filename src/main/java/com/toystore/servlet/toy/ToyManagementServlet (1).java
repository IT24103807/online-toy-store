package com.toystore.servlet.toy;

import com.google.gson.Gson;
import com.toystore.dao.ReviewDAO;
import com.toystore.dao.ToyDAO;
import com.toystore.model.Review;
import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;
import com.toystore.model.User;

import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/toys/*")
public class ToyManagementServlet extends HttpServlet {
    private ToyDAO toyDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        toyDAO = ToyDAO.getInstance();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all toys
            String searchTerm = request.getParameter("search");
            String category = request.getParameter("category");
            String brand = request.getParameter("brand");
            String ageRange = request.getParameter("ageRange");

            List<Toy> toys;
            if (searchTerm != null && !searchTerm.isEmpty()) {
                toys = toyDAO.searchToys(searchTerm);
            } else if (category != null && !category.isEmpty()) {
                toys = toyDAO.getToysByCategory(category);
            } else if (brand != null && !brand.isEmpty()) {
                toys = toyDAO.getToysByBrand(brand);
            } else if (ageRange != null && !ageRange.isEmpty()) {
                toys = toyDAO.getToysByAgeRange(ageRange);
            } else {
                toys = toyDAO.getAllToys();
            }

            request.setAttribute("toys", toys);
            request.getRequestDispatcher("/WEB-INF/views/toys.jsp").forward(request, response);
        } else {
            // Get specific toy
            String toyId = pathInfo.substring(1);
            Toy toy = toyDAO.getToyById(toyId);
            
            if (toy != null) {
                // Get review data
                ReviewDAO reviewDAO = new ReviewDAO();
                List<Review> reviews = reviewDAO.getReviewsByToyId(toyId);
                
                // Calculate average rating
                double averageRating = reviews.stream()
                    .mapToInt(Review::getRating)
                    .average()
                    .orElse(0.0);
                
                // Get current user's review if logged in
                User user = (User) request.getSession().getAttribute("user");
                if (user != null) {
                    Optional<Review> userReview = reviews.stream()
                        .filter(r -> r.getUserId().equals(user.getId()))
                        .findFirst();
                    userReview.ifPresent(review -> request.setAttribute("userReview", review));
                }
                
                // Set attributes for JSP
                request.setAttribute("toy", toy);
                request.setAttribute("reviews", reviews);
                request.setAttribute("averageRating", averageRating);
                
                request.getRequestDispatcher("/WEB-INF/views/toy-details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/add".equals(pathInfo)) {
            PhysicalToy toy = new PhysicalToy(
                UUID.randomUUID().toString(),
                request.getParameter("name"),
                request.getParameter("description"),
                request.getParameter("brand"),
                request.getParameter("category"),
                request.getParameter("ageRange"),
                Double.parseDouble(request.getParameter("price")),
                Integer.parseInt(request.getParameter("stockQuantity")),
                request.getParameter("imageUrl")
            );

            if (toyDAO.addToy(toy)) {
                response.sendRedirect(request.getContextPath() + "/toys");
            } else {
                request.setAttribute("error", "Failed to add toy");
                request.getRequestDispatcher("/WEB-INF/views/toy-form.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String toyId = pathInfo.substring(1);
        Toy toy = gson.fromJson(request.getReader(), PhysicalToy.class);
        toy.setId(toyId);
        
        if (toyDAO.updateToy(toy)) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String toyId = pathInfo.substring(1);
        if (toyDAO.deleteToy(toyId)) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 