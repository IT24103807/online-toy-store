package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.ToyDAO;
import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/toys/*")
public class AdminToyServlet extends AdminBaseServlet {
    private ToyDAO toyDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        toyDAO = new ToyDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Toy> toys = toyDAO.getAllToys();
            request.setAttribute("toys", toys);
            request.getRequestDispatcher("/WEB-INF/views/admin/toys.jsp").forward(request, response);
        } else {
            String toyId = pathInfo.substring(1);
            Toy toy = toyDAO.getToyById(toyId);
            
            if (toy != null) {
                request.setAttribute("editToy", toy);
                request.getRequestDispatcher("/WEB-INF/views/admin/toy-edit.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            String toyId = request.getParameter("toyId");
            toyDAO.deleteToy(toyId);
            response.sendRedirect(request.getContextPath() + "/admin/toys");
        } else {
            // Handle toy creation
            PhysicalToy toy = new PhysicalToy(
                UUID.randomUUID().toString(),
                request.getParameter("name"),
                request.getParameter("description"),
                request.getParameter("brand"),
                request.getParameter("category"),
                request.getParameter("ageRange"),
                Double.parseDouble(request.getParameter("price")),
                Integer.parseInt(request.getParameter("stockQuantity")),
                request.getParameter("imageUrl"),
                request.getParameter("dimensions"),
                Double.parseDouble(request.getParameter("weight")),
                request.getParameter("material"),
                Boolean.parseBoolean(request.getParameter("requiresAssembly")),
                Integer.parseInt(request.getParameter("assemblyTime")),
                Boolean.parseBoolean(request.getParameter("hasBatteries")),
                request.getParameter("batteryType"),
                Integer.parseInt(request.getParameter("minimumAge")),
                Boolean.parseBoolean(request.getParameter("hasWarranty")),
                Integer.parseInt(request.getParameter("warrantyMonths"))
            );
            
            toyDAO.addToy(toy);
            response.sendRedirect(request.getContextPath() + "/admin/toys");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String toyId = pathInfo.substring(1);
        Toy toy = gson.fromJson(request.getReader(), PhysicalToy.class);
        toy.setId(toyId);
        
        if (toyDAO.updateToy(toy)) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 