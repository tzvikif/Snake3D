attribute vec4 pos;
//attribute vec3 color;
//varying vec3 f_color;
attribute vec2 textureCoord;
varying vec2 textureCoordOut;
uniform mat4 mvp;

void main(void) {
    mat4 temp = mvp;
    gl_Position =  mvp * pos;
    textureCoordOut = textureCoord;
    
}