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


@implementation RenderingEngine

-(Drawable*)createDrawable:(Mesh*)mesh {
    Drawable *d = [[Drawable alloc] init];
    GLuint vboVertexBuffer;
    //CC3Vector *vertices = _objLoader->_arrVertices;
    glGenBuffers(1, &vboVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER,vboVertexBuffer );
    glBufferData(GL_ARRAY_BUFFER, [mesh sizeofVertices], mesh.vertices, GL_STATIC_DRAW);
    [d setVboVertexBuffer:vboVertexBuffer];
    
    GLuint ibo;
    glGenBuffers(1, &ibo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, [mesh sizeofIndices], mesh.indices, GL_STATIC_DRAW);
    [d setIboIndexBuffer:ibo];
    return d;
}
-(void)initialize:(CGRect)viewport {
    NSString *texcoord_name = @"texcoord";
    NSString* position_name = @"Position";
    NSString* normal_name = @"Normal";
    NSString* ambient_name = @"AmbientMaterial";
    NSString* diffuse_name = @"DiffuseMaterial";
    NSString* specular_name = @"SpecularMaterial";
    NSString* shininess_name = @"Shininess";
    NSString* lightPosition_name = @"LightPosition";
    NSString* normalMatrix_name = @"NormalMatrix";

    [_program1 addAttribute:position_name];
    [_program1 addAttribute:normal_name];
    [_program1 addAttribute:texcoord_name];
    [_program1 addUniform:ambient_name];
    [_program1 addUniform:diffuse_name];
    [_program1 addUniform:specular_name];
    [_program1 addUniform:lightPosition_name];
    [_program1 addUniform:normalMatrix_name];
    [_program1 addUniform:shininess_name];
    
    glUniform3f([_program1 uniformLocation:ambient_name] , 0.1f, 0.1f, 0.1f);
    glUniform3f([_program1 uniformLocation:specular_name],9.0, 9.0, 0.0);
    glUniform1f([_program1 uniformLocation:shininess_name],60);
    // Set the light position.
    CC3Vector4 lightPosition  = CC3Vector4Make(0.0,1.0,-2.0,0.0);
    glUniform4f([_program1 attributeLocation:lightPosition_name], lightPosition.x, lightPosition.y, lightPosition.z,lightPosition.w);
    CC3Vector color = CC3VectorMake(200.0/255.0, 150.0/255.0, 250.0/255.0);
    glUniform3f([_program1 uniformLocation:diffuse_name], color.x, color.y, color.z);
    glEnable(GL_DEPTH_TEST);
    
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //glEnable(GL_CULL_FACE);
    //glCullFace(GL_BACK);
    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glViewport(0, 0, viewport.size.width, viewport.size.width.height);
    
}
-(void)Render:(id<Renderable>)object {
    
}
@end
