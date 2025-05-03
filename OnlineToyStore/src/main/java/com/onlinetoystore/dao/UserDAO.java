package com.onlinetoystore.dao;

import com.onlinetoystore.model.User;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.Collections;

public class UserDAO {
    private static final List<User> users = Collections.synchronizedList(new ArrayList<>());
    private static final AtomicInteger idCounter = new AtomicInteger(1);

    static {
        // Add some initial users
        User admin = new User();
        admin.setId(idCounter.getAndIncrement());
        admin.setUsername("admin");
        admin.setEmail("admin@example.com");
        admin.setPassword("admin123");
        admin.setRole("ADMIN");
        users.add(admin);

        User user = new User();
        user.setId(idCounter.getAndIncrement());
        user.setUsername("user");
        user.setEmail("user@example.com");
        user.setPassword("user123");
        user.setRole("USER");
        users.add(user);
    }

    public synchronized List<User> getAllUsers() {
        return new ArrayList<>(users);
    }

    public synchronized User getUserById(int id) {
        return users.stream()
                .filter(user -> user.getId() == id)
                .findFirst()
                .orElse(null);
    }

    public synchronized User getUserByUsername(String username) {
        return users.stream()
                .filter(user -> user.getUsername().equals(username))
                .findFirst()
                .orElse(null);
    }

    public synchronized boolean addUser(User user) {
        if (getUserByUsername(user.getUsername()) != null) {
            return false;
        }
        user.setId(idCounter.getAndIncrement());
        users.add(user);
        return true;
    }

    public synchronized boolean updateUser(User user) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId() == user.getId()) {
                users.set(i, user);
                return true;
            }
        }
        return false;
    }

    public synchronized boolean deleteUser(int id) {
        return users.removeIf(user -> user.getId() == id);
    }

    public synchronized boolean isUsernameExists(String username) {
        return users.stream()
                .anyMatch(user -> user.getUsername().equals(username));
    }
} 