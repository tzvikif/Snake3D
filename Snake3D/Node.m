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
-(void)preRender {
    
}
-(id)initializeWithProgram:(GLProgram*)program andDrawable:(Drawable *)drawable andVertexStruct:(vertexStructure)vs andMaterial:(Material*)mat{
    if ([super init]) {
        [self setDrawable:drawable];
        _vs = vs;
        [self setProgram1:program];
        [self setMaterial:mat];
    }
    return self;
}
@end
