
int N_SEPARATION = 2;

int[] di;
int[] dj;

color[][] dicePalettes;

void setup() {
  size(800, 800);
  
  dicePalettes = new color[][] {
    {color(0, 255, 0), color(0, 255, 0), color(0, 255, 0)},
  };
  
  init();
  noLoop();
}

void draw() {
  background(0);
  drawPattern();
  // filter(BLUR, 0.8);
}

void init() {
  // 上下左右のずれの系列をつくる
  // i: [-1, -1, 1, 1]
  // j: [-1, 1, -1, 1]
  di = new int[N_SEPARATION*N_SEPARATION];
  dj = new int[N_SEPARATION*N_SEPARATION];
  for (int i = 0; i < N_SEPARATION; i++) {
    for (int j = 0; j < N_SEPARATION; j++) {
      di[j + i * N_SEPARATION] = i;
      dj[j + i * N_SEPARATION] = j;
    }
  }
  
  // 中心化
  for (int k = 0; k < di.length; k++) {
    di[k] = di[k] - N_SEPARATION / 2;
    dj[k] = dj[k] - N_SEPARATION / 2;
  }
}

void drawPattern() {
  float sf = random(1.5, 2.0);
  float rot = TWO_PI / (int)random(1, 13);
  
  translate(width / 2.0, height / 2.0);
  scale(sf, sf);
  rotate(rot);
  
  recur(new PVector(0.0, 0.0), width, 0);
}

void recur(PVector p, float s, int d) {
  if ((d >= 1 && random(1) < d / 4.0) || d > 2) {
    pushMatrix();
    float rot = HALF_PI * (int)random(0, 3);
    translate(p.x, p.y);
    rotate(rot);
    scale(s / (float)width, s / (float)height);
    
    strokeWeight(0.5 * (float)width / s);
    drawDice((int)random(6)+1, dicePalettes[(int)random(dicePalettes.length)]);
    
    popMatrix();
  } else {
    float stepSize = s / (float)N_SEPARATION;
    for (int k = 0; k < N_SEPARATION*N_SEPARATION; k++) {
      PVector cp = new PVector(
        p.x + stepSize * dj[k] + (N_SEPARATION % 2 == 0 ? stepSize / 2.0 : 0),
        p.y + stepSize * di[k] + (N_SEPARATION % 2 == 0 ? stepSize / 2.0 : 0)
      );
      recur(cp, s / (float)N_SEPARATION, d + 1);
    }
  }
}

void drawDice(int number, color[] dicePalette) {
  int N = 100;
  float r = width / 8.0;
  
  stroke(dicePalette[0]);
  noFill();
  
  beginShape();
  for (int k = 0; k < N; k++) {
    float t = TWO_PI * k / (float)N;
    float x = r * cos(t);
    float y = r * sin(t);
    
    if (t < PI / 2.0) {
      x = x + (width / 2.0 - r);
      y = y + (height / 2.0 - r);
    } else if (t < PI) {
      x = x - (width / 2.0 - r);
      y = y + (height / 2.0 - r);
    } else if (t < PI * 3 / 2) {
      x = x - (width / 2.0 - r);
      y = y - (height / 2.0 - r);
    } else {
      x = x + (width / 2.0 - r);
      y = y - (height / 2.0 - r);
    }
    
    vertex(x, y);
  }
  endShape(CLOSE);
  
  if (number == 1) {
    stroke(dicePalette[2]);
    circle(0, 0, width / 4.0);
  } else if (number == 2) {
    stroke(dicePalette[1]);
    circle(width / 3.0, height / 3.0, width / 5.0);
    circle(-width / 3.0, -height / 3.0, width / 5.0);
  } else if (number == 3) {
    stroke(dicePalette[1]);
    circle(width / 3.0, height / 3.0, width / 5.0);
    circle(0.0, 0.0, width / 5.0);
    circle(-width / 3.0, -height / 3.0, width / 5.0);
  } else if (number == 4) {
    stroke(dicePalette[1]);
    circle(width / 3.0, height / 3.0, width / 5.0);
    circle(-width / 3.0, height / 3.0, width / 5.0);
    circle(width / 3.0, -height / 3.0, width / 5.0);
    circle(-width / 3.0, -height / 3.0, width / 5.0);
  } else if (number == 5) {
    stroke(dicePalette[1]);
    circle(0.0, 0.0, width / 5.0);
    circle(width / 3.0, height / 3.0, width / 5.0);
    circle(-width / 3.0, height / 3.0, width / 5.0);
    circle(width / 3.0, -height / 3.0, width / 5.0);
    circle(-width / 3.0, -height / 3.0, width / 5.0);
  } else if (number == 6) {
    stroke(dicePalette[1]);
    circle(width / 3.0, 0.0, width / 5.0);
    circle(-width / 3.0, 0.0, width / 5.0);
    circle(width / 3.0, height / 3.0, width / 5.0);
    circle(-width / 3.0, height / 3.0, width / 5.0);
    circle(width / 3.0, -height / 3.0, width / 5.0);
    circle(-width / 3.0, -height / 3.0, width / 5.0);
  }
}

static final String timestamp(final String name, final String ext) {
 return name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
   "-" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}

void mouseReleased() {
  N_SEPARATION = (int)random(2, 5);
  init();
  redraw();
}

void keyReleased() {
  saveFrame(String.format("frames/%s", timestamp("Project", ".png")));
}
