varying mediump vec4 f_color;
uniform highp sampler2D mytexture;

void main(void) {
    highp vec4 notUsed = texture2D(mytexture, vec2(0.0,0.0));
    gl_FragColor = f_color;
}