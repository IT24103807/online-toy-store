package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.UserDAO;
import com.toystore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users/*")
public class AdminUserServlet extends AdminBaseServlet {
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
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
        // Handle user creation/update
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            String userId = request.getParameter("userId");
            userDAO.deleteUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            // Handle other actions
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
} 