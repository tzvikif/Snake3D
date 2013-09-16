attribute vec3 coord3d;
uniform mat4 transform;
varying float zcoord;

void main(void) {
    float z;
    gl_Position = transform * vec4(coord3d, 1);
    zcoord = coord3d.z;
    //zcolor = vec3(coord3d.xy,coord3d.z);
    gl_PointSize = 1.0;
}