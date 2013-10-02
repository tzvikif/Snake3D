attribute vec4 gridFloor;
attribute vec3 color;
varying vec3 f_color;
uniform mat4 mvp;

void main(void) {
    mat4 temp = mvp;
    gl_Position =  mvp * gridFloor;
    f_color = color;
    
}