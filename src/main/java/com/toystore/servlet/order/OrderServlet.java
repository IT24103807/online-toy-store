package com.toystore.servlet.order;

import com.toystore.dao.OrderDAO;
import com.toystore.model.Order;
import com.toystore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/orders/*")
public class OrderServlet extends HttpServlet {


    private OrderDAO orderDAO;


    @Override
    //Read
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {

            request.setAttribute("orders", orderDAO.getOrdersByUserId(user.getId()));
            request.getRequestDispatcher("/WEB-INF/views/orders/list.jsp").forward(request, response);
        } else {

            String orderId = pathInfo.substring(1);
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }


            if (!user.getId().equals(order.getUserId()) && !"ADMIN".equals(session.getAttribute("role"))) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            request.setAttribute("order", order);
            request.getRequestDispatcher("/WEB-INF/views/orders/details.jsp").forward(request, response);
        }
    }
} 