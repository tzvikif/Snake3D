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
    PT,
    P
}vertexStructure;

typedef struct _vertexPNCT
{
    CC3Vector position;
    CC3Vector normal;
    CC3Vector color;
    GLfloat texture[2];
}VertexPNCT;

typedef struct _vertexPNC 
{
    CC3Vector position;
    CC3Vector normal;
    CC3Vector color;
}VertexPNC;
typedef struct _vertexPC
{
    CC3Vector position;
    CC3Vector color;
}VertexPC;
typedef struct _vertexPT
{
    CC3Vector position;
    GLfloat texture[2];
}VertexPT;



@interface Mesh : NSObject
@property(assign,nonatomic) GLuint inoe,vnoe;
@property(assign,nonatomic) GLfloat *vertices;
@property(assign,nonatomic) GLushort *indices;
@property(assign,nonatomic) vertexStructure vertexStruct;

-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            texture:(GLfloat*)t
            indices:(GLushort*)elements
        indicesNumberOfElemets:(GLuint)inoe
       verticesNumberOfElemets:(GLuint)vnoe;
-(void)loadVertices:(GLfloat*)v
            indices:(GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe;
-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            indices:(GLushort*)elements
            indicesNumberOfElemets:(GLuint)inoe
            verticesNumberOfElemets:(GLuint)vnoe;
-(void)loadVertices:(const GLfloat*)v
              color:(const GLfloat*)c
            indices:(const GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe;
-(void)loadVertices:(const GLfloat*)v
            texture:(const GLfloat*)c
            indices:(const GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe;
-(size_t)sizeofVertices;
-(size_t)sizeofIndices;
-(void)loadObjFromFile:(NSString*)name;
-(void)loadObjFromFileWithUV:(NSString *)name;
@end
