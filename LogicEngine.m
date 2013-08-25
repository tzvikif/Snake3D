//
//  LogicEngine.m
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import "LogicEngine.h"
#import "SimpleCube.h"

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
    -0.5, -0.5,  0.5,
    0.5, -0.5,  0.5,
    0.5,  0.5,  0.5,
    -0.5,  0.5,  0.5,
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
    //[simpleCubeTemp initialize];
    //load cube mesh
    Mesh *cubeMesh = [[Mesh alloc] init];
//    [cubeMesh loadVertices:cube_vertices normals:cube_normals color:cube_colors Texture:cube_texcoords indices:cube_elements indicesNumberOfElemets:sizeof(cube_elements)/sizeof(GLushort) verticesNumberOfElemets:sizeof(cube_vertices)/sizeof(GLfloat)];
    [cubeMesh loadVertices:cube_vertices color:cube_colors indices:cube_elements indicesNumberOfElemets:sizeof(cube_elements)/sizeof(GLushort) verticesNumberOfElemets:sizeof(cube_vertices)/sizeof(GLfloat)];
    [self setCubeMesh:cubeMesh];
    [cubeMesh release];
    Drawable *cubeDrawable =  [renderingEngineTemp createDrawable:cubeMesh];
    SimpleCube *simpleCubeTemp = [[SimpleCube alloc] initializeWithProgram:program andDrawable:cubeDrawable andVertexStruct:cubeMesh.vertexStruct]; //Node
    [simpleCubeTemp preRender];
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
