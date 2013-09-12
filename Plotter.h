//
//  Plotter.h
//  Snake3D
//
//  Created by tzvifi on 8/28/13.
//
//

#import "Node.h"

@interface Plotter : Node {

}

@property(assign,nonatomic) GLfloat offset_x;
@property(assign,nonatomic) GLfloat offset_y;
@property(assign,nonatomic) GLfloat scale_xy;
@property(assign,nonatomic) GLfloat rotationAngle;
@property(nonatomic,retain) CC3GLMatrix *matView;
@property(nonatomic,retain) CC3GLMatrix *matProjection;

-(CC3GLMatrix*) viewport_transformX:(GLfloat)x y:(GLfloat)y width:(GLfloat)width height:(GLfloat)height;

@end
