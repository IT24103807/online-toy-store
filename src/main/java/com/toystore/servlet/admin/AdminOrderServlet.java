package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.OrderDAO;
import com.toystore.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders/*")
public class AdminOrderServlet extends AdminBaseServlet {
    private OrderDAO orderDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Order> orders = orderDAO.getAllOrders();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
        } else {
            String orderId = pathInfo.substring(1);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order != null) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("/WEB-INF/views/admin/order-details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        
        if ("updateStatus".equals(action)) {
            String status = request.getParameter("status");
            Order order = orderDAO.getOrderById(orderId);
            if (order != null) {
                order.setOrderStatus(status);
                orderDAO.updateOrder(order);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
} 