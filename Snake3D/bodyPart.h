//
//  bodyPart.h
//  Snake3D
//
//  Created by tzvifi on 9/30/13.
//
//

#import "Node.h"

@interface BodyPart : Node
@property(nonatomic,retain) Mesh *meshBp;
@property(nonatomic,retain) Material *materialPb;
@property(nonatomic,retain) Drawable *drawableBp;
@property(nonatomic,assign) CC3Vector position;
@property(nonatomic,assign) CC3Vector velocity;
@property(nonatomic,assign) float scaleFactor;


@end
