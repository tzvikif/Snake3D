attribute vec4 Position;
attribute vec3 Normal;
attribute vec2 texcoord;
uniform mat4 Projection;
uniform mat4 Model;
uniform mat4 View;
uniform mat4 NormalMatrix;
uniform vec4 LightPosition;
uniform vec3 AmbientMaterial;
uniform vec3 SpecularMaterial;
uniform vec3 DiffuseMaterial;
uniform mat4 MVP;
uniform float Shininess;
varying vec4 DestinationColor;
varying vec2 f_texcoord;

void main(void)
{
    mat4 nm = NormalMatrix;
    mat4 temp = MVP;
    vec4 N4 = View * Model * vec4(normalize(Normal),0);
    N4 = normalize(N4);
    vec3 N = N4.xyz;
    //N = normalize(N);
    vec4 vcLightPosition = View * LightPosition;
    vec4 vcVertexPosition = View * Model * Position;
    vec4 L = normalize(vcLightPosition - vcVertexPosition);
    vec3 E = vec3(0.0, 0.0, 1.0);
    vec3 H = normalize(L.xyz + E);
    float df = max(0.0, dot(N, L.xyz));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, Shininess);
    vec3 d = DiffuseMaterial;
    vec3 s = SpecularMaterial;
    vec3 a = AmbientMaterial;
    float distanceToLight = length(vcLightPosition-vcVertexPosition);
    float attenuation = 1.0 - distanceToLight / 64.0;
    //float attenuation = 1.0 / (1.0 + 1.0 * pow(distanceToLight, 1.0));
    //attenuation = 0.2;
    vec3 color = AmbientMaterial + attenuation * (df * DiffuseMaterial /*+ sf * SpecularMaterial*/);
    
    //color = vec3(1.0,0.0,0.0);
//    if (0.0 <= df && df < 0.25 ) {
//        color = vec3(1.0,0.0,0.0);
//    }
//    if (0.25 <= df && df <= 0.5 ) {
//        color = vec3(0.0,1.0,0.0);
//    }
//    if (0.5 <= df && df < 0.75 ) {
//        color = vec3(0.0,0.0,1.0);
//    }
//    if (0.75 <= df && df <= 1.0 ) {
//        color = vec3(1.0,0.0,1.0);
//    }
    //    else
    //    {
    //        color = DiffuseMaterial;
    //    }
//    if (distanceToLight < 5.0) {
//        color = vec3(1.0,0.0,0.0);
//    }
//    if (distanceToLight > 5.0 && distanceToLight < 15.0) {
//        color = vec3(0.0,1.0,0.0);
//    }
//    if (distanceToLight > 15.0 && distanceToLight < 20.0) {
//        color = vec3(0.0,0.0,1.0);
//    }
//    if (distanceToLight > 20.0) {
//        color = vec3(1.0,0.0,1.0);
//    }
    DestinationColor = vec4(color,1.0);
    f_texcoord = texcoord;
    //gl_PointSize = 10.0;
    //vec4 lp = vec4(0.0,3.0,0.5,1.0);
    gl_Position = Projection * View * Model * Position;
}
