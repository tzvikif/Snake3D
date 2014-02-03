    //
//  Mesh.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "Mesh.h"
#import "CC3Foundation.h"
#import "CC3Math.h"
#import "CC3GLMatrix.h"
#import "LoadObj.h"

@implementation Mesh
-(id)init {
    if ([super init]) {
        _vnoe = 0;
        _vertices = NULL;
        _indices = NULL;
        _inoe = 0;
    }
    return self;
}
-(void)dealloc {
    if (_vertices) {
        free(_vertices);
    }
    if (_indices) {
        free(_indices);
    }
    [super dealloc];
}
-(size_t)sizeofVertices {
    switch(_vertexStruct) {
        case PNCT:
            return  _vnoe * sizeof(VertexPNCT);
            break;
        case PNC:
            return _vnoe * sizeof(VertexPNC);
            break;
        case PC:
            return _vnoe * sizeof(VertexPC);
            break;
        case PT:
            return _vnoe * sizeof(VertexPT);
            break;
        case P:
            return _vnoe * sizeof(CC3Vector);
            break;
        default:
            NSLog(@"in Mesh: bad vertex struct  :%d",_vertexStruct);
            return 0;
            break;
    }
}
-(size_t)sizeofIndices {
    return _inoe * sizeof(GLushort);
}
-(void)loadVertices:(const GLfloat*)v
            indices:(const GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe {
    CC3Vector *verticesTemp = (CC3Vector*)malloc( sizeof(CC3Vector) * ( vnoe ));
    _indices = NULL;
    if (inoe > 0) {
        _indices = (GLushort*)malloc(inoe*sizeof(GLushort));
        memcpy(_indices, elements, inoe*sizeof(GLushort));
    }
    int index = 0;
    _vertices = (GLfloat*)verticesTemp;
    for (int i=0; i<vnoe*3; i+=3) {
        CC3Vector vertex;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
              
        verticesTemp[i/3] = vertex;
        index++;
    }
    _vnoe = vnoe;
    _inoe = inoe;
    _vertexStruct = P;

}
-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            indices:(GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe {
    VertexPNC *verticesTemp = (VertexPNC*)malloc( sizeof(VertexPNC) * ( vnoe ));
    
    _indices = (GLushort*)malloc(inoe*sizeof(GLushort));
    for (int i=0; i<vnoe*3; i+=3) {
        CC3Vector vertex;
        CC3Vector normal;
        CC3Vector color;
        VertexPNC vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        normal.x = n[i+0];
        normal.y = n[i+1];
        normal.z = n[i+2];
        
        color.x = c[i+0];
        color.y = c[i+1];
        color.z = c[i+2];
        
        vstruct.position = vertex;
        vstruct.normal = normal;
        vstruct.color = color;
        verticesTemp[i/3] = vstruct;
    }
    memcpy(_indices, elements, inoe*sizeof(GLushort));
    _vnoe = vnoe;
    _inoe = inoe;
    _vertexStruct = PNC;

}
//-(void)loadObjFromFile:(NSString *)name {
//    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"obj"];
//    LoadObj *bp = [[LoadObj alloc] initWithPath:path];
//    [self loadVertices:(GLfloat*)bp->_arrVertices
//               normals:NULL
//                 color:NULL
//               texture:bp->_arrTexture
//               indices:bp->_arrElements
//                indicesNumberOfElemets:bp->_numberOfFaces*3
//                verticesNumberOfElemets:bp->_numberOfVertices];
//}
-(void)loadObjFromFile:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"obj"];
    LoadObj *bp = [[LoadObj alloc] initWithPath:path];
    GLfloat *normals = [self computeNormalsWithElements:bp->_arrElements noe:bp->_numberOfFaces*3 andVertices:(GLfloat*)bp->_arrVertices nov:bp->_numberOfVertices andAverage:YES];
//     [self loadVertices:(const GLfloat*)bp->_arrVertices
//                 color:(const GLfloat*)bp->_arrVertices
//               indices:bp->_arrElements
//                indicesNumberOfElemets:bp->_numberOfFaces*3
//                verticesNumberOfElemets:bp->_numberOfVertices];
    [self loadVertices:(GLfloat*)bp->_arrVertices
               normals:(GLfloat*)normals
                 color:(GLfloat*)bp->_arrVertices
               indices:bp->_arrElements
                indicesNumberOfElemets:bp->_numberOfFaces*3
                verticesNumberOfElemets:bp->_numberOfVertices];
}
-(void)loadObjFromFileWithUV:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"obj"];
    LoadObj *bp = [[LoadObj alloc] initWithPath:path];
    //[bp displayArrays];
    [self loadVertices:(const GLfloat*)bp->_arrVertices texture:bp->_arrTexture indices:bp->_arrElements indicesNumberOfElemets:bp->_numberOfFaces*3 verticesNumberOfElemets:bp->_numberOfVertices];
}

-(void)loadVertices:(const GLfloat*)v
              color:(const GLfloat*)c
            indices:(const GLushort*)elements
indicesNumberOfElemets:(GLushort)inoe
verticesNumberOfElemets:(GLushort)vnoe {
    VertexPC *verticesTemp = (VertexPC*)malloc( sizeof(VertexPC) * ( vnoe ));
    if (inoe != 0 && elements != NULL) {
        _indices = (GLushort*)malloc(inoe*sizeof(GLushort));
    }
    
    
    _vertices = (GLfloat*)verticesTemp;
    for (int i=0; i<vnoe*3; i+=3) {
        CC3Vector vertex;
        CC3Vector color;
        VertexPC vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        color.x = c[i+0];
        color.y = c[i+1];
        color.z = c[i+2];
        
        vstruct.position = vertex;
        vstruct.color = color;
        verticesTemp[i/3] = vstruct;
    }
    if (inoe != 0 && elements != NULL) {
        memcpy(_indices, elements, inoe*sizeof(GLushort));
    }
    _vnoe = vnoe;
    _inoe = inoe;
    _vertexStruct = PC;
}
-(void)loadVertices:(const GLfloat*)v
              texture:(const GLfloat*)t
            indices:(const GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe {
    VertexPT *verticesTemp = (VertexPT*)malloc( sizeof(VertexPT) * ( vnoe ));
    _indices = (GLushort*)malloc(inoe*sizeof(GLushort));
    
    _vertices = (GLfloat*)verticesTemp;
    int textureIndex = 0;
    for (int i=0; i<vnoe*3; i+=3) {
        CC3Vector vertex;
        GLfloat texture[2];
        VertexPT vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        texture[0] = t[textureIndex+0];
        texture[1] = t[textureIndex+1];
        
        vstruct.position = vertex;
        vstruct.texture[0] = texture[0];
        vstruct.texture[1] = texture[1];
        verticesTemp[i/3] = vstruct;
        textureIndex += 2;
    }
    memcpy(_indices, elements, inoe*sizeof(GLushort));
    _vnoe = vnoe;
    _inoe = inoe;
    _vertexStruct = PT;
}
-(void)loadVertices:(GLfloat*)v
            normals:(GLfloat*)n
              color:(GLfloat*)c
            texture:(GLfloat*)t
            indices:(GLushort*)elements
indicesNumberOfElemets:(GLuint)inoe
verticesNumberOfElemets:(GLuint)vnoe {
    VertexPNCT *verticesTemp = (VertexPNCT*)malloc( sizeof(VertexPNCT) * ( vnoe ));
    _indices = (GLushort*)malloc(inoe*sizeof(GLushort));
    
    _vertices = (GLfloat*)verticesTemp;
    int textureIndex = 0;
    for (int i=0; i<vnoe*3; i+=3) {
        CC3Vector vertex;
        CC3Vector normal;
        CC3Vector color;
        GLfloat texture[2];
        VertexPNCT vstruct;
        
        vertex.x = v[i+0];
        vertex.y = v[i+1];
        vertex.z = v[i+2];
        
        normal.x = n[i+0];
        normal.y = n[i+1];
        normal.z = n[i+2];
        
        color.x = c[i+0];
        color.y = c[i+1];
        color.z = c[i+2];

        texture[0] = t[textureIndex+0];
        texture[1] = t[textureIndex+1];
        
        vstruct.position = vertex;
        vstruct.normal = normal;
        vstruct.color = color;
        vstruct.texture[0] = texture[0];
        vstruct.texture[1] = texture[1];
        verticesTemp[i/3] = vstruct;
        textureIndex += 2;
    }
    memcpy(_indices, elements, inoe*sizeof(GLushort));
    _vnoe = vnoe;
    _inoe = inoe;
    _vertexStruct = PNCT;
}
- (GLfloat*)computeNormalsWithElements:(GLushort*)elements noe:(GLushort)noe andVertices:(GLfloat*)vertices nov:(GLushort)nov andAverage:(BOOL)average {
    CC3Vector normal;
    GLfloat *normals = (GLfloat*)malloc(sizeof(GLfloat) * nov * 3);
    GLushort *element = elements;
    CC3Vector triangle[3];
    GLushort normalIndex[3];
    for (int i=0; i<noe; i+=3) {
        int index;
        GLfloat x,y,z;
        for (int j=0; j<3; j++) {
            index = *element;
            normalIndex[j] = index;
            x = vertices[index*3];
            y = vertices[index*3+1];
            z = vertices[index*3+2];
            triangle[j].x = x;
            triangle[j].y = y;
            triangle[j].z = z;
            element++;
        }
        normal = [self CalculateSurfaceNormal:triangle];
        for (int i=0; i<3; i++) {
            normals[normalIndex[i]*3] = normal.x;
            normals[normalIndex[i]*3+1] = normal.y;
            normals[normalIndex[i]*3+2] = normal.z;
        }
        
    }
    //[self displayNormals:normals noe:nov];
    //GLfloat *enormals = [self avarageNormalsWithElements:cube_elements numberOfElements:36 andNormals:cube_normals numberOfNormals:24];
    
    if (average == YES) {
        GLfloat *enormals = [self avarageNormalsWithElements:elements numberOfElements:noe andNormals:normals numberOfNormals:nov];
        free(normals);
        normals = enormals;
    }
    return normals;
}
- (void)displayNormals:(GLfloat*)arr noe:(GLushort)numberOfElements {
    NSLog(@"normals. count:%d",numberOfElements);
    int i;
    NSMutableString *str = [[NSMutableString alloc] init];
    for (i=0; i<numberOfElements*3; i+=3) {
        [str appendFormat:@"\n%f,%f,%f\n",arr[i],arr[i+1],arr[i+2]];
    }
    NSLog(@"%@",str);
}
- (GLfloat*)avarageNormalsWithElements:(GLushort*)arrElements numberOfElements:(GLushort)noe andNormals:(GLfloat*)arrNormals numberOfNormals:(GLushort)non{
    CC3Vector *normalsSum = (CC3Vector*)calloc(non, sizeof(CC3Vector));
    GLushort *normalsCount = (GLushort*)calloc(non, sizeof(GLushort));
    int indexI;
    for (int i=0; i<noe; i++) {
        indexI = arrElements[i];
        CC3Vector currFaceNormal = CC3VectorMake(arrNormals[indexI*3], arrNormals[indexI*3+1], arrNormals[indexI*3+2]);
        normalsSum[indexI] = CC3VectorAdd(normalsSum[indexI], currFaceNormal);
        normalsCount[indexI]++;
        //        int indexJ;
        //        for (int j=0; j<i; j++) {
        //            indexJ = arrElements[j];
        //            if (indexJ == indexI) {
        //                normalsSum[indexJ] = CC3VectorAdd(normalsSum[indexJ], currFaceNormal);
        //                normalsCount[indexJ]++;
        //            }
        //
        //        }
    }
    for (int i=0; i<non; i++) {
        normalsSum[i] = CC3VectorScaleUniform(normalsSum[i], 1.0/normalsCount[i]);
    }
    //[self displayNormals:(GLfloat*)normalsSum noe:non];
    free(normalsCount);
    return (GLfloat*)normalsSum;
}
-(CC3Vector)CalculateSurfaceNormal:(CC3Vector*)triangle {
    CC3Vector p1 = triangle[0];
    CC3Vector p2 = triangle[1];
    CC3Vector p3 = triangle[2];
    
    CC3Vector u = CC3VectorMake(p2.x-p1.x, p2.y-p1.y, p2.z-p1.z);
    CC3Vector v = CC3VectorMake(p3.x-p1.x, p3.y-p1.y, p3.z-p1.z);
    
    CC3Vector normal = CC3VectorCross(u, v);
    return normal;
}

@end
