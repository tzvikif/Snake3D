//
//  Node.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "Node.h"
#import "GLProgram.h"
#import "LogicEngine.h"
#include "Consts.h"

@interface Node()
-(void)initResources:(NSArray*)matrices;
@end

@implementation Node
-(void)initResources:(NSArray *)matrices {
    [self setModelMatrix:[matrices objectAtIndex:0]];
    [self setViewMatrix:[matrices objectAtIndex:1]];
    [self setProjectionMatrix:[matrices objectAtIndex:2]];
}

-(void)Render {
    NSException *ex = [[NSException alloc] initWithName:@"" reason:@"Render method in Node is virtual" userInfo:nil];
    @throw [ex autorelease];
}
-(id)initializeWithProgram:(GLProgram*)program andDrawable:(Drawable *)drawable andMesh:(Mesh*)mesh andMaterial:(Material*)mat andViewport:(CGRect)vp{
    if ([super init]) {
        [self setMesh:mesh];
        [self setDrawable:drawable];
        _vs = mesh.vertexStruct;
        [self setProgram1:program];
        [self setMaterial:mat];
        [self setViewport:vp];
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
-(void) dealloc {
    [_drawable release];
    [_material release];
    [_modelMatrix release];
    [_program1 release];
    [super dealloc];
}
@end
