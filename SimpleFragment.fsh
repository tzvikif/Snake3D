uniform sampler2D sampler;
varying mediump vec2 textureCoordOut;
void main(void) {
//    if (textureCoordOut.x > 0.0 && textureCoordOut.x < 0.5) {
//        gl_FragColor = vec4(0,0,0,1);
//    }
//    else
//    {
//        gl_FragColor = vec4(1,0,0,1);
//    }
    mediump vec4 c = texture2D(sampler, textureCoordOut);
    /*gl_FragColor = texture2D(Sampler, TextureCoordOut) * DestinationColor;*/
    gl_FragColor = vec4(c.xyz,1.0);
}