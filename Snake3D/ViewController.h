//
//  ViewController.h
//  Snake3D
//
//  Created by tzvifi on 8/19/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "GLProgram.h"
@class LogicEngine;
@interface ViewController : UIViewController {
    float m_timestamp;

}
@property (retain,nonatomic) LogicEngine *logicEngine;
- (void)Render: (CADisplayLink*) displayLink;
-(void)startRenderLoop;
@end
