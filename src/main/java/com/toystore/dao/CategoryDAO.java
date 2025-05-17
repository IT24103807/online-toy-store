package com.toystore.dao;

import com.toystore.model.Category;
import java.io.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.UUID;

public class CategoryDAO {
    private static final String CATEGORY_FILE = "data/categories.txt";
    private Map<String, Category> categories;

    public CategoryDAO() {
        categories = new HashMap<>();
        loadCategories();
    }

    private void loadCategories() {
        File file = new File(CATEGORY_FILE);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
        } else {
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] parts = line.split(",", 2);
                    if (parts.length == 2) {
                        categories.put(parts[0], new Category(parts[0], parts[1]));
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        // Always ensure 5 default categories exist
        String[] defaults = {"Action Figures", "Educational", "Dolls", "Vehicles", "Building Sets"};
        for (String def : defaults) {
            boolean exists = categories.values().stream().anyMatch(c -> c.getName().equalsIgnoreCase(def));
            if (!exists) {
                addCategory(def);
            }
        }
    }

    private void saveCategories() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(CATEGORY_FILE))) {
            for (Category category : categories.values()) {
                writer.println(category.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<Category> getAllCategories() {
        return new ArrayList<>(categories.values());
    }

    public Category getCategoryById(String id) {
        return categories.get(id);
    }

    public boolean addCategory(String name) {
        String id = UUID.randomUUID().toString();
        if (categories.values().stream().anyMatch(c -> c.getName().equalsIgnoreCase(name))) {
            return false; // Duplicate name
        }
        categories.put(id, new Category(id, name));
        saveCategories();
        return true;
    }

    public boolean updateCategory(String id, String newName) {
        Category category = categories.get(id);
        if (category == null) return false;
        if (categories.values().stream().anyMatch(c -> c.getName().equalsIgnoreCase(newName) && !c.getId().equals(id))) {
            return false; // Duplicate name
        }
        category.setName(newName);
        saveCategories();
        return true;
    }

    public boolean deleteCategory(String id) {
        if (categories.remove(id) != null) {
            saveCategories();
            return true;
        }
        return false;
    }
} 