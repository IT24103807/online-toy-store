package com.toystore.servlet.toy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.concurrent.TimeUnit;

@WebServlet("/images/*")
public class ToyImageServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "uploads/toys";
    private static final Logger LOGGER = Logger.getLogger(ToyImageServlet.class.getName());
    
    @Override
    public void init() throws ServletException {
        try {
            Path uploadPath = Paths.get(getServletContext().getRealPath(""), UPLOAD_DIRECTORY);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
                LOGGER.info("Created upload directory at: " + uploadPath.toAbsolutePath());
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to create upload directory", e);
            throw new ServletException("Failed to create upload directory", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            LOGGER.warning("No image path provided");
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String imageName = pathInfo.substring(1);
        LOGGER.info("Requesting image: " + imageName);
        
        // Set cache control headers for better performance
        long expireTime = System.currentTimeMillis() + TimeUnit.DAYS.toMillis(7);
        response.setDateHeader("Expires", expireTime);
        response.setHeader("Cache-Control", "public, max-age=604800");
        
        // Check if the image is a URL
        if (imageName.startsWith("http://") || imageName.startsWith("https://")) {
            try {
                URL url = new URL(imageName);
                response.setContentType("image/jpeg"); // Default content type
                try (InputStream in = url.openStream();
                     OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
                return;
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to fetch URL image: " + imageName, e);
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
        }

        // Handle local images
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        
        LOGGER.info("Looking for image in: " + uploadPath);
        
        // Create directory if it doesn't exist
        if (!uploadDir.exists()) {
            LOGGER.info("Creating upload directory: " + uploadPath);
            uploadDir.mkdirs();
        }
        
        // First try to find the exact file
        File imageFile = new File(uploadDir, imageName);
        LOGGER.info("Looking for image at: " + imageFile.getAbsolutePath());
        
        // If not found, try to find a file with the same name but different extension
        if (!imageFile.exists()) {
            String baseName = imageName.substring(0, imageName.lastIndexOf('.'));
            File[] matchingFiles = uploadDir.listFiles((dir, name) -> name.startsWith(baseName));
            if (matchingFiles != null && matchingFiles.length > 0) {
                imageFile = matchingFiles[0];
                LOGGER.info("Found alternative image: " + imageFile.getName());
            }
        }

        // If still not found, try to find a similar image
        if (!imageFile.exists()) {
            LOGGER.info("Trying to find similar image for: " + imageName);
            String[] possibleNames = {
                imageName,
                imageName.replace("-", " "),
                imageName.replace(" ", "-"),
                imageName.toLowerCase(),
                imageName.toUpperCase()
            };
            
            for (String name : possibleNames) {
                File possibleFile = new File(uploadDir, name);
                if (possibleFile.exists()) {
                    imageFile = possibleFile;
                    LOGGER.info("Found similar image: " + imageFile.getName());
                    break;
                }
            }
        }

        if (!imageFile.exists()) {
            LOGGER.warning("Image not found: " + imageName);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(imageFile.getAbsolutePath());
        if (contentType == null || !contentType.startsWith("image/")) {
            LOGGER.warning("Invalid content type for file: " + imageName + " (type: " + contentType + ")");
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            return;
        }

        response.setContentType(contentType);
        Files.copy(imageFile.toPath(), response.getOutputStream());
        LOGGER.info("Successfully served image: " + imageName);
    }
} 