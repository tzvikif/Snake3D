//
//  Consts.h
//  Snake3D
//
//  Created by tzvifi on 8/28/13.
//
//

#import <Foundation/Foundation.h>

extern int const N;

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
    WALL_RIGHIT,
    WALL_DOWN,
    WALL_UP
}WALL;

float lerp(float a,float b,float blend);
