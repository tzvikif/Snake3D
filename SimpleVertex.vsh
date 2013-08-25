attribute vec4 Position;
attribute vec4 Color;

uniform mat4 View;
uniform mat4 Projection;
uniform mat4 Model;
varying vec4 DestinationColor;
void main(void)
{
    DestinationColor = Color;
    gl_Position = Position;
    //gl_Position = Projection * View * Model * Position;
}
