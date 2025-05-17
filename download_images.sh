#!/bin/bash

# Create uploads directory if it doesn't exist
mkdir -p src/main/webapp/uploads/toys

# Download LEGO Classic image
curl -o src/main/webapp/uploads/toys/lego-classic.jpg https://m.media-amazon.com/images/I/91QYVQvXHaL._AC_SL1500_.jpg

# Download Barbie Dreamhouse image
curl -o src/main/webapp/uploads/toys/barbie-dreamhouse.jpg https://m.media-amazon.com/images/I/81QYVQvXHaL._AC_SL1500_.jpg

echo "Sample images downloaded successfully!" 