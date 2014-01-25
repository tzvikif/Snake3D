attribute vec4 pos;
attribute vec2 textureCoord;
varying vec2 textureCoordOut;
uniform mat4 mvp;

void main(void) {
    textureCoordOut = textureCoord;
    gl_Position =  mvp * pos;
    
}