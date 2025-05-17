package com.toystore.data;

import com.toystore.model.Toy;
import com.toystore.model.CustomerUser;
import java.util.Arrays;
import java.util.List;

public class SampleToyData {
    public static class SampleToy extends Toy {
        public SampleToy(String id, String name, String description, String brand, String category,
                        String ageRange, double price, int stockQuantity, String imageUrl) {
            super(id, name, description, brand, category, ageRange, price, stockQuantity, imageUrl);
        }

        @Override
        public double calculateDiscount(CustomerUser customer) {
            // Simple discount logic: 10% off for all customers
            return 0.10;
        }

        @Override
        public boolean requiresAssembly() {
            // Default to false for sample toys
            return false;
        }

        @Override
        public int getMinimumAge() {
            // Extract minimum age from age range (assuming format like "3-7 years")
            String ageRange = getAgeRange();
            if (ageRange != null && ageRange.length() > 0) {
                try {
                    return Integer.parseInt(ageRange.split("-")[0].trim());
                } catch (Exception e) {
                    return 0;
                }
            }
            return 0;
        }
    }

    public static Toy createSampleToy(String id, String name, String description, String brand, String category,
                                    String ageRange, double price, int stockQuantity, String imageUrl) {
        return new SampleToy(id, name, description, brand, category, ageRange, price, stockQuantity, imageUrl);
    }

    public static List<Toy> getSampleToys() {
        return Arrays.asList(
            new SampleToy("T001", "LEGO Police Station", "Build your own police station with this detailed LEGO set", "LEGO", "Building Sets", "8-12", 79.99, 20, "lego-millennium-falcon.jpg"),
            new SampleToy("T002", "Barbie Dreamhouse", "A beautiful dreamhouse for Barbie and her friends", "Barbie", "Dolls", "3-10", 199.99, 15, "barbie-dreamhouse.jpg"),
            new SampleToy("T003", "Hot Wheels Garage", "Race track and garage for your Hot Wheels collection", "Hot Wheels", "Vehicles", "4-8", 49.99, 30, "hot-wheels-garage.jpg"),
            new SampleToy("T004", "Nerf Blaster", "High-performance foam dart blaster", "Nerf", "Action Toys", "8-14", 29.99, 25, "toy-placeholder.jpg"),
            new SampleToy("T005", "Play-Doh Kitchen", "Creative playset with various Play-Doh tools", "Play-Doh", "Arts & Crafts", "3-6", 34.99, 40, "toy-placeholder.jpg")
        );
    }
} 