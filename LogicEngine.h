//
//  LogicEngine.h
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "CC3Foundation.h"
#import "CC3Math.h"
#import "CC3GLMatrix.h"
#import "Mesh.h"
#import "Drawable.h"
#import "Node.h"
#import "RenderingEngine.h"
//#import "Plotter.h"
#import "Floor.h"
#import "Consts.h"

@class GLProgram;
@class Food;

@interface LogicEngine : NSObject
@property(nonatomic,retain) NSMutableArray *renderables;
@property(nonatomic,retain) Food *currentFood;
@property(retain,nonatomic) RenderingEngine *renderingEngine;
@property(retain,nonatomic) NSMutableDictionary *programs;
@property(assign,nonatomic) NSTimeInterval timeBetweenSteps;
@property(nonatomic,assign) ORIENTATION orient;
@property(nonatomic,assign) ORIENTATION newOrient;
@property(nonatomic,assign) BOOL inOrientationAnimation;
@property(nonatomic,assign) float orientationTimeElapsed;
@property(nonatomic,assign) CGRect viewport;
@property(nonatomic,assign) BOOL isFoodOnBoard;

-(void)initialize:(CGRect)viewport;
//-(void)loadProgram:(GLProgram*)program;
-(void)updateAnimation:(NSTimeInterval)timeElapsed;
-(void)Render;
-(void)updateOffset_x:(GLfloat)delta;
-(void)updateScale:(GLfloat)delta;
-(BOOL)createProgramWithVertexShaderName:(NSString*)vsName andFragmentShaderName:(NSString*)fsName withId:(PROG_ID)progid;
@end
    