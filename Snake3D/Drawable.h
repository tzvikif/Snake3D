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
@property(nonatomic,assign) int IndexCount;
@property(nonatomic,assign) BOOL hasIndexBuffer;
+(Drawable*)createDrawable:(Mesh*)mesh;
@end
