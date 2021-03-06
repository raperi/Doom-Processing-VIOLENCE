import processing.serial.*;
Serial port;
PImage[] guns = new PImage[4];
PImage[] enemies = new PImage[4];
PImage[] reticles = new PImage[4];
int[] allowedAmo = new int[4];
int[] enemyHits = new int[4];
int[] enemyHitsGlobal = new int[4];
int[] ancListGlobal = new int[4];
int[] altListGlobal = new int[4];
int[] enemyState = new int[20];
int[] enemyList = new int[20];
int[] enemyPoints = new int[4];
int[] gunAmo = new int[4];
int[] coolDown = new int[4];
int[] ancList = new int[4];
int[] altList = new int[4];
int[] posX = new int[20];
int[] highScores = new int[10];
String[] gunNames = new String[4];

PImage doomLogo;
PImage violence;
PImage selectedGun;
PImage selectedRet;
PImage stage;
PFont agencyFB;
PFont DooM;

float distancia = 0;
float sensor;

int section;
int time;
int gunNum;
int avaiableGuns;
int cool;
int life = 10;
int e = 0;
int puntaje = 0;

void setup(){
  size(1280, 720);
  println(Serial.list());
  port= new Serial(this,Serial.list()[0],9600); 
  //port= new Serial(this,"/dev/cu.usbmodem14311",9600);
  doomLogo = loadImage("DOOM.jpg");
  stage = loadImage("stage.jpg");
  agencyFB = loadFont("AgencyFB-Reg-48.vlw");
  DooM = loadFont("DooM-50.vlw");
  violence = loadImage("violence.png");
  section = 0;
  gunNum = 0;
  avaiableGuns = 1;
  
  //CARGAR LISTAS
  for(int i = 0; i < guns.length; i++){
    guns[i] = loadImage("gun" + i + ".png");
    enemies[i] = loadImage("enemy" + i + ".png");
    reticles[i] = loadImage("reticle" + i + ".png");
  }
  for(int i = 0; i < 20; i++){
    enemyState[i] = 1;
    int e = int (random(4));
    int r = int (random(3));
    enemyList[i] = e;
    posX[i] = r;
  }
  for(int i = 0; i < highScores.length; i++){
    highScores[i] = 0;
  }
  gunNames[0] = "SHUT GUN";
  gunNames[1] = "CANNON";
  gunNames[2] = "CHAIN GUN";
  gunNames[3] = "BFG";
  allowedAmo[0] = 20;
  allowedAmo[1] = 15;
  allowedAmo[2] = 100;
  allowedAmo[3] = 5;
  ancListGlobal[0] = 75;
  ancListGlobal[1] = 80;
  ancListGlobal[2] = 100;
  ancListGlobal[3] = 120;
  altListGlobal[0] = 134;
  altListGlobal[1] = 134;
  altListGlobal[2] = 105;
  altListGlobal[3] = 134;
  altList[0] = altListGlobal[0];
  altList[1] = altListGlobal[1];
  altList[2] = altListGlobal[2];
  altList[3] = altListGlobal[3];
  ancList[0] = ancListGlobal[0];
  ancList[1] = ancListGlobal[1];
  ancList[2] = ancListGlobal[2];
  ancList[3] = ancListGlobal[3];
  enemyHitsGlobal[0] = 10;
  enemyHitsGlobal[1] = 15;
  enemyHitsGlobal[2] = 20;
  enemyHitsGlobal[3] = 40;
  enemyHits[0] =  enemyHitsGlobal[0];
  enemyHits[1] =  enemyHitsGlobal[1];
  enemyHits[2] =  enemyHitsGlobal[2];
  enemyHits[3] =  enemyHitsGlobal[3];
  gunAmo[0] = 20;
  gunAmo[1] = 15;
  gunAmo[2] = 100;
  gunAmo[3] = 5;
  coolDown[0] = 1;
  coolDown[1] = 2;
  coolDown[2] = 0;
  coolDown[3] = 1;
  enemyPoints[0] = 100;
  enemyPoints[1] = 250;
  enemyPoints[2] = 500;
  enemyPoints[3] = 1000;
}

void draw(){
  
  //PANTALLA DE INICIO
  if(section == 0){
    time = millis() / 1000;
    
    background(0, 0, 0);
    imageMode(CENTER);
    rectMode(CENTER);
    textAlign(CENTER);
    image(doomLogo, 640, 200);
    image(violence, 640, 470, 960, 540);
    textSize(50);
    textFont(agencyFB);
    if(time % 2 == 0){
      text("P R E S S    E N T E R    T O    S T A R T", 640, 670);
    }
    if(keyPressed){
      if(key == ENTER){
        background(255, 255, 255);
        section = 3;
        life = 100;
        puntaje = 0;
      }
    }
  }
  if(section == 1){
    background(0, 0, 0);
    image(stage, 640, 360, 1280, 720);
    selectedGun = guns[gunNum];
    selectedRet = reticles[gunNum];
    /*-----------Making enemies--------------*/
    boolean tf = true;
    int cordX = 0;
    for(int i = 0; i < enemyState.length; i++){
      if(tf){
        if(enemyState[i] == 1){
          e = i;
          tf = false;
          if(posX[i] == 0){
            cordX = 320;
          }
          else if(posX[i] == 1){
            cordX = 640;
          }
          else{
            cordX = 960;
          }
        }
      }
    }
    /*--------end cycle-------------*/
    if(altList[enemyList[e]] < 680){
      if(e == 0){
        image(enemies[enemyList[e]], cordX, 360, ancList[enemyList[e]], altList[enemyList[e]]);
        ancList[enemyList[e]] = ancList[enemyList[e]] + 7;
        altList[enemyList[e]] = altList[enemyList[e]] + 7;
      }
      else if(e == 1){
        image(enemies[enemyList[e]], cordX, 360, ancList[enemyList[e]], altList[enemyList[e]]);
        ancList[enemyList[e]] = ancList[enemyList[e]] + 7;
        altList[enemyList[e]] = altList[enemyList[e]] + 7;
      }
      else if(e == 2){
        image(enemies[enemyList[e]], cordX, 360, ancList[enemyList[e]], altList[enemyList[e]]);
        ancList[enemyList[e]] = ancList[enemyList[e]] + 7;
        altList[enemyList[e]] = altList[enemyList[e]] + 7;
      }
      else{
        image(enemies[enemyList[e]], cordX, 360, ancList[enemyList[e]], altList[enemyList[e]]);
        ancList[enemyList[e]] = ancList[enemyList[e]] + 7;
        altList[enemyList[e]] = altList[enemyList[e]] + 7;
      }
    }
    else if(altList[enemyList[e]] >= 680){
      background(#FF0000);
      enemyState[e] = 0;
      ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
      altList[enemyList[e]] = altListGlobal[enemyList[e]];
      life = life - enemyHits[enemyList[e]];
    }
    
    if(port.available()>0){
      sensor=port.read();
      if(sensor == '1'){
        int px = 0;
      if(posX[e] == 0){
        px = 320;
      }
      else if(posX[e] == 1){
        px = 640;
      }
      else{
        px = 960;
      }
      distancia = dist(mouseX, mouseY, px, 360);
      if(gunAmo[gunNum] > 0 && section == 1){
        gunAmo[gunNum] = gunAmo[gunNum] - 1;
        if(gunNum == 0 && distancia < 300){
          if(enemyHits[enemyList[e]] <= 0){
            altList[enemyList[e]] = altListGlobal[enemyList[e]];
            ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
            enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
            puntaje = puntaje + enemyPoints[enemyList[e]];
            enemyState[e] = 0;
            print(ancList[0] +"     ");
            println(altList[0]);
          }
          else{
            enemyHits[enemyList[e]] = enemyHits[enemyList[e]] - 5;
          }
        }
        if(gunNum == 1 && distancia < 400){
          if(enemyHits[enemyList[e]] <= 0){
            altList[enemyList[e]] = altListGlobal[enemyList[e]];
            ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
            enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
            puntaje = puntaje + enemyPoints[enemyList[e]];
            enemyState[e] = 0;
            print(ancList[0] +"     ");
            println(altList[0]);
          }
          else{
            enemyHits[enemyList[e]] = enemyHits[enemyList[e]] - 10;
          }
        }
        if(gunNum == 2 && distancia < 1000){
          if(enemyHits[enemyList[e]] <= 0){
            altList[enemyList[e]] = altListGlobal[enemyList[e]];
            ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
            enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
            puntaje = puntaje + enemyPoints[enemyList[e]];
            enemyState[e] = 0;
            print(ancList[0] +"     ");
            println(altList[0]);
          }
          else{
            enemyHits[enemyList[e]] = enemyHits[enemyList[e]] - 2;
          }
        }
        if(gunNum == 3){
          background(255, 255, 255);
          altList[enemyList[e]] = altListGlobal[enemyList[e]];
          ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
          enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
          puntaje = puntaje + enemyPoints[enemyList[e]];
          enemyState[e] = 0;
          print(ancList[0] +"     ");
          println(altList[0]);
          
        }
      }
      }
      else if (sensor == '8'){
        gunNum = 0;
      }
      else if (sensor == '7'){
        gunNum = 1;
      }
      else if (sensor == '6'){
        gunNum = 2;
      }
      else if (sensor == '5'){
        gunNum = 3;
      }
    }
    
    if(life <= 0){
      section = 2;
      boolean rep = false;
      for(int i = 0; i < highScores.length; i++){
        if(!rep){
          if(highScores[i] == 0){
            highScores[i] = puntaje;
            rep = true;
          }
        }
      }
    }
    
    image(selectedGun, mouseX, 600);
    if(gunNum == 3){
      image(selectedRet, 640, 360);
    }
    else{
      image(selectedRet, mouseX, 400, 100, 100);
    }
    textSize(50);
    fill(#39ff14);
    text(gunNames[gunNum], 1150, 630);
    text("HEALTH", 150, 630);
    text("SCORE", 640, 630);
    textFont(DooM);
    text(life + "%", 150, 690);
    text(puntaje, 640, 690);
    textFont(agencyFB);
    textSize(25);
    if(gunAmo[gunNum] > 0){
      fill(#39ff14);
      text(gunAmo[gunNum] + "   /   " + allowedAmo[gunNum], 1120, 690);
    }
    else if(gunAmo[gunNum] == 0 && gunNames[gunNum] != "BFG"){
      fill(#FF0000);
      text("PRESS X TO REALOAD", 1150, 690);
    }
    else{
      fill(#FF0000);
      text("NO MORE BFG", 1150, 690);
    }
    
    if(keyPressed){
      if(key == 'a'){
          gunNum = 0;
          cool = coolDown[gunNum];
        }
        else if(key == 's'){
          gunNum = 1;
          cool = coolDown[gunNum];
        }
        else if(key == 'd'){
          gunNum = 2;
          cool = coolDown[gunNum];
        }
        else if(key == 'f'){
          gunNum = 3;
          cool = coolDown[gunNum];
        }
        else if(key == 'x' && gunAmo[gunNum] == 0 && gunNames[gunNum] != "BFG"){
          gunAmo[gunNum] = allowedAmo[gunNum];
        }
    }
    
  }
  
  if(section == 3){
    background(0, 0, 0);
    fill(#FF0000);
    textFont(DooM);
    text("TUTORIAL", 640, 100);
    int n = 200;
    for(int i = 0; i < guns.length; i++){
      image(guns[i], 100, n, 170, 140);
      textFont(agencyFB);
      textSize(30);
      fill(#39ff14);
      text(gunNames[i], 250, n);
      n = n + 140;
    }
    textSize(20);
      text("Close range weapon. Medium power shot.", 350, 250);
      text("Mid range weapon. Strong power shot.", 343, 390);
      text("Long range weapon. Weak shot. A lot of bullets", 360, 530);
      text("KILLS EVERYTHING ON SCREEN (only 5 shots in the entire run)", 400, 670);
      text("PRESS C TO CONTINUE", 900, 360);
      if(keyPressed){
      if(key == 'c'){
        section =1;
      }
    }
  }
  
  else if(section == 2){
    background(0, 0, 0);
    time = millis() / 1000;
    int a, b, t;
    for(a = 1; a < highScores.length; a++){
      for(b = highScores.length - 1; b >= a; b--){
        if(highScores[b - 1] > highScores[b]){
          t = highScores[b - 1];
          highScores[b - 1] = highScores[b];
          highScores[b] = t;
        }
      }
    }
    for(int i = 0; i < highScores.length / 2; i++){
      int temp = highScores[i];
      highScores[i] = highScores[highScores.length - i - 1];
      highScores[highScores.length - i - 1] = temp;
    }
    
    fill(#FF0000);
    textFont(DooM);
    text("GAME OVER", 640, 100);
    int n = 200;
    textSize(30);
    for(int i = 0; i < highScores.length; i++){
      fill(255, 255, 255);
      text((i + 1) + ".", 450, n);
      text(highScores[i], 600, n);
      n = n + 40;
      println(highScores[0]);
    }
    textFont(agencyFB);
    textSize(50);
    if(time % 2 == 0){
      text("P R E S S   E N T E R   T O   'M'   T O   M A I N   S C R E A N", 640, 670);
    }
    if(keyPressed){
      if(key == 'm'){
        background(255, 255, 255);
        section = 0;
      }
    }
  }
}
void mouseReleased(){
      int px = 0;
      if(posX[e] == 0){
        px = 320;
      }
      else if(posX[e] == 1){
        px = 640;
      }
      else{
        px = 960;
      }
      distancia = dist(mouseX, mouseY, px, 360);
      if(gunAmo[gunNum] > 0 && section == 1){
        gunAmo[gunNum] = gunAmo[gunNum] - 1;
        if(gunNum == 0 && distancia < 300){
          if(enemyHits[enemyList[e]] <= 0){
            altList[enemyList[e]] = altListGlobal[enemyList[e]];
            ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
            enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
            puntaje = puntaje + enemyPoints[enemyList[e]];
            enemyState[e] = 0;
            print(ancList[0] +"     ");
            println(altList[0]);
          }
          else{
            enemyHits[enemyList[e]] = enemyHits[enemyList[e]] - 5;
          }
        }
        if(gunNum == 1 && distancia < 400){
          if(enemyHits[enemyList[e]] <= 0){
            altList[enemyList[e]] = altListGlobal[enemyList[e]];
            ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
            enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
            puntaje = puntaje + enemyPoints[enemyList[e]];
            enemyState[e] = 0;
            print(ancList[0] +"     ");
            println(altList[0]);
          }
          else{
            enemyHits[enemyList[e]] = enemyHits[enemyList[e]] - 10;
          }
        }
        if(gunNum == 2 && distancia < 1000){
          if(enemyHits[enemyList[e]] <= 0){
            altList[enemyList[e]] = altListGlobal[enemyList[e]];
            ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
            enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
            puntaje = puntaje + enemyPoints[enemyList[e]];
            enemyState[e] = 0;
            print(ancList[0] +"     ");
            println(altList[0]);
          }
          else{
            enemyHits[enemyList[e]] = enemyHits[enemyList[e]] - 2;
          }
        }
        if(gunNum == 3){
          background(255, 255, 255);
          altList[enemyList[e]] = altListGlobal[enemyList[e]];
          ancList[enemyList[e]] = ancListGlobal[enemyList[e]];
          enemyHits[enemyList[e]] = enemyHitsGlobal[enemyList[e]];
          puntaje = puntaje + enemyPoints[enemyList[e]];
          enemyState[e] = 0;
          print(ancList[0] +"     ");
          println(altList[0]);
          
        }
      }
    }
