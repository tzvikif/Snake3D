//varying mediump vec3   f_color;
uniform sampler2D sampler;
varying mediump vec2 textureCoordOut;
//varying vec3 colorOut;

void main(void) {
    mediump vec2 texCoord = textureCoordOut;
    texCoord.y = 1.0-textureCoordOut.y;
    mediump vec4 tex = texture2D(sampler, texCoord);
    gl_FragColor = tex;
    
    
}