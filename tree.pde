class Tree{
  float x;
  float y;
  float len;
  float angle;
  float step;
  
  Tree(float x_, float y_, float len_, float angle_, float step_){
    this.x = x_;
    this.y = y_;
    this.len = len_;
    this.angle = angle_;
    this.step = step_;
  }
  
  void show(){
    push();
    translate(this.x, this.y);
    strokeWeight(this.len * 0.2);
    stroke(0);
    line(0, 0, 0, -this.len);
    translate(0, -this.len);
    drawBranches(this.len * this.step);
    pop();  
  }
  
  void drawBranches(float currentLen){
    if (currentLen > 2){
      push();
      rotate(-this.angle);
      strokeWeight(currentLen * 0.2);
      line(0, 0, 0, -currentLen);
      translate(0, -currentLen);
      drawBranches(currentLen * this.step);
      pop();
      
      push();
      rotate(this.angle);
      strokeWeight(currentLen * 0.2);
      line(0, 0, 0, -currentLen);
      translate(0, -currentLen);
      drawBranches(currentLen * this.step);
      pop();
    }
  }
}
