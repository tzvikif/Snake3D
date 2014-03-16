//
//  ViewController.h
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GLProgram.h"
#import "StickyButton.h"
@class LogicEngine;
@interface ViewController : UIViewController <UIGestureRecognizerDelegate,stickyProtocol> {
    NSTimeInterval m_timestamp;

}
@property (retain,nonatomic) LogicEngine *logicEngine;
@property (retain,nonatomic) GLProgram *program1;
- (IBAction)btnContinueClicked:(id)sender;
- (IBAction)btnStartOverClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnContinue;
@property (retain, nonatomic) IBOutlet UIButton *btnStartOver;
- (IBAction)btnCwClicked:(id)sender;
- (IBAction)btnCcwClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnCw;
@property (retain, nonatomic) IBOutlet StickyButton *plus;
@property (retain, nonatomic) IBOutlet StickyButton *minus;
@property (retain,nonatomic) NSTimer *plusTimer;
@property (retain,nonatomic) NSTimer *minusTimer;

- (void)Render: (CADisplayLink*) displayLink;
-(void)startRenderLoop;
@end
