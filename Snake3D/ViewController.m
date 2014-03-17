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
-(void)handleSwipeGesture:(UISwipeGestureRecognizer*)sender;
-(void)pinched:(UIPinchGestureRecognizer*)gestureRecognizer;
-(void)goingUp;
-(void)goingDown;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    LogicEngine *leTemp = [[LogicEngine alloc] init];
    [self setLogicEngine:leTemp];
    [leTemp release];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int tempHeight = screenBounds.size.height;
    screenBounds.size.height = screenBounds.size.width;
    screenBounds.size.width = tempHeight;
    [_logicEngine initialize:screenBounds];
      [self addSwipeRecognizer];
    //[self addPinchRecognizer];
    CGRect frame = _btnCw.frame;
    frame.origin.x = screenBounds.size.width - frame.size.width;
    [_btnCw setFrame:frame];
    UIImage *plusImage = [UIImage imageNamed:@"plus.jpeg"];
    [_plus setImage:plusImage];
    [_plus setDelegate:self];
    UIImage *minusImage = [UIImage imageNamed:@"minus.jpeg"];
    [_minus setImage:minusImage];
    [_minus setDelegate:self];
    [self startRenderLoop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startRenderLoop {
    CADisplayLink* displayLink;
    //[self Render:nil];
    m_timestamp = CACurrentMediaTime();
    displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(Render:)];
    
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
    
}

- (IBAction)btnContinueClicked:(id)sender {
    [_logicEngine btnContinueClicked];
}

- (IBAction)btnStartOverClicked:(id)sender {
    [_logicEngine btnStartOverClicked];
}
- (void) Render: (CADisplayLink*) displayLink {
    if (displayLink != nil) {
        NSTimeInterval elapsedSeconds = displayLink.timestamp - m_timestamp;
        m_timestamp = displayLink.timestamp;
        [_logicEngine Render];
        [_logicEngine updateAnimation:elapsedSeconds];
        [(GLView*)self.view presentRenderbuffer];
    }
    
}
-(void)handleSwipeGesture:(UISwipeGestureRecognizer*)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"up gesture");
        [_logicEngine setDir:DIR_UP];
        
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"down gesture");
        [_logicEngine setDir:DIR_DOWN];
        
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"left gesture");
        [_logicEngine setDir:DIR_LEFT];
        
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"right gesture");
        [_logicEngine setDir:DIR_RIGHT];
    }
}
-(void)addSwipeRecognizer {
    //left
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    //right
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];
    //up
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGestureRecognizer];
    //down
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
     
    [swipeLeftGestureRecognizer release];
    [swipeRightGestureRecognizer release];
    [swipeDownGestureRecognizer release];
    [swipeUpGestureRecognizer release];
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
#pragma mark -
#pragma mark stickyProtocol methods
-(void)touchBegan:(UIView *)caller  {
    if (caller == _plus) {
        self.plusTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                     target:self
                   selector:@selector(goingUp)
                   userInfo:nil repeats:YES];
    }
    if (caller == _minus) {
        self.minusTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                     target:self
                   selector:@selector(goingDown)
                   userInfo:nil
                    repeats:YES];
    }
}
-(void)touchEnded:(UIView *)caller {
    if (caller == _plus) {
        [_plusTimer invalidate];
    }
    if (caller == _minus) {
        [_minusTimer invalidate];
    }
}


-(void)dealloc {
    [_logicEngine release];
    [_program1 release];
    [_btnContinue release];
    [_btnStartOver release];
    [_btnCw release];
    [_plus release];
    [_minus release];
    [_minusTimer release];
    [_plusTimer release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnContinue:nil];
    [self setBtnStartOver:nil];
    [super viewDidUnload];
}
- (IBAction)btnCwClicked:(id)sender {
    [_logicEngine setDir:DIR_RIGHT];
}

- (IBAction)btnCcwClicked:(id)sender {
    [_logicEngine setDir:DIR_LEFT];
}
- (void)goingDown {
    [_logicEngine eyeViewGoingDown];
}

- (void)goingUp {
    [_logicEngine eyeViewGoingUp];
}
@end
