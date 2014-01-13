//
//  Material.h
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import <Foundation/Foundation.h>
#import "Vectors.h"

@interface Material : NSObject
@property(nonatomic,assign) GLuint textureId;
@property(assign,nonatomic) CC3Vector4 *lightPosition;
@property(assign,nonatomic) CC3Vector *diffuse;
@property(assign,nonatomic) CC3Vector *specular;
@property(assign,nonatomic) CC3Vector *ambient;
@property(assign,nonatomic) GLfloat shininess;

- (void)setupTexture:(NSString *)fileName;
- (void)setupTexture:(NSString *)fileName withParams:(NSDictionary*)params;
@end
