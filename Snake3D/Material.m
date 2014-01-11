//
//  Materials.h
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//
#import "Material.h"
#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "Consts.h"

@implementation Material
- (void)setupTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    //return texName;
    _textureId = texName;
}
- (void)setup3DTexture:(NSArray *)fileNames {

    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_CUBE_MAP, texName);
    for (GLuint i=0; i<sizeof(types)/sizeof(types[0]);i++) {
        CGImageRef spriteImage = [UIImage imageNamed:[fileNames objectAtIndex:i]].CGImage;
        if (!spriteImage) {
            NSLog(@"Failed to load image %@", [fileNames objectAtIndex:i]);
            exit(1);
        }
        // 2
        size_t width = CGImageGetWidth(spriteImage);
        size_t height = CGImageGetHeight(spriteImage);
        
        GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
        
        CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                           CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        
        // 3
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
        CGContextRelease(spriteContext);
        
        glTexImage2D(types[i], 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
        glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        //glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);
        
        free(spriteData);
        
        

    }
    
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    //return texName;
    _textureId = texName;
}
- (void)bindTexture:(GLenum)TextureUnit {
    glActiveTexture(TextureUnit);
    glBindTexture(GL_TEXTURE_CUBE_MAP, _textureId);
}


@end
