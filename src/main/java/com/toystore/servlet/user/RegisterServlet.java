package com.toystore.servlet.user;

import com.toystore.dao.UserDAO;
import com.toystore.model.User;
import com.toystore.model.CustomerUser;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = UserDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        // Validate input
        if (username == null || password == null || email == null || fullName == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || 
            email.trim().isEmpty() || fullName.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if username already exists
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create new user
        CustomerUser newUser = new CustomerUser(
            UUID.randomUUID().toString(),
            username,
            password,
            fullName,
            email,
            "",  // phone
            "",  // address
            "default-avatar.jpg"
        );
        userDAO.addUser(newUser);

        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login");
    }
} 