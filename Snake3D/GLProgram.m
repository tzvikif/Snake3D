#import "GLProgram.h"

#pragma mark Function Pointer Definitions
typedef void (*GLInfoFunction)(GLuint program, 
                               GLenum pname, 
                               GLint* params);
typedef void (*GLLogFunction) (GLuint program, 
                               GLsizei bufsize, 
                               GLsizei* length, 
                               GLchar* infolog);
#pragma mark -
#pragma mark Private Extension Method Declaration
@interface GLProgram()
{
    NSMutableDictionary  *attributes;
    NSMutableDictionary  *uniforms;
    GLuint          program,
    vertShader, 
    fragShader;
}
- (BOOL)compileShader:(GLuint *)shader 
                 type:(GLenum)type 
                 file:(NSString *)file;
- (NSString *)logForOpenGLObject:(GLuint)object 
                    infoCallback:(GLInfoFunction)infoFunc 
                         logFunc:(GLLogFunction)logFunc;
//- (void)checkUniform:(GLuint)uniform name:(const char *)name;
//- (void)checkAttribute:(GLuint)attribute name:(const char *)name;
@end
#pragma mark -

@implementation GLProgram
- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename 
            fragmentShaderFilename:(NSString *)fShaderFilename
{
    if (self = [super init])
    {
        attributes = [[NSMutableDictionary alloc] init];
        uniforms   = [[NSMutableDictionary alloc] init];
        NSString *vertShaderPathname, *fragShaderPathname;
        program = glCreateProgram();
        
        vertShaderPathname = [[NSBundle mainBundle] 
                              pathForResource:vShaderFilename 
                              ofType:@"vsh"];
        if (![self compileShader:&vertShader 
                            type:GL_VERTEX_SHADER
                            file:vertShaderPathname])
            NSLog(@"Failed to compile vertex shader");
        
        fragShaderPathname = [[NSBundle mainBundle] 
                              pathForResource:fShaderFilename 
                              ofType:@"fsh"];
        if (![self compileShader:&fragShader 
                            type:GL_FRAGMENT_SHADER 
                            file:fragShaderPathname])
            NSLog(@"Failed to compile fragment shader");
        
        glAttachShader(program, vertShader);
        glAttachShader(program, fragShader);
    }
    return self;
}
- (BOOL)compileShader:(GLuint *)shader 
                 type:(GLenum)type 
                 file:(NSString *)file
{
//    GLint status;
//    const GLchar *source;
    
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:file
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader %@: %@",shaderString, error.localizedDescription);
        exit(1);
    }

    GLuint shaderHandle = glCreateShader(type);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    *shader = shaderHandle;
    return YES;
    
//    if (!source)
//    {
//        NSLog(@"Failed to load vertex shader");
//        return NO;
//    }
    
//    *shader = glCreateShader(type);
//    glShaderSource(*shader, 1, &source, NULL);
//    glCompileShader(*shader);
//    
//    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
//    return status == GL_TRUE;
}
#pragma mark -
- (void)addAttribute:(NSString *)attributeName
{
    if (![attributes objectForKey:attributeName])
    {
        int attribLocation = glGetAttribLocation(program, [attributeName UTF8String]);
        if (attribLocation == -1) {
            NSLog(@"Could not bind attribute %@\n", attributeName);
            exit(1);
        }

        [attributes setObject:[NSNumber numberWithInt:attribLocation] forKey:attributeName];
        glEnableVertexAttribArray(attribLocation);
    }
}
- (void)addUniform:(NSString *)uniformName
{
    if (![uniforms objectForKey:uniformName])
    {
        int uniformLocation = glGetUniformLocation(program, [uniformName UTF8String]);
        if (uniformLocation == -1) {
            NSLog(@"Could not bind uniform %@\n", uniformName);
            exit(1);
        }
        [uniforms setObject:[NSNumber numberWithInt:uniformLocation] forKey:uniformName];
    }
}
- (GLuint)attributeLocation:(NSString *)attributeName
{
    NSNumber *location = [attributes objectForKey:attributeName];
    if (location == nil) {
        NSException* myException = [NSException
                                    exceptionWithName:@"AttributeException"
                                    reason:[NSString stringWithFormat:@"%@: no such attribute location",attributeName]
                                    userInfo:nil];
        @throw myException;
    }
    return (GLuint)[location intValue];
}
- (GLuint)uniformLocation:(NSString *)uniformName
{
    NSNumber *location = [uniforms objectForKey:uniformName];
    if (location == nil) {
        NSException* myException = [NSException
                                    exceptionWithName:@"UniformException"
                                    reason:[NSString stringWithFormat:@"%@: no such uniform location",uniformName]
                                    userInfo:nil];
        @throw myException;
    }
    return (GLuint)[location intValue];
}
#pragma mark -
- (BOOL)link
{
    GLint status;
    
    glLinkProgram(program);
    glValidateProgram(program);
    
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE)
        return NO;
    
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return YES;
}
- (void)use
{
    glUseProgram(program);
}
#pragma mark -
- (NSString *)logForOpenGLObject:(GLuint)object 
                    infoCallback:(GLInfoFunction)infoFunc 
                         logFunc:(GLLogFunction)logFunc
{
    GLint logLength = 0, charsWritten = 0;
    
    infoFunc(object, GL_INFO_LOG_LENGTH, &logLength);    
    if (logLength < 1)
        return nil;
    
    char *logBytes = malloc(logLength);
    logFunc(object, logLength, &charsWritten, logBytes);
    NSString *log = [[[NSString alloc] initWithBytes:logBytes 
                                              length:logLength 
                                            encoding:NSUTF8StringEncoding] 
                     autorelease];
    free(logBytes);
    return log;
}
- (NSString *)vertexShaderLog
{
    return [self logForOpenGLObject:vertShader 
                       infoCallback:(GLInfoFunction)&glGetProgramiv 
                            logFunc:(GLLogFunction)&glGetProgramInfoLog];
    
}
- (NSString *)fragmentShaderLog
{
    return [self logForOpenGLObject:fragShader 
                       infoCallback:(GLInfoFunction)&glGetProgramiv 
                            logFunc:(GLLogFunction)&glGetProgramInfoLog];
}
- (NSString *)programLog
{
    return [self logForOpenGLObject:program 
                       infoCallback:(GLInfoFunction)&glGetProgramiv 
                            logFunc:(GLLogFunction)&glGetProgramInfoLog];
}
#pragma mark -
- (void)dealloc
{
    [attributes release];
    [uniforms release];
    
    if (vertShader)
        glDeleteShader(vertShader);
    
    if (fragShader)
        glDeleteShader(fragShader);
    
    if (program)
        glDeleteProgram(program);
    
    [super dealloc];
}
@end
