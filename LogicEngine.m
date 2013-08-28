//
//  LogicEngine.m
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import "LogicEngine.h"
#import "Plotter.h"
#include "Consts.h"


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
    -1.0, -1.0,  1.0,
    1.0, -1.0,  1.0,
    1.0,  1.0,  1.0,
    -1.0,  1.0,  1.0,
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
    [renderingEngineTemp initialize:viewport andProgram:program];
    [self setRenderingEngine:renderingEngineTemp];
    [renderingEngineTemp release];
    Mesh *plotMesh = [[Mesh alloc] init];
    CC3Vector *graph = [self createGraph];
    [plotMesh loadVertices:(GLfloat*)graph indices:NULL indicesNumberOfElemets:0 verticesNumberOfElemets:N];
    free(graph);
    [self setPlotterMesh:plotMesh];
    [plotMesh release];
    Drawable *plotDrawable =  [RenderingEngine createDrawable:plotMesh];
    Material *plotMaterial = [[Material alloc] init];
    //[cubeMaterial setupTexture:@"uvtemplate.bmp"];
    Plotter *plotterTemp = [[Plotter alloc] initializeWithProgram:program andDrawable:plotDrawable andVertexStruct:plotMesh.vertexStruct andMaterial:plotMaterial]; //Node
    [plotterTemp preRender];
    [self setPlotterObj:plotterTemp];
    [plotterTemp release];
    [plotDrawable release];
}
-(void)Render {
    
    [_renderingEngine Render:_plotterObj];
}
-(void)updateAnimation:(float)elapsedSeconds {
    
}
-(CC3Vector*)createGraph {
    CC3Vector *graph = malloc(sizeof(CC3Vector) * N);
    
    for(int i = N/2; i < N; i++) {
        float x = (i - N/2.0) / 1000.0;
        graph[i].x = x;
        graph[i].y = sin(x * 10.0) / (1.0 + x * x);
        graph[i].z = -0.5;
        NSLog(@"x=%f f(x)=%f",graph[i].x,graph[i].y);
    }
    return  graph;
}
-(void)loadProgram:(GLProgram*)program {
    [self setProgram1:program];
}
-(void)dealloc {
    [_program1 release];
    [_plotterObj release];
    [_plotterMesh release];
    [_renderingEngine release];
    [super dealloc];
}
@end
