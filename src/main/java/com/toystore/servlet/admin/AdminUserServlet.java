package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.UserDAO;
import com.toystore.model.AdminUser;
import com.toystore.model.CustomerUser;
import com.toystore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/users/*")
public class AdminUserServlet extends AdminBaseServlet {
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = UserDAO.getInstance();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
        } else {
            String userId = pathInfo.substring(1);
            User user = userDAO.getUserById(userId);
            
            if (user != null) {
                request.setAttribute("editUser", user);
                request.getRequestDispatcher("/WEB-INF/views/admin/user-edit.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getPathInfo();
        if (userId == null || userId.isEmpty()) {
            // Handle user creation
            String action = request.getParameter("action");
            if ("delete".equals(action)) {
                String userIdToDelete = request.getParameter("userId");
                userDAO.deleteUser(userIdToDelete);
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Handle user creation
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            
            if (username == null || password == null || fullName == null || email == null || role == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
                return;
            }
            
            User newUser;
            if ("ADMIN".equals(role)) {
                newUser = new AdminUser(
                    UUID.randomUUID().toString(),
                    username,
                    password,
                    fullName,
                    email,
                    "",
                    "",
                    "default-avatar.jpg",
                    "IT",
                    "Administrator"
                );
            } else {
                newUser = new CustomerUser(
                    UUID.randomUUID().toString(),
                    username,
                    password,
                    fullName,
                    email,
                    "",
                    "",
                    "default-avatar.jpg"
                );
            }
            
            userDAO.addUser(newUser);
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        // Handle user update
        userId = userId.substring(1); // Remove leading slash
        User existingUser = userDAO.getUserById(userId);
        if (existingUser == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String active = request.getParameter("active");
        
        if (username == null || fullName == null || email == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required fields");
            return;
        }
        
        // Update user properties
        existingUser.setUsername(username);
        existingUser.setFullName(fullName);
        existingUser.setEmail(email);
        existingUser.setPhoneNumber(phone);
        existingUser.setAddress(address);
        existingUser.setActive(Boolean.parseBoolean(active));
        
        // Only update password if provided
        if (password != null && !password.trim().isEmpty()) {
            existingUser.setPassword(password);
        }
        
        userDAO.updateUser(existingUser);
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
} 