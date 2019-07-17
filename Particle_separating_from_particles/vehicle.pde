class Particle {
  PVector pos, vel, acc;
  float desiredseparation, desiredcohesion, maxf, maxv;
  color ran;
  Particle(float x, float y,color r) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);  
    acc = new PVector(0, 0);    
    maxv = 3;
    maxf = 0.2;   
    desiredseparation=25;
    desiredcohesion=160;
    ran=r;
  }
  PVector seek (PVector target) {
    PVector desiredSeek = PVector.sub(target, pos);
    desiredSeek.setMag(maxv);
    PVector seekForce=PVector.sub(desiredSeek, vel);
    seekForce.limit(maxf);
    return seekForce;
  }
  PVector followlider (Particle [] p, PVector target) {
    PVector localFitness =  PVector.sub(target,pos);
    PVector bestFitness = localFitness;
    for (int i=0;i<p.length; i++) {
      PVector nFitness = PVector.sub(target,p[i].pos);
      if (nFitness.mag()<bestFitness.mag()) bestFitness = nFitness;
    }
    bestFitness.setMag(maxv);
    PVector seekForce=PVector.sub(bestFitness, vel);
    seekForce.limit(maxf);
    return seekForce;
  }
  PVector allign (Particle [] p, int me) {
    PVector desiredAllign = new PVector(0, 0);
    PVector allignForce= new PVector(0, 0);
    int count = 0;
    for (int i=0; i<p.length; i++)   if (i!=me && (PVector.dist(pos, p[i].pos) < desiredseparation)) { 
      desiredAllign.add(p[i].vel);
      count ++;
    }
    if (count > 0) {
      desiredAllign.div(count);
      desiredAllign.setMag(maxv);
      allignForce = PVector.sub(desiredAllign, vel);
      allignForce.limit(maxf);
      return allignForce;
    } else return new PVector(0, 0);
  }
  PVector separate (Particle [] p, int me) {
    PVector sepaForce = new PVector(0, 0);
    int count = 0;
    for (int i=0; i<p.length; i++)   if (i!=me && (PVector.dist(pos, p[i].pos) < desiredseparation)) {  
      PVector desiredSep = PVector.sub(pos, p[i].pos);
      desiredSep.normalize();
      desiredSep.div(PVector.dist(pos, p[i].pos));        
      sepaForce.add(desiredSep);
      count++;
    }
    if (count > 0) {
      sepaForce.div(count);
      sepaForce.setMag(maxv);
      sepaForce.sub(vel);         // Implement Reynolds: Steering = Desired - Velocity
      sepaForce.limit(maxf);
    }
    return sepaForce;
  }
  PVector cohesion (Particle [] p, int me) {
    PVector coheForce = new PVector(0, 0);   
    int count = 0;
    for (int i=0; i<p.length; i++)   if (i!=me && (PVector.dist(pos, p[i].pos) < desiredcohesion)) {
      coheForce.add(p[i].pos); // Add position
      count++;
    }
    if (count > 0) {
      coheForce.div(count);
      return seek(coheForce);
    } else return new PVector(0, 0);
  }
  void applyForce(PVector force) {  
    acc.add(force);
  }
  void applyallForces(Particle[]p, int me) {
    PVector f1 = seek(new PVector(mouseX, mouseY));
    PVector f2 = separate (p, me);
    PVector f3 = cohesion (p, me);
    f1.mult(.2);
    f2.mult(2);
    f3.mult(1);
    applyForce(f1);
    applyForce(f2);
  }
  void update() { 
    vel.add(acc);   
    vel.limit(maxv);
    pos.add(vel);   
    acc.mult(0);
  }
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    fill(ran);
    ellipse(0, 0, 2, 2);
    popMatrix();
  }
  void checklimit() {
    if (pos.x<0||pos.x>width||pos.y<0||pos.y>height) {
      vel.x=-vel.x;
      vel.y=-vel.y;
    }
  }
}
