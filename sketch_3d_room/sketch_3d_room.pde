//Jennifer Tsai
//3D Room
//Jan 19, 2022

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle;

//robot
import java.awt.Robot;
Robot rbt;
boolean skipFrame;

//colour pallette
color white = #FFFFFF; //empty space 
color black = #000000; //diamond
color blue = #7092BE; //nether

//map variables
int gridSize;
PImage map;

//textured cubes
PImage diamond;
PImage NetherPortal;   
PImage Obsedian;

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  upX = 0;
  upY = 1;
  upZ = 0;
  leftRightHeadAngle = radians(270);
  //noCursor();

  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;

  //map
  map = loadImage("map.png");
  gridSize = 100;

  //textured cube
  diamond = loadImage("diamond.png");
  NetherPortal = loadImage("NetherPortal.jpg");
  Obsedian = loadImage("CryingObsidian.png");
}

void draw() {
  background(0);
  pointLight(45, 125, 250, eyeX, eyeY, eyeZ);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  drawFloor(-2000, 2000, height, 100);
  drawFloor(-2000, 2000, height-gridSize*4, 100);
  drawFocalPoint();
  controlCamera();
  drawMap();
  
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == blue) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, diamond, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, diamond, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, diamond, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, NetherPortal, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, NetherPortal, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, NetherPortal, gridSize);
      }
    }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}


void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, Obsedian, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}

void controlCamera() {
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) { 
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX + cos(leftRightHeadAngle + PI/2)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX + cos(leftRightHeadAngle - PI/2)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle - PI/2)*10;
  }
 
  if (skipFrame == false) {
  leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
  upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  
  if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = false;
  } else if (mouseX > width-2) {
    rbt.mouseMove(2, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
} 

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
