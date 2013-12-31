attribute vec4 gridFloor;
attribute vec2 textureCoord;
varying vec2 textureCoordOut;
uniform mat4 mvp;

void main(void) {
    mat4 temp = mvp;
    textureCoordOut = textureCoord;
    gl_Position =  mvp * gridFloor;
    
}