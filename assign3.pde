//Declare constants
final int START_MENU = 0;
final int GAME_RUN = 1;
final int CLICKED = 0;
final int RELEASED = 1;
final int ENABLED = 2;
final int MAX_HP = 190;

//Declare variables
PImage bg1, bg2, fighter, enemy1, treasure, hpFrame, start1, start2;
int gameState, bg1X, bg2X, bgY, hpFrameX, hpFrameY, treasureX, treasureY;
int fighterX, fighterY, enemyX, enemyY, start1Y, start2Y;
boolean upPressed, downPressed, leftPressed, rightPressed;
int mouse = CLICKED;
int hp = MAX_HP / 5;
int waveCount = 1;

void setup(){
  
  //setting frame
  size(640,480);
  
  //loading img
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  fighter = loadImage("img/fighter.png");
  enemy1 = loadImage("img/enemy.png");
  treasure = loadImage("img/treasure.png");
  hpFrame = loadImage("img/hp.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  
   
  //intialize variables
    //set game state
    gameState = START_MENU;
  
    //set bg
    start1Y = height + 1;
    start2Y = 0;
    bg1X = width;
    bg2X = 0;
    bgY = height;
  
    //set hp
    hpFrameX = 5;
    hpFrameY = 5;
  
    //set treasure -
    //treasure never start touching eny boundaries or the hp bar
    treasureX = (int)random(3, width - 44);
  
    if (treasureX <= 211 + hpFrameX) {
      treasureY = (int)random(34 + hpFrameY, height - 44);
    } else {
      treasureY = (int)random(3, height - 44);
    }
  
    //set enemy - 
    //enemy never start touching the lower boundary
    enemyX = -309;
    enemyY = (int)random(3, height - 64);
  
    //set fighter
    fighterX = width - 54;
    fighterY = height / 2 - 25;
}


void draw(){
  switch(gameState) { 

  case START_MENU: 
    //starting bg
      //set
      image(start2, 0, start2Y);
      image(start1, 0, start1Y);
  
      //When mouse is on the button, light the button on
      //When mouse both clicked & released while it's on the button, start the game
      if (mouseX > 210 && mouseY > 382 && mouseX < 446 && mouseY < 413) {
        start1Y = 0;
        if (mouse == RELEASED) {
          nextGameState();
        }
      } else {
        initialize("start1Y");
      }
      break;

  case GAME_RUN: 



    //hide menu
    start1Y = height + 1;
    start2Y = height + 1;

    //bg
      //set
      image(bg1, bg1X - width, 0);
      image(bg2, bg2X - width, 0);
  
      //move
      ++bg1X;
      ++bg2X;
      bg1X %= width * 2;
      bg2X %= width * 2;
      
    //hp
      //set
      fill(RGB);
      noStroke();
      fill(255, 0, 0, 220);
      rect(hpFrameX + 13, hpFrameY, hp, 25);
      image(hpFrame, hpFrameX, hpFrameY);
      fill(255, 255, 255);
      textSize(18);
      text((int)(((float)hp / MAX_HP) * 100) + "%", 100, 25);
      
      //anti-copying
      textSize(10);
      text("102208026", hpFrameX + 320, 25);

    //treasure
      //set           
      //treasure won't be touching fighter when appears
      int treaFiDisX = abs(fighterX - treasureX);
      int treaFiDisY = abs(fighterY - treasureY);
      while (treaFiDisX < 60 && treaFiDisY < 60) {
        initialize("treasureX");
        initialize("treasureY");
        treaFiDisX = abs(fighterX - treasureX);
        treaFiDisY = abs(fighterY - treasureY);
      }
      image(treasure, treasureX, treasureY);
      //gain hp           
      if (treaFiDisX < 41 && treaFiDisY < 41) {
       
        do {
          initialize("treasureX");
          initialize("treasureY");
          treaFiDisX = abs(fighterX - treasureX);
          treaFiDisY = abs(fighterY - treasureY);
        } while (treaFiDisX < 60 && treaFiDisY < 60);
      }
  


    //fighter
      //set
      image(fighter, fighterX, fighterY);
      //move
      if (fighterY > 5 && upPressed) fighterY -= 5;
      if (fighterY < height - 59 && downPressed) fighterY += 5;
      if (fighterX > 5 && leftPressed) fighterX -= 5;
      if (fighterX < width - 59 && rightPressed) fighterX += 5;
  
  //enemies
  switch(waveCount %= 3){
    case 1:
      for(int count = 0; count < 5; ++count){
        image(enemy1, enemyX + 62 * count, enemyY);
      }
      enemyX += 4;
      if(enemyX > 644){
        ++waveCount;
        initialize("enemyX");
      }
      break;
      
    case 2:
      for(int count = 0; count < 5; ++count){
        while(enemyY < 123) initialize("enemyY");
        image(enemy1, enemyX + 62 * count, enemyY - 30 * count);
      }
      enemyX += 4;
      if(enemyX > 644){
        ++waveCount;
        initialize("enemyX");
      }
      break;
      
    case 0:    
      while(enemyY > 264 || enemyY < 216) enemyY = (int)(random(216, 265));
        for(int i = 0; i < 3; ++i){
          for(int j = 0; j < 3; ++j){
            if(!(i == 1 && j == 1)){
            image(enemy1, enemyX + 62 * j + 62 * i, enemyY - 40 * j + 40 * i);
            }
          }
        }
        enemyX += 4;
        if(enemyX > 644){
          ++waveCount;
          initialize("enemyX");
        }
          break;
    default: image(enemy1, 300, 200);
  }
  }
            
  
  
  
  
  
  
  
  
  
}



  void mousePressed() {
    switch(gameState) {
    case START_MENU:
      if (mouseX > 210 && mouseY > 382 && mouseX < 446 && mouseY < 413 && mouseButton == LEFT) {
        mouse = ENABLED;
      }
      break;
    }
  }





  void mouseReleased() {
    switch(gameState) {
    case START_MENU:
      if (mouse == ENABLED && mouseX > 210 && mouseY > 382 && mouseX < 446 && mouseY < 413) {
        mouse = RELEASED;
      } else mouse = CLICKED;
      break;
    
    }
  }

  void keyPressed() {
    if (key == CODED) {
      switch(keyCode) {
      case UP: 
        if (fighterY > 0) upPressed = true;
        break;
      case DOWN:
        if (fighterY < height - 54) downPressed = true;
        break;
      case LEFT:
        if (fighterX > 0) leftPressed = true;
        break;
      case RIGHT:
        if (fighterX < width - 54) rightPressed = true;
        break;
      }
    }
  }

  void keyReleased() {

    if (key == CODED) {
      switch(keyCode) {
      case UP: 
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      }
    }
  }


  void initialize(String s) {
    switch(s) {
    case "start1Y":
      start1Y = height + 1;
      break;
      
    case "treasureX":
      treasureX = (int)random(3, width - 44);
      break;

    case "treasureY":
      if (treasureX <= 211 + hpFrameX) {
        treasureY = (int)random(34 + hpFrameY, height - 44);
      } else {
        treasureY = (int)random(3, height - 44);
      }
      break;

    case "enemyX":
      enemyX = -309;
      break;

    case "enemyY":
      enemyY = (int)random(34 + hpFrameY, height - 64);
      break;

    }
  }

void nextGameState() {

    switch(gameState) {
    case START_MENU:
      gameState = GAME_RUN;
      mouse = CLICKED;
      break;

    } 
  }
