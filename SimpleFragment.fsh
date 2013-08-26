varying lowp vec4 DestinationColor;
varying mediump vec2 f_texcoord;
varying highp mat4 f_model;
uniform sampler2D texture;

void main(void) {
    mediump vec2 flipped_texcoord = vec2(f_texcoord.x, 1.0 - f_texcoord.y);
    gl_FragColor = texture2D(texture, flipped_texcoord) * vec4(0.4,0.4,0.6,1);
    //gl_FragColor = DestinationColor;
    //gl_FragColor = vec4(1.0,0.0,0.8,1.0);
    //gl_FragColor = DestinationColor;
}