//
//  GLView.h
//  cube
//
//  Created by tzviki fisher on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>


@interface GLView : UIView
{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    float m_timestamp;

}
+ (Class)layerClass;
- (void)setupLayer;
- (void)setupContext;
- (void)setupRenderBuffer;
- (void)setupFrameBuffer;
- (void)presentRenderbuffer;
- (void)startRenderLoop;
- (void) Render: (CADisplayLink*) displayLink;
@end
