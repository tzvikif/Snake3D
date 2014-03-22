attribute vec4 pos;
attribute vec2 textureCoord;
varying vec2 textureCoordOut;
attribute vec3 color;
varying vec3 colorOut;
uniform mat4 mvp;

void main(void) {
    textureCoordOut = textureCoord;
    colorOut = color;
    gl_Position =  mvp * pos;
    
}