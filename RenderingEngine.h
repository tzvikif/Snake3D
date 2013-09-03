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
@property(nonatomic,retain) CC3GLMatrix *matView;
@property(nonatomic,retain) CC3GLMatrix *matProjection;
@property(nonatomic,retain) GLProgram *program1;
@property(assign,nonatomic) CGRect viewport;
-(void)initialize:(CGRect)viewport andProgram:(GLProgram*)program;
+(Drawable*)createDrawable:(Mesh*)mesh;
-(void)Render:(id<Renderable>)object;
-(void)drawFloor;
-(CC3GLMatrix*) viewport_transformX:(GLfloat) x andY:(GLfloat)y andWidth:(GLfloat)width andHeight:(GLfloat)height;
@end
