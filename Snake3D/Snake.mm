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
    _bpCount = 1;
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    [self setBodyParts:ma];
    [ma release];
    Mesh *meshCube = [[Mesh alloc] init];
    [meshCube loadVertices:SnakeCube_vertices color:SnakeCube_colors indices:SnakeCube_elements indicesNumberOfElemets:sizeof(SnakeCube_elements)/sizeof(GLushort)
   verticesNumberOfElemets:sizeof(SnakeCube_vertices)/sizeof(GLfloat)/3];
    Drawable *drwblTemp = [Drawable createDrawable:meshCube];
    Material *materialTemp = [[Material alloc] init];
    BodyPart *bp = [[BodyPart alloc] initializeWithProgram:self.program1 andDrawable:drwblTemp andMesh:meshCube andMaterial:materialTemp andViewport:self.viewport];
    [bp setScaleFactor:2.0];
    [bp setPosition:CC3VectorMake(10.5, 1.0, 10.5)];
    [bp setVelocity:CC3VectorMake(0, 0, 0.5)];
    [bp setViewMatrix:self.viewMatrix];
    [bp setProjectionMatrix:self.projectionMatrix];
    [bp initResources];
    [_bodyParts addObject:bp];
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
}
@end
