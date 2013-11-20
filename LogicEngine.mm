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
@end

@implementation LogicEngine

-(void)initialize:(CGRect)viewport {
    _viewport = viewport;
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
    [renderingEngineTemp initialize:viewport andProgram:_programs];
    [self setRenderingEngine:renderingEngineTemp];
    [renderingEngineTemp release];
    Mesh *floorMeshTemp = [[Mesh alloc] init];
    //sizeof(GLushort) verticesNumberOfElemets:sizeof(cube_vertices)/sizeof(GLfloat)];
    [self createFloor:floorMeshTemp];
    
    Drawable *DrwFloor =  [Drawable createDrawable:floorMeshTemp];
    Material *floorMaterialTemp = [[Material alloc] init];
    [floorMaterialTemp setupTexture:@"tile_floor.png"];
    Floor *floorObjTemp = [[Floor alloc] initializeWithProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_FLOOR]] andDrawable:DrwFloor andMesh:floorMeshTemp andMaterial:floorMaterialTemp andViewport:viewport];
    [floorMeshTemp release];
    [floorMaterialTemp release];
    Snake *snakeObjTemp = [[Snake alloc] init];
    [snakeObjTemp setPosition:CC3VectorMake(2.5, 0.5, 5.5)];
    [snakeObjTemp setSpeed:SNKspeed];
    [snakeObjTemp setProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_SNAKE]]];
    [_renderables addObject:snakeObjTemp];
    [_renderables addObject:floorObjTemp];
    
    [floorObjTemp release];
    [snakeObjTemp release];
    
    [_renderingEngine initResources:_renderables];
}
-(void)Render:(NSArray*)renderables; {
    [_renderingEngine Render:renderables];
}
-(void)Render {
    [_renderingEngine preRender];
    [self Render:_renderables];
    if (_currentFood) {
        [self Render:[NSArray arrayWithObject:_currentFood]];
    }
}
//updateAnimation: is called after Render()
//paramters: timeElapsed - time elapsed after last frame.
-(void)updateAnimation:(NSTimeInterval)timeElapsed {
    Snake *snk = [_renderables objectAtIndex:0];
    BOOL isCollide = [snk isCollideWithPosition:snk.position] || [snk isCollideWithWall];
    if (!isCollide) {
        [snk advance];
    }
    else {
        [snk oops:timeElapsed];
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
    Snake *snk = [_renderables objectAtIndex:0];
    CC3Vector pos = snk.position;
    
    DIRECTION currentDir = snk.dir;
    
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
        case DIR_UP:
            [snk setDir:DIR_UP andPosition:nextTurnPos];
            break;
        case DIR_DOWN:
            [snk setDir:DIR_DOWN andPosition:nextTurnPos];
            break;
        case DIR_LEFT:
            [snk setDir:DIR_LEFT andPosition:nextTurnPos];
            break;
        case DIR_RIGHT:
            [snk setDir:DIR_RIGHT andPosition:nextTurnPos];
            break;
        default:
            break;
    }
}
//-(ORIENTATION)getOrientation:(CC3Vector)pos; {
//    ORIENTATION tempOrien = ORTN_NONE;
//    if (pos.x > 0 && pos.z <= 0) {
//        tempOrien = ORTN_UR;
//    }
//    if (pos.x <= 0 && pos.z <= 0) {
//        tempOrien = ORTN_UL;
//    }
//    if (pos.x > 0 && pos.z > 0) {
//        tempOrien = ORTN_BR;
//    }
//    if (pos.x <= 0 && pos.z > 0) {
//        tempOrien = ORTN_BL;
//    }
//    if (tempOrien == ORTN_NONE) {
//        NSLog(@"new orientation error. x=%f z=%f", pos.x,pos.z);
//    }
//    return tempOrien;
//}
-(CC3Vector*)getOrientation:(CC3Vector)pos andVelocity:(CC3Vector)velocity {
    CC3Vector vn = CC3VectorNormalize(velocity);
    static CC3Vector lookAt[3];
    lookAt[LOOK_AT] = CC3VectorMake(pos.x-5.0*vn.x, 0,pos.z+5.0*vn.z);
    lookAt[UP] = CC3VectorMake(0.0, 1.0, 0.0);
    lookAt[EYE_AT] = CC3VectorMake(pos.x+10.0*vn.x, 10,pos.z-10.0*vn.z);
    return lookAt;
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
    Food *foodTemp = [[Food alloc] init];
    Mesh *foodMeshTemp = [[Mesh alloc] init];
    [foodMeshTemp loadVertices:cube_vertices
                         color:cube_colorsFood
                       indices:cube_elements
        indicesNumberOfElemets:cube_elementsSize/sizeof(GLushort)
       verticesNumberOfElemets:cube_verticesSize/sizeof(GLfloat)];
    Drawable *DrwFood =  [Drawable createDrawable:foodMeshTemp];
    Material *foodMaterialTemp = [[Material alloc] init];
    [foodMaterialTemp setupTexture:@"tile_floor.png"];
    [foodTemp initializeWithProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_SNAKE]]
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
        Snake *snk = [_renderables objectAtIndex:0];
        pos = CC3VectorMake(x<0?x+0.5:x-0.5, 0.5,z<0?z+0.5:z-0.5);
        BOOL isCollide = [snk isCollideWithPosition:pos];
        if (isCollide == NO) {
            emptySpot = YES;
        }
    }
    [foodTemp setPosition:pos];
    return [foodTemp autorelease];
}
-(BOOL)isFoodEaten:(CC3Vector)pos {
    Snake *snk = [_renderables objectAtIndex:0];
    BOOL isEaten = [snk isCollideWithPosition:pos];
    return isEaten;
}
-(void)dealloc {
    [_programs release];
    [_renderingEngine release];
    [_renderables release];
    [super dealloc];
}
@end
