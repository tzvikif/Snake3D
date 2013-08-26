//
//  Material.h
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import <Foundation/Foundation.h>

@interface Material : NSObject
@property(nonatomic,assign) GLuint textureId;
- (void)setupTexture:(NSString *)fileName;
@end
