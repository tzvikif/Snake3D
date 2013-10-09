//
//  bodyPart.h
//  Snake3D
//
//  Created by tzvifi on 9/30/13.
//
//

#import "Node.h"
#import "Consts.h"

@interface BodyPart : Node

@property(nonatomic,assign) CC3Vector position;
@property(nonatomic,assign) CC3Vector velocity;
@property(nonatomic,assign) CC3Vector scaleFactor;
@property(nonatomic,retain) CC3GLMatrix *rotatetionMat;
@property(nonatomic,assign) int myId;
@property(nonatomic,assign) float speed;
@property(nonatomic,retain) NSMutableArray *turnsAndPositions;
-(void)addTurnDirection:(DIRECTION)dir inPosition:(CC3Vector)pos;
-(void)advance;
@end
