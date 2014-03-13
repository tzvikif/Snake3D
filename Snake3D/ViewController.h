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
@class LogicEngine;
@interface ViewController : UIViewController <UIGestureRecognizerDelegate> {
    NSTimeInterval m_timestamp;

}
@property (retain,nonatomic) LogicEngine *logicEngine;
@property (retain,nonatomic) GLProgram *program1;
- (void)Render: (CADisplayLink*) displayLink;
-(void)startRenderLoop;
- (IBAction)btnContinueClicked:(id)sender;
- (IBAction)btnStartOverClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnContinue;
@property (retain, nonatomic) IBOutlet UIButton *btnStartOver;
- (IBAction)btnCwClicked:(id)sender;
- (IBAction)btnCcwClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnCw;
- (IBAction)btnDown:(id)sender;
- (IBAction)btnUp:(id)sender;

@end
