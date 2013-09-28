//
//  Node.h
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
#import "Mesh.h"
#import "Drawable.h"
#import "Material.h"
@class GLProgram;

@protocol Renderable <NSObject>
-(void)Render;
@end
@interface Node : NSObject {
    vertexStructure _vs;
}
@property(retain,nonatomic) CC3GLMatrix *modelMatrix;
@property(retain,nonatomic) CC3GLMatrix *viewMatrix;
@property(retain,nonatomic) CC3GLMatrix *projectionMatrix;
@property(retain,nonatomic) Drawable *drawable;
@property(assign,nonatomic) CGRect viewport;
@property(retain,nonatomic) Material *material;
@property(retain,nonatomic) GLProgram *program1;

-(id)initializeWithProgram:(GLProgram*)program andDrawable:(Drawable *)drawable andVertexStruct:(vertexStructure)vs andMaterial:(Material*)mat andViewport:(CGRect)vp;
-(GLsizei)getStride;
-(void)Render;
-(void)initResources;
@end
