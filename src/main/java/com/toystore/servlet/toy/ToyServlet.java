package com.toystore.servlet.toy;

import com.google.gson.Gson;
import com.toystore.dao.ToyDAO;
import com.toystore.dao.CategoryDAO;
import com.toystore.model.Toy;
import com.toystore.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/toys")
public class ToyServlet extends HttpServlet {
    private ToyDAO toyDAO;
    private static final Logger LOGGER = Logger.getLogger(ToyServlet.class.getName());

    @Override
    public void init() throws ServletException {
        toyDAO = ToyDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        String category = request.getParameter("category");
        String ageRange = request.getParameter("ageRange");

        List<Toy> toys = toyDAO.getAllToys();

        if (searchTerm != null && !searchTerm.isEmpty()) {
            String lowerSearch = searchTerm.toLowerCase();
            toys = toys.stream()
                .filter(t -> t.getName().toLowerCase().contains(lowerSearch)
                          || t.getDescription().toLowerCase().contains(lowerSearch))
                .collect(Collectors.toList());
        }
        if (category != null && !category.isEmpty()) {
            toys = toys.stream()
                .filter(t -> t.getCategory().equals(category))
                .collect(Collectors.toList());
        }
        if (ageRange != null && !ageRange.isEmpty()) {
            toys = toys.stream()
                .filter(t -> t.getAgeRange().equals(ageRange))
                .collect(Collectors.toList());
        }

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        LOGGER.info("Found " + toys.size() + " toys");
        request.setAttribute("toys", toys);
        request.getRequestDispatcher("/WEB-INF/views/toys.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String toyId = request.getParameter("toyId");
        if (toyId != null) {
            Toy toy = toyDAO.getToyById(toyId);
            if (toy != null) {
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(toy));
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
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
        int newQuantity = Integer.parseInt(request.getParameter("quantity"));
        
        boolean success = toyDAO.updateToyQuantity(toyId, newQuantity);
        if (success) {
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
        boolean success = toyDAO.removeToy(toyId);
        
        if (success) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 