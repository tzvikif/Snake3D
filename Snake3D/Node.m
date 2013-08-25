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
-(void)initialize {
    
}
-(void)setDrawable:(Drawable *)drawable andVertexStruct:(vertexStructure)vs {
    [self setDrawable:drawable];
    _vs = vs;
}
@end
