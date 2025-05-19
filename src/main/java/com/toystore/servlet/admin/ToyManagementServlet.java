package com.toystore.servlet.admin;

import java.io.IOException;
import java.io.File;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.toystore.dao.ToyDAO;
import com.toystore.model.PhysicalToy;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/admin/toys/manage")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ToyManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ToyDAO toyDAO;
    private static final String UPLOAD_DIR = "uploads/toys";

    @Override
    public void init() throws ServletException {
        toyDAO = ToyDAO.getInstance();
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    private String processImageUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + fileExtension;
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            String filePath = uploadPath + File.separator + newFileName;
            filePart.write(filePath);
            
            return UPLOAD_DIR + "/" + newFileName;
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String brand = request.getParameter("brand");
            String category = request.getParameter("category");
            String ageRange = request.getParameter("ageRange");
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            
            // Process image upload
            String imageUrl = processImageUpload(request);
            if (imageUrl == null) {
                imageUrl = "default-toy.jpg"; // Default image if no file was uploaded
            }

            // Generate a unique ID for the new toy
            String id = "TOY-" + System.currentTimeMillis();

            PhysicalToy toy = new PhysicalToy(id, name, description, brand, category, 
                                            ageRange, price, stockQuantity, imageUrl);
            toy.setActive(isActive);
            toyDAO.addToy(toy);
            
            response.sendRedirect(request.getContextPath() + "/admin/toys");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in form data");
            request.getRequestDispatcher("/WEB-INF/views/admin/toy-edit.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error processing toy: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/toy-edit.jsp").forward(request, response);
        }
    }
} 