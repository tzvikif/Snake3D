//
//  Food.h
//  Snake3D
//
//  Created by tzvifi on 10/16/13.
//
//

#import "Node.h"
#import "Consts.h"

@interface Food : Node
@property(nonatomic,assign) CC3Vector position;
@property(nonatomic,assign) CC3Vector scaleFactor;
@end
