//
//  StickyButton.h
//  Snake3D
//
//  Created by tzviki fisher on 15/03/14.
//
//

#import <UIKit/UIKit.h>

@protocol stickyProtocol <NSObject>
@required
-(void)touchBegan:(UIView*)caller;
-(void)touchEnded:(UIView*)caller;
@end

@interface StickyButton : UIImageView
@property(nonatomic,assign) id<stickyProtocol> delegate;
@end
