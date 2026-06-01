import gifAnimation.*; // Import the GIF library

GameManager gm;
final int WAITING = 4;
PImage bgImgFront, bgImgBack;
Gif oceanGif;   // Declare the GIF variable

void setup() {
  size(800, 450);
  
  bgImgBack = loadImage("background_2.png");
  bgImgFront = loadImage("background_1.png");
  
  // Load the GIF from your data folder and pass 'this' sketch context
  oceanGif = new Gif(this, "ocean.gif");
  oceanGif.loop(); // Tell the GIF to loop continuously 
  
  gm = new GameManager();
}

void draw() {
  // 1. Draw the static background (Sky, Boat, Fisherman)
  if (bgImgBack != null) {
    image(bgImgBack, 0, 0);
  } else {
    background(200, 230, 255);
  }
  
  // 2. Overlay the flowing ocean GIF on top of the old static water
  if (oceanGif != null) {
    image(oceanGif, 0, 0);
  }
  
  if (bgImgFront != null) {
    image(bgImgFront, 0, 0);
  } else {
    background(200, 230, 255);
  }
  
  // 3. Run game elements (Line, Bobber, UI, Fish) over the environment
  gm.run();
}

void keyPressed() {
  gm.handleInput();
}
