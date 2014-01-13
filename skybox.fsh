//varying mediump vec3   f_color;
uniform sampler2D sampler;
varying mediump vec2 textureCoordOut;
//varying vec3 colorOut;

void main(void) {
    mediump vec4 tex = texture2D(sampler, textureCoordOut);
    gl_FragColor = tex;
    
    
}