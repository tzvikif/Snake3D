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

@implementation RenderingEngine

+(Drawable*)createDrawable:(Mesh*)mesh {
    Drawable *d = [[Drawable alloc] init];
    GLuint vboVertexBuffer;
    //CC3Vector *vertices = _objLoader->_arrVertices;
    glGenBuffers(1, &vboVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER,vboVertexBuffer );
    size_t  size = [mesh sizeofVertices];
    size = [mesh sizeofIndices];
    glBufferData(GL_ARRAY_BUFFER, [mesh sizeofVertices], mesh.vertices, GL_STATIC_DRAW);
    [d setVboVertexBuffer:vboVertexBuffer];
    
    if ([mesh sizeofIndices] != 0) {
        GLuint ibo;
        glGenBuffers(1, &ibo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [mesh sizeofIndices], mesh.indices, GL_STATIC_DRAW);
        [d setIboIndexBuffer:ibo];
    }
    return d;
}
-(void)initialize:(CGRect)viewport andProgram:(GLProgram *)program{
 
    [self setProgram1:program];
    [self setViewport:viewport];
    [self.program1 use];    //must me before glUniform*

    glEnable(GL_DEPTH_TEST);
    
    //glEnable(GL_CULL_FACE);
    //glCullFace(GL_BACK);
    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glViewport(0, 0, viewport.size.width, viewport.size.height);
  
    
    //CC3GLMatrix *projection = [CC3GLMatrix identity];
    _matProjection = [CC3GLMatrix identity];
    _matView = [CC3GLMatrix identity];
    [_matView populateToLookAt:CC3VectorMake(0.0, 0.0, -4.0) withEyeAt:CC3VectorMake(1.0, 2.0, 0.0) withUp:CC3VectorMake(0.0, 1.0, 0.0)];
    float ratio = viewport.size.width / viewport.size.height;
    //glUniformMatrix4fv([_program1 uniformLocation:view_name], 1, 0, _matView.glMatrix);
    //[projection populateFromFrustumFov:45.0 andNear:0.1 andFar:10 andAspectRatio:ratio];
    [_matProjection populateOrthoFromFrustumLeft:-1.0 andRight:1.0 andBottom:-1.2 andTop:1.2 andNear:0.1 andFar:2.0];
    //GLuint projectionId = [_program1 uniformLocation:projection_name];
    //glUniformMatrix4fv(projectionId, 1, 0, _matProjection.glMatrix);
    
}
-(void)Render:(id<Renderable>)object {
    [object Render];
}

@end
