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
#import "Plotter.h"

@class GLProgram;

@interface LogicEngine : NSObject
@property(nonatomic,retain) Plotter *plotterObj;
@property(nonatomic,retain) Mesh *plotterMesh;
//@property(nonatomic,retain) Drawable *cubeDrawable;
@property(retain,nonatomic) RenderingEngine *renderingEngine;
@property(retain,nonatomic) GLProgram *program1;

-(void)initialize:(CGRect)viewport andProgram:(GLProgram *)program;
-(void)loadProgram:(GLProgram*)program;
-(void)updateAnimation:(float)elapsedSeconds;
-(void)Render;
-(CC3Vector*)createGraph;
-(void)updateOffset_x:(GLfloat)delta;
-(void)updateScale:(GLfloat)delta;
@end
