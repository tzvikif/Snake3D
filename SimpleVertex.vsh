attribute vec4 Position;

uniform mat4 View;
uniform mat4 Projection;
uniform mat4 Model;

void main(void)
{
    gl_Position = Position;
    //gl_Position = Projection * View * Model * Position;
}
