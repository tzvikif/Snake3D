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
@property(nonatomic,assign) CC3Vector *initScales;
@property(nonatomic,assign) float totalTimeElapsed;
@property(nonatomic,assign) CC3Vector position;
@property(nonatomic,assign) BOOL velocityChanged;
@property(nonatomic,assign) float speed;
@property(nonatomic,assign) DIRECTION dir;
@property(nonatomic,assign) CC3Vector turnPos;
-(void)setDir:(DIRECTION)dir andAtPosition:(CC3Vector)pos;
-(BOOL)isCollideWithPosition:(CC3Vector)pos;
-(BOOL)isCollideWithWall;
-(BOOL)oops:(NSTimeInterval)timeElappsed;
-(void)addBodyPart;
-(void)advance;
-(CC3Vector)getVelocity;
-(BOOL)isRotating;
-(float)getRotationAngle;
@end
