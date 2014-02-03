attribute vec4 Position;
attribute vec4 Color;
attribute vec3 Normal;
varying vec4 f_color;
attribute vec2 textureCoord;
varying vec2 textureCoordOut;
uniform mat4 MVP;

void main(void) {
    f_color = Color;
    vec3 tempNormal = Normal;
    textureCoordOut = textureCoord;
    gl_Position =  MVP  * Position;
}