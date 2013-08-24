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
    PC,
    P,
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
typedef struct _vertex2
{
    CC3Vector position;
    CC3Vector4 color;
}Vertex2;


@interface Mesh : NSObject
@property(assign,nonatomic) GLuint inoe,vnoe;
@property(assign,nonatomic) GLfloat *vertices;
@property(assign,nonatomic) GLushort *indices;
@property(assign,nonatomic) vertexStructure vertexStruct;

-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            Texture:(GLfloat*)t
            indices:(GLushort*)elements
        indicesNumberOfElemets:(GLuint)inoe
       verticesNumberOfElemets:(GLuint)vnoe;
-(size_t)sizeofVertices;
-(size_t)sizeofIndices;
@end
