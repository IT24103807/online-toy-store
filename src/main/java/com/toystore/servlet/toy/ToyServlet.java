package com.toystore.servlet.toy;

import com.google.gson.Gson;
import com.toystore.dao.ToyDAO;
import com.toystore.model.Toy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/toys")
public class ToyServlet extends HttpServlet {
    private ToyDAO toyDAO;

    @Override
    public void init() throws ServletException {
        toyDAO = new ToyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        String brand = request.getParameter("brand");
        String ageRange = request.getParameter("ageRange");

        List<Toy> toys;
        if (searchTerm != null && !searchTerm.isEmpty()) {
            toys = toyDAO.searchToys(searchTerm);
        } else if (brand != null && !brand.isEmpty()) {
            toys = toyDAO.getToysByBrand(brand);
        } else if (ageRange != null && !ageRange.isEmpty()) {
            toys = toyDAO.getToysByAgeRange(ageRange);
        } else {
            toys = toyDAO.getAllToys();
        }

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