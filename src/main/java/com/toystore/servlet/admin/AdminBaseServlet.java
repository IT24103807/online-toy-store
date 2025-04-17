package com.toystore.servlet.admin;

import com.toystore.model.AdminUser;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public abstract class AdminBaseServlet extends HttpServlet {
    
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null || 
            !(session.getAttribute("user") instanceof AdminUser)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        super.service(request, response);
    }
} 