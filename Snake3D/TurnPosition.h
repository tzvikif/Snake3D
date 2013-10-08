//
//  TurnPosition.h
//  Snake3D
//
//  Created by tzviki fisher on 09/10/13.
//
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "Consts.h"

@interface TurnPosition : NSObject
@property(nonatomic,assign) CC3Vector nextTurnPos;
@property(nonatomic,assign) DIRECTION nextTurnDir;

@end
