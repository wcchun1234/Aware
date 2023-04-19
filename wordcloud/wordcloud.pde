import peasy.PeasyCam;
import java.util.ArrayList;

Table table1; // Declare a Table object for the first CSV file
Table table2; // Declare a Table object for the second CSV file
Table table3; // Declare a Table object for the third CSV file
ArrayList<PVector> wordPositions; // Declare an ArrayList to store word positions
ArrayList<String> words; // Declare an ArrayList to store the words
int numWords1; // Declare a variable to store the number of words in the first table
int numWords2; // Declare a variable to store the number of words in the second table
int numWords3; // Declare a variable to store the number of words in the third table
float scaleFactor = 400; // Declare a scaling factor for the distance between words
PeasyCam cam; // Declare a PeasyCam object
float threshold = 100; // Declare a threshold for similarity between words

void setup() {
  fullScreen(P3D, 1);  // For projector
  //size(1500, 900, P3D); // Set the canvas size to 800x600 pixels, with a 3D renderer
  smooth(2);
  
  // Load both CSV files
  table1 = loadTable("reduced_embedded_photo.csv", "header");
  table2 = loadTable("reduced_embedded_ard.csv", "header");
  table3 = loadTable("reduced_embedded_data.csv", "header");

  numWords1 = table1.getRowCount(); // Get the number of rows in the first table
  numWords2 = table2.getRowCount(); // Get the number of rows in the second table
  numWords3 = table3.getRowCount(); // Get the number of rows in the third table
  wordPositions = new ArrayList<PVector>(); // Initialize the ArrayList
  words = new ArrayList<String>(); // Initialize the ArrayList

  // Initialize the PeasyCam object
  cam = new PeasyCam(this, width/2, height/2, 0, 1000);// Set the minimum and maximum distance for the camera
  cam.setMinimumDistance(1);
  cam.setMaximumDistance(30000);

  // Adjust the wheel sensitivity for zooming (increase the value to decrease sensitivity)
  cam.setWheelScale(0.01); // Adjust this value to your desired sensitivity

  // Combine the wordPositions ArrayList and words ArrayList for both tables
  for (int i = 0; i < numWords1; i++) {
    float x = table1.getFloat(i, "x"); // Get the x coordinate from the first table
    float y = table1.getFloat(i, "y"); // Get the y coordinate from the first table
    float z = table1.getFloat(i, "z"); // Get the z coordinate from the first table
    String word = table1.getString(i, "text"); // Get the word from the first table
    PVector pos = new PVector(x * scaleFactor, y * scaleFactor, z * scaleFactor); // Create a new PVector object for the word position, scaled by the factor
    wordPositions.add(pos); // Add the PVector object to the ArrayList
    words.add(word); // Add the word to the ArrayList
  }

  for (int i = 0; i < numWords2; i++) {
    float x = table2.getFloat(i, "x"); // Get the x coordinate from the second table
    float y = table2.getFloat(i, "y"); // Get the y coordinate from the second table
    float z = table2.getFloat(i, "z"); // Get the z coordinate from the second table
    String word = table2.getString(i, "text"); // Get the word from the second table
    PVector pos = new PVector(x * scaleFactor, y * scaleFactor, z * scaleFactor); // Create a new PVector object for the word position, scaled by the factor
    wordPositions.add(pos); // Add the PVector object to the ArrayList
    words.add(word); // Add the word to the ArrayList
  }
  for (int i = 0; i < numWords3; i++) {
    float x = table3.getFloat(i, "x"); // Get the x coordinate from the third table
    float y = table3.getFloat(i, "y"); // Get the y coordinate from the third table
    float z = table3.getFloat(i, "z"); // Get the z coordinate from the third table
    String word = table3.getString(i, "text"); // Get the word from the third table
    PVector pos = new PVector(x * scaleFactor, y * scaleFactor, z * scaleFactor); // Create a new PVector object for the word position, scaled by the factor
    wordPositions.add(pos); // Add the PVector object to the ArrayList
    words.add(word); // Add the word to the ArrayList
  }
}

void draw() {
  background(0); // Set the background color to black

  // Draw lines between words if they are close enough
  for (int i = 0; i < wordPositions.size(); i++) {
    PVector pos1 = wordPositions.get(i);
    for (int j = i + 1; j < wordPositions.size(); j++) {
      PVector pos2 = wordPositions.get(j);
      float d = PVector.dist(pos1, pos2);
      if (d < threshold) {
        stroke(255, 100); // Set the stroke color to white with 100 alpha
        line(pos1.x, pos1.y * -1, pos1.z, pos2.x, pos2.y * -1, pos2.z); // Draw a line between the two word positions
      }
    }
  }

  // Draw text and colored lines between word positions
  textSize(100); // Set the font size to 12
  textAlign(CENTER, CENTER); // Set the text alignment to center
  noStroke(); // Disable stroke for the text
  PVector nextPos = null; // Declare a variable to store the next position
  for (int i = 0; i < wordPositions.size(); i++) {
    PVector pos = wordPositions.get(i);
    String word = words.get(i);

    if (i < numWords1) {
      fill(0, 255, 255); // Set the fill color to blue for the text from the first CSV file
    } else if (i < numWords1 + numWords2) {
      fill(255, 102, 255); // Set the fill color to red for the text from the second CSV file
    } else {
      fill(255, 255, 0); // Set the fill color to yellow for the text from the third CSV file
    }

    pushMatrix(); // Save the current transformation matrix
    translate(pos.x, pos.y * -1, pos.z); // Translate to the word position
    scale(1, -1); // Flip the text along the Y-axis

    text(word, 0, 0); // Display the word at its position

    // Draw colored lines between word positions
    if (i < numWords1 - 1) {
      stroke(51, 255, 255); // Set the stroke color to blue for the lines from the first CSV file
    } else if (i < numWords1 + numWords2 - 1) {
      stroke(255, 102, 255); // Set the stroke color to red for the lines from the second CSV file
    } else {
      stroke(255, 255, 0); // Set the stroke color to yellow for the lines from the third CSV file
    }

    if (i < wordPositions.size() - 1) { // Check if there is a next position
      nextPos = wordPositions.get(i + 1); // Get the next position
      line(pos.x, pos.y * -1, pos.z, nextPos.x, nextPos.y * -1, nextPos.z); // Draw a line between the two word positions
    }

    popMatrix(); // Restore the transformation matrix
  }
}

void randomZoom() {
  // Generate random X, Y, and Z values within the word positions range
  float minX = Float.MAX_VALUE;
  float maxX = Float.MIN_VALUE;
  float minY = Float.MAX_VALUE;
  float maxY = Float.MIN_VALUE;
  float minZ = Float.MAX_VALUE;
  float maxZ = Float.MIN_VALUE;

  for (PVector position : wordPositions) {
    if (position.x < minX) minX = position.x;
    if (position.x > maxX) maxX = position.x;
    if (position.y < minY) minY = position.y;
    if (position.y > maxY) maxY = position.y;
    if (position.z < minZ) minZ = position.z;
    if (position.z > maxZ) maxZ = position.z;
  }

  float randomX = random(minX, maxX);
  float randomY = random(minY, maxY) * -1; // Multiply by -1 to account for flipped Y-axis
  float randomZ = random(minZ, maxZ);

  // Set the camera target to the random position
  cam.lookAt(randomX, randomY, randomZ, 1000);
}
