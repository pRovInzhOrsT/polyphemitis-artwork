/*

--The Eyeflood Generator--

by pRovInzhOrsT, 2021

This program generated the cover artwork for my single "Polyphemitis". Listen to the song, I'm better at music than at programming...

USER INSTRUCTIONS

1. Run this code.
2. Watch the generation process until the graphic seems fancy enough.
3. Click left mouse-button to halt. The image then will be saved for further use.

*/

//++// PREPARING //++//

PImage img, img2, img3;
boolean game = true;
color titleColor = color(240, 100, 0);
color[] mainScreenSave;
color[] mainTitleSave;
color[] artistSave;

void setup() {
  background(0);
  size(1000, 1000);
  img = loadImage("eye.png");
}

//++// MAIN LOOP //++//

void draw() {
  
  if (game) {
    
    // Placing the eyes
    
    scale(random(0.01, random(0.8, 1))); // Randomize their size...
    rotate(random(-PI/4, PI/4)); // ...apply a random rotation...
    
    image(img, random(0, width), random(0, height)); // ...and give them a random position
    image(img, random(width / 2, width), random(height / 2, height));
    image(img, random(width / 2, width), random(height / 2, height));
    
    loadPixels();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int loc = x + y * width;        
        pixels[loc] = pixels[(int(loc - 2 * x - 2 * y) + pixels.length) % pixels.length]; // Apply varying degrees of distortion to different parts of the image
        pixels[loc] = pixels[(int(loc + random(0, 0.001) * x + (x * 0.00001 * y)) + pixels.length) % pixels.length];
      }
    }
    
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int loc = x + y * width;
        pixels[loc] = color(1.0 * red(pixels[(loc + int(random(1))) % pixels.length]), 1 * green(pixels[(loc + int(random(2))) % pixels.length]), 0, 100); // Offset red and green colors for a fancy glitch effect
      }
    }  
    
    updatePixels();
    
  } else {
    
    frameRate(0); // End the generation loop
    
    pixels = tintOrange(pixels);
    mainScreenSave = savePixels(pixels);
    clearAll(pixels);
    updatePixels();
    
    img2 = loadImage("polyphemitis.png"); // Placing the song title now
    scale(0.45);
    rotate(0);
    image(img2, height * 0.11, height * 1.98);
    loadPixels();
    
    updatePixels();
    
    mainTitleSave = savePixels(pixels);
    
    img2 = loadImage("polyphemitis.png"); // Second song title layer
    scale(1.01);
    image(img2, width * 0.104, height * 1.962);
    loadPixels();
    
    pixels = drawTitleEdge(pixels); // Coloring
    
    mainTitleSave = savePixels(pixels); // Save all for later
    clearAll(pixels);
    updatePixels();    
    
    img3 = loadImage("prov.png"); // Placing the artist name
    scale(0.25);
    image(img3, width * 4, height * 0.4);
    loadPixels();
    
    artistSave = savePixels(pixels); // Save all for later
    clearAll(pixels);
    updatePixels();
    
    pixels = glueAll(pixels); // Unite all the different parts
    updatePixels();
    
    save("MyPolyphemitisCover.tif"); // Save the final image
    //save("MyPolyphemitisCover.png"); // (Choose your file type)
    
  }
}

//++// MESSY HELPER METHODS DOWN HERE TO KEEP THE MAIN LOOP CLEAN //++//

void mousePressed() {
  game = false; 
}

color[] savePixels(final color[] pixelArray) {
  color[] saved = new color[pixelArray.length];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      saved[loc] = pixelArray[loc];
    }
  }
  return saved;
}

void clearAll(final color[] pixelArray) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      pixelArray[loc] = color(0, 0, 0);
    }
  }
}

color[] tintOrange(final color[] pixelArray) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      int blue = 0;
      if (red(pixelArray[loc]) + green(pixelArray[loc]) < 20) {
        blue = int(random(1, 30));
      }
      pixelArray[loc] = color(0.8 * red(pixelArray[loc]), 0.6 * green(pixelArray[loc]), blue);
    }
  }
  return pixelArray;
}

color[] tintTitle(final color[] pixelArray) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      if (red(pixelArray[loc]) > 40) {          
        pixelArray[loc] = color(titleColor);
        int changeRed = int(random(9)) == 0 ? 1 : 0;
        int changeGreen = int(random(7)) == 0 ? 1 : 0;
        titleColor = color(red(titleColor) + changeRed * random(-1, 2), green(titleColor) + changeGreen * random(-1, 2), 0);
      }
    }
  }
  return pixelArray;
}

color[] drawTitleEdge(final color[] pixelArray) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;        
      if (red(pixelArray[loc]) > 40) {
        if(red(mainTitleSave[loc]) == 0) {
          pixelArray[loc] = color(random(150, 200), random(220, 255), random(20));
        } else {
          if (red(mainTitleSave[loc]) > 0) {
            pixelArray[loc] = mainTitleSave[loc];
          }
        }          
      } else {
        if (red(mainTitleSave[loc]) > 0) {
          pixelArray[loc] = mainTitleSave[loc];
        }
      }
    }
  }
  return pixelArray;
}

color[] artistDistortion(final color[] pixelArray) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      if (red(pixelArray.length) > 30) {
        pixelArray[loc] = color(random(20), random(200, 250), random(180, 220));
      }
      if (loc < pixels.length - 3 && loc > 1) {
        if (red(pixels[loc + 1]) > 0) {
          if ( green(pixels[loc - 1]) == 0 ) {
            pixelArray[loc + 1] = color(0, random(200, 240), random(230, 250));
            pixelArray[loc + 2] = color(random(20), random(220, 255), random(210, 235));
            pixelArray[loc + 3] = color(random(20), random(40), 255);
          }
        }
      }
    }
  }
  return pixelArray;
}

color[] glueAll(final color[] pixelArray) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      if (red(pixelArray[loc]) + green(pixels[loc]) == 0) {
        if (red(artistSave[loc]) + green(artistSave[loc]) == 0) {
          if (red(mainTitleSave[loc]) + green(mainTitleSave[loc]) == 0) {
            pixelArray[loc] = mainScreenSave[loc];
          } else {
            pixelArray[loc] = mainTitleSave[loc];
          }
        } else {
          pixelArray[loc] = artistSave[loc];
        }     
      } 
    }
  }
  return pixelArray;
}
