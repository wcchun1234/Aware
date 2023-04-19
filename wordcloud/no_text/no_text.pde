import peasy.PeasyCam;
import java.util.HashSet;
import java.util.Arrays;

Table table1; // Declare a Table object for the first CSV file
Table table2; // Declare a Table object for the second CSV file
Table table3; // Declare a Table object for the third CSV file
ArrayList<PVector> wordPositions; // Declare an ArrayList to store word positions
int numWords1; // Declare a variable to store the number of words in the first table
int numWords2; // Declare a variable to store the number of words in the second table
int numWords3; // Declare a variable to store the number of words in the third table
float scaleFactor = 200; // Declare a scaling factor for the distance between words
PeasyCam cam; // Declare a PeasyCam object
float threshold = 10; // Declare a threshold for similarity between words

void setup() {
  //size(800, 600, P3D); // Set the canvas size to 800x600 pixels, with a 3D renderer
  fullScreen(P3D, 1);

  // Load both CSV files
  table1 = loadTable("reduced_embedded_photo.csv", "header");
  table2 = loadTable("reduced_embedded_ard.csv", "header");
  table3 = loadTable("reduced_embedded_data.csv", "header");

  numWords1 = table1.getRowCount(); // Get the number of rows in the first table
  numWords2 = table2.getRowCount(); // Get the number of rows in the second table
  numWords3 = table3.getRowCount(); // Get the number of rows in the third table
  wordPositions = new ArrayList<PVector>(); // Initialize the ArrayList

  // Initialize the PeasyCam object
  cam = new PeasyCam(this, width/2, height/2, 0, 1000);

  // Combine the wordPositions ArrayList for both tables
  for (int i = 0; i < numWords1; i++) {
    float x = table1.getFloat(i, "x"); // Get the x coordinate from the first table
    float y = table1.getFloat(i, "y"); // Get the y coordinate from the first table
    float z = table1.getFloat(i, "z"); // Get the z coordinate from the first table
    PVector pos = new PVector(x * scaleFactor, y * scaleFactor, z * scaleFactor); // Create a new PVector object for the word position, scaled by the factor
    wordPositions.add(pos); // Add the PVector object to the ArrayList
  }

  for (int i = 0; i < numWords2; i++) {
    float x = table2.getFloat(i, "x"); // Get the x coordinate from the second table
    float y = table2.getFloat(i, "y"); // Get the y coordinate from the second table
    float z = table2.getFloat(i, "z"); // Get the z coordinate from the second table
    PVector pos = new PVector(x * scaleFactor, y * scaleFactor, z * scaleFactor); // Create a new PVector object for the word position, scaled by the factor
    wordPositions.add(pos); // Add the PVector object to the ArrayList
  }
  for (int i = 0; i < numWords3; i++) {
    float x = table3.getFloat(i, "x"); // Get the x coordinate from the third table
    float y = table3.getFloat(i, "y"); // Get the y coordinate from the third table
    float z = table3.getFloat(i, "z"); // Get the z coordinate from the third table
    PVector pos = new PVector(x * scaleFactor, y * scaleFactor, z * scaleFactor); // Create a new PVector object for the word position, scaled by the factor
    wordPositions.add(pos); // Add the PVector object to the ArrayList
  }
}

void draw() {
  //fullScreen(P3D, 1);
  background(0); // Set the background color to white
  stroke(255);
  textSize(100); // Set the font size to 20
  textAlign(CENTER, CENTER); // Set the text alignment to center

  for (int i = 0; i < wordPositions.size(); i++) {
    PVector pos1 = wordPositions.get(i); // Get the PVector object for the first word position
    for (int j = i + 1; j < wordPositions.size(); j++) {
      PVector pos2 = wordPositions.get(j); // Get the PVector
      // object for the second word position
      float d = PVector.dist(pos1, pos2); // Calculate the distance between the two word positions
      if (d < threshold * scaleFactor) { // If the distance is below the threshold
        float alpha = map(d, 0, threshold * scaleFactor, 10, 100); // Map the distance to a value between 50 (transparent) and 255 (opaque)
        stroke(255, alpha); // Set the stroke color to white with the calculated alpha value
        // Determine which table each word position belongs to and adjust the stroke color accordingly
        if (i < numWords1 && j < numWords1) { // If both word positions are from the first table
          // do nothing, stroke color is already white with alpha
        } else if (i >= numWords1 && j >= numWords1) { // If both word positions are from the second table
          // do nothing, stroke color is already white with alpha
        } else if (i >= numWords1 + numWords2 && j >= numWords1 + numWords2) { // If both word positions are from the third table
          // do nothing, stroke color is already white with alpha
        } else { // Otherwise (i.e. if one word position is from each table)
          stroke(255, alpha); // Set the stroke color to white with the calculated alpha value
        }
        line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z); // Draw a line between the two word positions
      }
    }
  }
}
