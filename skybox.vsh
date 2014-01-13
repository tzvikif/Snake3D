attribute vec3 pos;
//attribute vec3 color;
//varying vec3 colorOut;
attribute vec2 textureCoord;
varying vec2 textureCoordOut;
uniform mat4 mvp;

void main(void) {
    gl_Position =  mvp * vec4(pos,1.0);
    textureCoordOut = textureCoord;
    //colorOut = color;
    
}