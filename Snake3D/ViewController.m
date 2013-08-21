//
//  ViewController.m
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import "ViewController.h"
#import "LogicEngine.h"
#import "GLView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _logicEngine = [[LogicEngine alloc] init];
    [_logicEngine initialize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startRenderLoop {
    CADisplayLink* displayLink;
    [self Render:nil];
    m_timestamp = CACurrentMediaTime();
    displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(Render:)];
    
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
    
}
- (void) Render: (CADisplayLink*) displayLink {
    if (displayLink != nil) {
        float elapsedSeconds = displayLink.timestamp - m_timestamp;
        m_timestamp = displayLink.timestamp;
        [_logicEngine updateAnimation:elapsedSeconds];
    }
    [_logicEngine Render];
    [(GLView*)self.view presentRenderbuffer];
}
-(void)dealloc {
    [_logicEngine release];
    [super dealloc];
}
@end
