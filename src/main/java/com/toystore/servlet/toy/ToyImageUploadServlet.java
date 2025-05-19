package com.toystore.servlet.toy;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/admin/toys/upload-image")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ToyImageUploadServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "uploads/toys";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the upload directory path
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        
        // Create upload directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            // Get image file
            Part filePart = request.getPart("image");
            String fileName = filePart.getSubmittedFileName();
            
            // Generate a unique filename to prevent overwrites
            String uniqueFileName = UUID.randomUUID().toString() + 
                                  fileName.substring(fileName.lastIndexOf("."));
            
            // Save file
            File file = new File(uploadDir, uniqueFileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Return the full path that should be used in the im  b v bn age Url field
            // This will be used in the <img src=""> tag
            String imagePath = uniqueFileName;
            
            response.setContentType("text/plain");
            response.getWriter().write(imagePath);
            
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error uploading image: " + e.getMessage());
        }
    }
} 