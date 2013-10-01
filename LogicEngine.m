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

@interface LogicEngine ()
-(void)createFloor:(Mesh*)floorMesh;
@end

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

-(void)initialize:(CGRect)viewport andProgram:(GLProgram *)program{
    RenderingEngine *renderingEngineTemp = [[RenderingEngine alloc] init];
    NSMutableArray *maTemp = [[NSMutableArray alloc] init];
    [self setRenderables:maTemp];
    [maTemp release];
    [renderingEngineTemp initialize:viewport andProgram:program];
    [self setRenderingEngine:renderingEngineTemp];
    [renderingEngineTemp release];
    Mesh *floorMeshTemp = [[Mesh alloc] init];
    //sizeof(GLushort) verticesNumberOfElemets:sizeof(cube_vertices)/sizeof(GLfloat)];
    [self createFloor:floorMeshTemp];
    
    Drawable *DrwFloor =  [Drawable createDrawable:floorMeshTemp];
    Material *floorMaterialTemp = [[Material alloc] init];
    [floorMaterialTemp setupTexture:@"tile_floor.png"];
    Floor *floorObjTemp = [[Floor alloc] initializeWithProgram:program andDrawable:DrwFloor andMesh:floorMeshTemp
                                                   andMaterial:floorMaterialTemp andViewport:viewport]; //Node
    [floorMeshTemp release];
    [floorMaterialTemp release];
    Snake *snakeObj = [[Snake alloc] init];
    //[_renderables addObject:floorObjTemp];
    [_renderables addObject:snakeObj];
    [snakeObj release];
    [floorObjTemp release];
    [_renderingEngine initResources:_renderables];
}
-(void)Render {
    [_renderingEngine Render:_renderables];
}
-(void)updateAnimation:(float)elapsedSeconds {
    
}
-(void)updateOffset_x:(GLfloat)delta {
//    [_plotterObj setOffset_x:_plotterObj.offset_x+=delta];
}
-(void)updateScale:(GLfloat)delta {
//    [_plotterObj setScale_xy:delta];
}
-(CC3Vector*)createGraph {
    CC3Vector *graph = malloc(sizeof(CC3Vector) * N * N);
    
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++) {
            float x = (i - N / 2) / (N / 2.0);
            float y = (j - N / 2) / (N / 2.0);
            float t = hypotf(x, y) * 4.0;
            float z = (1 - t * t) * expf(t * t / -2.0);
            (graph + i * N + j)->x = x;
            (graph + i * N + j)->y = y;
            (graph + i * N + j)->z = z;
        }
        
    }    return  graph;
}
-(void)createFloor:(Mesh*)floorMesh {
    CC3Vector *floorGrid = malloc(sizeof(CC3Vector) * N * N);
    float x,y,z;
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++) {
            x = (i - N / 2) / (N / 2.0);
            y = (j - N / 2) / (N / 2.0);
            z = 0;
            (floorGrid + i * N + j)->x = x;
            (floorGrid + i * N + j)->y = z;
            (floorGrid + i * N + j)->z = y;
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
    GLushort *elements = malloc(sizeof(GLushort)*(N)*(N-1)*2*2);
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
  //  [floorMesh loadVertices:(GLfloat*)floorGrid indices:elements indicesNumberOfElemets:(N-1)*N*6 verticesNumberOfElemets:N*N];
    //[floorMesh loadVertices:(GLfloat*)floorGrid indices:elements indicesNumberOfElemets:(N-1)*(N-1)*6 verticesNumberOfElemets:(N)*(N)];
    [floorMesh loadVertices:(GLfloat*)floorGrid indices:elements indicesNumberOfElemets:N*(N-1)*4 verticesNumberOfElemets:(N)*(N)];
    
    free(floorGrid);
    free(elements);
}
-(void)loadProgram:(GLProgram*)program {
    [self setProgram1:program];
}
-(void)dealloc {
    [_program1 release];
    [_renderingEngine release];
    [_renderables release];
    [super dealloc];
}
@end
