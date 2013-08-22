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
uniform float Shininess;
varying vec4 DestinationColor;
varying vec2 f_texcoord;

void main(void)
{
    mat4 nm = NormalMatrix;
    vec4 N4 = View * Model * vec4(normalize(Normal),0);
    N4 = normalize(N4);
    vec3 N = N4.xyz;
    //N = normalize(N);
    vec4 L = normalize(LightPosition - View * Model* Position);
    vec3 E = vec3(0.0, 0.0, 1.0);
    vec3 H = normalize(L.xyz + E);
    float df = max(0.0, dot(N, L.xyz));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, Shininess);
    vec3 d = DiffuseMaterial;
    vec3 s = SpecularMaterial;
    vec3 a = AmbientMaterial;
    //vec3 dm = vec3(200.0/255.0, 100.0/255.0, 200.0/255.0);
    vec3 color = AmbientMaterial + df * DiffuseMaterial + sf * SpecularMaterial;
    //vec3 color = SpecularMaterial;
    if (0.0 <= df && df < 0.25 ) {
        color = vec3(1.0,0.0,0.0);
    }
    if (0.25 <= df && df <= 0.5 ) {
        color = vec3(1.0,0.0,1.0);
    }
    if (0.5 <= df && df < 0.75 ) {
        color = vec3(1.0,1.0,0.0);
    }
    if (0.75 <= df && df <= 1.0 ) {
        color = vec3(0.0,0.0,1.0);
    }
//    else
//    {
//        color = DiffuseMaterial;
//    }
    DestinationColor = vec4(color,1.0);
    f_texcoord = texcoord;
    gl_Position = Projection * View * Model* Position;
}
