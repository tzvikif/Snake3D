//
//  RenderingEngine.h
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Node.h"
//#import "Drawable.h"
//#import "Mesh.h"

@class GLProgram;
@class Mesh;
@class Drawable;
@class CC3GLMatrix;


@interface RenderingEngine : NSObject
@property(nonatomic,retain) CC3GLMatrix *view;
@property(nonatomic,retain) GLProgram *program1;
-(void)initialize:(CGRect)viewport;
-(Drawable*)createDrawable:(Mesh*)mesh;
-(void)Render:(id<Renderable>)object;
@end
