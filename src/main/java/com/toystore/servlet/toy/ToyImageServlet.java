package com.toystore.servlet.toy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/images/toys/*")
public class ToyImageServlet extends HttpServlet {
    private static final String IMAGE_DIR = "/WEB-INF/images/toys/";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String imageName = pathInfo.substring(1);
        String imagePath = getServletContext().getRealPath(IMAGE_DIR + imageName);
        File imageFile = new File(imagePath);

        if (!imageFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(imagePath);
        if (contentType == null || !contentType.startsWith("image/")) {
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            return;
        }

        response.setContentType(contentType);
        Files.copy(imageFile.toPath(), response.getOutputStream());
    }
} 