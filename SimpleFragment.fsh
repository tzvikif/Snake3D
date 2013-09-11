//uniform mediump vec4 color;
varying mediump vec3 zcolor;
void main(void) {
    gl_FragColor = vec4(zcolor,1);
}