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
#import <math.h>

@interface LogicEngine ()
-(void)createFloor:(Mesh*)floorMesh;
-(ORIENTATION)getOrientation:(CC3Vector)pos;
-(void)updateSceneOrientation:(NSTimeInterval)timeElapsed;
@end
float speed = 0.05;
//UL
CC3Vector ul_lookAt = CC3VectorMake(-8.0, 1.0, -8.0);
CC3Vector ul_eyeAt = CC3VectorMake(-8.0, 8.0, 8.0);
CC3Vector ul_up = CC3VectorMake(0.0, 1.0, 0.0);
//UR
CC3Vector ur_lookAt = CC3VectorMake(8.0, 1.0, -8.0);
CC3Vector ur_eyeAt = CC3VectorMake(8.0, 8.0, 8.0);
CC3Vector ur_up = CC3VectorMake(0.0, 1.0, 0.0);
//BL
CC3Vector bl_lookAt = CC3VectorMake(-8.0, 1.0, 0.0);
CC3Vector bl_eyeAt = CC3VectorMake(-8.0, 8.0, 22.0);
CC3Vector bl_up = CC3VectorMake(0.0, 1.0, 0.0);
//BR
CC3Vector br_lookAt = CC3VectorMake(8.0, 1.0, 0.0);
CC3Vector br_eyeAt = CC3VectorMake(8.0, 8.0, 22.0);
CC3Vector br_up = CC3VectorMake(0.0, 1.0, 0.0);
GLfloat cube_verticesX[] = {
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
GLfloat cube_vertices[] = {
    // front
    -1.0, -1.0,  -0.5,
    1.0, -1.0,  -0.5,
    0.0,  1.0,  -0.5,
    -1.0,  1.0,  -0.5,
};
GLfloat cube_colorsX[] = {
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
GLushort cube_elementsX[] = {
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
GLushort cube_elements[] = {
    // front
    0,  1,  2,
    2,  3,  0,
 };
GLfloat cube_colors[] = {
    // front colors
    1.0, 0.0, 0.3,
    0.2, 1.0, 0.0,
    0.0, 1.0, 1.0,
    0.3, 1.0, 0.7,
};

GLfloat cube_texcoords[2*4*6] = {
    // front
    0.0, 0.0,
    1.0, 0.0,
    1.0, 1.0,
    0.0, 1.0,
};
GLfloat cube_normals[] = {
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,4.000000,0.000000,
    
    -0.000000,4.000000,0.000000,
    
    0.000000,4.000000,0.000000,
    
    0.000000,4.000000,0.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    -0.000000,-4.000000,0.000000,
    
    0.000000,-4.000000,0.000000,
    
    -0.000000,-4.000000,0.000000,
    
    -0.000000,-4.000000,0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    -4.000000,0.000000,0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,0.000000,
    
    4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,-0.000000
};

@implementation LogicEngine

-(void)initialize:(CGRect)viewport {
    RenderingEngine *renderingEngineTemp = [[RenderingEngine alloc] init];
    _orient = ORTN_UR;
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
    [snakeObjTemp setSpeed:speed];
    [snakeObjTemp setProgram:[_programs objectForKey:[NSNumber numberWithInt:PROG_SNAKE]]];
    [_renderables addObject:snakeObjTemp];
    [_renderables addObject:floorObjTemp];
    
    [floorObjTemp release];
    [snakeObjTemp release];
    
    [_renderingEngine initResources:_renderables];
}
-(void)Render {
    [_renderingEngine Render:_renderables];
}
//updateAnimation: is called after Render()
//paramters: timeElapsed - time elapsed after last frame.
-(void)updateAnimation:(NSTimeInterval)timeElapsed {
    Snake *snk = [_renderables objectAtIndex:0];
    BOOL isCollide = [snk isCollideWithPosition:snk.position];
    if (!isCollide) {
        [snk advance];
    }
    else {
        [snk oops:timeElapsed];
    }
    if (_newOrient != ORTN_NONE) {
        _orient = _newOrient;
        [self updateSceneOrientation:timeElapsed];
    }
    else
    {
        ORIENTATION snakeOrientation = [self getOrientation:snk.position];
        if (_orient != snakeOrientation) {
            _newOrient = snakeOrientation;
            NSLog(@"new orientation:%d",_newOrient);
        }
    }
}
-(void)updateOffset_x:(GLfloat)delta {
//    [_plotterObj setOffset_x:_plotterObj.offset_x+=delta];
}
-(void)updateScale:(GLfloat)delta {
//    [_plotterObj setScale_xy:delta];
}
//-(CC3Vector*)createGraph {
//    CC3Vector *graph = malloc(sizeof(CC3Vector) * N * N);
//    
//    for(int i = 0; i < N; i++) {
//        for(int j = 0; j < N; j++) {
//            float x = (i - N / 2) / (N / 2.0);
//            float y = (j - N / 2) / (N / 2.0);
//            float t = hypotf(x, y) * 4.0;
//            float z = (1 - t * t) * expf(t * t / -2.0);
//            (graph + i * N + j)->x = x;
//            (graph + i * N + j)->y = y;
//            (graph + i * N + j)->z = z;
//        }
//        
//    }    return  graph;
//}
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

//    NSMutableString *str = [[NSMutableString alloc] init];
//    for (int i=0; i<(N-1)*(N-1)*6; i++) {
//        if (i%6 == 0) {
//            [str appendString:@"\n"];
//        }
//        
//        
//        if (i%3 == 0) {
//            [str appendFormat:@"%d",elements[i]];
//            [str appendString:@" "];
//            
//        }
//        else {
//            [str appendFormat:@"%d,",elements[i]];
//        }
//    }
//    NSLog(@"%@",str);
    //[floorMesh loadVertices:(GLfloat*)cube_vertices indices:cube_elements indicesNumberOfElemets:sizeof(cube_elements)/sizeof(cube_elements[0]) verticesNumberOfElemets:sizeof(cube_vertices)/sizeof(cube_vertices[0])];
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
//    px = px<0?-px:px;
//    
//    pz = pz<0?-pz:pz;
//    px*=100;
//    pz*=100;
//    px = roundf(px);
//    pz = roundf(pz);
//    px = truncf(px);
//    pz = truncf(pz);
//    px /= 100.0;
//    pz /= 100.0;
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
-(ORIENTATION)getOrientation:(CC3Vector)pos; {
    ORIENTATION tempOrien;
    if (pos.x > 0 && pos.z < 0) {
        tempOrien = ORTN_UR;
    }
    if (pos.x < 0 && pos.z < 0) {
        tempOrien = ORTN_UL;
    }
    if (pos.x > 0 && pos.z > 0) {
        tempOrien = ORTN_BR;
    }
    if (pos.x < 0 && pos.z > 0) {
        tempOrien = ORTN_BL;
    }
    return tempOrien;
}
-(void)updateSceneOrientation:(NSTimeInterval)timeElapsed {
    _orientationTimeElapsed += timeElapsed;
    NSLog(@"_orientationTimeElapsed:%f",_orientationTimeElapsed);
    if (_orientationTimeElapsed > totalOrientationTime) {
        _orientationTimeElapsed = 0;
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
        default:
            break;
    }
    clookAt = CC3VectorLerp(slookAt, dlookAt, _orientationTimeElapsed/totalOrientationTime);
    ceyeAt = CC3VectorLerp(seyeAt, deyeAt, _orientationTimeElapsed/totalOrientationTime);
    cup = CC3VectorLerp(sup, dup, _orientationTimeElapsed/totalOrientationTime);
    CC3Vector arr[3];
    arr[0] = clookAt;
    arr[1] = ceyeAt;
    arr[2] = cup;
    NSLog(@"_orientationTimeElapsed=%f eyeAtX=%f eyeAtZ=%f",_orientationTimeElapsed,ceyeAt.x,ceyeAt.z);
    [_renderingEngine applyView:arr to:_renderables];
    
}
-(void)dealloc {
    [_programs release];
    [_renderingEngine release];
    [_renderables release];
    [super dealloc];
}
@end
