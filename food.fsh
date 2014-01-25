uniform sampler2D sampler;
varying mediump vec2 textureCoordOut;
void main(void) {
    mediump vec2 texCoord = textureCoordOut;
    texCoord.y = 1.0-textureCoordOut.y;
    mediump vec4 c = texture2D(sampler, texCoord);
    gl_FragColor = vec4(c.xyz,1.0);
}