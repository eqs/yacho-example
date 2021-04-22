// https://stackoverflow.com/questions/3522454/how-to-implement-a-tree-data-structure-in-java
// https://github.com/gt4dev/yet-another-tree-structure
class TreeNode<T extends AbstractShape> {
  
  final int MAX_N = 8;
  int N = 1;
  
  T data;
  TreeNode<T> parent;
  ArrayList<TreeNode<T>> children;

  TreeNode(T data) {
      this.data = data;
      this.children = new ArrayList<TreeNode<T>>();
  }
  
  private int findMinimumSquare(int n) {
    for (int k = 1; k <= MAX_N; k++) {
      if (n <= k * k) {
        return k;
      }
    }
    return MAX_N;
  }

  TreeNode<T> addChild(T child) {
      TreeNode<T> childNode = new TreeNode<T>(child);
      childNode.parent = this;
      this.children.add(childNode);
      this.N = findMinimumSquare(this.children.size());
      return childNode;
  }
  
  boolean isRoot() {
    return parent == null;
  }
  
  boolean isLeaf() {
    return children.size() == 0;
  }
  
  int getLevel() {
    if (this.isRoot()) {
      return 0;
    } else {
      return parent.getLevel() + 1;
    }
  }
  
  void draw() {
    if (isLeaf()) {
      data.draw();
    } else {
      for (int k = 0; k < children.size(); k++) {
        int i = k % N;
        int j = k / N;
        pushMatrix();
        translate(width / (float)N * j , height / (float)N * i);
        scale(1.0 / N);
        children.get(k).draw();
        popMatrix();
      }
    }
  }
}
