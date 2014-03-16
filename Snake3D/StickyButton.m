//
//  StickyButton.m
//  Snake3D
//
//  Created by tzviki fisher on 15/03/14.
//
//

#import "StickyButton.h"

@implementation StickyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate conformsToProtocol:@protocol(stickyProtocol)]) {
        [_delegate touchBegan:self];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_delegate conformsToProtocol:@protocol(stickyProtocol)]) {
        [_delegate touchEnded:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
