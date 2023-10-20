class Node {
  Vec3 pos;
  Vec3 vel;
  float r;

  Node(Vec3 pos) {
    this.pos = pos;
    this.vel = new Vec3(0, 0, 0);
    r = 1;
  }
}

// const variables
Vec3 gravity = new Vec3(0, 10, 0);    // scale it for natrual res
int rowNum  = 15, colNum = 15;
Node nodes[][] = new Node[rowNum][colNum];
float k_s = 80;                        // scale it for natrual res
float k_v = 100;
float restLen = 2;
int substeps = 10;
Camera cam;

Vec3 SpherePos = new Vec3 (23,30,5);   // 23,30,24
float sphereRadius = 10;  // 10

void setup(){
  size(700, 700, P3D);
  surface.setTitle("Proj2");
  cam = new Camera();
      cam.position.x = -50.616463;
      cam.position.y = 16.24583;
      cam.position.z = 57.92675;
      cam.theta = -0.9624545;
      cam.phi = 0;
  
  //camera(40, 0, 100, 0, 0, 0, 0, 1, 0);

  nodes[0][0] = new Node(new Vec3(5,4,0));
  float rowDiff = 2;
  float colDiff = 2;
  for(int i = 0; i < rowNum; i++ ){
    for(int j = 0; j < colNum; j++){
        nodes[i][j] = new Node(new Vec3(5 + j*colDiff, 4 , rowDiff * i));

    }
  }
}

void draw(){
  background(255);
  fill(0, 255, 0);
  noStroke();
  directionalLight(255, 255, 255, 1, 1, -1);  // upper left specular
  directionalLight(255, 255, 255, -1, 1, 1);  // upper left specular
  cam.Update(1.0/frameRate);
  // println(cam.position.x);
  // println(cam.position.y);
  // println(cam.position.z);
  // println(cam.theta);
  // println(cam.phi);
  
  for(int i = 0; i < substeps; i++){
      update(1/frameRate/substeps);
     // exit();
  }
  

  for(int i = 0; i < rowNum; i++){
    for(int j = 0; j < colNum; j++){
      pushMatrix();
      translate(nodes[i][j].pos.x, nodes[i][j].pos.y, nodes[i][j].pos.z);
      sphere(nodes[i][j].r );
      popMatrix();
    }
  }
  
   pushMatrix();
   translate(SpherePos.x, SpherePos.y, SpherePos.z);
   fill(255, 200, 0);
   sphere(sphereRadius );
   popMatrix();
}


void update(float dt){

  
  Vec3 vn[][] = new Vec3[rowNum][colNum];
  for(int i = 0; i < rowNum; i++){
    for(int j = 0; j < colNum; j++){
      vn[i][j] = nodes[i][j].vel;
    }
  }
  
  // horizontal
  for(int i = 0; i < rowNum;i++){
    for(int j = 0; j < colNum-1; j++){
      Vec3 e = nodes[i][j+1].pos.minus(nodes[i][j].pos);
      float l = e.length();
      e = e.normalized();
      float v1 = dot(e, nodes[i][j].vel);
      float v2 = dot(e, nodes[i][j+1].vel);
      float force = -k_s * (restLen - l) - k_v*(v1-v2);
      vn[i][j].add(e.times(force*dt));
      vn[i][j+1] = vn[i][j+1].minus(e.times(force*dt));
    }
  }
  
  // vertical 
  for(int i = 0; i < rowNum-1;i++){
    for(int j = 0; j < colNum; j++){
      Vec3 e = nodes[i+1][j].pos.minus(nodes[i][j].pos);
      float l = e.length();
      e = e.normalized();
      float v1 = dot(e, nodes[i][j].vel);
      float v2 = dot(e, nodes[i+1][j].vel);
      float force = -k_s * (restLen - l) - k_v*(v1-v2);
      vn[i][j].add(e.times(force*dt));
      vn[i+1][j] = vn[i+1][j].minus(e.times(force*dt));
    }
  }


  // // / this direction
  // for(int i = 1; i < rowNum;i++){
  //   for(int j = 0; j < colNum - 1; j++){
  //     Vec3 e = nodes[i-1][j+1].pos.minus(nodes[i][j].pos);
  //     float l = e.length();
  //     e = e.normalized();
  //     float v1 = dot(e, nodes[i][j].vel);
  //     float v2 = dot(e, nodes[i-1][j+1].vel);
  //     float force = -k_s * (restLen - l) - k_v*(v1-v2);
  //     vn[i][j].add(e.times(force*dt));
  //     vn[i-1][j+1] = vn[i-1][j+1].minus(e.times(force*dt));
  //   }
  // }

  // // \ direction
  // for(int i = 1; i < rowNum;i++){
  //   for(int j = 1; j < colNum; j++){
  //     Vec3 e = nodes[i-1][j-1].pos.minus(nodes[i][j].pos);
  //     float l = e.length();
  //     e = e.normalized();
  //     float v1 = dot(e, nodes[i][j].vel);
  //     float v2 = dot(e, nodes[i-1][j-1].vel);
  //     float force = -k_s * (restLen - l) - k_v*(v1-v2);
  //     vn[i][j].add(e.times(force*dt));
  //     vn[i-1][j-1] = vn[i-1][j-1].minus(e.times(force*dt));
  //   }
  // }
  
  for(int i = 0; i < rowNum; i++){
    for(int j = 0; j < colNum; j++)
        // add gravity
      vn[i][j].add(gravity.times(dt));
  }
  
  // fix top row
  for(int i = 0; i < colNum; i++)
    vn[0][i] = new Vec3(0,0,0);
  
  for(int i = 0; i < rowNum; i++){
    for(int j = 0; j < colNum; j++){
      nodes[i][j].vel = vn[i][j];    // update vel
      nodes[i][j].pos.add( nodes[i][j].vel.times(dt));

      // colission with sphere
      if (nodes[i][j].pos.distanceTo(SpherePos) <= nodes[i][j].r + sphereRadius){
        Vec3 normal = nodes[i][j].pos.minus(SpherePos);
        normal = normal.normalized();
        nodes[i][j].pos = SpherePos.plus(normal.times(nodes[i][j].r + sphereRadius));
        Vec3 velNormal = normal.times(dot(nodes[i][j].vel, normal));
        nodes[i][j].vel = nodes[i][j].vel.minus(velNormal.times(1 + 0.1));
      }
      
     // colission with other nodes
     for(int k = 0; k < rowNum; k++){
      for(int h = 0; h < colNum; h++){
        if(k == i && j == h) continue;
        // colission with sphere
        if (nodes[i][j].pos.distanceTo(nodes[k][h].pos) <= nodes[i][j].r * 2){
          Vec3 normal = nodes[i][j].pos.minus(nodes[k][h].pos);
          normal = normal.normalized();
          nodes[i][j].pos = nodes[k][h].pos.plus(normal.times(nodes[i][j].r * 2.01));
          nodes[k][h].pos = nodes[i][j].pos.plus(normal.times(-nodes[i][j].r * 2.01));
          Vec3 velNormal = normal.times(dot(nodes[i][j].vel, normal));
          nodes[i][j].vel = nodes[i][j].vel.minus(velNormal.times(1 + 0.1));
        }
        
      }
     }  
     
    }
  }
      
    
  

  /*
  
  Node firstRow[]  = new Node[colNum];
  for(int i = 0; i < colNum; i++){
    firstRow[i] = nodes[0][i];
  }
  
  for(int i = 1; i < rowNum; i++){
    for(int j = 0; j < colNum; j++){
      
      //  1: vertical_UP    
      float stringLen1 = nodes[i][j].pos.distanceTo(nodes[i-1][j].pos);
      float stringF1 = -k_s * (stringLen1 - restLen);
      Vec3 string_dir1 = nodes[i][j].pos.minus(nodes[i-1][j].pos);
      string_dir1 = string_dir1.normalized();
      Vec3 stringFVec1 = string_dir1.times(stringF1);
      Vec3 dampF1 = nodes[i][j].vel.minus(nodes[i-1][j].vel).times(-k_v);
      Vec3 force1 = stringFVec1.plus(dampF1);

      // 2. right
      float stringLen2 = 0;
      if(j+1 < colNum) stringLen2 = nodes[i][j].pos.distanceTo(nodes[i][j+1].pos);
      float stringF2 =  0 ;
      if(j+1 < colNum) stringF2 = -k_s * (stringLen2 - restLen);
      Vec3 string_dir2 = new Vec3(0,0,0);
      if(j+1 < colNum){
        string_dir2 = nodes[i][j].pos.minus(nodes[i][j+1].pos);
        string_dir2 = string_dir2.normalized();
      }
      Vec3 stringFVec2 = string_dir2.times(stringF2);
      Vec3 dampF2 = new Vec3(0,0,0);
      if(j+1 < colNum) dampF2 = nodes[i][j].vel.minus(nodes[i][j+1].vel).times(-k_v);
      Vec3 force2 = stringFVec2.plus(dampF2);

      // 3. left
      float stringLen3 = 0;
      if(j-1 >= 0) stringLen3 = nodes[i][j].pos.distanceTo(nodes[i][j-1].pos);
      float stringF3 = 0;
      if(j-1 >= 0) stringF3 = -k_s * (stringLen3 - restLen);
      Vec3 string_dir3 = new Vec3(0,0,0);
      if(j-1 >= 0) {
        string_dir3 = nodes[i][j].pos.minus(nodes[i][j-1].pos);
        string_dir3 = string_dir3.normalized();
      }
      Vec3 stringFVec3 = string_dir3.times(stringF3);
      Vec3 dampF3 = new Vec3(0,0,0);
      if(j-1 >= 0) dampF3 = nodes[i][j].vel.minus(nodes[i][j-1].vel).times(-k_v);
      Vec3 force3 = stringFVec3.plus(dampF3);

      // 4. down
      float stringLen4 = 0;
      if(i+1 < rowNum) stringLen4 = nodes[i][j].pos.distanceTo(nodes[i+1][j].pos);
      float stringF4 = 0;
      if(i+1 < rowNum) stringF4 = -k_s * (stringLen4 - restLen);
      Vec3 string_dir4 = new Vec3(0,0,0);
      if(i+1 < rowNum) {
        string_dir4 = nodes[i][j].pos.minus(nodes[i+1][j].pos);
        string_dir4 = string_dir4.normalized();
      }
      Vec3 stringFVec4 = string_dir4.times(stringF4);
      Vec3 dampF4 = new Vec3(0,0,0);
      if(i+1 < rowNum) dampF4 = nodes[i][j].vel.minus(nodes[i+1][j].vel).times(-k_v);
      Vec3 force4 = stringFVec4.plus(dampF4);

      // 5. upper right 
      


      Vec3 force = new Vec3(0,0,0);
      force.add(force1);
      force.add(force2);
      force.add(force3);
      force.add(force4);
      
      nodes[i][j].vel.add(force.times(dt));    // a = F/m 
      nodes[i][j].vel.add(gravity.times(dt));

      // colission with big Sphere
      if (nodes[i][j].pos.distanceTo(SpherePos) <= nodes[i][j].r + sphereRadius){
        Vec3 normal = nodes[i][j].pos.minus(SpherePos);
        normal = normal.normalized();
        nodes[i][j].pos = SpherePos.plus(normal.times(nodes[i][j].r + sphereRadius));
      }
      
      nodes[i][j].pos.x += nodes[i][j].vel.x * dt;
      nodes[i][j].pos.y += nodes[i][j].vel.y * dt;
      nodes[i][j].pos.z += nodes[i][j].vel.z * dt;
    }
  }
  
  
  // fix first row
  for(int i = 0; i < colNum; i++){
    nodes[0][i]= firstRow[i];
  }

  */
  
  
}

void keyPressed()
{
  cam.HandleKeyPressed();
}

void keyReleased()
{
  cam.HandleKeyReleased();
}
