uniform sampler2D sampler1;
varying mediump vec2 textureCoordOut;
void main(void) {
    gl_FragColor = texture2D(sampler1, textureCoordOut);
    /*gl_FragColor = texture2D(Sampler, TextureCoordOut) * DestinationColor;*/
}