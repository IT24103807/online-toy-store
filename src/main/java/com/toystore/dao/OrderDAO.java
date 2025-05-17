package com.toystore.dao;

import com.toystore.model.Order;
import com.toystore.model.OrderItem;
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.stream.Collectors;

public class OrderDAO {
    private static final String ORDERS_FILE = "data/orders.txt";
    private static final String ORDER_ITEMS_FILE = "data/order_items.txt";
    private Map<String, Order> orders;
    private Map<String, List<OrderItem>> orderItems;
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static OrderDAO instance;

    private OrderDAO() {
        orders = new HashMap<>();
        orderItems = new HashMap<>();
        loadOrders();
        loadOrderItems();
    }

    public static OrderDAO getInstance() {
        if (instance == null) {
            instance = new OrderDAO();
        }
        return instance;
    }

    private void loadOrders() {
        File file = new File(ORDERS_FILE);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                Order order = new Order(
                    parts[0],  // id
                    parts[1],  // userId
                    parts[7],  // shippingAddress
                    parts[8],  // paymentMethod
                    parts[17]  // couponCode
                );
                order.setSubtotal(Double.parseDouble(parts[3]));
                order.setTax(Double.parseDouble(parts[4]));
                order.setShippingCost(Double.parseDouble(parts[5]));
                order.setTotalAmount(Double.parseDouble(parts[6]));
                order.setOrderStatus(parts[9]);
                order.setOrderDate(dateFormat.parse(parts[10]));
                order.setLastModifiedDate(dateFormat.parse(parts[11]));
                order.setTrackingNumber(parts[12]);
                order.setEstimatedDeliveryDate(dateFormat.parse(parts[13]));
                order.setLoyaltyPointsEarned(Integer.parseInt(parts[16]));
                order.setDiscountAmount(Double.parseDouble(parts[18]));
                orders.put(order.getId(), order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadOrderItems() {
        File file = new File(ORDER_ITEMS_FILE);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                OrderItem item = new OrderItem(
                    parts[0],  // id
                    parts[1],  // orderId
                    parts[2],  // toyId
                    parts[3],  // toyName
                    Integer.parseInt(parts[4]),    // quantity
                    Double.parseDouble(parts[5])   // unitPrice
                );
                item.setDiscount(Double.parseDouble(parts[8]));
                
                orderItems.computeIfAbsent(item.getOrderId(), k -> new ArrayList<>()).add(item);
                Order order = orders.get(item.getOrderId());
                if (order != null) {
                    order.getItems().add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void saveOrders() {
        System.out.println("OrderDAO.saveOrders called. Writing to: " + ORDERS_FILE);
        try (PrintWriter writer = new PrintWriter(new FileWriter(ORDERS_FILE))) {
            for (Order order : orders.values()) {
                writer.println(order.toString());
            }
        } catch (IOException e) {
            System.out.println("OrderDAO.saveOrders exception: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void saveOrderItems() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(ORDER_ITEMS_FILE))) {
            for (List<OrderItem> items : orderItems.values()) {
                for (OrderItem item : items) {
                    writer.println(item.toString());
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public Order getOrderById(String id) {
        return orders.get(id);
    }

    public List<Order> getAllOrders() {
        return new ArrayList<>(orders.values());
    }

    public List<Order> getOrdersByUserId(String userId) {
        return orders.values().stream()
            .filter(o -> o.getUserId().equals(userId))
            .sorted((o1, o2) -> o2.getOrderDate().compareTo(o1.getOrderDate()))
            .collect(Collectors.toList());
    }

    public List<Order> getOrdersByStatus(String status) {
        return orders.values().stream()
            .filter(o -> o.getOrderStatus().equals(status))
            .sorted((o1, o2) -> o2.getOrderDate().compareTo(o1.getOrderDate()))
            .collect(Collectors.toList());
    }

    public List<Order> getRecentOrders(int limit) {
        return orders.values().stream()
            .sorted((o1, o2) -> o2.getOrderDate().compareTo(o1.getOrderDate()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    public List<Order> getHighValueOrders(double threshold) {
        return orders.values().stream()
            .filter(o -> o.getTotalAmount() >= threshold)
            .sorted((o1, o2) -> Double.compare(o2.getTotalAmount(), o1.getTotalAmount()))
            .collect(Collectors.toList());
    }

    public boolean addOrder(Order order) {
        System.out.println("OrderDAO.addOrder called for order id: " + order.getId());
        if (getOrderById(order.getId()) != null) {
            return false;
        }
        orders.put(order.getId(), order);
        for (OrderItem item : order.getItems()) {
            orderItems.computeIfAbsent(order.getId(), k -> new ArrayList<>()).add(item);
        }
        saveOrders();
        saveOrderItems();
        return true;
    }

    public boolean updateOrder(Order order) {
        if (!orders.containsKey(order.getId())) {
            return false;
        }
        orders.put(order.getId(), order);
        orderItems.put(order.getId(), order.getItems());
        saveOrders();
        saveOrderItems();
        return true;
    }

    public boolean deleteOrder(String id) {
        if (orders.remove(id) != null) {
            orderItems.remove(id);
            saveOrders();
            saveOrderItems();
            return true;
        }
        return false;
    }

    public boolean updateOrderStatus(String id, String status) {
        Order order = orders.get(id);
        if (order != null) {
            order.setOrderStatus(status);
            saveOrders();
            return true;
        }
        return false;
    }

    public double getTotalRevenue() {
        return orders.values().stream()
            .mapToDouble(Order::getTotalAmount)
            .sum();
    }

    public Map<String, Double> getRevenueByStatus() {
        Map<String, Double> revenue = new HashMap<>();
        orders.values().forEach(order -> {
            revenue.merge(order.getOrderStatus(), order.getTotalAmount(), Double::sum);
        });
        return revenue;
    }
} 