//
//  RenderingEngine.h
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Drawable.h"
#import "Mesh.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "CC3Foundation.h"
#import "CC3Math.h"
#import "CC3GLMatrix.h"

@interface RenderingEngine : NSObject
@property(nonatomic,retain) CC3GLMatrix *view;
-(void)initialize;
-(Drawable*)createDrawable:(Mesh*)mesh;
@end
