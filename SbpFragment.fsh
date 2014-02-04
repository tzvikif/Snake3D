varying lowp vec4 DestinationColor;
varying mediump vec2 f_texcoord;
uniform sampler2D mytexture;

void main(void) {
    mediump vec2 flipped_texcoord = vec2(f_texcoord.x, 1.0 - f_texcoord.y);
    gl_FragColor = texture2D(mytexture, flipped_texcoord) * DestinationColor;
    //gl_FragColor = DestinationColor;
    //gl_FragColor = vec4(1.0,0.0,0.8,1.0);
}