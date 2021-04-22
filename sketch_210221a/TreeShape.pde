
// http://blawat2015.no-ip.com/~mieki256/diary/201603202.html
final Comparator<PVector> comp = new Comparator<PVector>() {
  int compare(PVector v1, PVector v2) {
    if (v1.z > v2.z) return 1;
    else if (v1.z == v2.z) return 0;
    return -1;
  }
};

abstract class AbstractShape {
  abstract void draw();
}

class Circle extends AbstractShape {
  void draw() {
    rect(0, 0, width, height);
    translate(width / 2.0, height / 2.0);
    ellipse(0, 0, width, height);
  }
}

class UFO extends AbstractShape {
  
  color[] palette;
  float angularVelocity = TWO_PI;

  UFO(color[] palette) {
    this(palette, TWO_PI*random(1.0, 2.0)*(random(1) > 0.5 ? 1.0 : -1.0));
  }
  
  UFO(color[] palette, float angularVelocity) {
    this.palette = palette;
    this.angularVelocity = angularVelocity;
  }
  
  void draw() {
    float s = 0.6;
    int nCircles = 6;
    
    float w = width;
    float h = height;
    
    // noStroke();
    rectMode(CENTER);
    
    translate(width / 2.0, height / 2.0);
    strokeWeight(0.8);
    
    fill(palette[0]);
    arc(0, 0, w*s, h*s, PI, TWO_PI);
    
    PVector[] points = new PVector[nCircles];
    float circleWidth = w / 3.0;
    float angleInterval = TWO_PI / nCircles;
    for (int k = 0; k < nCircles; k++) {
      float phi = angleInterval * k;
      float t = frameCount / 60.0 / TWO_PI;
      float cx = (w / 2.0 - circleWidth / 2.0) * cos(t * angularVelocity + phi);
      float cz = sin(t * angularVelocity + phi);
      points[k] = new PVector(cx, 0, cz);
    }
    
    fill(palette[2]);
    Arrays.sort(points, comp);
    for (int k = 0; k < nCircles; k++) {
      float cx = points[k].x;
      arc(cx, h / 4.0, circleWidth, circleWidth, 0, PI);
    }
    
    fill(palette[1]);
    beginShape();
    vertex(w/2.0*s, 0);
    vertex(w/2.0, h/4.0);
    vertex(-w/2.0, h/4.0);
    vertex(-w/2.0*s, 0);
    endShape(CLOSE);
  }
}
