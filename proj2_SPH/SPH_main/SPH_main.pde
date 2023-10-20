import java.util.ArrayList;

class Node {
  Vec2 pos;
  Vec2 lastPos;
  Vec2 vel;
  float dens;
  float densN;
  float press;
  float pressN;


  Node(Vec2 pos) {
    this.pos = pos;
    lastPos = pos;
    this.vel = new Vec2(0, 0);
    dens=densN= 0;
  }
}

class Pair{
  int p1;  // index for p1;
  int p2;  // index for p1;
  float q;
  float q2;
  float q3;
  
}


//Simulation paramaters
static int maxParticles = 400;
Vec2 spherePos = new Vec2(300,350);
float sphereRadius = 60;
float r = 5;
float genRate = 20;
float COR = 0.7;
Vec2 gravity = new Vec2(0,1000);

int K_smoothR = 10;
float k_stiff = 5;
float k_resDensity = 10;
float k_stiffN = 5;

Node nodes[] = new Node[maxParticles];

int numParticles = 0;

void setup(){
  size(640,480);
  surface.setTitle("SPH");
  strokeWeight(2); //Draw thicker lines 


  
}

Vec2 obstacleVel = new Vec2(0,0);

// *********************************** Update
void update(float dt){
  float toGen_float = genRate * dt;
  int toGen = int(toGen_float);
  float fractPart = toGen_float - toGen;
  if (random(1) < fractPart) toGen += 1;
  for (int i = 0; i < toGen; i++){
    if (numParticles >= maxParticles) break;
    
    nodes[numParticles] = new Node(new Vec2(20+random(20),200+random(20)));
    nodes[numParticles].vel = new Vec2(30 + random(60), -190 - random(10)); 
    numParticles += 1;
  }

  // update pos, gravity, collision
  for (int i = 0; i <  numParticles; i++){
    nodes[i].vel = (nodes[i].pos.minus(nodes[i].lastPos)).times(1/dt);
    nodes[i].vel.add(gravity.times(dt));

    // colision with boundaries
    if (nodes[i].pos.y > height - r){
      nodes[i].pos.y = height - r;
      nodes[i].vel.y *= -COR;
    }
    if (nodes[i].pos.y < r){
      nodes[i].pos.y = r + 4;
      nodes[i].vel.y *= -COR;
    }
    if (nodes[i].pos.x > width - r){
      nodes[i].pos.x = width - r;
      nodes[i].vel.x *= -COR;
    }
    if (nodes[i].pos.x < r){
      nodes[i].pos.x = r;
      nodes[i].vel.x *= -COR;
    }
    
    // collision with sphere
    if (nodes[i].pos.distanceTo(spherePos) < (sphereRadius+r)){
      Vec2 normal = (nodes[i].pos.minus(spherePos)).normalized();
      nodes[i].pos = spherePos.plus(normal.times(sphereRadius+r).times(1.01));
      Vec2 velNormal = normal.times(dot(nodes[i].vel,normal));
      nodes[i].vel.subtract(velNormal.times(1 + COR));

    }

    nodes[i].lastPos = nodes[i].pos;
    nodes[i].pos.add(nodes[i].vel.times(dt));
    nodes[i].dens = 0;
    nodes[i].densN = 0;
  
  }
  // find nearby nodes in the K_smoothR
  // create pair
  ArrayList<Pair> pairs = new ArrayList<Pair>();
  for(int i = 0; i < numParticles; i++){
    for(int j = 0; j < numParticles; j++){
      if(i==j) continue;
      float dis = nodes[i].pos.distanceTo(nodes[j].pos);
      if( dis < K_smoothR){
         Pair p = new Pair();
         p.p1 = i;
         p.p2 = j;
         p.q = 1 - (dis / K_smoothR);
         p.q2 = p.q*p.q;
         p.q3 = p.q2*p.q;
         pairs.add(p);
      }
    }
  }

  // Accumulate per-particle density
  for(int i = 0; i < pairs.size(); i++){
    int p1 = pairs.get(i).p1;
    int p2 = pairs.get(i).p2;
    nodes[p1].dens += pairs.get(i).q2;
    nodes[p2].dens += pairs.get(i).q2;
    nodes[p1].densN += pairs.get(i).q3;
    nodes[p2].densN += pairs.get(i).q3;
  }

  // Computer per-particle pressure: stiffness*(density - rest_density)
  for(int i = 0; i < numParticles; i++){
    nodes[i].press = k_stiff * (nodes[i].dens - k_resDensity);
    nodes[i].pressN = k_stiffN * (nodes[i].densN);

    if(nodes[i].press > 30) nodes[i].press = 30;
    if(nodes[i].pressN > 300) nodes[i].press = 300;
  }

    for(int i = 0; i < pairs.size(); i++){
      int p1 = pairs.get(i).p1;
      int p2 = pairs.get(i).p2;
      float totalPressure = (nodes[p1].press + nodes[p2].press) * pairs.get(i).q + (nodes[p1].pressN + nodes[p2].pressN) * pairs.get(i).q2;
      float displace = totalPressure * dt * dt;
      nodes[p1].pos.add( nodes[p1].pos.minus(nodes[p2].pos).normalized() );
      nodes[p2].pos.add( nodes[p2].pos.minus(nodes[p1].pos).normalized() );      
    }

}

int substeps = 5;
void draw(){
  for(int i = 0; i < substeps; i ++){
    update(1.0/20/substeps);
  }

  
  background(255); //White background
  stroke(0,0,0);
  fill(20,20,240);
  for (int i = 0; i < numParticles; i++){
    circle(nodes[i].pos.x, nodes[i].pos.y, r*2); //(x, y, diameter)
  }
  
  fill(180,60,40);
  circle(spherePos.x, spherePos.y, sphereRadius*2); //(x, y, diameter)
}
