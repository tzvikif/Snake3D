attribute vec4 Position;
//attribute vec4 Color;
attribute vec2 texcoord;
varying vec2 f_texcoord;
uniform mat4 View;
uniform mat4 Projection;
uniform mat4 Model;
varying mat4 f_model;
varying vec4 DestinationColor;
void main(void)
{
    //DestinationColor = Color;
    f_texcoord = texcoord;
    f_model = Model;
    gl_Position = Projection * Model * Position;
}
