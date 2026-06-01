class Fish {
  float fishX;
  float targetX;
  boolean entering = true;
  String name;
  float struggle;
  int fishScore;
  String fishDiff;
  String[] names = {"Tuna", "Salmon", "Bass", "Trout", "Snapper"};
  PImage fishImg;

  Fish() {
    //fishX = random(400, 600);
    fishX = 800;
    targetX = random(400, 600);
    name = names[(int)random(names.length)];

    // Remember to save your new images as transparent .png files!
    fishImg = loadImage(name.toLowerCase() + ".png");

    if (name.equals("Bass")) {
      fishDiff = "easy";
      fishScore = 5;
      struggle = 0.6;
    } else if (name.equals("Trout") || name.equals("Snapper")) {
      fishDiff = "medium";
      fishScore = 15;
      struggle = 1.1;
    } else {
      fishDiff = "hard";
      fishScore = 40;
      struggle = 1.6;
    }
  }

  void update() {
    if (entering) {

      float speed = 2.5;

      if (fishX < targetX) {
        fishX += speed;
      } else {
        fishX -= speed;
      }

      if (abs(fishX - targetX) < speed) {
        fishX = targetX;
        entering = false;
      }
      return;
    }
  }
  void updateStruggle() {
    //updateStruggle() ;
    float move = (random(100) < 0.5) ? 25.0 : struggle;
    fishX += move;
  }


  void displayShadow() {
    fill(50, 50, 50, 150);
    ellipse(fishX, 380, 50, 30); // Changed from 350 to 380
  }

  void displayFish() {
    if (fishImg != null) {
      pushMatrix();
      translate(fishX, 380); // Changed from 350 to 380
      imageMode(CENTER);

      // Resizing 1280x1280 down to 64x64 on the fly for better visibility
      image(fishImg, 0, 0, 64, 64);
      popMatrix();
      imageMode(CORNER);
    } else {
      fill(50, 80, 150);
      ellipse(fishX, 380, 40, 25); // Changed from 350 to 380
    }
  }
}
