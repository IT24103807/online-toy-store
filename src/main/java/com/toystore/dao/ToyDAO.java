package com.toystore.dao;

import com.toystore.data.SampleToyData;
import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;
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

    public ToyDAO() {
        toys = new ConcurrentHashMap<>();
        ensureDataDirectory();
        loadToys();
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
                    LOGGER.info("Toys file is empty, initializing with sample data");
                    initializeWithSampleData();
                    return;
                }

                toys.clear();
                List<String> lines = Files.readAllLines(filePath);
                int lineNumber = 0;
                
                for (String line : lines) {
                    lineNumber++;
                    try {
                        String[] parts = line.split(",");
                        if (parts.length < 22) {
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
                            parts[8],  // imageUrl
                            parts[9],  // dimensions
                            Double.parseDouble(parts[10]), // weight
                            parts[11], // material
                            Boolean.parseBoolean(parts[12]), // requiresAssembly
                            Integer.parseInt(parts[13]),     // assemblyTime
                            Boolean.parseBoolean(parts[14]), // hasBatteries
                            parts[15], // batteryType
                            Integer.parseInt(parts[16]),     // minimumAge
                            Boolean.parseBoolean(parts[17]), // hasWarranty
                            Integer.parseInt(parts[18])      // warrantyMonths
                        );
                        toy.setActive(Boolean.parseBoolean(parts[19]));
                        toy.setRating(Double.parseDouble(parts[20]));
                        toy.setReviewCount(Integer.parseInt(parts[21]));
                        toys.put(toy.getId(), toy);
                    } catch (NumberFormatException | ArrayIndexOutOfBoundsException e) {
                        LOGGER.log(Level.WARNING, "Error parsing line " + lineNumber + ": " + line, e);
                    }
                }
                
                if (toys.isEmpty()) {
                    LOGGER.info("No valid toys found in file, initializing with sample data");
                    initializeWithSampleData();
                } else {
                    LOGGER.info("Successfully loaded " + toys.size() + " toys from file");
                }
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error reading toys file", e);
                initializeWithSampleData();
            }
        }
    }

    private void initializeWithSampleData() {
        toys.clear();
        for (Toy toy : SampleToyData.getSampleToys()) {
            toys.put(toy.getId(), toy);
        }
        saveToys();
        LOGGER.info("Initialized with sample data");
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
        return new ArrayList<>(toys.values());
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

    public boolean addToy(Toy toy) {
        synchronized (lock) {
            if (getToyById(toy.getId()) != null) {
                return false;
            }
            toys.put(toy.getId(), toy);
            saveToys();
            return true;
        }
    }

    public boolean updateToy(Toy toy) {
        synchronized (lock) {
            if (!toys.containsKey(toy.getId())) {
                return false;
            }
            toys.put(toy.getId(), toy);
            saveToys();
            return true;
        }
    }

    public boolean deleteToy(String id) {
        synchronized (lock) {
            Toy toy = toys.get(id);
            if (toy != null) {
                toy.setActive(false);
                saveToys();
                return true;
            }
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