//
//  Drawable.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "Drawable.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@implementation Drawable

+(Drawable*)createDrawable:(Mesh*)mesh {
    Drawable *d = [[Drawable alloc] init];
    GLuint vboVertexBuffer;
    //CC3Vector *vertices = _objLoader->_arrVertices;
    glGenBuffers(1, &vboVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER,vboVertexBuffer );
    size_t  size = [mesh sizeofVertices];
    glBufferData(GL_ARRAY_BUFFER, size, mesh.vertices, GL_STATIC_DRAW);
    [d setVboVertexBuffer:vboVertexBuffer];
    
    if ([mesh sizeofIndices] != 0) {
        GLuint ibo;
        glGenBuffers(1, &ibo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
        size = [mesh sizeofIndices];
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, mesh.indices, GL_STATIC_DRAW);
        [d setIboIndexBuffer:ibo];
    }
    return d;
}
@end
