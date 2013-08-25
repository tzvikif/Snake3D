//
//  Node.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "Node.h"

@implementation Node
-(void)Render {
    
}
-(id)initializeWithProgram:(GLProgram*)program andDrawable:(Drawable *)drawable andVertexStruct:(vertexStructure)vs{
    if ([super init]) {
        [self setDrawable:drawable];
        _vs = vs;
        [self setProgram1:program];
    }
    return self;
}
@end
