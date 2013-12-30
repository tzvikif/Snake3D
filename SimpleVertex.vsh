attribute vec4 gridFloor;
attribute vec2 texturePos;
uniform mat4 mvp;

void main(void) {
    mat4 temp = mvp;
    gl_Position =  mvp * gridFloor;
    
}