//
//  LogicEngine.h
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
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
#import "Node.h"
#import "RenderingEngine.h"

@interface LogicEngine : NSObject
@property(nonatomic,retain) Node *simpleCube;
@property(retain,nonatomic) RenderingEngine *renderingEng;
-(void)initialize;
@end
