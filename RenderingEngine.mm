//
//  RenderingEngine.m
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import <Foundation/Foundation.h>
#import "RenderingEngine.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Vectors.h"
#import "GLProgram.h"
#import "CC3Foundation.h"
#import "CC3Math.h"
#import "CC3GLMatrix.h"
#import "Mesh.h"
#import "Drawable.h"
#import "Consts.h"
#import "Floor.h"
#import "Snake.h"


@implementation RenderingEngine

-(void)initialize:(CGRect)viewport andProgram:(NSMutableDictionary*)programs{
 
    [self setPrograms:programs];
    [self setViewport:viewport];
  
    //[_matProjection populateOrthoFromFrustumLeft:-1.0 andRight:1.0 andBottom:-1.2 andTop:1.2 andNear:0.1 andFar:2.0];
    //GLuint projectionId = [_program1 uniformLocation:projection_name];
    //glUniformMatrix4fv(projectionId, 1, 0, _matProjection.glMatrix);
    
}
-(void)initResources:(NSArray*)renderables {
    [self setMatProjection:[CC3GLMatrix identity]];
    [self setMatView:[CC3GLMatrix identity]];
    [_matView populateToLookAt:CC3VectorMake(0.0, 1.0, 0.0) withEyeAt:CC3VectorMake(0.0,6.0 , 8.0) withUp:CC3VectorMake(0.0, 1.0, 0.0)];
    float ratio = self.viewport.size.width / self.viewport.size.height;
    [_matProjection populateFromFrustumFov:45.0 andNear:0.1 andFar:50 andAspectRatio:ratio];
    for (Node *obj in renderables) {
            [obj setProjectionMatrix:_matProjection];
            [obj setViewMatrix:_matView];
            [obj setViewport:self.viewport];
            [obj initResources];
        }
}
-(void)Render:(NSArray*)renderables {
    glClearColor(0.4, 0.9, 0.9, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    for (Node *obj in renderables) {
//            [obj setViewMatrix:_matView];
//            [obj setProjectionMatrix:_matProjection];
    [obj Render];
    }
}

@end
