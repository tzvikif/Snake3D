//
//  LoadObj.h
//  cube
//
//  Created by tzviki fisher on 07/07/13.
//
//

#import <Foundation/Foundation.h>
#import "CC3Foundation.h"

@interface LoadObj : NSObject {
@public
    CC3Vector *_arrVertices;
    CC3Vector *_arrNormals;
    GLfloat *_arrTexture;
    GLushort _numberOfFaces;
    GLushort _numberOfVertices;
    GLushort *_arrElements;
    GLubyte	_valuesPerCoord;
    
}
@property (nonatomic, retain) NSString *sourceObjFilePath;
- (id)initWithPath:(NSString *)path;
- (void)displayArrays;  //for debug.
@end
