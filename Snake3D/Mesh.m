//
//  Mesh.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "Mesh.h"
#import "CC3Foundation.h"
#import "CC3Math.h"
#import "CC3GLMatrix.h"

@implementation Mesh
-(size_t)sizeofVertices {
    Vertex4 *v = NULL;
    switch(_vertexStruct) {
            case PNCT:
            return (sizeof(v->position) + sizeof(v->normal) + sizeof(v->color) + sizeof(v->texture))*_vnoe/3;
            break;
            case PNC:
            return sizeof(v->position) + sizeof(v->normal) + sizeof(v->color);
            break;
            default:
            NSLog(@"in Mesh: bad vertex struct:%d",_vertexStruct);
            break;
    }
}
-(size_t)sizeofIndices {
    return sizeof(GLushort)*_inoe;
}
-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            Texture:(GLfloat*)t
            indices:(GLushort*)i
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe
 {
    Vertex4 *verticesTemp = malloc( sizeof(Vertex4) * ( vnoe/3 ));
    [self setVertices:(GLfloat*)verticesTemp];
    GLushort *indicesTemp = malloc(sizeof(GLuint)*inoe);
    [self setIndices:indicesTemp];
    for (int i=0; i<vnoe/3; i+=3) {
        CC3Vector vertex;
        CC3Vector normal;
        CC3Vector4 color;
        GLfloat texture[2];
        Vertex4 vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        normal.x = n[i+0];
        normal.y = n[i+1];
        normal.z = n[i+2];
        
        color.x = c[i+0];
        color.y = c[i+1];
        color.z = c[i+2];
        color.w = 1.0;
        
        texture[0] = t[i+0];
        texture[1] = t[i+1];
        
        vstruct.position = vertex;
        vstruct.normal = normal;
        vstruct.color = color;
        vstruct.texture[0] = texture[0];
        vstruct.texture[1] = texture[1];
        verticesTemp[i/3] = vstruct;
    }
}

@end
