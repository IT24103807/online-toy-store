package com.toystore.data;

import com.toystore.model.Toy;
import com.toystore.model.PhysicalToy;
import java.util.ArrayList;
import java.util.List;

public class SampleToyData {
    public static List<Toy> getSampleToys() {
        List<Toy> toys = new ArrayList<>();
        
        toys.add(new PhysicalToy(
            "T001",
            "LEGO City Police Station",
            "Build and play with this amazing LEGO City Police Station set!",
            "LEGO",
            "Building Sets",
            "6-12",
            59.99,
            20,
            "images/toys/lego-police.jpg",
            "12x15x10 inches",
            2.5,
            "Plastic",
            true,
            30,
            false,
            "None",
            6,
            true,
            12
        ));
        
        toys.add(new PhysicalToy(
            "T002",
            "Barbie Dreamhouse",
            "Three-story dreamhouse with pool, elevator, and 8 rooms",
            "Barbie",
            "Dolls",
            "3+",
            179.99,
            15,
            "images/toys/barbie-house.jpg",
            "30x24x36 inches",
            15.0,
            "Plastic",
            true,
            45,
            true,
            "AA",
            3,
            true,
            24
        ));
        
        toys.add(new PhysicalToy(
            "T003",
            "Hot Wheels 20-Car Pack",
            "Collection of 20 die-cast cars with various designs",
            "Hot Wheels",
            "Vehicles",
            "3+",
            24.99,
            50,
            "images/toys/hot-wheels.jpg",
            "12x8x2 inches",
            1.5,
            "Die-cast metal",
            false,
            0,
            false,
            "None",
            3,
            false,
            0
        ));
        
        toys.add(new PhysicalToy(
            "T004",
            "Nerf Ultra One Blaster",
            "Motorized Nerf blaster with 25-dart drum",
            "Nerf",
            "Action Toys",
            "8+",
            49.99,
            30,
            "images/toys/nerf-blaster.jpg",
            "24x12x4 inches",
            2.0,
            "Plastic",
            false,
            0,
            true,
            "C",
            8,
            true,
            12
        ));
        
        toys.add(new PhysicalToy(
            "T005",
            "Play-Doh Super Color Pack",
            "Pack of 20 different colored Play-Doh containers",
            "Play-Doh",
            "Arts & Crafts",
            "3+",
            19.99,
            100,
            "images/toys/play-doh.jpg",
            "8x8x4 inches",
            3.0,
            "Modeling compound",
            false,
            0,
            false,
            "None",
            3,
            false,
            0
        ));
        
        return toys;
    }
} 