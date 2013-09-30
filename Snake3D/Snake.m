//
//  Snake.m
//  Snake3D
//
//  Created by tzvifi on 9/30/13.
//
//

#import "Snake.h"
#import "BodyPart.h"
#import "Drawable.h"

@implementation Snake

-(void)initResources {
    _bpCount = 1;
    Drawable *drwblTemp = [[Drawable alloc] init];
    [drwblTemp]
    BodyPart *pb = [[BodyPart alloc] initializeWithProgram:(GLProgram *) andDrawable:<#(Drawable *)#> andVertexStruct:<#(vertexStructure)#> andMaterial:<#(Material *)#> andViewport:<#(CGRect)#>];
}
@end
