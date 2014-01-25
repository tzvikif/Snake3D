uniform sampler2D sampler;
varying mediump vec2 textureCoordOut;
void main(void) {
    mediump vec4 c = texture2D(sampler, textureCoordOut);
    gl_FragColor = vec4(c.xyz,0.5);
}