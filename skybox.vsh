attribute vec4 pos;
attribute vec3 color;
varying vec3 colorOut;
attribute vec3 textureCoord;
varying vec3 textureCoordOut;
uniform mat4 mvp;

void main(void) {
    gl_Position =  mvp * pos;
    textureCoordOut = textureCoord;
    colorOut = color;
    
}