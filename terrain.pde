Tree tree;

class Terrain {
  float xOff = 0;
  float yOff = 0;
  float xStep = width * 0.2;
  float yEnd = 0;
  
  void show(){
    yPos = height * 0.33;    
    while (yPos < height * 1.2) {
      translate(0, yPos);
      terrain.drawSegment();
      yPos += 0.8;
      resetMatrix();
    }
  }
  
  void drawSegment() {    
    push();
    beginShape();
    noiseSeed(noiseSeedValue);
    
    this.xOff = 0;
    vertex(0, map(noise(this.xOff, this.yOff), 0, 1, -height * 0.2, height * 0.2));
    this.xStep = map(yPos, 0, height, hilliness, hilliness + 20);
    
    for (float x = 0; x < width; x += this.xStep) {
      float y = map(noise(this.xOff, this.yOff), 0, 1, -height * 0.2, height * 0.2);
      vertex(x, y);
      
      if(shouldDrawTree(x, y) && yPos <= height){
        tree = new Tree(x, y, map(yPos, 0, height, 7, 45), 0.3, 0.7);
        tree.show();
      }
      this.xOff += 0.05;
      this.yEnd = y;
    }
    this.yOff += detail * 0.01;
    
    vertex(width, this.yEnd);
    vertex(width, height);
    vertex(0, height);
    
    stroke(0, 64, 0, 128);
    strokeWeight(random(2));

    fill(terrainColor, 200, 160, 150);
    
    endShape(CLOSE);
    pop();
  }
  
  boolean shouldDrawTree(float x, float y){
    return (x != 0 && y != 0 && (x*y) % treeFreq == 0);
  }
}
