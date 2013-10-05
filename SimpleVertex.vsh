attribute vec4 gridFloor;

uniform mat4 mvp;

void main(void) {
    mat4 temp = mvp;
    gl_Position =  mvp * gridFloor;
    
}