attribute vec2 coord2d;
uniform mat4 transform;
varying vec4 graph_coord;

void main(void) {
    gl_Position = transform * vec4(coord2d.xy, 0, 1);
    graph_coord = vec4(1,1,1,1);
}