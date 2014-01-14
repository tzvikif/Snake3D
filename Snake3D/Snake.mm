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
//GLfloat SnakeCube_verticesY[] = {
//    // front
//    -0.125, -0.125,  0.125,
//    0.125, -0.125,  0.125,
//    0.125,  0.125,  0.125,
//    -0.125,  0.125,  0.125,
//    // top
//    -0.125,  0.125,  0.125,
//    0.125,  0.125,  0.125,
//    0.125,  0.125, -0.125,
//    -0.125,  0.125, -0.125,
//    // back
//    0.125, -0.125, -0.125,
//    -0.125, -0.125, -0.125,
//    -0.125,  0.125, -0.125,
//    0.125,  0.125, -0.125,
//    // bottom
//    -0.125, -0.125, -0.125,
//    0.125, -0.125, -0.125,
//    0.125, -0.125,  0.125,
//    -0.125, -0.125,  0.125,
//    // left
//    -0.125, -0.125, -0.125,
//    -0.125, -0.125,  0.125,
//    -0.125,  0.125,  0.125,
//    -0.125,  0.125, -0.125,
//    // right
//    0.125, -0.125,  0.125,
//    0.125, -0.125, -0.125,
//    0.125,  0.125, -0.125,
//    0.125,  0.125,  0.125,
//};

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

float lerp(float a,float b,float blend) {
    return  (blend*a + (1-blend)*b);
    
}
float bsf = 1.0/2.0;
@implementation Snake

-(void)initResources {
    _bpCount = 3;
    _totalTimeElapsed = 0;
    _velocityChanged = YES;
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    [self setBodyParts:ma];
    [ma release];
    Mesh *bodyMesh = [[Mesh alloc] init];
    Mesh *headMesh = [[Mesh alloc] init];
//    [meshCube loadVertices:SnakeCube_vertices
//                     color:SnakeCube_colors
//                   indices:SnakeCube_elements
//                indicesNumberOfElemets:sizeof(SnakeCube_elements)/sizeof(SnakeCube_elements[0])
//                verticesNumberOfElemets:SnakeCube_verticesYSize/sizeof(GLfloat)/3];
    [bodyMesh loadObjFromFile:@"snakeBP"];
    [headMesh loadObjFromFile:@"monkey"];
    Drawable *bodyDrwblTemp = [Drawable createDrawable:bodyMesh];
    Drawable *headDrwblTemp = [Drawable createDrawable:headMesh];
    Material *bodyMaterialTemp = [[Material alloc] init];
    Material *headMaterialTemp = [[Material alloc] init];
    [bodyMaterialTemp setupTexture:@"Reptiles0090_S.png"];
    [headMaterialTemp setupTexture:@"Reptiles0090_S.png"];
    BodyPart *bp;
    CC3Vector pos;
    _initScales = (CC3Vector*)malloc(sizeof(CC3Vector) * _bpCount);
    [self setPosition:CC3VectorMake(2.5, 0.5, 1.5)];
    //create head
    bp = [[BodyPart alloc] initializeWithProgram:self.program andDrawable:headDrwblTemp andMesh:headMesh andMaterial:headMaterialTemp andViewport:self.viewport];
    [bp setMyId:0];
    [bp setSpeed:_speed];
    [bp initResources];
    CC3Vector currentScale = CC3VectorMake(bsf, bsf, bsf);
    [bp setScaleFactor:CC3VectorMake(currentScale.x, currentScale.y, currentScale.z)];
    pos = _position;
    [bp setPosition:pos];
    [bp setViewMatrix:self.viewMatrix];
    [bp setProjectionMatrix:self.projectionMatrix];
    [_bodyParts addObject:bp];
    for (int i=1; i<_bpCount; i++) {
        bp = [[BodyPart alloc] initializeWithProgram:self.program andDrawable:bodyDrwblTemp andMesh:bodyMesh andMaterial:bodyMaterialTemp andViewport:self.viewport];
        [bp setMyId:i];
        [bp setSpeed:_speed];
        [bp initResources];
        CC3Vector currentScale = CC3VectorMake(bsf-i*0.02, bsf, bsf);
        _initScales[i] = currentScale;
        [bp setScaleFactor:CC3VectorMake(currentScale.x, currentScale.y, currentScale.z)];
        pos = _position;
        pos.z = _position.z + i;
        [bp setPosition:pos];
        [bp setViewMatrix:self.viewMatrix];
        [bp setProjectionMatrix:self.projectionMatrix];
        
        [_bodyParts addObject:bp];
    }
    [bodyMesh release];
    [headMesh release];
    [bodyMaterialTemp release];
    [headMaterialTemp release];
}
-(void)dealloc {
    [_bodyParts release];
    free(_initScales);
    [super dealloc];
}
-(void)Render {
    for (BodyPart *bp in _bodyParts) {
        [bp Render];
    }
    _velocityChanged = NO;
}
-(void)setDir:(DIRECTION)dir andAtPosition:(CC3Vector)pos{
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
}
-(BOOL)isCollideWithPosition:(CC3Vector)pos {
    //snake
    BOOL collisitionStatus = NO;
    for (int i=2; i<[_bodyParts count]; i++) {
        BodyPart *bp = [_bodyParts objectAtIndex:i];
        CC3Vector objPos = bp.position;
        TWODIGITS_FP(objPos.x);
        TWODIGITS_FP(objPos.z);
        TWODIGITS_FP(pos.x);
        TWODIGITS_FP(pos.z);
        if ((objPos.x - pos.x < 1.0 && objPos.x - pos.x > -1.0) && (objPos.z - pos.z < 1.0 && objPos.z - pos.z > -1.0)) {
            collisitionStatus = YES;
           
            NSLog(@"collision. objPos.x=%f objPos.z=%f pos.x=%f pos.z=%f",objPos.x,objPos.z,pos.x,pos.z);
            break;
        }
    }
    return collisitionStatus;
}
-(BOOL)isCollideWithWall {
    BOOL collisitionStatus = NO;
    BodyPart *bp = [_bodyParts objectAtIndex:0];
    CC3Vector objPos = bp.position;
    //in case N is even the right most point(the x axis) is N/2 - 1.
    if (objPos.x > trunc((N-1)/2.0) - 0.5 || objPos.x < -N/2.0 + 0.5 ||
        objPos.z > trunc((N-1)/2.0 - 0.5) || objPos.z < -N/2.0 + 0.5) {
        collisitionStatus = YES;
    }
    return collisitionStatus;
}
-(void)oops:(NSTimeInterval)timeElappsed{
    static float total = 0.3;
    if (_totalTimeElapsed >= total) {
        //_totalTimeElapsed = 0;
        for (BodyPart *bp in _bodyParts) {
            [bp setIsDrawEnabled:NO];
        }
        return;
    }
    
    _totalTimeElapsed += timeElappsed;
    if (_totalTimeElapsed > total) {
        _totalTimeElapsed = total;
    }
 
    float scaleX,scaleY,scaleZ;
    BodyPart *bp;
    for (int i=0; i<_bpCount; i++) {
        bp = [_bodyParts objectAtIndex:i];
        CC3Vector scaleFactor = _initScales[i];
        scaleX = lerp(0.0, scaleFactor.x, _totalTimeElapsed/total);
        scaleY = lerp(0, scaleFactor.y, _totalTimeElapsed/total);
        //scaleZ = lerp(0, scaleFactor.z, timeElappsed/total);
    
        scaleFactor = CC3VectorMake(scaleFactor.x, scaleY, scaleFactor.z);
        //NSLog(@"scaleX=%f scaleY=%f scaleZ=%f totalTime=%f",scaleX,scaleY,scaleFactor.z,_totalTimeElapsed);
        [bp setScaleFactor:scaleFactor];
    }
}
-(void)addBodyPart {
     BodyPart *tail = [_bodyParts objectAtIndex:[_bodyParts count]-1];
    BodyPart *lastObj = [tail copy];
    CC3Vector currentScale = CC3VectorMake(bsf-([_bodyParts count]-1)*0.02, bsf, bsf);
    CC3Vector *tempScale = (CC3Vector*)malloc(sizeof(CC3Vector) * ([_bodyParts count]+1));
    memcpy(tempScale, _initScales, sizeof(CC3Vector)*[_bodyParts count]);
    
    tempScale[[_bodyParts count]] = currentScale;
    free(_initScales);
    _initScales = tempScale;
    [lastObj setScaleFactor:CC3VectorMake(currentScale.x, currentScale.y, currentScale.z)];
    CC3Vector negVelocity = CC3VectorNegate(lastObj.velocity);
    CC3Vector one =  CC3VectorMake(!negVelocity.x?0:negVelocity.x<0?-1.0/negVelocity.x:1.0/negVelocity.x,
                  !negVelocity.y?0:negVelocity.y<0?-1.0/negVelocity.y:1.0/negVelocity.y,
                  !negVelocity.z?0:negVelocity.z<0?-1.0/negVelocity.z:1.0/negVelocity.z);
    CC3Vector scale = CC3VectorScale(negVelocity, one);
    CC3Vector newPartPos = CC3VectorAdd(lastObj.position,
                                        CC3VectorScale(negVelocity,one));
    [lastObj setPosition:newPartPos];
    [_bodyParts addObject:lastObj];
}
-(BOOL)isRotating {
    BodyPart *head = [_bodyParts objectAtIndex:0];
    return head.isRotating;
}
-(float)getRotationAngle {
    BodyPart *head = [_bodyParts objectAtIndex:0];
    return head.currentRotatoinAngle;
}
-(CC3Vector)getVelocity {
    BodyPart *head = _bodyParts[0];
    return head.velocity;
}
@end
