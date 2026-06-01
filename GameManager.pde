class GameManager {
  int gameState;
  int score, lives;
  Fish currentFish;
  TypingEngine typer;
  int waitTimer = 0;
  int fishingTimer = 0;
  int fishingDuration = 300; 

  GameManager() {
    score = 0;
    lives = 3;
    typer = new TypingEngine();
    startWaiting();
    gameState = 3;
  }

  void startWaiting() {
    gameState = WAITING;
    waitTimer = (int)random(120, 300); 
    currentFish = null;
  }

  void spawnFish() {
    currentFish = new Fish();
    typer.setTarget(currentFish.name, true);
    fishingTimer = 0; 
    gameState = 0;
  }

  void run() {
    drawFishingLine();
    
    drawUI();
    switch(gameState) {
    case WAITING:
      updateWaiting();
      break;
    case 0:
      drawFishingPhase();
      break;
    case 1:
      drawReelingPhase();
      break;
    case 2:
      drawGameOver();
      break;
    case 3:
      drawStartScreen();
      break;
    }
  }

  void updateWaiting() {
    waitTimer--;
    textAlign(CENTER);
    fill(0, 100);
    text("Waiting for a bite...", width/2, height/2 + 50);

    if (waitTimer <= 0) {
      spawnFish();
    }
  }

  void drawFishingLine() {
    float rodTipX = 242;
    float rodTipY = 215;

    strokeWeight(1);
    stroke(0); 
    
    if (gameState == 1 && currentFish != null) {
      float hookX = currentFish.fishX - 24;
      float hookY = 380; // Changed from 350 to 380
      
      line(rodTipX, rodTipY, hookX, hookY);
      
    } else {
      float lineDropY = 320;
      line(rodTipX, rodTipY, rodTipX, lineDropY);
      
      strokeWeight(1);
      stroke(0);
      
      fill(255, 0, 0);
      arc(rodTipX, lineDropY, 12, 12, PI, TWO_PI, CHORD);
      
      fill(255);
      arc(rodTipX, lineDropY, 12, 12, 0, PI, CHORD);
    }
    noStroke();
  }

  void drawFishingPhase() {
    if (currentFish != null) {
      currentFish.update();
      fishingTimer++;
      if (fishingTimer >= fishingDuration) {
        startWaiting();
        return;
      }

      if (currentFish.fishImg != null) {
        pushMatrix();
        translate(currentFish.fishX, 380); // Changed from 350 to 380
        imageMode(CENTER);
        tint(0, 50, 120, 100); 
        
        image(currentFish.fishImg, 0, 0, 64, 64);
        noTint();
        popMatrix();
        imageMode(CORNER);
      }
      
      currentFish.displayShadow();
      typer.displayBubble();
      fill(255);
      textSize(16);
      text(currentFish.name, currentFish.fishX, 410); // Changed from 380 to 410 so it sits nicely below the fish
    }
  }

  void drawReelingPhase() {
    if (currentFish != null) {
      currentFish.updateStruggle();
      currentFish.displayFish();
      typer.displaySentence();

      // Adjust bounding checks if your new background structure implies different boundaries
      float hookX = currentFish.fishX - 32; 
      if (hookX <= 215) {
        score += currentFish.fishScore;
        startWaiting();
        return;
      }

      if (hookX >= width) {
        loseLife();
        return;
      }
    }
  }

  void loseLife() {
    lives--;
    if (lives <= 0) gameState = 2;
    else startWaiting();
  }

  void handleInput() {
    if (gameState == 0) {
      if (typer.checkBubbleInput()) {
        gameState = 1;
        typer.setTarget(typer.getRandomSentence(currentFish.fishDiff), false);
      } else if (typer.failed) {
        loseLife();
      }
    } else if (gameState == 1 && currentFish != null) {
      typer.checkReelingInput(currentFish);
    } else if (gameState == 2 && key == ' ') {
      reset();
    } else if (gameState == 3 && key == ' ') {
      gameState = WAITING;
    }
  }

  void drawUI() {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text("SCORE: " + score, 20, 40);
    text("LIVES: " + lives, 20, 70);
    
    //if ((gameState == 0 || gameState == 1) && currentFish != null) {
    //  textAlign(RIGHT);
    //  text(currentFish.name.toUpperCase() + " [" + currentFish.fishDiff.toUpperCase() + "]", width - 20, 40);
    //}
  }

  void drawGameOver() {
    textAlign(CENTER);
    fill(200, 0, 0);
    textSize(40);
    text("GAME OVER", width/2, height/2);
    fill(0);
    textSize(20);
    text("Press SPACE to Restart", width/2, height/2 + 50);
  }

  void drawStartScreen() {
    textAlign(CENTER);
    fill(0);
    textSize(40);
    text("HOOKED ON WORDS", width/2, height/2);
    textSize(20);
    text("Press SPACE to Start", width/2, height/2 + 50);
  }

  void reset() {
    score = 0;
    lives = 3;
    startWaiting();
  }
}
