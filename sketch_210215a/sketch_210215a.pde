
final int N = 100;
final int MAX_TRIAL = 1000;

int[] nPetalsList;
Flower[] flowerList;

void setup() {
  size(800, 800);
  nPetalsList = new int[] {12, 16, 24};
  initFlowerList();
  noLoop();
}

void initFlowerList() {
  
  flowerList = new Flower[200];
  
  for (int k = 0; k < flowerList.length; k++) {
    int trial = 0;
    while (trial < MAX_TRIAL) {
      int n = nPetalsList[(int)random(nPetalsList.length)];
      float r = pow(random(4.0, 16.0), 2.0);
      
      float u = random(-width / 2.0, width / 2.0);
      float v = random(0, TWO_PI);
      float x = u * cos(v);
      float y = u * sin(v);
      
      color[] palette = selectPalette();
      Flower newFlower = new Flower(new PVector(x, y), n, r, 0, palette);
      
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
  scale(0.7);
  
  background(0, 0, 42);
  
  for (Flower flower : flowerList) {
    pushMatrix();
    flower.draw();
    popMatrix();
  }

  filter(BLUR, 0.8);
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
  color[] colors = {#DB2EB2, #23DBD8, #18DB69, #DB5002, #2CB3E6, #E6AF15, #375BE6, #E66743, #20E6AE};
  
  int idx1 = (int)(random(colors.length));
  int idx2 = -1;
  while (true) {
    idx2 = (int)(random(colors.length));
    if (idx1 != idx2) {
      break;
    }
  }
  return new color[] {colors[idx1], colors[idx2]};
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
    fill(palette[0], 220);
    
    drawPetals();
    
    noStroke();
    fill(palette[1], 220);
    
    pushMatrix();
    scale(0.75);
    rotate(TWO_PI / nPetals / 2.0);
    drawPetals();
    popMatrix();
  
    popMatrix();
  }
  
  void drawPetals() {
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
      
      if (d < (flower.getRadius() + newFlower.getRadius()) * 0.8) {
        return true;
      }
    }
  }
  return false;
}
