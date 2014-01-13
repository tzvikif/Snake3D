//
//  SkyBox.h
//  Snake3D
//
//  Created by tzvikif on 1/7/14.
//
//

#import "Node.h"

@interface SkyBox : Node
@property(nonatomic,assign) CC3Vector scaleFactor;
@property(retain,nonatomic) NSDictionary *materials;
@end
