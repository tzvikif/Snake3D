//
//  Snake.h
//  Snake3D
//
//  Created by tzvifi on 9/30/13.
//
//

#import "Node.h"

@interface Snake : Node
@property(nonatomic,retain) NSMutableArray *bodyParts;
@property(nonatomic,assign) int bpCount;
@property(nonatomic,assign) CC3Vector velocity;
@property(nonatomic,assign) BOOL velocityChanged;
@end
