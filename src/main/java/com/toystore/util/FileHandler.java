package com.toystore.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {
    private static final String DATA_DIRECTORY = "data";

    static {
        File directory = new File(DATA_DIRECTORY);
        if (!directory.exists()) {
            directory.mkdir();
        }
    }

    public static void writeToFile(String fileName, String content) throws IOException {
        File file = new File(DATA_DIRECTORY + File.separator + fileName);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(content);
            writer.newLine();
        }
    }

    public static List<String> readFromFile(String fileName) throws IOException {
        List<String> lines = new ArrayList<>();
        File file = new File(DATA_DIRECTORY + File.separator + fileName);
        
        if (!file.exists()) {
            return lines;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        return lines;
    }

    public static void updateFile(String fileName, List<String> contents) throws IOException {
        File file = new File(DATA_DIRECTORY + File.separator + fileName);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (String line : contents) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    public static void deleteFromFile(String fileName, String lineToDelete) throws IOException {
        List<String> lines = readFromFile(fileName);
        lines.remove(lineToDelete);
        updateFile(fileName, lines);
    }
} 