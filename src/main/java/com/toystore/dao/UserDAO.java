package com.toystore.dao;

import com.toystore.model.User;
import com.toystore.model.AdminUser;
import com.toystore.model.CustomerUser;
import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

public class UserDAO {
    private static final String USERS_FILE = System.getProperty("user.dir") + File.separator + "data" + File.separator + "users.txt";
    private Map<String, User> users;

    public UserDAO() {
        users = new HashMap<>();
        loadUsers();
    }

    private void loadUsers() {
        File file = new File(USERS_FILE);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            // Create default admin user
            AdminUser adminUser = new AdminUser(
                UUID.randomUUID().toString(),
                "admin",
                "admin",
                "Administrator",
                "admin@toystore.com",
                "",  // phone
                "",  // address
                "default-avatar.jpg",
                "IT",  // department
                "System Administrator"  // title
            );
            users.put(adminUser.getId(), adminUser);
            saveUsers();
            System.out.println("Created default admin user: admin/admin at " + USERS_FILE);
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    String[] parts = line.split(",");
                    if (parts.length < 8) {
                        System.out.println("Skipping invalid line: " + line);
                        continue;
                    }
                    
                    User user;
                    String id = parts[0];
                    String username = parts[1];
                    String password = parts[2];
                    String fullName = parts[3];
                    String email = parts[4];
                    String phone = parts[5];
                    String address = parts[6];
                    String avatarUrl = "default-avatar.jpg";
                    
                    if ("ADMIN".equals(parts[7])) {
                        String department = parts.length > 8 ? parts[8] : "IT";
                        String title = parts.length > 9 ? parts[9] : "Administrator";
                        user = new AdminUser(
                            id, username, password, fullName, email,
                            phone, address, avatarUrl, department, title
                        );
                    } else {
                        String membershipType = parts.length > 8 ? parts[8] : "REGULAR";
                        user = new CustomerUser(
                            id, username, password, fullName, email,
                            phone, address, membershipType
                        );
                    }
                    users.put(user.getId(), user);
                    System.out.println("Loaded user: " + username);
                } catch (Exception e) {
                    System.out.println("Error processing line: " + line);
                    e.printStackTrace();
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading users file: " + e.getMessage());
            e.printStackTrace();
        }
        
        // If no users were loaded, create default admin
        if (users.isEmpty()) {
            AdminUser adminUser = new AdminUser(
                UUID.randomUUID().toString(),
                "admin",
                "admin",
                "Administrator",
                "admin@toystore.com",
                "",  // phone
                "",  // address
                "default-avatar.jpg",
                "IT",  // department
                "System Administrator"  // title
            );
            users.put(adminUser.getId(), adminUser);
            saveUsers();
            System.out.println("Created default admin user: admin/admin at " + USERS_FILE);
        }
    }

    private void saveUsers() {
        try {
            File file = new File(USERS_FILE);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            try (PrintWriter writer = new PrintWriter(new FileWriter(file))) {
                for (User user : users.values()) {
                    writer.println(user.toString());
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public User getUserById(String id) {
        return users.get(id);
    }

    public User getUserByUsername(String username) {
        return users.values().stream()
            .filter(u -> u.getUsername().equals(username))
            .findFirst()
            .orElse(null);
    }

    public List<User> getAllUsers() {
        return new ArrayList<>(users.values());
    }

    public List<User> searchUsers(String searchQuery) {
        final String query = searchQuery.toLowerCase();
        return users.values().stream()
            .filter(u -> u.getUsername().toLowerCase().contains(query) ||
                        u.getFullName().toLowerCase().contains(query) ||
                        u.getEmail().toLowerCase().contains(query))
            .collect(Collectors.toList());
    }

    public boolean addUser(User user) {
        if (getUserByUsername(user.getUsername()) != null) {
            return false;
        }
        users.put(user.getId(), user);
        saveUsers();
        return true;
    }

    public boolean updateUser(User user) {
        if (users.containsKey(user.getId())) {
            users.put(user.getId(), user);
            saveUsers();
            return true;
        }
        return false;
    }

    public boolean deleteUser(String id) {
        User user = users.get(id);
        if (user != null) {
            user.setActive(false);
            saveUsers();
            return true;
        }
        return false;
    }

    public boolean authenticate(String username, String password) {
        User user = getUserByUsername(username);
        return user != null && user.getPassword().equals(password) && user.isActive();
    }

    public List<AdminUser> getAllAdmins() {
        return users.values().stream()
            .filter(u -> u instanceof AdminUser)
            .map(u -> (AdminUser) u)
            .collect(Collectors.toList());
    }

    public List<CustomerUser> getAllCustomers() {
        return users.values().stream()
            .filter(u -> u instanceof CustomerUser)
            .map(u -> (CustomerUser) u)
            .collect(Collectors.toList());
    }

    public boolean validateUser(String username, String password) {
        User user = getUserByUsername(username);
        return user != null && user.getPassword().equals(password) && user.isActive();
    }

    public boolean verifyPassword(String userId, String password) {
        User user = getUserById(userId);
        return user != null && user.getPassword().equals(password);
    }

    public boolean updatePassword(String userId, String newPassword) {
        User user = getUserById(userId);
        if (user != null) {
            user.setPassword(newPassword);
            saveUsers();
            return true;
        }
        return false;
    }
} 