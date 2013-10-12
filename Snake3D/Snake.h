//
//  Snake.h
//  Snake3D
//
//  Created by tzvifi on 9/30/13.
//
//

#import "Node.h"
#import "Consts.h"
@interface Snake : Node
@property(nonatomic,retain) NSMutableArray *bodyParts;
@property(nonatomic,assign) int bpCount;
@property(nonatomic,assign) CC3Vector position;
@property(nonatomic,assign) BOOL velocityChanged;
@property(nonatomic,assign) float speed;
@property(nonatomic,assign) DIRECTION dir;
@property(nonatomic,assign) CC3Vector turnPos;
-(void)setDir:(DIRECTION)dir andPosition:(CC3Vector)pos;
-(void)advance;
@end
