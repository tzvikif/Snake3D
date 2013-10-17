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
@property(nonatomic,retain) NSMutableDictionary *programs;
@property(assign,nonatomic) CGRect viewport;
-(void)initialize:(CGRect)viewport andProgram:(NSMutableDictionary*)programs;
-(void)Render:(NSArray*)renderables;
-(void)initResources:(NSArray*)renderables;
-(void)applyView:(CC3Vector*)arr to:(NSArray*)renderables;
-(void)preRender;
@end
