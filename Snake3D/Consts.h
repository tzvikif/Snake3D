//
//  Consts.h
//  Snake3D
//
//  Created by tzvifi on 8/28/13.
//
//

#import <Foundation/Foundation.h>

extern int const N;
extern float const totalOrientationTime;
typedef enum _PROGRAMS {
    PROG_FLOOR,
    PROG_SNAKE
}PROG_ID;

typedef enum _DIRECTION {
    DIR_UP,
    DIR_DOWN,
    DIR_LEFT,
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

float lerp(float a,float b,float blend);

