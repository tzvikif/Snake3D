//
//  Consts.h
//  Snake3D
//
//  Created by tzvifi on 8/28/13.
//
//

#import <Foundation/Foundation.h>
#import "Vectors.h"
extern int const N;
extern float const totalOrientationTime;
extern float const SNKspeed;
typedef enum _PROGRAMS {
    PROG_FLOOR,
    PROG_SNAKE,
    PROG_SKYBOX
}PROG_ID;

typedef enum _DIRECTION {
    DIR_UP = 0,
    DIR_LEFT,
    DIR_DOWN,
    DIR_RIGHT
}DIRECTION;

typedef enum _WALL {
    WALL_LEFT,
    WALL_RIGHT,
    WALL_DOWN,
    WALL_UP
}WALL;

typedef enum _ORIENTATION {
    ORTN_NONE,  
    ORTN_UL,    //upper left
    ORTN_UR,    //upper right
    ORTN_BL,    //bottom left
    ORTN_BR     //bottom right
}ORIENTATION;
typedef enum _VIEW {
    LOOK_AT,
    UP,    //upper left
    EYE_AT    //upper right
}VIEW;


float lerp(float a,float b,float blend);

//UL
extern CC3Vector const ul_lookAt;
extern CC3Vector const ul_eyeAt;
extern CC3Vector const ul_up;
//UR
extern CC3Vector const ur_lookAt;
extern CC3Vector const ur_eyeAt;
extern CC3Vector const ur_up;
//BL
extern CC3Vector const bl_lookAt;
extern CC3Vector const bl_eyeAt;
extern CC3Vector const bl_up;
//BR
extern CC3Vector const br_lookAt;
extern CC3Vector const br_eyeAt;
extern CC3Vector const br_up;

extern GLfloat const cube_verticesX[];
extern GLfloat const cube_vertices[];
extern size_t const cube_verticesSize;
extern size_t const cube_verticesXSize;
extern GLfloat const cube_colorsX[];
extern GLushort const cube_elementsX[];
extern GLushort const cube_elements[];
extern size_t const cube_elementsSize;
extern GLfloat const cube_colors[];
extern GLfloat const cube_colorsFood[];
extern GLfloat const cube_normals[];
extern size_t const SimpleCube_elementsSize;
extern GLfloat const SnakeCube_verticesY[];
extern size_t const SnakeCube_verticesYSize;
extern GLfloat const cube_texcoords[];

#define TWODIGITS_FP(x) x*=100;x=roundf(x);x/=100; //round a number by 2 digits. 5.499993 => 5.500000


