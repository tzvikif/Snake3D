#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLProgram : NSObject 
{
}
- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename 
            fragmentShaderFilename:(NSString *)fShaderFilename;
- (void)addAttribute:(NSString *)attributeName;
- (void)addUniform:(NSString *)uniformName;
//- (GLuint)attributeIndex:(NSString *)attributeName;
//- (GLuint)uniformIndex:(NSString *)uniformName;
- (GLuint)attributeLocation:(NSString *)attributeName;
- (GLuint)uniformLocation:(NSString *)uniformName;
- (BOOL)link;
- (void)use;
- (NSString *)vertexShaderLog;
- (NSString *)fragmentShaderLog;
- (NSString *)programLog;
@end
