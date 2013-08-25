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
    switch(_vertexStruct) {
        case PNCT:
            return  _vnoe * sizeof(VertexPNCT);
            break;
        case PNC:
            return _vnoe * sizeof(VertexPNC);
            break;
        case PC:
            return _vnoe * sizeof(VertexPC);
            break;
        default:
            NSLog(@"in Mesh: bad vertex struct  :%d",_vertexStruct);
            return 0;
            break;
    }
}
-(size_t)sizeofIndices {
    return _inoe * sizeof(GLushort);
}
-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            Texture:(GLfloat*)t
            indices:(GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe
 {
     VertexPNCT *verticesTemp = malloc( sizeof(VertexPNCT) * ( vnoe/3 ));
     
     _indices = malloc(inoe*sizeof(GLuint));
    for (int i=0; i<vnoe; i+=3) {
        CC3Vector vertex;
        CC3Vector normal;
        CC3Vector color;
        GLfloat texture[2];
        VertexPNCT vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        normal.x = n[i+0];
        normal.y = n[i+1];
        normal.z = n[i+2];
        
        color.x = c[i+0];
        color.y = c[i+1];
        color.z = c[i+2];
        //color.w = 1.0;
        
        texture[0] = t[i+0];
        texture[1] = t[i+1];
        
        vstruct.position = vertex;
        vstruct.normal = normal;
        vstruct.color = color;
        vstruct.texture[0] = texture[0];
        vstruct.texture[1] = texture[1];
        verticesTemp[i/3] = vstruct;
    }
     memcpy(_indices, elements, inoe*sizeof(GLuint));
     _vnoe = vnoe;
     _inoe = inoe;
     _vertexStruct = PNCT;
}
-(void)loadVertices:(GLfloat*)v
            indices:(GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe {
    
}
-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            indices:(GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe {
    VertexPNC *verticesTemp = malloc( sizeof(VertexPNC) * ( vnoe/3 ));
    
    _indices = malloc(inoe*sizeof(GLuint));
    for (int i=0; i<vnoe; i+=3) {
        CC3Vector vertex;
        CC3Vector normal;
        CC3Vector color;
        VertexPNC vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        normal.x = n[i+0];
        normal.y = n[i+1];
        normal.z = n[i+2];
        
        color.x = c[i+0];
        color.y = c[i+1];
        color.z = c[i+2];
        
        vstruct.position = vertex;
        vstruct.normal = normal;
        vstruct.color = color;
        verticesTemp[i/3] = vstruct;
    }
    memcpy(_indices, elements, inoe*sizeof(GLuint));
    _vnoe = vnoe;
    _inoe = inoe;
    _vertexStruct = PNC;

}
-(void)loadVertices:(GLfloat*)v
              color:(GLfloat*)c
            indices:(GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe {
    VertexPC *verticesTemp = malloc( sizeof(VertexPC) * ( vnoe/3 ));
    _indices = malloc(inoe*sizeof(GLuint));
    
    _vertices = (GLfloat*)verticesTemp;
    for (int i=0; i<vnoe; i+=3) {
        CC3Vector vertex;
        CC3Vector color;
        VertexPC vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        color.x = c[i+0];
        color.y = c[i+1];
        color.z = c[i+2];
        
        vstruct.position = vertex;
        vstruct.color = color;
        verticesTemp[i/3] = vstruct;
    }
    memcpy(_indices, elements, inoe*sizeof(GLuint));
    _vnoe = vnoe;
    _inoe = inoe;
    _vertexStruct = PC;
}
@end
