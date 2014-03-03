//
//  LogicEngine.m
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import "LogicEngine.h"
//#import "Plotter.h"
#include "Consts.h"
#import "Floor.h"
#import "Snake.h"
#import "GLProgram.h"
#import "Vectors.h"
#import "Food.h"
#import "SkyBox.h"
#include <stdlib.h>
#import <math.h>

@interface LogicEngine ()
-(void)createFloor:(Mesh*)floorMesh;
//-(ORIENTATION)getOrientation:(CC3Vector)pos;
-(CC3Vector*)getOrientation:(CC3Vector)pos andVelocity:(CC3Vector)velocity;
-(void)updateSceneOrientation:(NSTimeInterval)timeElapsed;
-(Food*)createFood;
-(void)Render:(NSArray*)renderables;
-(BOOL)isFoodEaten:(CC3Vector)pos;
-(Snake*)getSnakeObj;
-(Snake*)initSnakeWithBPcount:(int)count;
@end

@implementation LogicEngine

-(void)initialize:(CGRect)viewport {
    _viewport = viewport;
    _gameStopped = NO;
    RenderingEngine *renderingEngineTemp = [[RenderingEngine alloc] init];
    _orient = ORTN_BR;
    _newOrient = ORTN_NONE;
    NSMutableArray *maTemp = [[NSMutableArray alloc] init];
    [self setRenderables:maTemp];
    [maTemp release];
    NSMutableDictionary *progs = [[NSMutableDictionary alloc] init];
    [self setPrograms:progs];
    [progs release];
    [self createProgramWithVertexShaderName:@"SimpleVertex"
                      andFragmentShaderName:@"SimpleFragment"
                                     withId:PROG_FLOOR];
    [self createProgramWithVertexShaderName:@"SbpVertex"
                      andFragmentShaderName:@"SbpFragment"
                                     withId:PROG_SNAKE];
    [self createProgramWithVertexShaderName:@"skybox"
                      andFragmentShaderName:@"skybox"
                                     withId:PROG_SKYBOX];
    [self createProgramWithVertexShaderName:@"food"
                      andFragmentShaderName:@"food"
                                     withId:PROG_FOOD];
    [renderingEngineTemp initialize:viewport andProgram:_programs];
    [self setRenderingEngine:renderingEngineTemp];
    [renderingEngineTemp release];
    Mesh *floorMeshTemp = [[Mesh alloc] init];
    //sizeof(GLushort) verticesNumberOfElemets:sizeof(cube_vertices)/sizeof(GLfloat)];
    //[self createFloor:floorMeshTemp];
    [self createSimpleFloor:floorMeshTemp];
    
    Drawable *DrwFloor =  [Drawable createDrawable:floorMeshTemp];
    Material *floorMaterialTemp = [[Material alloc] init];
    [floorMaterialTemp setupTexture:@"floorGrass.png"];
    Floor *floorObjTemp = [[Floor alloc] initializeWithProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_FLOOR]] andDrawable:DrwFloor andMesh:floorMeshTemp andMaterial:floorMaterialTemp andViewport:viewport];
    [floorMeshTemp release];
    [floorMaterialTemp release];
  
    SkyBox *sboxTemp = [self createSkyBox];
    Snake* snakeObjTemp = [self initSnakeWithBPcount:initNumberOfSnakeParts];
    [_renderables addObject:sboxTemp];
    [_renderables addObject:snakeObjTemp];
    [_renderables addObject:floorObjTemp];
    
    [floorObjTemp release];
    [snakeObjTemp release];
    [sboxTemp release];
    
    [_renderingEngine initResources:_renderables];
    }
-(void)Render:(NSArray*)renderables; {
    [_renderingEngine Render:renderables];
}
-(Snake*)initSnakeWithBPcount:(int)count {
    Snake *snakeObjTemp = [[Snake alloc] init];
    [snakeObjTemp setBpCount:count];
    [snakeObjTemp setPosition:CC3VectorMake(2.5, 0.5, 5.5)];
    [snakeObjTemp setSpeed:SNKspeed];
    [snakeObjTemp setProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_SNAKE]]];
    _currentVelocity = [snakeObjTemp getVelocity];
    return snakeObjTemp;
}
-(void)Render {
     if (self.isGameStopped) {
         return;
     }
    [_renderingEngine preRender];
    [self Render:_renderables];
    if (_currentFood) {
        [self Render:[NSArray arrayWithObject:_currentFood]];
    }
}
//updateAnimation: is called after Render()
//paramters: timeElapsed - time elapsed after last frame.
-(void)updateAnimation:(NSTimeInterval)timeElapsed {
    Snake *snk = [self getSnakeObj];
    if (!self.isGameStopped) {
        BOOL isCollide = [snk isCollideWithPosition:snk.position] || [snk isCollideWithWall];
        if (!isCollide) {
            [snk advance];
        }
        else {
            if ([snk oops:timeElapsed]) {
                _gameStopped = YES;
            };
        }
        CC3Vector *pnewOrientation = [self getOrientation:snk.position andVelocity:[snk getVelocity]];
        [_renderingEngine applyView:pnewOrientation to:_renderables];
        //[self updateSceneOrientation:timeElapsed];
        if (!_isFoodOnBoard) {
            Food *f = [self createFood];
            [f setProjectionMatrix:_renderingEngine.matProjection];
            [f setViewMatrix:_renderingEngine.matView];
            [f setViewport:_renderingEngine.viewport];
            [f initResources];
            [self setCurrentFood:f];
            _isFoodOnBoard = YES;
        }
        
        if ([self isFoodEaten:_currentFood.position]) {
            _isFoodOnBoard = NO;
            [_currentFood release];
            _currentFood = nil;
            [snk addBodyPart];
        }
    }
}
-(void)updateOffset_x:(GLfloat)delta {
    //    [_plotterObj setOffset_x:_plotterObj.offset_x+=delta];
}
-(void)updateScale:(GLfloat)delta {
    //    [_plotterObj setScale_xy:delta];
}
-(void)createFloor:(Mesh*)floorMesh {
    CC3Vector *floorGrid = (CC3Vector*)malloc(sizeof(CC3Vector) * N * N);
    float x,y,z;
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++) {
            x = (i - N / 2) / (N / 2.0);
            z = (j - N / 2) / (N / 2.0);
            y = 0;
            (floorGrid + i * N + j)->x = x;
            (floorGrid + i * N + j)->y = y;
            (floorGrid + i * N + j)->z = z;
            //NSLog(@"vertices: x=%f,y=%f,z=%f",x,y,z);
        }
    }
    //    GLushort *elements = malloc(sizeof(GLushort)* (N-1)*(N-1)*6);
    //    GLushort index = 0;
    //    for (int i=0; i< N-1; i++) {
    //        for (int j=0; j<N-1; j++) {
    //            elements[index+0] = (i+1)*N+j+0;
    //            elements[index+1] = i*N+j+1;
    //            elements[index+2] = i*N+j+0;
    //            elements[index+3] = (i+1)*N+j+0;
    //            elements[index+4] = (i+1)*N+j+1;
    //            elements[index+5] = i*N+j+1;
    //            index+=6;
    //        }
    //    }
    //draw grid
    GLushort *elements = (GLushort*)malloc(sizeof(GLushort)*(N)*(N-1)*2*2);
    GLushort index = 0;
    for (int c=0; c<N; c++) {
        for (int r=0; r<N-1; r++) {
            elements[index+0] = c*N + r;
            elements[index+1] = c*N + r + 1;
            index+=2;
        }
    }
    for (int r=0; r<N;r++) {
        for (int c=0; c<N-1; c++) {
            elements[index+0] = c*N + r;
            elements[index+1] = (c+1)*N + r;
            index+=2;
        }
    }
    
    [floorMesh loadVertices:(GLfloat*)floorGrid indices:elements indicesNumberOfElemets:N*(N-1)*4 verticesNumberOfElemets:N*N];
    
    free(floorGrid);
    free(elements);
}
-(void)createSimpleFloor:(Mesh*)floorMesh {
    CC3Vector *floorGrid = (CC3Vector*)malloc(sizeof(CC3Vector) * 4);
  
    GLfloat left = (0 - N / 2) / (N / 2.0);
    GLfloat right = ((N-1) - N / 2) / (N / 2.0);
    GLfloat far = (0 - N / 2) / (N / 2.0);
    GLfloat near = ((N-1) - N / 2) / (N / 2.0);
//    int left = -1;
//    int right = 1;
//    int far = -1;
//    int near = 1;
   
    GLfloat *texCoord =  (GLfloat*)malloc(sizeof(GLfloat) * 4*2);   //(x,y) * 4 vertices
    texCoord[0] =   0.0;
    texCoord[1] =   0.0;
    texCoord[2] =   1.0;
    texCoord[3] =   0.0;
    texCoord[4] =   1.0;
    texCoord[5] =   1.0;
    texCoord[6] =   0.0;
    texCoord[7] =   1.0;
    
    floorGrid[0].x = left;
    floorGrid[0].z = near;
    floorGrid[0].y = 0;
    
    floorGrid[1].x = right;
    floorGrid[1].z = near;
    floorGrid[1].y = 0;
    
    floorGrid[2].x = right;
    floorGrid[2].z = far;
    floorGrid[2].y = 0;
    
    floorGrid[3].x = left;
    floorGrid[3].z = far;
    floorGrid[3].y = 0;
    
    GLushort *elements = (GLushort*)malloc(sizeof(GLushort)*6);
    elements[0] = 0;
    elements[1] = 1;
    elements[2] = 2;
    elements[3] = 0;
    elements[4] = 2;
    elements[5] = 3;
    
//    [floorMesh loadVertices:(GLfloat*)floorGrid indices:elements indicesNumberOfElemets:6
//    verticesNumberOfElemets:4];
    
    [floorMesh loadVertices:(GLfloat*)floorGrid normals:(GLfloat*)floorGrid color:(GLfloat*)floorGrid texture:texCoord indices:elements indicesNumberOfElemets:6 verticesNumberOfElemets:4];
    
    free(floorGrid);
    free(elements);
}
//-(void)loadProgram:(GLProgram*)program {
//    [self setProgram1:program];
//}
-(BOOL)createProgramWithVertexShaderName:(NSString*)vsName andFragmentShaderName:(NSString*)fsName withId:(PROG_ID)progid {
    GLProgram *theProgram = [[GLProgram alloc] initWithVertexShaderFilename:vsName fragmentShaderFilename:fsName];
    if (![theProgram link])
    {
        NSLog(@"Link failed");
        
        NSString *progLog = [theProgram programLog];
        NSLog(@"Program Log: %@", progLog);
        
        NSString *fragLog = [theProgram fragmentShaderLog];
        NSLog(@"Frag Log: %@", fragLog);
        
        NSString *vertLog = [theProgram vertexShaderLog];
        NSLog(@"Vert Log: %@", vertLog);
        
        //[(GLView *)self.view stopAnimation];
        theProgram = nil;
    }
    else
    {
        [_programs setObject:theProgram forKey:[NSNumber numberWithInt:progid]];
        [theProgram release];
    }
    return (theProgram == nil)?NO:YES;
    
}
-(void)setDir:(DIRECTION)dir {
    Snake *snk = [self getSnakeObj];
    CC3Vector pos = snk.position;
    //CC3Vector velocity = [snk getVelocity];
    //CC3Vector vn = CC3VectorNegate(CC3VectorNormalize(velocity));
    DIRECTION currentDir = snk.dir;
    //next turn position
    float px = pos.x;
    float pz = pos.z;
    NSLog(@"in logicEngine. px=%f pz=%f",px,pz);
    float tpz,tpx;
    if (currentDir == DIR_UP) {
        tpz = roundf(pz);
        pz = tpz - 0.5;
    }
    if (currentDir == DIR_DOWN) {
        tpz = roundf(pz);
        pz = tpz + 0.5;
    }
    if (currentDir == DIR_LEFT) {
        tpx = roundf(px);
        px = tpx - 0.5;
    }
    if (currentDir == DIR_RIGHT) {
        tpx = roundf(px);
        px = tpx + 0.5;
    }
    NSLog(@"next turn pos: x=%f z=%f",px,pz);
    CC3Vector nextTurnPos = CC3VectorMake(px, 0.5, pz);
    switch (dir) {
        case DIR_LEFT:
            [snk setDir:(DIRECTION)((currentDir+1)%4) andAtPosition:nextTurnPos];
            break;
        case DIR_RIGHT:
//            rotationMat = [CC3GLMatrix identity];
//            [rotationMat rotateByY:-90.0];
//            velocity = [rotationMat multiplyByVector:velocity];
            [snk setDir:(DIRECTION)((currentDir+3)%4) andAtPosition:nextTurnPos];   //same as decrement 1
              break;
        default:
            break;
    }
}

-(CC3Vector*)getOrientation:(CC3Vector)pos andVelocity:(CC3Vector)velocity {
    Snake *snk = [self getSnakeObj];
   //NSLog(@"pos at:(%f,%f,%f)",pos.x,pos.y,pos.z);
    //CC3Vector vn = CC3VectorNormalize(velocity);
    CC3Vector eyeAt = CC3VectorMake(pos.x, 10,pos.z+10.0);
    CC3Vector lookAt =  CC3VectorMake(pos.x, 2,pos.z-5.0);
    static CC3Vector cameraSpace[3];
    float angle = [snk getRotationAngle];
//    if ([snk isRotating]) {
        angle = [snk getRotationAngle];

        //NSLog(@"angle:%f",angle);
//        NSLog(@"postion(%f,%f,%f",pos.x,pos.y,pos.z);
//        NSLog(@"before translation eyeAt(%f,%f,%f",eyeAt.x,eyeAt.y,eyeAt.z);
    CC3GLMatrix *rotationMat = [CC3GLMatrix identity];
    [rotationMat translateBy:pos];
    [rotationMat rotateByY:angle];

    [rotationMat translateBy:CC3VectorNegate(pos)];
    //[rotationMat print:@"rotation"];
    [rotationMat transpose];
    CC3Vector4 eyeAt4 = [rotationMat multiplyByVector:CC3Vector4Make(eyeAt.x, eyeAt.y, eyeAt.z, 1.0)];
    eyeAt.x = eyeAt4.x;
    eyeAt.y = eyeAt4.y;
    eyeAt.z = eyeAt4.z;
    CC3Vector4 lookAt4 = [rotationMat multiplyByVector:CC3Vector4Make(lookAt.x, 0, lookAt.z, 1.0)];
    lookAt.x = lookAt4.x;
    lookAt.y = lookAt4.y;
    lookAt.z = lookAt4.z;
//        NSLog(@"after translation eyeAt(%f,%f,%f",eyeAt.x,eyeAt.y,eyeAt.z);
//        {
//            CC3GLMatrix *rotationMat = [CC3GLMatrix identity];
//        
//            //[rotationMat translateBy:CC3VectorMake(0, 0, 10)];
//            [rotationMat rotateByY:90]; 
//            CC3Vector4 tempv4 = CC3Vector4Make(eyeAtTemp.x-pos.x, eyeAtTemp.y-pos.y, eyeAtTemp.z-pos.z, 1);
//            
//            CC3Vector4 test = [rotationMat multiplyByVector:tempv4];
//            CC3Vector test3 = CC3VectorAdd(CC3VectorMake(test.x, test.y, test.z), CC3VectorMake(pos.x, pos.y, pos.z));
//            //[rotationMat print:@"test"];
//            NSLog(@"test  eyeAt(%f,%f,%f#",test3.x,test3.y,test3.z);
//        }
    
        
  //  }
    cameraSpace[LOOK_AT] = lookAt;
    cameraSpace[UP] = CC3VectorMake(0.0, 1.0, 0.0);
    cameraSpace[EYE_AT] = eyeAt;
    //NSLog(@"eye at:(%f,%f,%f)",eyeAt.x,eyeAt.y,eyeAt.z);
    return cameraSpace;
}

-(void)updateSceneOrientation:(NSTimeInterval)timeElapsed {
    _orientationTimeElapsed += timeElapsed;
    if (_orientationTimeElapsed > totalOrientationTime) {
        _orientationTimeElapsed = 0;
        _orient = _newOrient;
        _newOrient = ORTN_NONE;
    }
    CC3Vector slookAt,seyeAt,sup;   //source
    CC3Vector dlookAt,deyeAt,dup;   //destination
    CC3Vector clookAt,ceyeAt,cup;   //current
    switch (_orient) {
        case ORTN_UL:
            slookAt = ul_lookAt;
            seyeAt = ul_eyeAt;
            sup = ul_up;
            break;
        case ORTN_UR:
            slookAt = ur_lookAt;
            seyeAt = ur_eyeAt;
            sup = ur_up;
            break;
        case ORTN_BL:
            slookAt = bl_lookAt;
            seyeAt = bl_eyeAt;
            sup = bl_up;
            break;
        case ORTN_BR:
            slookAt = br_lookAt;
            seyeAt = br_eyeAt;
            sup = br_up;
            break;
        default:
            NSException* myException = [NSException
                                        exceptionWithName:@"orientation error"
                                        reason:[NSString stringWithFormat:@"%d: invalid orientation",_orient]
                                        userInfo:nil];
            @throw myException;
            break;
            break;
    }
    
    switch (_newOrient) {
        case ORTN_UL:
            dlookAt = ul_lookAt;
            deyeAt = ul_eyeAt;
            dup = ul_up;
            break;
        case ORTN_UR:
            dlookAt = ur_lookAt;
            deyeAt = ur_eyeAt;
            dup = ur_up;
            break;
        case ORTN_BL:
            dlookAt = bl_lookAt;
            deyeAt = bl_eyeAt;
            dup = bl_up;
            break;
        case ORTN_BR:
            dlookAt = br_lookAt;
            deyeAt = br_eyeAt;
            dup = br_up;
            break;
        case ORTN_NONE:
            //nothing to do.
            break;
        default:
            NSException* myException = [NSException
                                        exceptionWithName:@"orientation error"
                                        reason:[NSString stringWithFormat:@"%d: invalid new orientation",_newOrient]
                                        userInfo:nil];
            @throw myException;
            break;
    }
    clookAt = CC3VectorLerp(slookAt, dlookAt, _orientationTimeElapsed/totalOrientationTime);
    ceyeAt = CC3VectorLerp(seyeAt, deyeAt, _orientationTimeElapsed/totalOrientationTime);
    cup = CC3VectorLerp(sup, dup, _orientationTimeElapsed/totalOrientationTime);
    CC3Vector arr[3];
    arr[0] = clookAt;
    arr[1] = ceyeAt;
    arr[2] = cup;
    //NSLog(@"_orientationTimeElapsed=%f eyeAtX=%f eyeAtZ=%f",_orientationTimeElapsed,ceyeAt.x,ceyeAt.z);
    
    [_renderingEngine applyView:arr to:_renderables];
    
}
-(void)updateSceneOrientation {
    
}
-(Food*)createFood {
    Food *foodObj = [[Food alloc] init];
    Mesh *foodMeshTemp = [[Mesh alloc] init];
    [foodMeshTemp loadObjFromFileWithUV:@"mushroom"];
//    [foodMeshTemp loadVertices:cube_vertices
//                         color:cube_colorsFood
//                       indices:cube_elements
//        indicesNumberOfElemets:cube_elementsSize/sizeof(GLushort)
//       verticesNumberOfElemets:cube_verticesSize/sizeof(GLfloat)];
    Drawable *DrwFood =  [Drawable createDrawable:foodMeshTemp];
    Material *foodMaterialTemp = [[Material alloc] init];
    [foodMaterialTemp setupTexture:@"mushroom.png"];
    //[foodMaterialTemp setupTexture:@"tile_floor.png"];
    [foodObj initializeWithProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_FOOD]]
                        andDrawable:DrwFood
                            andMesh:foodMeshTemp andMaterial:foodMaterialTemp
                        andViewport:_viewport];
    
    BOOL emptySpot = NO;
    CC3Vector pos;
    int x,z;
    while (!emptySpot) {
        x = arc4random() % N;
        x -= truncf( (N+1)/2.0 );
        z = arc4random() % N;
        z -= truncf( (N+1)/2.0 );
        Snake *snk = [self getSnakeObj];
        pos = CC3VectorMake(x<0?x+0.5:x-0.5, 0.5,z<0?z+0.5:z-0.5);
        BOOL isCollide = [snk isCollideWithPosition:pos];
        if (isCollide == NO) {
            emptySpot = YES;
        }
    }
    [foodObj setPosition:pos];
    return [foodObj autorelease];
}
-(SkyBox*)createSkyBox {
    
    Mesh *msh = [[Mesh alloc] init];
    [msh loadVertices:cube_vertices
        texture:cube_texcoords
        indices:cube_elements
        indicesNumberOfElemets:cube_elementsSize/sizeof(cube_elements[0])
        verticesNumberOfElemets:cube_verticesSize/sizeof(cube_vertices[0])];
    Drawable *dr =  [Drawable createDrawable:msh];
    Material *mtxpos = [[Material alloc] init];
    Material *mtxneg = [[Material alloc] init];
    Material *mtypos = [[Material alloc] init];
    Material *mtyneg = [[Material alloc] init];
    Material *mtzpos = [[Material alloc] init];
    Material *mtzneg = [[Material alloc] init];

    [mtxpos setupTexture:@"xpos.png"];
    [mtxneg setupTexture:@"xneg.png"];
    [mtypos setupTexture:@"ypos.png"];
    [mtyneg setupTexture:@"yneg.png"];
    [mtzpos setupTexture:@"zpos.png"];
    [mtzneg setupTexture:@"zneg.png"];

    SkyBox *sb = [[SkyBox alloc] initializeWithProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_SKYBOX]]
                                           andDrawable:dr andMesh:msh andMaterial:nil andViewport:_viewport];
    [msh release];
    NSMutableDictionary *mtrDic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:mtxpos,mtxneg,mtypos,mtyneg,mtzpos,mtzneg,nil]
                                                                       forKeys:[NSArray arrayWithObjects:
                                                                                [NSNumber numberWithInt:GL_TEXTURE_CUBE_MAP_POSITIVE_X],
                                                                                [NSNumber numberWithInt:GL_TEXTURE_CUBE_MAP_NEGATIVE_X],
                                                                                [NSNumber numberWithInt:GL_TEXTURE_CUBE_MAP_POSITIVE_Y],
                                                                                [NSNumber numberWithInt:GL_TEXTURE_CUBE_MAP_NEGATIVE_Y],
                                                                                [NSNumber numberWithInt:GL_TEXTURE_CUBE_MAP_POSITIVE_Z],
                                                                                [NSNumber numberWithInt:GL_TEXTURE_CUBE_MAP_NEGATIVE_Z],
                                                                                nil]];
    //[sb setMoreMaterials:mtrDic];
    [sb setMaterials:mtrDic];
    [mtrDic release];
    [mtxpos release];
    [mtxneg release];
    [mtypos release];
    [mtyneg release];
    [mtzpos release];
    [mtzneg release];
    
    return sb;
}
-(DIRECTION)getDirectionFromVelocity:(CC3Vector)v {
    return DIR_DOWN;
}
-(BOOL)isFoodEaten:(CC3Vector)pos {
    Snake *snk =  [self getSnakeObj];
    BOOL isEaten = [snk isCollideWithPosition:pos];
    return isEaten;
}
-(void)btnContinueClicked {
    Snake *snake = [self getSnakeObj];
    Snake *newSnake = [self initSnakeWithBPcount:snake.bpCount];
    [_renderables removeObject:snake];
    [_renderables addObject:newSnake];
    
    _gameStopped = NO;
}
-(void)btnStartOverClicked {
    Snake *snake = [self getSnakeObj];
    Snake *newSnake = [self initSnakeWithBPcount:initNumberOfSnakeParts];
    [_renderables removeObject:snake];
    [_renderables addObject:newSnake];
    
    _gameStopped = NO;
}

-(Node*)getSnakeObj {
    Snake *snake;
    for (Node *obj in _renderables) {
        if ([obj isKindOfClass:[Snake class]]) {
            snake = (Snake*)obj;
            break;
        }
    }
    return snake;
}
-(void)dealloc {
    [_programs release];
    [_renderingEngine release];
    [_renderables release];
    [super dealloc];
}
@end
