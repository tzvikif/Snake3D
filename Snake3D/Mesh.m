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
    Vertex4 *v =  self.vertices;
    switch(_vertexStruct) {
            case PNCT:
            return (sizeof(v->position) + sizeof(v->normal) + sizeof(v->color) + sizeof(v->texture))*_verticesSize;
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
    return sizeof(GLuint)*_indicesSize;
}
-(void)loadVertices:(GLfloat*)v normals:(GLfloat*)n color:(GLfloat*)c Texture:(GLfloat*)t andIndices:(GLuint*)i {
    Vertex4 *verticesTemp = malloc( sizeof(Vertex4) * ( sizeof(v)/sizeof(GLfloat)/3 ));
    [self setVertices:verticesTemp];
    GLuint *indicesTemp = malloc(sizeof(i));
    [self setIndices:indicesTemp];
    for (int i=0; i<sizeof(v)/sizeof(GLfloat); i+=3) {
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
        
        vstruct.texture = texture;
    }
}
@end
