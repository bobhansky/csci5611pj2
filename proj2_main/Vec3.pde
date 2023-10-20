// by bob zhou

public class Vec3 {
  public float x, y, z;
  
  public Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public float length(){
    return sqrt(x*x+y*y+z*z);
  }
  
  public float lengthSqr(){
    return x*x+y*y+z*z;
  }
  
  // return a new var
  public Vec3 plus(Vec3 rhs){
    return new Vec3(x+rhs.x, y+rhs.y, z+rhs.z);
  }
  
  public void add(Vec3 rhs){
    x += rhs.x;
    y += rhs.y;
    z += rhs.z;
  }
  
    // return a new var
  public Vec3 minus(Vec3 rhs){
    return new Vec3(x-rhs.x, y-rhs.y, z-rhs.z);
  }
  
    // return a new var
  public Vec3 times(float rhs){
    return new Vec3(x*rhs, y*rhs, z*rhs);
  }
  
  public Vec3 normalized(){
    float magnitude = sqrt(x*x + y*y + z*z);
    return new Vec3(x/magnitude, y/magnitude, z/magnitude);
  }
  
  
   public float distanceTo(Vec3 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    float dz = rhs.z - z;
    return sqrt(dx*dx + dy*dy + dz*dz);
  }
}

float dot(Vec3 a, Vec3 b){
  return a.x*b.x + a.y*b.y + a.z*b.z;
}

Vec3 crossProduct(Vec3 v1, Vec3 v2){
  return new Vec3(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x);
}
