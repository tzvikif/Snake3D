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
#import "SimpleCube.h"
@class GLProgram;

@interface LogicEngine : NSObject
@property(nonatomic,retain) SimpleCube *simpleCube;
@property(nonatomic,retain) Mesh *cubeMesh;
//@property(nonatomic,retain) Drawable *cubeDrawable;
@property(retain,nonatomic) RenderingEngine *renderingEngine;
@property(retain,nonatomic) GLProgram *program1;

-(void)initialize:(CGRect)viewport;
-(void)loadProgram:(GLProgram*)program;
-(void)updateAnimation:(float)elapsedSeconds;
-(void)Render;
@end
