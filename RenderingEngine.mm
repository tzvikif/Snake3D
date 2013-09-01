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
    
    
//    for(int i = 0; i < 101; i++) {
//        line[i] = (i - 50) / 50.0;
//    }
    
    
//    size_t  size = [mesh sizeofVertices];
//    size = [mesh sizeofIndices];
//    glBufferData(GL_ARRAY_BUFFER, [mesh sizeofVertices], mesh.vertices, GL_STATIC_DRAW);
    
    GLbyte graph[2048];
    GLfloat line[2048];
    
    for(int i = 0; i < 2048; i++) {
        float x = (i - 1024.0) / 100.0;
        float y = sin(x * 10.0) / (1.0 + x * x);
        graph[i] = roundf(y * 128 + 128);
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(line), line, GL_STATIC_DRAW);
    [d setVboVertexBuffer:vboVertexBuffer];
    GLuint texture_id;
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &texture_id);
    glBindTexture(GL_TEXTURE_2D, texture_id);
    glTexImage2D(
                 GL_TEXTURE_2D,      // target
                 0,                  // level, 0 = base, no minimap,
                 GL_RGBA,       // internalformat
                 2048,               // width
                 1,                  // height
                 0,                  // border, always 0 in OpenGL ES
                 GL_RGBA,       // format
                 GL_UNSIGNED_BYTE,   // type
                 graph
                 );
    [d setTextureId:texture_id];
//    if ([mesh sizeofIndices] != 0) {
//        GLuint ibo;
//        glGenBuffers(1, &ibo);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
//        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [mesh sizeofIndices], mesh.indices, GL_STATIC_DRAW);
//        [d setIboIndexBuffer:ibo];
//    }
    return d;
}
-(void)initialize:(CGRect)viewport andProgram:(GLProgram *)program{
 
    [self setProgram1:program];
    [self.program1 use];    //must me before glUniform*
    NSString* ambient_name = @"AmbientMaterial";
    NSString* diffuse_name = @"DiffuseMaterial";
    NSString* specular_name = @"SpecularMaterial";
    NSString* shininess_name = @"Shininess";
    NSString* lightPosition_name = @"LightPosition";
    NSString* normalMatrix_name = @"NormalMatrix";
    NSString* view_name = @"View";
    NSString* projection_name = @"Projection";

//    [_program1 addUniform:ambient_name];
//    [_program1 addUniform:diffuse_name];
//    [_program1 addUniform:specular_name];
//    [_program1 addUniform:lightPosition_name];
//    [_program1 addUniform:normalMatrix_name];
//    [_program1 addUniform:shininess_name];
//    [_program1 addUniform:view_name];
//    [_program1 addUniform:projection_name];
    
    
//    glUniform3f([_program1 uniformLocation:ambient_name] , 0.1f, 0.1f, 0.1f);
//    glUniform3f([_program1 uniformLocation:specular_name],9.0, 9.0, 0.0);
//    glUniform1f([_program1 uniformLocation:shininess_name],60);
    // Set the light position.
//    CC3Vector4 lightPosition  = CC3Vector4Make(0.0,1.0,-2.0,0.0);
//    glUniform4f([_program1 attributeLocation:lightPosition_name], lightPosition.x, lightPosition.y, lightPosition.z,lightPosition.w);
//    CC3Vector color = CC3VectorMake(200.0/255.0, 150.0/255.0, 250.0/255.0);
//    glUniform3f([_program1 uniformLocation:diffuse_name], color.x, color.y, color.z);
    glEnable(GL_DEPTH_TEST);
    
    //glEnable(GL_CULL_FACE);
    //glCullFace(GL_BACK);
    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glViewport(0, 0, viewport.size.width, viewport.size.height);
    
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
