package com.toystore.servlet.toy;

import com.google.gson.Gson;
import com.toystore.dao.ToyDAO;
import com.toystore.model.Toy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private ToyDAO toyDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        toyDAO = new ToyDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<String, Integer> cart = getCart(session);
        List<Map<String, Object>> cartItems = new ArrayList<>();
        double total = 0.0;

        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
            Toy toy = toyDAO.getToyById(entry.getKey());
            if (toy != null) {
                Map<String, Object> item = new HashMap<>();
                item.put("toy", toy);
                item.put("quantity", entry.getValue());
                item.put("subtotal", toy.getPrice() * entry.getValue());
                total += toy.getPrice() * entry.getValue();
                cartItems.add(item);
            }
        }

        // Check if it's an API request
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            Map<String, Object> cartData = new HashMap<>();
            cartData.put("items", cartItems);
            cartData.put("total", total);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(cartData));
        } else {
            // Forward to JSP
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("total", total);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String toyId = request.getParameter("toyId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (toyId == null || quantity <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid toy ID or quantity");
            return;
        }

        Toy toy = toyDAO.getToyById(toyId);
        if (toy == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Toy not found");
            return;
        }

        if (toy.getStockQuantity() < quantity) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Not enough stock");
            return;
        }

        HttpSession session = request.getSession();
        Map<String, Integer> cart = getCart(session);

        // Update cart
        cart.merge(toyId, quantity, Integer::sum);
        session.setAttribute("cart", cart);

        // Return updated cart data
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Added to cart successfully");
        result.put("cartSize", cart.size());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(result));
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String toyId = request.getParameter("toyId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (toyId == null || quantity < 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid toy ID or quantity");
            return;
        }

        HttpSession session = request.getSession();
        Map<String, Integer> cart = getCart(session);

        if (quantity == 0) {
            cart.remove(toyId);
        } else {
            Toy toy = toyDAO.getToyById(toyId);
            if (toy == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Toy not found");
                return;
            }
            if (toy.getStockQuantity() < quantity) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Not enough stock");
                return;
            }
            cart.put(toyId, quantity);
        }

        session.setAttribute("cart", cart);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String toyId = request.getParameter("toyId");
        HttpSession session = request.getSession();
        Map<String, Integer> cart = getCart(session);

        if (toyId == null) {
            // Clear entire cart
            cart.clear();
        } else {
            // Remove specific item
            cart.remove(toyId);
        }

        session.setAttribute("cart", cart);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Integer> getCart(HttpSession session) {
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }
} 