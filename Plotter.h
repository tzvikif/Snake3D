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
@property(assign,nonatomic) GLfloat scale_x;
-(CC3GLMatrix*)viewport_transformX:(GLfloat) x andY:(GLfloat)y andWidth:(GLfloat)width andHeight:(GLfloat)height;
@end
