package com.toystore.dao;

import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.stream.Collectors;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public class ToyDAO {
    private static final String DATA_DIRECTORY = "data";
    private static final String TOYS_FILE = DATA_DIRECTORY + "/toys.txt";
    private final Map<String, Toy> toys;
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private final Object lock = new Object();
    private static final Logger LOGGER = Logger.getLogger(ToyDAO.class.getName());
    private static ToyDAO instance;

    private ToyDAO() {
        toys = new ConcurrentHashMap<>();
        ensureDataDirectory();
        loadToys();
    }

    public static ToyDAO getInstance() {
        if (instance == null) {
            instance = new ToyDAO();
        }
        return instance;
    }

    private void ensureDataDirectory() {
        try {
            Path dataDir = Paths.get(DATA_DIRECTORY);
            if (!Files.exists(dataDir)) {
                Files.createDirectories(dataDir);
                LOGGER.info("Created data directory at: " + dataDir.toAbsolutePath());
            }
            
            Path toysFile = Paths.get(TOYS_FILE);
            if (!Files.exists(toysFile)) {
                Files.createFile(toysFile);
                LOGGER.info("Created toys data file at: " + toysFile.toAbsolutePath());
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to create data directory or file", e);
        }
    }

    private void loadToys() {
        synchronized (lock) {
            Path filePath = Paths.get(TOYS_FILE);
            try {
                if (Files.size(filePath) == 0) {
                    LOGGER.info("Toys file is empty, starting with no toys");
                    return;
                }

                toys.clear();
                List<String> lines = Files.readAllLines(filePath);
                int lineNumber = 0;
                
                for (String line : lines) {
                    lineNumber++;
                    try {
                        String[] parts = line.split(",");
                        if (parts.length < 9) {
                            LOGGER.warning("Invalid data format at line " + lineNumber + ": " + line);
                            continue;
                        }
                        PhysicalToy toy = new PhysicalToy(
                            parts[0],  // id
                            parts[1],  // name
                            parts[2],  // description
                            parts[3],  // brand
                            parts[4],  // category
                            parts[5],  // ageRange
                            Double.parseDouble(parts[6]),  // price
                            Integer.parseInt(parts[7]),    // stockQuantity
                            parts[8]   // imageUrl
                        );
                        toy.setAddedDate(dateFormat.parse(parts[9]));
                        toy.setLastModifiedDate(dateFormat.parse(parts[10]));
                        toy.setActive(Boolean.parseBoolean(parts[11]));
                        toy.setRating(Double.parseDouble(parts[12]));
                        toy.setReviewCount(Integer.parseInt(parts[13]));
                        toys.put(toy.getId(), toy);
                    } catch (NumberFormatException | ArrayIndexOutOfBoundsException | ParseException e) {
                        LOGGER.log(Level.WARNING, "Error parsing line " + lineNumber + ": " + line, e);
                    }
                }
                
                LOGGER.info("Successfully loaded " + toys.size() + " toys from file");
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error reading toys file", e);
            }
        }
    }

    private void saveToys() {
        synchronized (lock) {
            Path filePath = Paths.get(TOYS_FILE);
            try {
                List<String> lines = new ArrayList<>();
                for (Toy toy : toys.values()) {
                    lines.add(toy.toString());
                }
                Files.write(filePath, lines, StandardOpenOption.TRUNCATE_EXISTING);
                LOGGER.info("Successfully saved " + toys.size() + " toys to file");
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error saving toys to file", e);
            }
        }
    }

    public Toy getToyById(String id) {
        return toys.get(id);
    }

    public List<Toy> getAllToys() {
        return toys.values().stream()
            .filter(Toy::isActive)
            .collect(Collectors.toList());
    }

    public List<Toy> searchToys(String searchQuery) {
        final String query = searchQuery.toLowerCase();
        return toys.values().stream()
            .filter(t -> t.isActive() &&
                        (t.getName().toLowerCase().contains(query) ||
                         t.getDescription().toLowerCase().contains(query) ||
                         t.getBrand().toLowerCase().contains(query) ||
                         t.getCategory().toLowerCase().contains(query)))
            .collect(Collectors.toList());
    }

    public List<Toy> getToysByBrand(String brand) {
        return toys.values().stream()
            .filter(t -> t.isActive() && t.getBrand().equals(brand))
            .collect(Collectors.toList());
    }

    public List<Toy> getToysByCategory(String category) {
        return toys.values().stream()
            .filter(t -> t.isActive() && t.getCategory().equals(category))
            .collect(Collectors.toList());
    }

    public List<Toy> getToysByAgeRange(String ageRange) {
        return toys.values().stream()
            .filter(t -> t.isActive() && t.getAgeRange().equals(ageRange))
            .collect(Collectors.toList());
    }

    public List<Toy> getNewArrivals(int limit) {
        return toys.values().stream()
            .filter(Toy::isActive)
            .sorted((t1, t2) -> t2.getAddedDate().compareTo(t1.getAddedDate()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    public List<Toy> getTopRated(int limit) {
        return toys.values().stream()
            .filter(t -> t.isActive() && t.getReviewCount() > 0)
            .sorted((t1, t2) -> Double.compare(t2.getRating(), t1.getRating()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    public List<Toy> getLowStock(int threshold) {
        return toys.values().stream()
            .filter(t -> t.isActive() && t.getStockQuantity() <= threshold)
            .collect(Collectors.toList());
    }

    public List<Toy> getLowStockToys(int limit) {
        return toys.values().stream()
            .filter(toy -> toy.getStockQuantity() < 10)
            .sorted((t1, t2) -> Integer.compare(t1.getStockQuantity(), t2.getStockQuantity()))
            .limit(limit)
            .collect(Collectors.toList());
    }

    public int getActiveToyCount() {
        synchronized (lock) {
            int count = (int) toys.values().stream()
                .filter(Toy::isActive)
                .count();
            LOGGER.info("Current active toy count: " + count);
            return count;
        }
    }

    public boolean addToy(Toy toy) {
        synchronized (lock) {
            if (getToyById(toy.getId()) != null) {
                LOGGER.warning("Failed to add toy: ID already exists - " + toy.getId());
                return false;
            }
            toy.setActive(true); // Ensure new toys are active
            toys.put(toy.getId(), toy);
            saveToys();
            LOGGER.info("Successfully added new toy: " + toy.getName() + " (ID: " + toy.getId() + ")");
            LOGGER.info("New total active toy count: " + getActiveToyCount());
            return true;
        }
    }

    public boolean updateToy(Toy toy) {
        synchronized (lock) {
            if (!toys.containsKey(toy.getId())) {
                LOGGER.warning("Failed to update toy: ID not found - " + toy.getId());
                return false;
            }
            
            // Get the existing toy
            Toy existingToy = toys.get(toy.getId());
            
            // Update only the changed properties
            existingToy.setName(toy.getName());
            existingToy.setDescription(toy.getDescription());
            existingToy.setBrand(toy.getBrand());
            existingToy.setCategory(toy.getCategory());
            existingToy.setPrice(toy.getPrice());
            existingToy.setStockQuantity(toy.getStockQuantity());
            existingToy.setActive(toy.isActive());
            
            // Only update image if it's different
            if (toy.getImageUrl() != null && !toy.getImageUrl().equals(existingToy.getImageUrl())) {
                existingToy.setImageUrl(toy.getImageUrl());
            }
            
            // Update last modified date
            existingToy.setLastModifiedDate(new Date());
            
            saveToys();
            LOGGER.info("Successfully updated toy: " + toy.getName() + " (ID: " + toy.getId() + ")");
            LOGGER.info("Current active toy count: " + getActiveToyCount());
            return true;
        }
    }

    public boolean deleteToy(String id) {
        synchronized (lock) {
            Toy toy = toys.get(id);
            if (toy != null) {
                toy.setActive(false);
                saveToys();
                LOGGER.info("Successfully deactivated toy: " + toy.getName() + " (ID: " + id + ")");
                LOGGER.info("Current active toy count: " + getActiveToyCount());
                return true;
            }
            LOGGER.warning("Failed to delete toy: ID not found - " + id);
            return false;
        }
    }

    public boolean updateToyQuantity(String id, int quantity) {
        synchronized (lock) {
            Toy toy = toys.get(id);
            if (toy != null) {
                toy.setStockQuantity(quantity);
                saveToys();
                return true;
            }
            return false;
        }
    }

    public boolean removeToy(String id) {
        synchronized (lock) {
            if (toys.remove(id) != null) {
                saveToys();
                return true;
            }
            return false;
        }
    }
} 