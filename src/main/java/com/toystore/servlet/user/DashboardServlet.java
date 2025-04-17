package com.toystore.servlet.user;

import com.toystore.dao.UserDAO;
import com.toystore.model.User;

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

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
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