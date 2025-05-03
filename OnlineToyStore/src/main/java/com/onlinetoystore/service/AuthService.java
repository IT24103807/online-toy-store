package com.onlinetoystore.service;

import com.onlinetoystore.dao.UserDAO;
import com.onlinetoystore.model.User;

public class AuthService {
    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public User login(String username, String password) {
        User user = userDAO.getUserByUsername(username);
        if (user != null && user.verifyPassword(password) && user.isActive()) {
            return user;
        }
        return null;
    }

    public boolean register(User user) {
        if (userDAO.isUsernameExists(user.getUsername())) {
            return false;
        }
        return userDAO.addUser(user);
    }

    public boolean isAdmin(User user) {
        return user != null && "ADMIN".equals(user.getRole());
    }
} 