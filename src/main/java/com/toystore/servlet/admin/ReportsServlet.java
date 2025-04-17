package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.OrderDAO;
import com.toystore.dao.ToyDAO;
import com.toystore.dao.UserDAO;
import com.toystore.model.Order;
import com.toystore.model.Toy;
import com.toystore.model.User;
import com.toystore.model.CustomerUser;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/reports")
public class ReportsServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private ToyDAO toyDAO;
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        toyDAO = new ToyDAO();
        userDAO = new UserDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get date range parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        LocalDate startDate = startDateStr != null ? 
            LocalDate.parse(startDateStr) : 
            LocalDate.now().minusMonths(1);
        LocalDate endDate = endDateStr != null ? 
            LocalDate.parse(endDateStr) : 
            LocalDate.now();

        // Convert LocalDate to Date for comparison
        Date startDateTime = Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date endDateTime = Date.from(endDate.plusDays(1).atStartOfDay(ZoneId.systemDefault()).toInstant());

        // Get orders within date range
        List<Order> orders = orderDAO.getAllOrders().stream()
            .filter(order -> order.getOrderDate().after(startDateTime) && 
                           order.getOrderDate().before(endDateTime))
            .collect(Collectors.toList());

        // Prepare sales data
        Map<LocalDate, Double> salesByDate = new TreeMap<>();
        orders.forEach(order -> {
            LocalDate orderDate = order.getOrderDate().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
            salesByDate.merge(orderDate, order.getTotalAmount(), Double::sum);
        });

        // Prepare chart data
        List<String> salesLabels = new ArrayList<>();
        List<Double> salesData = new ArrayList<>();
        salesByDate.forEach((date, amount) -> {
            salesLabels.add(date.toString());
            salesData.add(amount);
        });

        // Top selling products
        Map<String, Integer> productSales = new HashMap<>();
        Map<String, Double> productRevenue = new HashMap<>();
        orders.forEach(order -> {
            order.getItems().forEach(item -> {
                productSales.merge(item.getToyId(), item.getQuantity(), Integer::sum);
                productRevenue.merge(item.getToyId(), 
                    item.getQuantity() * item.getUnitPrice(), Double::sum);
            });
        });

        List<Map<String, Object>> topProducts = new ArrayList<>();
        productSales.entrySet().stream()
            .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
            .limit(10)
            .forEach(entry -> {
                Toy toy = toyDAO.getToyById(entry.getKey());
                if (toy != null) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("name", toy.getName());
                    product.put("unitsSold", entry.getValue());
                    product.put("revenue", productRevenue.get(entry.getKey()));
                    topProducts.add(product);
                }
            });

        // Customer demographics based on membership duration
        List<CustomerUser> customers = userDAO.getAllCustomers();
        Map<String, Long> demographics = new HashMap<>();
        customers.forEach(customer -> {
            long membershipMonths = (new Date().getTime() - customer.getMemberSince().getTime()) 
                / (1000L * 60 * 60 * 24 * 30);
            String category = membershipMonths < 6 ? "New Members" :
                            membershipMonths < 12 ? "Regular Members" : "Long-term Members";
            demographics.merge(category, 1L, Long::sum);
        });

        List<String> demographicsLabels = new ArrayList<>(demographics.keySet());
        List<Long> demographicsData = demographicsLabels.stream()
            .map(demographics::get)
            .collect(Collectors.toList());

        // Top customers
        Map<String, Double> customerSpending = new HashMap<>();
        Map<String, Integer> customerOrders = new HashMap<>();
        orders.forEach(order -> {
            customerSpending.merge(order.getUserId(), order.getTotalAmount(), Double::sum);
            customerOrders.merge(order.getUserId(), 1, Integer::sum);
        });

        List<Map<String, Object>> topCustomers = new ArrayList<>();
        customerSpending.entrySet().stream()
            .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
            .limit(10)
            .forEach(entry -> {
                User user = userDAO.getUserById(entry.getKey());
                if (user != null) {
                    Map<String, Object> customer = new HashMap<>();
                    customer.put("fullName", user.getFullName());
                    customer.put("orderCount", customerOrders.get(entry.getKey()));
                    customer.put("totalSpent", entry.getValue());
                    topCustomers.add(customer);
                }
            });

        // Inventory status
        List<Toy> inventory = toyDAO.getAllToys();

        // Set attributes for JSP
        request.setAttribute("salesLabels", gson.toJson(salesLabels));
        request.setAttribute("salesData", gson.toJson(salesData));
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("demographicsLabels", gson.toJson(demographicsLabels));
        request.setAttribute("demographicsData", gson.toJson(demographicsData));
        request.setAttribute("topCustomers", topCustomers);
        request.setAttribute("inventory", inventory);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp")
              .forward(request, response);
    }
} 