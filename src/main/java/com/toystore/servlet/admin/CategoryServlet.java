package com.toystore.servlet.admin;

import com.toystore.dao.CategoryDAO;
import com.toystore.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "add":
                request.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(request, response);
                break;
            case "edit":
                String editId = request.getParameter("id");
                Category editCategory = categoryDAO.getCategoryById(editId);
                request.setAttribute("category", editCategory);
                request.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(request, response);
                break;
            default:
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/views/admin/category-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "add";
        switch (action) {
            case "add":
                String name = request.getParameter("name");
                if (name != null && !name.trim().isEmpty()) {
                    boolean success = categoryDAO.addCategory(name.trim());
                    if (!success) {
                        request.setAttribute("error", "Category name already exists.");
                        request.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(request, response);
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
            case "edit":
                String id = request.getParameter("id");
                String newName = request.getParameter("name");
                if (id != null && newName != null && !newName.trim().isEmpty()) {
                    boolean success = categoryDAO.updateCategory(id, newName.trim());
                    if (!success) {
                        request.setAttribute("error", "Category name already exists or invalid.");
                        request.setAttribute("category", categoryDAO.getCategoryById(id));
                        request.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(request, response);
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
            case "delete":
                String delId = request.getParameter("id");
                if (delId != null) {
                    categoryDAO.deleteCategory(delId);
                }
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
        }
    }
} 