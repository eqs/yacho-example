import java.util.Arrays;
import java.util.Comparator;

TreeNode tree;
boolean recording = false;

void setup() {
  size(800, 800);
  
  frameRate(30);
  
  tree = new TreeNode(new UFO(randomPalette()));
  buildTree(tree, 0);
}

void draw() {
  background(10, 10, 64);
  tree.draw();
  
  if (recording) {
    saveFrame("frames/#####.png");
  }
}

color[] randomPalette() {
  color[][] palettes = new color[][] {
    {color(#16C5F5), color(#F52F6E), color(#F5E52F)},
    {color(#18F569), color(#9A32F5), color(#F5B249)},
    {color(#B7F52F), color(#2F73F5), color(#F53816)},
  };
  
  int k = (int)random(palettes.length);
  return palettes[k];
}

void buildTree(TreeNode t, int depth) {
  
  if (depth != 0 && (random(10) < 3 || t.getLevel() >= 3)) {
    t.addChild(new UFO(randomPalette()));
    return;
  }
  
  int[] counts = {4, 9};
  int n = counts[(int)random(counts.length)];
  for (int k = 0; k < n; k++) {
    TreeNode child = t.addChild(new UFO(randomPalette()));
    buildTree(child, depth + 1);
  }
}

void mousePressed() {
  tree = new TreeNode(new UFO(randomPalette()));
  buildTree(tree, 0);
  redraw();
}

static final String timestamp(final String name, final String ext) {
 return name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
   "-" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}

void keyReleased() {
  // saveFrame(String.format("frames/%s", timestamp("Project", ".png")));
  recording = !recording;
}
