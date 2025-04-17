package com.toystore.dao;

import com.toystore.data.SampleToyData;
import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;
import java.io.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.stream.Collectors;
import java.util.concurrent.ConcurrentHashMap;

public class ToyDAO {
    private static final String TOYS_FILE = "data/toys.txt";
    private Map<String, Toy> toys;
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public ToyDAO() {
        toys = new HashMap<>();
        loadToys();
    }

    private void loadToys() {
        File file = new File(TOYS_FILE);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            // Initialize with sample data if file doesn't exist
            toys = new HashMap<>();
            for (Toy toy : SampleToyData.getSampleToys()) {
                toys.put(toy.getId(), toy);
            }
            saveToys();
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
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
            }
        } catch (IOException | NumberFormatException e) {
            e.printStackTrace();
            // Initialize with sample data if there's an error
            toys = new HashMap<>();
            for (Toy toy : SampleToyData.getSampleToys()) {
                toys.put(toy.getId(), toy);
            }
            saveToys();
        }
    }

    private void saveToys() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(TOYS_FILE))) {
            for (Toy toy : toys.values()) {
                writer.println(toy.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
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
        if (getToyById(toy.getId()) != null) {
            return false;
        }
        toys.put(toy.getId(), toy);
        saveToys();
        return true;
    }

    public boolean updateToy(Toy toy) {
        if (!toys.containsKey(toy.getId())) {
            return false;
        }
        toys.put(toy.getId(), toy);
        saveToys();
        return true;
    }

    public boolean deleteToy(String id) {
        Toy toy = toys.get(id);
        if (toy != null) {
            toy.setActive(false);
            saveToys();
            return true;
        }
        return false;
    }

    public boolean updateToyQuantity(String id, int quantity) {
        Toy toy = toys.get(id);
        if (toy != null) {
            toy.setStockQuantity(quantity);
            saveToys();
            return true;
        }
        return false;
    }

    public boolean removeToy(String id) {
        if (toys.remove(id) != null) {
            saveToys();
            return true;
        }
        return false;
    }
} 