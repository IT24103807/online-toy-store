package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.UserDAO;
import com.toystore.dao.ToyDAO;
import com.toystore.dao.OrderDAO;
import com.toystore.model.Order;
import com.toystore.model.Toy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@WebServlet("/api/admin/stats/*")
public class AdminStatsServlet extends AdminBaseServlet {
    private UserDAO userDAO;
    private ToyDAO toyDAO;
    private OrderDAO orderDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        toyDAO = new ToyDAO();
        orderDAO = new OrderDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        Map<String, Object> result = new HashMap<>();

        if (pathInfo == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (pathInfo) {
            case "/users":
                result.put("total", userDAO.getAllUsers().size());
                break;
            case "/products":
                result.put("total", toyDAO.getAllToys().size());
                break;
            case "/orders/today":
                List<Order> todayOrders = getTodayOrders();
                result.put("total", todayOrders.size());
                break;
            case "/revenue/today":
                double todayRevenue = getTodayRevenue();
                result.put("total", String.format("%.2f", todayRevenue));
                break;
            case "/orders/recent":
                List<Order> recentOrders = orderDAO.getRecentOrders(5);
                result.put("orders", recentOrders);
                break;
            case "/products/low-stock":
                List<Toy> lowStockToys = toyDAO.getLowStockToys(5);
                result.put("products", lowStockToys);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(result));
    }

    private List<Order> getTodayOrders() {
        LocalDate today = LocalDate.now();
        Date startOfDay = Date.from(today.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endOfDay = Date.from(today.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant());
        
        return orderDAO.getAllOrders().stream()
            .filter(order -> order.getOrderDate().after(startOfDay) && 
                           order.getOrderDate().before(endOfDay))
            .collect(Collectors.toList());
    }

    private double getTodayRevenue() {
        return getTodayOrders().stream()
            .mapToDouble(Order::getTotalAmount)
            .sum();
    }
} 