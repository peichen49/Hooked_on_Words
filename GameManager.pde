class GameManager {
  int gameState;
  int score, lives;
  Fish currentFish;
  TypingEngine typer;
  int waitTimer = 0;
  int fishingTimer = 0;
  int fishingDuration = 300;
  int fishCaughtX = 215;

  GameManager() {
    score = 0;
    lives = 3;
    typer = new TypingEngine();
    startWaiting();
    gameState = 3;
  }

  void startWaiting() {
    gameState = WAITING;
    waitTimer = (int)random(30, 60);
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
    text("Waiting for a bite... [" + waitTimer/10 + "]", width/2, height/2 + 50);

    if (waitTimer <= 0) {
      spawnFish();
    }
  }

  void drawFishingLine() {
    float[] tipXCoordinates = { 242, 189, 171, 242 };
    float[] tipYCoordinates = { 215, 171, 126, 215 };

    float rodTipX = tipXCoordinates[currentFrame];
    float rodTipY = tipYCoordinates[currentFrame];

    strokeWeight(1);
    stroke(0);

    if (gameState == 1 && currentFish != null) {
      float hookX = currentFish.fishX - 24;
      float hookY = 380;

      line(rodTipX, rodTipY, hookX, hookY);
    } else {
      // --- Floating Bobber Physics ---
      float bobberSwingX = rodTipX + sin(frameCount * 0.05) * 15;
      float lineDropY = 400 + cos(frameCount * 0.07) * 5;

      // Draw the fishing line shifting from the dynamic rod tip to the drifting bobber position
      line(rodTipX, rodTipY, bobberSwingX, lineDropY);

      strokeWeight(1);
      stroke(0);

      // Red half of the bobber
      fill(255, 0, 0);
      arc(bobberSwingX, lineDropY, 12, 12, PI, TWO_PI, CHORD);

      // White half of the bobber
      fill(255);
      arc(bobberSwingX, lineDropY, 12, 12, 0, PI, CHORD);
    }
    noStroke();
  }

  void drawFishingPhase() {
    if (currentFish != null) {
      currentFish.swimIn();

      fishingTimer++;
      if (fishingTimer >= fishingDuration) {
        startWaiting();
        return;
      }

      if (currentFish.fishImg != null) {
        pushMatrix();
        translate(currentFish.fishX, 380);
        imageMode(CENTER);
        tint(0, 50, 120, 100);

        image(currentFish.fishImg, 0, 0, 64, 64);
        noTint();
        popMatrix();
        imageMode(CORNER);
      }

      currentFish.displayShadow();

      if (currentFish.isReady) {
        typer.displayBubble();
      }
      
      textAlign(CENTER);
      fill(255);
      textSize(16);
      text(currentFish.name, currentFish.fishX, 410);
      textAlign(LEFT);
    }
  }

  void drawReelingPhase() {
    if (currentFish != null) {
      currentFish.updateStruggle();
      currentFish.displayFish();
      typer.displaySentence();

      // Adjust bounding checks if your new background structure implies different boundaries
      float hookX = currentFish.fishX - 24;
      if (hookX <= fishCaughtX) {
        score += currentFish.fishScore;
        hookSfx.play();
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
    loseFish.play();
    if (lives <= 0) {
    gameState = 2;
    gameOver.play();}
    else startWaiting();
  }

  void handleInput() {
    if (gameState == 0) {
      if (currentFish != null && !currentFish.isReady) return;
      if (typer.checkBubbleInput()) {
        gameState = 1;
        typer.setTarget(typer.getRandomSentence(currentFish.fishDiff), false);
      } else if (typer.failed) {
        loseLife();
      }
    } else if (gameState == 1 && currentFish != null) {
      typer.checkReelingInput(currentFish, this);
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

    // Test the Fish Type
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
    text("HOOKED ON WORDS", width/2, height/2 - 30);
    textSize(20);
    text("Press SPACE to Start", width/2, height/2 + 20);
  }

  void reset() {
    score = 0;
    lives = 3;
    startWaiting();
  }
}
