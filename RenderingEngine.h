//
//  RenderingEngine.h
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "Floor.h"
//#import "Drawable.h"
//#import "Mesh.h"

@class GLProgram;
@class Mesh;
@class Drawable;
@class CC3GLMatrix;


@interface RenderingEngine : NSObject
@property(nonatomic,retain) CC3GLMatrix *matView;
@property(nonatomic,retain) CC3GLMatrix *matProjection;
@property(nonatomic,retain) GLProgram *program1;
@property(assign,nonatomic) CGRect viewport;
-(void)initialize:(CGRect)viewport andProgram:(GLProgram*)program;
-(void)Render:(NSArray*)renderables;
-(void)initResources:(NSArray*)nodes;
@end
