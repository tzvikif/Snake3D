//varying mediump vec3   f_color;
uniform sampler2D sampler;
varying mediump vec2 textureCoordOut;

void main(void) {
    //gl_FragColor = vec4(f_color,1);
    mediump vec4 c = texture2D(sampler, textureCoordOut);
    gl_FragColor = c;

}