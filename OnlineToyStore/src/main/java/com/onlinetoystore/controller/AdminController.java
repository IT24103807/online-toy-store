package com.onlinetoystore.controller;

import com.onlinetoystore.dao.UserDAO;
import com.onlinetoystore.model.User;
import com.onlinetoystore.service.AuthService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AdminController", urlPatterns = {"/admin/*"})
public class AdminController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminController.class.getName());
    private final UserDAO userDAO;
    private final AuthService authService;

    public AdminController() {
        this.userDAO = new UserDAO();
        this.authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null || !authService.isAdmin(currentUser)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                return;
            }

            switch (pathInfo) {
                case "/dashboard":
                    request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                    break;
                case "/users":
                    List<User> users = userDAO.getAllUsers();
                    request.setAttribute("users", users);
                    request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
                    break;
                case "/edit":
                    try {
                        int userId = Integer.parseInt(request.getParameter("id"));
                        User user = userDAO.getUserById(userId);
                        if (user == null) {
                            request.setAttribute("error", "User not found");
                            response.sendRedirect(request.getContextPath() + "/admin/users");
                            return;
                        }
                        request.setAttribute("user", user);
                        request.getRequestDispatcher("/admin/edit-user.jsp").forward(request, response);
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid user ID format", e);
                        request.setAttribute("error", "Invalid user ID");
                        response.sendRedirect(request.getContextPath() + "/admin/users");
                    }
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AdminController doGet", e);
            request.setAttribute("error", "An error occurred while processing your request");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null || !authService.isAdmin(currentUser)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String pathInfo = request.getPathInfo();
            if (pathInfo == null) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            switch (pathInfo) {
                case "/update":
                    updateUser(request, response);
                    break;
                case "/delete":
                    deleteUser(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AdminController doPost", e);
            request.setAttribute("error", "An error occurred while processing your request");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            boolean active = "on".equals(request.getParameter("active"));

            // Input validation
            if (username == null || username.trim().isEmpty() || 
                email == null || email.trim().isEmpty() || 
                role == null || role.trim().isEmpty()) {
                request.setAttribute("error", "All fields are required");
                response.sendRedirect(request.getContextPath() + "/admin/edit?id=" + id);
                return;
            }

            User user = userDAO.getUserById(id);
            if (user == null) {
                request.setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setRole(role.trim());
            user.setActive(active);

            // Only update password if a new one is provided
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password.trim());
            }

            userDAO.updateUser(user);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid user ID format", e);
            request.setAttribute("error", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user", e);
            request.setAttribute("error", "Error updating user");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Prevent self-deletion
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null && currentUser.getId() == id) {
                request.setAttribute("error", "Cannot delete your own account");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            userDAO.deleteUser(id);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid user ID format", e);
            request.setAttribute("error", "Invalid user ID");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting user", e);
            request.setAttribute("error", "Error deleting user");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
} 