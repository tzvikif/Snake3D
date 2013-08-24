//
//  LogicEngine.m
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import "LogicEngine.h"
#import "SimpleCube.h"

GLfloat cube_vertices[] = {
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
GLfloat cube_colors[] = {
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
GLushort cube_elements[] = {
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
    [renderingEngineTemp setProgram1:_program1];
    [renderingEngineTemp initialize:viewport];
    [self setRenderingEngine:renderingEngineTemp];
    [renderingEngineTemp release];
    SimpleCube *simpleCubeTemp = [[SimpleCube alloc] init]; //Node
    [simpleCubeTemp initialize];
    //load cube mesh
    Mesh *cubeMesh = [[Mesh alloc] init];
    [cubeMesh loadVertices:cube_vertices normals:cube_normals color:cube_colors Texture:cube_texcoords indices:cube_elements indicesNumberOfElemets:sizeof(cube_elements)/sizeof(GLushort) verticesNumberOfElemets:sizeof(cube_vertices)/sizeof(GLfloat)];
    [self setCubeMesh:cubeMesh];
    [cubeMesh release];
    Drawable *cubeDrawable =  [renderingEngineTemp createDrawable:cubeMesh];
    [simpleCubeTemp setDrawable:cubeDrawable];
    [self setSimpleCube:simpleCubeTemp];
    [simpleCubeTemp release];
    [cubeDrawable release];
    
}
-(void)Render {
    
    [_renderingEngine Render:_simpleCube];
}
-(void)updateAnimation:(float)elapsedSeconds {
    
}
-(void)loadProgram:(GLProgram*)program {
    [self setProgram1:program];
}
-(void)dealloc {
    [_program1 release];
    [_simpleCube release];
    [_cubeMesh release];
    [_renderingEngine release];
    [super dealloc];
}
@end
