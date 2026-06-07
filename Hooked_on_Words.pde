import processing.sound.*;
SoundFile bgm;
SoundFile hookSfx;
SoundFile loseFish;
SoundFile gameOver;

import gifAnimation.*;

GameManager gm;
final int WAITING = 4;
PImage bgImgBack;
PImage[] fishermanImg = new PImage[4];
int currentFrame = 0;
Gif oceanGif;

void setup() {
  size(800, 450);

  bgImgBack = loadImage("background.png");
  fishermanImg[0] = loadImage("fisher_1.png");
  fishermanImg[1] = loadImage("fisher_2.png");
  fishermanImg[2] = loadImage("fisher_3.png");
  fishermanImg[3] = loadImage("fisher_4.png");

  oceanGif = new Gif(this, "ocean.gif");
  oceanGif.loop();

  bgm = new SoundFile(this, "bgm.mp3");
  bgm.loop();
  bgm.amp(0.3);

  hookSfx = new SoundFile(this, "hook.mp3");
  loseFish = new SoundFile(this,"lose.mp3");
  gameOver = new SoundFile(this,"over.mp3");

  gm = new GameManager();
}

void draw() {
  if (bgImgBack != null) {
    image(bgImgBack, 0, 0);
  } else {
    background(200, 230, 255);
  }

  if (oceanGif != null) {
    image(oceanGif, 0, 0);
  }

  // Animate/choose your currentFrame depending on the game state.
  // For example, if reeling, change frame based on the timer or typing index.
  if (gm.gameState == 1) {
    // Cycles frames 0, 1, 2 smoothly over time while reeling
    currentFrame = (frameCount / 10) % 4;
  } else {
    currentFrame = 0; // Default idle frame when waiting or fishing
  }

  // Draw the dynamic foreground fisherman image
  if (fishermanImg[currentFrame] != null) {
    image(fishermanImg[currentFrame], 0, 0);
  }

  // ---------------------------------------------------------
  // DEBUG OVERLAY: Delete or comment this section out later!
  // ---------------------------------------------------------
  //// 1. Draw a red crosshair at the mouse position
  //stroke(255, 0, 0);
  //strokeWeight(1);
  //line(mouseX - 10, mouseY, mouseX + 10, mouseY);
  //line(mouseX, mouseY - 10, mouseX, mouseY + 10);

  //// 2. Display the coordinate text near the cursor
  //fill(0);
  //rect(mouseX + 15, mouseY - 25, 95, 22, 5); // Background box for readability
  //fill(255, 255, 0); // Bright yellow text
  //textSize(14);
  //textAlign(LEFT, CENTER);
  //text("X: " + mouseX + " Y: " + mouseY, mouseX + 20, mouseY - 15);
  // ---------------------------------------------------------

  gm.run();
}

void keyPressed() {
  gm.handleInput();
}
