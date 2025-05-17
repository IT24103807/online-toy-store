package com.toystore.servlet.user;

import com.google.gson.Gson;
import com.toystore.dao.UserDAO;
import com.toystore.dao.ToyDAO;
import com.toystore.dao.OrderDAO;
import com.toystore.model.User;
import com.toystore.model.Order;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/dashboard/*")
public class DashboardServlet extends HttpServlet {
    private UserDAO userDAO;
    private ToyDAO toyDAO;
    private OrderDAO orderDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = UserDAO.getInstance();
        toyDAO = ToyDAO.getInstance();
        orderDAO = OrderDAO.getInstance();
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

        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/stats")) {
            // Handle AJAX request for statistics
            response.setContentType("application/json");
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalToys", toyDAO.getActiveToyCount());
            stats.put("lowStockCount", toyDAO.getLowStockToys(5).size());
            stats.put("newArrivalsCount", toyDAO.getNewArrivals(5).size());
            response.getWriter().write(gson.toJson(stats));
            return;
        }
        
        // Add toy statistics to the request
        request.setAttribute("totalToys", toyDAO.getActiveToyCount());
        request.setAttribute("lowStockToys", toyDAO.getLowStockToys(5));
        request.setAttribute("newArrivals", toyDAO.getNewArrivals(5));
        
        // Load user's orders
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        request.setAttribute("orders", orders);
        
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        switch (action) {
            case "updateProfile":
                handleProfileUpdate(request, response, user);
                break;
            case "changePassword":
                handlePasswordChange(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        user.setFullName(fullName);
        user.setEmail(email);

        boolean success = userDAO.updateUser(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/dashboard?success=profile-updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=update-failed");
        }
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        if (!userDAO.verifyPassword(user.getUsername(), currentPassword)) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=wrong-password");
            return;
        }

        boolean success = userDAO.updatePassword(user.getUsername(), newPassword);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/dashboard?success=password-changed");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=password-change-failed");
        }
    }
} 