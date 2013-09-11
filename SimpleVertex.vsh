attribute vec3 coord3d;
uniform mat4 transform;
varying vec3 zcolor;

void main(void) {
    gl_Position = transform * vec4(coord3d.xy, 0, 1);
    zcolor = vec3(coord3d.xy,coord3d.z);
}