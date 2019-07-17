Particle [] particles = new Particle [50];

void setup() {
  size(1000, 1000);
  for (int i = 0; i < particles.length; i++) particles[i] = new Particle(random(0, 2), random(0, 2), color(random(255), 0, random(255)));
  background(255);
}
void draw() {
  pushStyle();
  fill(255, 50);
  if (frameCount%10==0) rect(0, 0, width, height);
  popStyle();
  fill(255);
  for (int i = 0; i < particles.length; i++) {    
    particles[i].applyallForces(particles, i);
    particles[i].update();
    particles[i].checklimit();
    particles[i].display();
  }
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(14);
  rect(width*.2,0,width*.6,40);
  fill(150);
  text("your mouse is the swarm leader", width*.5, 20);
}
