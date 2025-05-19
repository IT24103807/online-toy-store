package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.ToyDAO;
import com.toystore.dao.CategoryDAO;
import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;
import com.toystore.model.Category;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.UUID;

@WebServlet("/admin/toys/*")
public class AdminToyServlet extends AdminBaseServlet {
    private ToyDAO toyDAO;
    private Gson gson;
    private static final String UPLOAD_DIRECTORY = "uploads/toys";
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40;    // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    @Override
    public void init() throws ServletException {
        toyDAO = ToyDAO.getInstance();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        
        // Get the application path for image uploads
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Toy> toys = toyDAO.getAllToys();
            request.setAttribute("toys", toys);
            request.getRequestDispatcher("/WEB-INF/views/admin/toys.jsp").forward(request, response);
        } else {
            String toyId = pathInfo.substring(1);
            Toy toy = toyDAO.getToyById(toyId);
            
            if (toy != null) {
                request.setAttribute("toy", toy);
                request.getRequestDispatcher("/WEB-INF/views/admin/toy-edit.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo != null && pathInfo.equals("/delete")) {
                String toyId = request.getParameter("id");
                if (toyId != null && !toyId.isEmpty()) {
                    Toy toyToDelete = toyDAO.getToyById(toyId);
                    
                    if (toyToDelete != null) {
                        // Delete the associated image file if it exists
                        String toyImagePath = toyToDelete.getImageUrl();
                        if (toyImagePath != null && !toyImagePath.isEmpty()) {
                            String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                            File imageFile = new File(uploadPath + File.separator + toyImagePath);
                            if (imageFile.exists()) {
                                imageFile.delete();
                            }
                        }
                        
                        // Remove the toy from the database
                        if (toyDAO.removeToy(toyId)) {
                            response.setStatus(HttpServletResponse.SC_OK);
                            return;
                        }
                    }
                }
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Configure upload settings
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(MEMORY_THRESHOLD);
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(MAX_FILE_SIZE);
            upload.setSizeMax(MAX_REQUEST_SIZE);

            // Get the application path
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Parse the request
            List<FileItem> formItems = upload.parseRequest(request);
            Map<String, String> formFields = new HashMap<>();
            String imagePath = null;

            if (formItems != null && formItems.size() > 0) {
                for (FileItem item : formItems) {
                    if (item.isFormField()) {
                        formFields.put(item.getFieldName(), item.getString());
                    } else {
                        String fileName = new File(item.getName()).getName();
                        if (!fileName.isEmpty()) {
                            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                            String newFileName = UUID.randomUUID().toString() + fileExtension;
                            String filePath = uploadPath + File.separator + newFileName;
                            File storeFile = new File(filePath);
                            item.write(storeFile);
                            imagePath = newFileName;
                        }
                    }
                }
            }

            String action = formFields.get("action");
            String toyId = formFields.get("id");
            
            if ("update".equals(action) && toyId != null && !toyId.isEmpty()) {
                Toy existingToy = toyDAO.getToyById(toyId);
                
                if (existingToy != null && existingToy instanceof PhysicalToy) {
                    PhysicalToy physicalToy = (PhysicalToy) existingToy;
                    // Update the existing toy's properties
                    physicalToy.setName(formFields.get("name"));
                    physicalToy.setDescription(formFields.get("description"));
                    physicalToy.setBrand(formFields.get("brand"));
                    physicalToy.setCategory(formFields.get("category"));
                    physicalToy.setPrice(Double.parseDouble(formFields.get("price")));
                    physicalToy.setStockQuantity(Integer.parseInt(formFields.get("stockQuantity")));
                    physicalToy.setActive("true".equals(formFields.get("isActive")));
                    
                    // Only update image if a new one was uploaded
                    if (imagePath != null) {
                        // Delete old image file if it exists
                        String oldImagePath = physicalToy.getImageUrl();
                        if (oldImagePath != null && !oldImagePath.isEmpty()) {
                            File oldImageFile = new File(uploadPath + File.separator + oldImagePath);
                            if (oldImageFile.exists()) {
                                oldImageFile.delete();
                            }
                        }
                        physicalToy.setImageUrl(imagePath);
                    }

                    if (toyDAO.updateToy(physicalToy)) {
                        response.sendRedirect(request.getContextPath() + "/admin/toys");
                        return;
                    }
                }
                request.setAttribute("error", "Failed to update toy");
                request.getRequestDispatcher("/WEB-INF/views/admin/toys.jsp").forward(request, response);
            } else if ("add".equals(action)) {
                // Create new toy
                PhysicalToy newToy = new PhysicalToy(
                    UUID.randomUUID().toString(),
                    formFields.get("name"),
                    formFields.get("description"),
                    formFields.get("brand"),
                    formFields.get("category"),
                    "3-12", // Default age range
                    Double.parseDouble(formFields.get("price")),
                    Integer.parseInt(formFields.get("stockQuantity")),
                    imagePath
                );
                newToy.setActive("true".equals(formFields.get("isActive")));
                
                if (toyDAO.addToy(newToy)) {
                    response.sendRedirect(request.getContextPath() + "/admin/toys");
                } else {
                    request.setAttribute("error", "Failed to add toy");
                    request.getRequestDispatcher("/WEB-INF/views/admin/toys.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing the form: " + e.getMessage());
            if ("add".equals(request.getParameter("action"))) {
                request.getRequestDispatcher("/WEB-INF/views/admin/toys.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/views/admin/toy-edit.jsp").forward(request, response);
            }
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