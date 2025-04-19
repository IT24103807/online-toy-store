package com.toystore.servlet.admin;

import com.google.gson.Gson;
import com.toystore.dao.ToyDAO;
import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;
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
        try {
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
            String imageType = formFields.get("imageType");
            
            if ("url".equals(imageType)) {
                imagePath = formFields.get("imageUrl");
            }
            
            if ("delete".equals(action)) {
                String toyId = formFields.get("toyId");
                toyDAO.deleteToy(toyId);
                response.sendRedirect(request.getContextPath() + "/admin/toys");
            } else if ("add".equals(action)) {
                PhysicalToy toy = new PhysicalToy(
                    UUID.randomUUID().toString(),
                    formFields.get("name"),
                    formFields.get("description"),
                    formFields.get("brand"),
                    formFields.get("category"),
                    formFields.get("ageRange"),
                    Double.parseDouble(formFields.get("price")),
                    Integer.parseInt(formFields.get("stockQuantity")),
                    imagePath,
                    formFields.get("dimensions"),
                    Double.parseDouble(formFields.get("weight")),
                    formFields.get("material"),
                    formFields.get("requiresAssembly") != null,
                    Integer.parseInt(formFields.get("assemblyTime")),
                    formFields.get("hasBatteries") != null,
                    formFields.get("batteryType"),
                    Integer.parseInt(formFields.get("minimumAge")),
                    formFields.get("hasWarranty") != null,
                    Integer.parseInt(formFields.get("warrantyMonths"))
                );

                if (toyDAO.addToy(toy)) {
                    response.sendRedirect(request.getContextPath() + "/admin/toys");
                } else {
                    request.setAttribute("error", "Failed to add toy");
                    request.getRequestDispatcher("/WEB-INF/views/admin/toys.jsp").forward(request, response);
                }
            } else if ("edit".equals(action)) {
                String toyId = request.getPathInfo().substring(1);
                Toy existingToy = toyDAO.getToyById(toyId);
                String imageUrl = imagePath != null ? imagePath : existingToy.getImageUrl();

                PhysicalToy toy = new PhysicalToy(
                    toyId,
                    formFields.get("name"),
                    formFields.get("description"),
                    formFields.get("brand"),
                    formFields.get("category"),
                    formFields.get("ageRange"),
                    Double.parseDouble(formFields.get("price")),
                    Integer.parseInt(formFields.get("stockQuantity")),
                    imageUrl,
                    formFields.get("dimensions"),
                    Double.parseDouble(formFields.get("weight")),
                    formFields.get("material"),
                    formFields.get("requiresAssembly") != null,
                    Integer.parseInt(formFields.get("assemblyTime")),
                    formFields.get("hasBatteries") != null,
                    formFields.get("batteryType"),
                    Integer.parseInt(formFields.get("minimumAge")),
                    formFields.get("hasWarranty") != null,
                    Integer.parseInt(formFields.get("warrantyMonths"))
                );

                if (toyDAO.updateToy(toy)) {
                    response.sendRedirect(request.getContextPath() + "/admin/toys");
                } else {
                    request.setAttribute("error", "Failed to update toy");
                    request.getRequestDispatcher("/WEB-INF/views/admin/toy-edit.jsp").forward(request, response);
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