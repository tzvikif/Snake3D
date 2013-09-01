//
//  Drawable.h
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "Mesh.h"

@interface Drawable : NSObject

@property(nonatomic,assign) GLuint vboVertexBuffer;
@property(nonatomic,assign) GLuint iboIndexBuffer;
@property(nonatomic,assign) GLuint textureId;

@property(nonatomic,assign) int IndexCount;

@end

