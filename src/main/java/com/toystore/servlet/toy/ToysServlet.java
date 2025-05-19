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

@WebServlet("/toys/search")
public class ToysServlet extends HttpServlet {
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

        sendJsonResponse(response, toys);
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
} 