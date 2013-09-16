//uniform mediump vec4 color;
varying mediump float zcoord;
void main(void) {
    mediump vec3 zcolor;
    if (zcoord > 0.0 && zcoord < 0.3) {
        zcolor = vec3(1,0,0);
        
    }
    if (zcoord > 0.3 && zcoord < 0.6) {
        zcolor = vec3(0,1,0);
        
    }
    if (zcoord > 0.6) {
        zcolor = vec3(0,0,1);
        
    }
    if (zcoord < 0.0) {
        zcolor = vec3(0.3,0.6,0.5);
        
    }
    
    
    
    gl_FragColor = vec4(zcolor,1);
}