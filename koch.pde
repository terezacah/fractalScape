// Inspired by tutorial by Daniel Shiffman: https://www.youtube.com/watch?v=X8bXDKqMsXE&t=1001s

class Koch{
  ArrayList<Segment> segments = new ArrayList<Segment>();
  
  Koch(float xPos_, float yPos_, float len_, float detail_, int modif_){
    PVector a = new PVector(xPos_, yPos_);
    PVector b = new PVector(xPos_ + len_ * modif_, yPos_ + (len_ * sqrt(3)));
    PVector c = new PVector(xPos_ - len_ * modif_, yPos_ + (len_ * sqrt(3)));
    
    segments.add(new Segment(a, b));
    segments.add(new Segment(b, c));
    segments.add(new Segment(c, a));
    
    for (int i = 0; i < detail_; i++){
      ArrayList<Segment> nextGen = new ArrayList<Segment>();
      for (Segment s : segments){
        ArrayList<Segment> children = s.generate();
        nextGen.addAll(children);
      }
      segments = nextGen;
    } 
  }
  
  void show(){
    stroke(255, 80);
    fill(255, 80);
    beginShape();
    for (Segment s : this.segments){
      vertex(s.a.x, s.a.y);
      vertex(s.b.x, s.b.y);
    }
    endShape(CLOSE);
  }
}

class Segment{
  PVector a;
  PVector b;
  
  Segment(PVector a_, PVector b_){
    this.a = a_.copy();
    this.b = b_.copy();
  }
  
  ArrayList<Segment> generate(){
    ArrayList<Segment> children = new ArrayList<Segment>();
    
    PVector v = PVector.sub(this.b, this.a);
    v.div(3);
    
    PVector b1 = PVector.add(this.a, v);
    PVector a1 = PVector.sub(this.b, v);
    
    v.rotate(-PI/3);
    PVector c = PVector.add(b1, v);
    
    children.add(new Segment(this.a, b1));
    children.add(new Segment(b1, c));
    children.add(new Segment(c, a1));
    children.add(new Segment(a1, this.b));
    
    return children;
  }
}
