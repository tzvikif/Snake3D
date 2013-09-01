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
-(void)addSwipeRecognizer;
-(void)addPinchRecognizer;
-(void)pinched:(UIPinchGestureRecognizer*)gestureRecognizer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
	// Do any additional setup after loading the view, typically from a nib.
    GLProgram *theProgram = [[GLProgram alloc] initWithVertexShaderFilename:@"SimpleVertex" fragmentShaderFilename:@"SimpleFragment"];
    self.program1 = theProgram;
    [theProgram release];
    if (![self.program1 link])
    {
        NSLog(@"Link failed");
        
        NSString *progLog = [self.program1 programLog];
        NSLog(@"Program Log: %@", progLog);
        
        NSString *fragLog = [self.program1 fragmentShaderLog];
        NSLog(@"Frag Log: %@", fragLog);
        
        NSString *vertLog = [self.program1 vertexShaderLog];
        NSLog(@"Vert Log: %@", vertLog);
        
        //[(GLView *)self.view stopAnimation];
        self.program1 = nil;
    }
    _logicEngine = [[LogicEngine alloc] init];
    
    //[_logicEngine loadProgram:_program1];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [_logicEngine initialize:screenBounds andProgram:self.program1];
    [self addSwipeRecognizer];
    [self addPinchRecognizer];
    [self startRenderLoop];
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
- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    [_logicEngine updateOffset_x:-0.3];
}
- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    [_logicEngine updateOffset_x:0.3];
}
-(void)addSwipeRecognizer {
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];
    [swipeLeftGestureRecognizer release];
    [swipeRightGestureRecognizer release];
}
-(void)addPinchRecognizer {
    UIPinchGestureRecognizer *gestureRecognizer=[[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinched:)] autorelease];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)pinched:(UIPinchGestureRecognizer*)gestureRecognizer{
    //if(gestureRecognizer.state==UIGestureRecognizerStateEnded){
        //pinch ended
        float scale = gestureRecognizer.scale;
//        if (scale > 1.0) {
//            scale = 1.5;
//        }
//        else {
//            scale = 0.66;
//        }
    if(scale > 1.5)
    {
        scale = 1.5;
    }
    if (scale < 0.66) {
        scale = 0.66;
    }
        [_logicEngine updateScale:scale];
    //}
}
-(void)dealloc {
    [_logicEngine release];
    [_program1 release];
    [super dealloc];
}
@end
