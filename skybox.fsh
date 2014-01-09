//varying mediump vec3   f_color;
uniform sampler3D sampler;
varying mediump vec3 textureCoordOut;
varying vec3 colorOut;

void main(void) {
    //gl_FragColor = vec4(f_color,1);
    mediump vec4 tex = texture3D(sampler, textureCoordOut);
    gl_FragColor = tex * colorOut;
    
}