
final int N = 100;
final int MAX_TRIAL = 1000;

int[] nPetalsList;
Flower[] flowerList;

void setup() {
  size(800, 800);
  nPetalsList = new int[] {8, 10, 12, 16};
  initFlowerList();
  noLoop();
}

void initFlowerList() {
  
  flowerList = new Flower[200];
  
  for (int k = 0; k < flowerList.length; k++) {
    int trial = 0;
    while (trial < MAX_TRIAL) {
      int n = nPetalsList[(int)random(nPetalsList.length)];
      float r = random(8.0, 128.0);
      float x = random(-width / 2.0, width / 2.0);
      float y = random(-height / 2.0, height / 2.0);
      
      color[] palette = selectPalette();
      Flower newFlower = new Flower(new PVector(x, y), n, r, r / 2.0 , palette);
      
      if (!intersects(flowerList, newFlower)) {
        flowerList[k] = newFlower;
        break;
      }
      
      trial++;
    }
    
    if (trial == MAX_TRIAL) {
      flowerList[k] = new Flower(new PVector(0.0, 0.0), 0, -1.0, -1.0, null);
    }
  }
}

void draw() {
  translate(width / 2.0, height / 2.0);
  
  background(0);
  
  for (Flower flower : flowerList) {
    pushMatrix();
    flower.draw();
    popMatrix();
  }

  filter(BLUR, 0.7);
}

void mousePressed() {
  initFlowerList();
  redraw();
}

void keyReleased() {
  saveFrame(String.format("frames/%s", timestamp("Project", ".png")));
}

static final String timestamp(final String name, final String ext) {
  return name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
    "-" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}

color[] selectPalette() {
   color[][] palettes = new color[][] {
     {color(255, 0, 255), color(255, 255, 0)},
     {color(0x5B, 0x55, 0xDC), color(0xFA, 0xEB, 0x5B)},
     {color(0x48, 0x74, 0xCE), color(0xF8, 0xBA, 0x69)},
     {color(0x00, 0x72, 0xC2), color(0xFF, 0xAA, 0x1C)},
     {color(0xA6, 0x37, 0xEA), color(0xFF, 0xEA, 0x01)},
     {color(0x4E, 0xB7, 0xD9), color(0xFF, 0xCB, 0x4F)},
   };
   return palettes[(int)random(palettes.length)];
}
class Flower {
  int nPetals;
  PVector pos;
  float r;
  float petalRadius;
  color[] palette;
  Flower(PVector pos, int nPetals, float r, float petalRadius, color[] palette) {
    this.pos = pos;
    this.nPetals = nPetals;
    this.r = r;
    this.petalRadius = petalRadius;
    this.palette = palette;
  }
  
  void draw() {
    if (this.r < 0.0) {
      return;
    }
    
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    
    noStroke();
    fill(palette[0]);
    
    for (int n = 0; n < nPetals; n++) {
      pushMatrix();
      float s = TWO_PI / nPetals * n + TWO_PI / nPetals / 2.0;
      translate(petalRadius * cos(s), petalRadius * sin(s));
      beginShape();
      for (int k = 0; k < N; k++) {
        float t = (TWO_PI / nPetals * k / N) + (TWO_PI / nPetals * n);
        float r = this.r * pow(sin(t * (nPetals / 2.0)), 2.0);
        float x = r * cos(t);
        float y = r * sin(t);
        
        vertex(x, y);
      }
      endShape(CLOSE);
      popMatrix();
    }
    
    noStroke();
    fill(palette[1]);
    circle(0, 0, petalRadius);
  
    popMatrix();
  }
  
  float getRadius() {
    return this.r + this.petalRadius;
  }
}

boolean intersects(Flower[] flowers, Flower newFlower) {
  for (Flower flower : flowers) {
    if (flower != null) {
      PVector diffVec = PVector.sub(flower.pos, newFlower.pos);
      float d = diffVec.mag();
      
      if (d < flower.getRadius() + newFlower.getRadius()) {
        return true;
      }
    }
  }
  return false;
}
