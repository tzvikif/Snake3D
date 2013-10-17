//
//  Consts.m
//  Snake3D
//
//  Created by tzvifi on 8/28/13.
//
//

#import "Consts.h"
#import "Vectors.h"
#import "CC3Foundation.h"
int const N = 32;

float UP_DIR_ANGLE = 0;
float DOWN_DIR_ANGLE = 180;
float LEFT_DIR_ANGLE = 90;
float RIGHT_DIR_ANGLE = 270;

float const totalOrientationTime = 1.0;
float const SNKspeed = 0.1;

//UL
CC3Vector const ul_lookAt = {-8.0, 1.0, -8.0};
CC3Vector const ul_eyeAt = {-12.0, 10.0, 10.0};
CC3Vector const ul_up = {0.0, 1.0, 0.0};
//UR
CC3Vector const ur_lookAt = {6.0, 1.0, -8.0};
CC3Vector const ur_eyeAt = {14.0, 10.0, 10.0};
CC3Vector const ur_up = {0.0, 1.0, 0.0};
//BL
CC3Vector const bl_lookAt = {-5.0, 1.0, 0.0};
CC3Vector const bl_eyeAt = {-13.0, 10.0, 24.0};
CC3Vector const bl_up = {0.0, 1.0, 0.0};
//BR
CC3Vector const br_lookAt = {5.0, 1.0, 0.0};
CC3Vector const br_eyeAt = {12.0, 10.0, 24.0};
CC3Vector const br_up = {0.0, 1.0, 0.0};

GLfloat const cube_vertices[] = {
    // front
    -1.0, -1.0,  1.0,
    1.0, -1.0,  1.0,
    1.0,  1.0,  1.0,
    -1.0,  1.0,  1.0,
    // top
    -1.0,  1.0,  1.0,
    1.0,  1.0,  1.0,
    1.0,  1.0, -1.0,
    -1.0,  1.0, -1.0,
    // back
    1.0, -1.0, -1.0,
    -1.0, -1.0, -1.0,
    -1.0,  1.0, -1.0,
    1.0,  1.0, -1.0,
    // bottom
    -1.0, -1.0, -1.0,
    1.0, -1.0, -1.0,
    1.0, -1.0,  1.0,
    -1.0, -1.0,  1.0,
    // left
    -1.0, -1.0, -1.0,
    -1.0, -1.0,  1.0,
    -1.0,  1.0,  1.0,
    -1.0,  1.0, -1.0,
    // right
    1.0, -1.0,  1.0,
    1.0, -1.0, -1.0,
    1.0,  1.0, -1.0,
    1.0,  1.0,  1.0,
};
size_t const cube_verticesSize = sizeof(cube_vertices);
GLfloat const cube_verticesX[] = {
    // front
    -1.0, -1.0,  -0.5,
    1.0, -1.0,  -0.5,
    0.0,  1.0,  -0.5,
    -1.0,  1.0,  -0.5,
};
size_t const cube_verticesXSize = sizeof(cube_vertices);
GLfloat const cube_colorsX[] = {
    // front colors
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    // back colors
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
};
GLushort const cube_elements[] = {
    // front
    0,  1,  2,
    2,  3,  0,
    // top
    4,  5,  6,
    6,  7,  4,
    // back
    8,  9, 10,
    10, 11,  8,
    // bottom
    12, 13, 14,
    14, 15, 12,
    // left
    16, 17, 18,
    18, 19, 16,
    // right
    20, 21, 22,
    22, 23, 20,
};
size_t const cube_elementsSize = sizeof(cube_elements);
GLushort const SimpleCube_elements[] = {
    // front
    0,  1,  2,
    2,  3,  0,
};
size_t const SimpleCube_elementsSize = sizeof(SimpleCube_elements);
GLfloat const cube_colors[] = {
    // front colors
    1.0, 0.0, 0.3,
    0.2, 1.0, 0.0,
    0.0, 1.0, 1.0,
    0.3, 1.0, 0.7,
};
GLfloat const cube_colorsFood[] = {
    // front colors
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,

    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,

    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,
    0.4, 0.4, 0.6,

};

GLfloat const cube_texcoords[2*4*6] = {
    // front
    0.0, 0.0,
    1.0, 0.0,
    1.0, 1.0,
    0.0, 1.0,
};
GLfloat const cube_normals[] = {
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,4.000000,0.000000,
    
    -0.000000,4.000000,0.000000,
    
    0.000000,4.000000,0.000000,
    
    0.000000,4.000000,0.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    -0.000000,-4.000000,0.000000,
    
    0.000000,-4.000000,0.000000,
    
    -0.000000,-4.000000,0.000000,
    
    -0.000000,-4.000000,0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    -4.000000,0.000000,0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,0.000000,
    
    4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,-0.000000
};

GLfloat const SnakeCube_verticesY[] = {
    // front
    -0.125, -0.125,  0.125,
    0.125, -0.125,  0.125,
    0.125,  0.125,  0.125,
    -0.125,  0.125,  0.125,
    // top
    -0.125,  0.125,  0.125,
    0.125,  0.125,  0.125,
    0.125,  0.125, -0.125,
    -0.125,  0.125, -0.125,
    // back
    0.125, -0.125, -0.125,
    -0.125, -0.125, -0.125,
    -0.125,  0.125, -0.125,
    0.125,  0.125, -0.125,
    // bottom
    -0.125, -0.125, -0.125,
    0.125, -0.125, -0.125,
    0.125, -0.125,  0.125,
    -0.125, -0.125,  0.125,
    // left
    -0.125, -0.125, -0.125,
    -0.125, -0.125,  0.125,
    -0.125,  0.125,  0.125,
    -0.125,  0.125, -0.125,
    // right
    0.125, -0.125,  0.125,
    0.125, -0.125, -0.125,
    0.125,  0.125, -0.125,
    0.125,  0.125,  0.125,
};
size_t const SnakeCube_verticesYSize = sizeof(SnakeCube_verticesY);



