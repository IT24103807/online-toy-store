package com.toystore.servlet.order;

import com.google.gson.Gson;
import com.toystore.dao.OrderDAO;
import com.toystore.dao.ToyDAO;
import com.toystore.model.Order;
import com.toystore.model.OrderItem;
import com.toystore.model.PhysicalToy;
import com.toystore.model.Toy;
import com.toystore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private ToyDAO toyDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        orderDAO = OrderDAO.getInstance();
        toyDAO = ToyDAO.getInstance();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, Integer> cart = getCart(session);
        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Calculate totals and prepare cart items
        List<Map<String, Object>> cartItems = new ArrayList<>();
        double subtotal = 0.0;
        
        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
            Toy toy = toyDAO.getToyById(entry.getKey());
            if (toy != null) {
                Map<String, Object> item = new HashMap<>();
                item.put("toy", toy);
                item.put("quantity", entry.getValue());
                double itemSubtotal = toy.getPrice() * entry.getValue();
                item.put("subtotal", itemSubtotal);
                subtotal += itemSubtotal;
                cartItems.add(item);
            }
        }

        // Calculate tax and shipping
        double tax = subtotal * 0.08; // 8% tax
        double shipping = 5.99; // Base shipping rate
        double total = subtotal + tax + shipping;

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("tax", tax);
        request.setAttribute("shipping", shipping);
        request.setAttribute("total", total);
        
        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Map<String, Integer> cart = getCart(session);
        if (cart.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cart is empty");
            return;
        }

        // Parse JSON request body
        StringBuilder buffer = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            buffer.append(line);
        }
        Map<String, Object> requestData = gson.fromJson(buffer.toString(), Map.class);

        // Validate required fields
        String shippingAddress = (String) requestData.get("shippingAddress");
        String paymentMethod = (String) requestData.get("paymentMethod");
        
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Shipping address is required");
            return;
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Payment method is required");
            return;
        }

        // Validate credit card details if payment method is CREDIT_CARD
        if ("CREDIT_CARD".equals(paymentMethod)) {
            String cardNumber = (String) requestData.get("cardNumber");
            String expiryDate = (String) requestData.get("expiryDate");
            String cvv = (String) requestData.get("cvv");

            if (cardNumber == null || !cardNumber.matches("[0-9]{16}")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid card number");
                return;
            }

            if (expiryDate == null || !expiryDate.matches("(0[1-9]|1[0-2])\\/[0-9]{2}")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid expiry date");
                return;
            }

            if (cvv == null || !cvv.matches("[0-9]{3,4}")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid CVV");
                return;
            }
        }

        // Create new order
        Order order = new Order(
            UUID.randomUUID().toString(),
            user.getId(),
            shippingAddress,
            paymentMethod,
            (String) requestData.get("couponCode")
        );

        // Calculate totals
        double subtotal = 0.0;
        double tax = 0.0;
        double shipping = 5.99;
        
        // Add items to order and update stock
        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
            Toy toy = toyDAO.getToyById(entry.getKey());
            if (toy != null) {
                if (toy.getStockQuantity() < entry.getValue()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                        "Not enough stock for " + toy.getName());
                    return;
                }

                double itemPrice = toy.getPrice() * entry.getValue();
                subtotal += itemPrice;

                OrderItem item = new OrderItem(
                    UUID.randomUUID().toString(),
                    order.getId(),
                    toy.getId(),
                    toy.getName(),
                    entry.getValue(),
                    toy.getPrice()
                );
                order.addItem(item);

                // Update stock
                toy.setStockQuantity(toy.getStockQuantity() - entry.getValue());
                toyDAO.updateToy(toy);
            }
        }

        // Calculate final totals
        tax = subtotal * 0.08; // 8% tax
        double total = subtotal + tax + shipping;

        order.setSubtotal(subtotal);
        order.setTax(tax);
        order.setShippingCost(shipping);
        order.setTotalAmount(total);

        // Save order
        if (orderDAO.addOrder(order)) {
            // Clear cart
            session.removeAttribute("cart");
            
            // Return success response
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("orderId", order.getId());
            result.put("message", "Order placed successfully!");
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(result));
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Failed to place order");
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, Integer> getCart(HttpSession session) {
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        return cart != null ? cart : new HashMap<>();
    }
} 