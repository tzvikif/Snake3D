//
//  GLView.m
//  cube
//
//  Created by tzviki fisher on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"
@implementation GLView

+ (Class)layerClass { // set up openGL view
    return [CAEAGLLayer class];
}

// Replace initWithFrame with this
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self setupLayer];        
        [self setupContext];     
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        //[self startRenderLoop];

    }
    return self;
}

- (void)setupLayer { // set leyer to opaque
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES; // by default is opaque set to NO, so we change because of better
    // preformance reasons to YES.
}

// 5) Create OpenGL context

- (void)setupContext {
    
    /*To do anything with OpenGL, you need to create an EAGLContext, and set the current context to the newly created context.
     An EAGLContext manages all of the information iOS needs to draw with OpenGL. It’s similar to how you need a Core Graphics context to do anything with Core Graphics.
     When you create a context, you specify what version of the API you want to use. Here, you specify that you want to use OpenGL ES 2.0. If it is not available (such as if the program was run on an iPhone 3G), the app would terminate.*/
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}



// 6) Create a render buffer

- (void)setupRenderBuffer {
    
    /*The next step to use OpenGL is to create a render buffer, which is an OpenGL object that stores the rendered image to present to the screen.
     Sometimes you’ll see a render buffer also referred to as a color buffer, because in essence it’s storing colors to display!
     There are three steps to create a render buffer:
     Call glGenRenderbuffers to create a new render buffer object. This returns a unique integer for the the render buffer (we store it here in _colorRenderBuffer). Sometimes you’ll see this unique integer referred to as an “OpenGL name.”
     Call glBindRenderbuffer to tell OpenGL “whenever I refer to GL_RENDERBUFFER, I really mean _colorRenderBuffer.”
     Finally, allocate some storage for the render buffer. The EAGLContext you created earlier has a method you can use for this called renderbufferStorage.*/
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);        
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);    
}

// 7) Create a frame buffer

- (void)setupFrameBuffer {
    
    /*A frame buffer is an OpenGL object that contains a render buffer, and some other buffers you’ll learn about later such as a depth buffer, stencil buffer, and accumulation buffer.
     The first two steps for creating a frame buffer is very similar to creating a render buffer – it uses the glGen and glBind like you’ve seen before, just ending with “Framebuffer/s” instead of “Renderbuffer/s”.
     The last function call (glFramebufferRenderbuffer) is new however. It lets you attach the render buffer you created earlier to the frame buffer’s GL_COLOR_ATTACHMENT0 slot.*/
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, 
                              GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);    
}
-(void)presentRenderbuffer {
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}
-(void)dealloc {
    [super dealloc];
}
@end
