attribute vec3 coord3d;
uniform mat4 transform;
varying vec3 zcolor;

void main(void) {
    float z;
    gl_Position = transform * vec4(coord3d, 1);
    if (coord3d.z > 0.0 && coord3d.z < 0.3) {
        zcolor = vec3(1,0,0);

    }
    if (coord3d.z > 0.3 && coord3d.z < 0.6) {
        zcolor = vec3(0,1,0);
        
    }
    if (coord3d.z > 0.6) {
        zcolor = vec3(0,0,1);
        
    }
  
    //zcolor = vec3(coord3d.xy,coord3d.z);
    gl_PointSize = 1.0;
}