//
//  Node.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "Node.h"
#import "GLProgram.h"

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
-(GLsizei)getStride {
    NSException* myException;
    GLsizei stride = -1;
    switch (_vs) {
        case PC:
            stride = sizeof(VertexPC);
            break;
        case PNCT:
            stride = sizeof(VertexPNCT);
            break;
        case PNC:
            stride = sizeof(VertexPNC);
            break;
        case PT:
            stride = sizeof(VertexPT);
            break;
        case P:
            stride = sizeof(CC3Vector);
            break;
        default:
            myException = [NSException
                                        exceptionWithName:@"stride error"
                                        reason:@"vertex structure is missing"
                                        userInfo:nil];
            @throw myException;
            break;
    }
    return stride;
}
@end
