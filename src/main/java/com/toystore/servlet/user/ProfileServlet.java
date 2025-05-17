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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = UserDAO.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String currentPassword = request.getParameter("password");

        if ("delete".equals(action)) {
            if (!userDAO.verifyPassword(user.getId(), currentPassword)) {
                session.setAttribute("error", "Current password is incorrect");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            if (userDAO.deleteUser(user.getId())) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/?success=account-deleted");
                return;
            } else {
                session.setAttribute("error", "Failed to delete account. Please try again.");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "New passwords do not match");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        if (!userDAO.verifyPassword(user.getId(), currentPassword)) {
            session.setAttribute("error", "Current password is incorrect");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        if (userDAO.updatePassword(user.getId(), newPassword)) {
            session.setAttribute("success", "Password changed successfully");
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            session.setAttribute("error", "Failed to change password. Please try again.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}
