//
//  Snake.m
//  Snake3D
//
//  Created by tzvifi on 9/30/13.
//
//

#import "Snake.h"
#import "Drawable.h"
#import "BodyPart.h"
#import "Floor.h"
#import "Consts.h"
GLfloat SnakeCube_vertices[] = {
    // front
    -1.0, -1.0,  1.0,
    1.0, -1.0,  1.0,
    1.0,  1.0,  1.0,
    -1.0,  1.0,  1.0,
    // top
    -1.0,  1.0,  1.0,
    1.0,  1.0,  1.0,
    1.0,  1.0, -1.0,
    -1.0,  1.0, -1.0,
    // back
    1.0, -1.0, -1.0,
    -1.0, -1.0, -1.0,
    -1.0,  1.0, -1.0,
    1.0,  1.0, -1.0,
    // bottom
    -1.0, -1.0, -1.0,
    1.0, -1.0, -1.0,
    1.0, -1.0,  1.0,
    -1.0, -1.0,  1.0,
    // left
    -1.0, -1.0, -1.0,
    -1.0, -1.0,  1.0,
    -1.0,  1.0,  1.0,
    -1.0,  1.0, -1.0,
    // right
    1.0, -1.0,  1.0,
    1.0, -1.0, -1.0,
    1.0,  1.0, -1.0,
    1.0,  1.0,  1.0,
};
GLfloat SnakeCube_verticesY[] = {
    // front
    -0.125, -0.125,  0.125,
    0.125, -0.125,  0.125,
    0.125,  0.125,  0.125,
    -0.125,  0.125,  0.125,
    // top
    -0.125,  0.125,  0.125,
    0.125,  0.125,  0.125,
    0.125,  0.125, -0.125,
    -0.125,  0.125, -0.125,
    // back
    0.125, -0.125, -0.125,
    -0.125, -0.125, -0.125,
    -0.125,  0.125, -0.125,
    0.125,  0.125, -0.125,
    // bottom
    -0.125, -0.125, -0.125,
    0.125, -0.125, -0.125,
    0.125, -0.125,  0.125,
    -0.125, -0.125,  0.125,
    // left
    -0.125, -0.125, -0.125,
    -0.125, -0.125,  0.125,
    -0.125,  0.125,  0.125,
    -0.125,  0.125, -0.125,
    // right
    0.125, -0.125,  0.125,
    0.125, -0.125, -0.125,
    0.125,  0.125, -0.125,
    0.125,  0.125,  0.125,
};

GLfloat SnakeCube_verticesX[] = {
    // front
    -1.0, -1.0,  -0.5,
    1.0, -1.0,  -0.5,
    1.0,  1.0,  -0.5,
    -1.0,  1.0,  -0.5,
};
GLfloat SnakeCube_colors[] = {
    // front colors
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    // back colors
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
};
GLushort SnakeCube_elements[] = {
    // front
    0,  1,  2,
    2,  3,  0,
    // top
    4,  5,  6,
    6,  7,  4,
    // back
    8,  9, 10,
    10, 11,  8,
    // bottom
    12, 13, 14,
    14, 15, 12,
    // left
    16, 17, 18,
    18, 19, 16,
    // right
    20, 21, 22,
    22, 23, 20,
};



@implementation Snake

-(void)initResources {
    _bpCount = 15;
    _velocityChanged = YES;
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    [self setBodyParts:ma];
    [ma release];
    Mesh *meshCube = [[Mesh alloc] init];
    [meshCube loadVertices:SnakeCube_vertices color:SnakeCube_colors indices:SnakeCube_elements indicesNumberOfElemets:sizeof(SnakeCube_elements)/sizeof(SnakeCube_elements[0])
   verticesNumberOfElemets:sizeof(SnakeCube_verticesY)/sizeof(SnakeCube_verticesY[0])/3];
    Drawable *drwblTemp = [Drawable createDrawable:meshCube];
    Material *materialTemp = [[Material alloc] init];
    BodyPart *bp;
    CC3Vector pos;
    [self setPosition:CC3VectorMake(2.5, 0.5, 1.5)];
    //[bp setScaleFactor:(N/2.0)/2.0];
    for (int i=0; i<_bpCount; i++) {
        bp = [[BodyPart alloc] initializeWithProgram:self.program andDrawable:drwblTemp andMesh:meshCube andMaterial:materialTemp andViewport:self.viewport];
        [bp setMyId:i];
        [bp setSpeed:_speed];
        [bp initResources];
        float bsf = 1.0/2.0; //base scale factor
        [bp setScaleFactor:CC3VectorMake(bsf-i*0.02, bsf, bsf)];
        pos = _position;
        pos.z = _position.z + i;
        [bp setPosition:pos];
        [bp setViewMatrix:self.viewMatrix];
        [bp setProjectionMatrix:self.projectionMatrix];
        
        [_bodyParts addObject:bp];
    }
    [meshCube release];
    [materialTemp release];
}
-(void)dealloc {
    [_bodyParts release];   
    [super dealloc];
}
-(void)Render {
    for (BodyPart *bp in _bodyParts) {
        [bp Render];
    }
    _velocityChanged = NO;
}
-(void)setDir:(DIRECTION)dir andPosition:(CC3Vector)pos{
    if (dir != _dir) {
        _dir = dir;
        _turnPos = pos;
        for (BodyPart *bp in _bodyParts) {
            [bp addTurnDirection:dir inPosition:pos];
        }
    }
}
-(void)advance {
    for (BodyPart *bp in _bodyParts) {
        [bp advance];
    }
    //NSLog(@"----------");
    BodyPart *bp = [_bodyParts objectAtIndex:0];
    _position = bp.position;
    _dir = bp.dir;
    //NSLog(@"px=%f pz=%f",_position.x,_position.y);
}
@end
