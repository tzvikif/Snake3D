//varying mediump vec3   f_color;
uniform sampler2D sampler;
varying mediump vec2 textureCoordOut;
//varying vec3 colorOut;

void main(void) {
    //gl_FragColor = vec4(f_color,1);
    mediump vec3 temp;
    mediump vec4 tex = texture3D(sampler, temp);
    gl_FragColor = tex;
    
    
}