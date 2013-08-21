//
//  Mesh.h
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "CC3Foundation.h"
#import "CC3Math.h"
#import "CC3GLMatrix.h"

typedef enum _vertexStructure
{
    PNCT,
    PNC,
}vertexStructure;

typedef struct _vertex4
{
    CC3Vector position;
    CC3Vector normal;
    CC3Vector4 color;
    GLfloat texture[2];
}Vertex4;

typedef struct _vertex3
{
    CC3Vector position;
    CC3Vector normal;
    CC3Vector4 color;
}Vertex3;


@interface Mesh : NSObject
@property(assign,nonatomic) Vertex4 *vertices;
@property(assign,nonatomic) GLuint *indices;
@property(assign,nonatomic) GLuint indicesSize,verticesSize;
@property(nonatomic,assign) vertexStructure vertexStruct;
-(size_t)sizeofVertices;
-(size_t)sizeofIndices;
-(void)loadVertices:(GLfloat*)v normals:(GLfloat*)n color:(GLfloat*)c Texture:(GLfloat*)t andIndices:(GLuint*)i;
@end
