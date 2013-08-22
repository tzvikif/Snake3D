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

@protocol Renderable <NSObject>
-(void)Render;
@end
@interface Node : NSObject<Renderable>
@property(retain,nonatomic) CC3GLMatrix *model;
@property(retain,nonatomic) Mesh *cubeMesh;
@property(retain,nonatomic) Drawable *cubeDrawable;
@property(retain,nonatomic) Material *material;
@end
