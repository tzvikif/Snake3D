//
//  Plotter.m
//  Snake3D
//
//  Created by tzvifi on 8/28/13.
//
//

#import "Plotter.h"
#import "GLProgram.h"
#import "LogicEngine.h"
#include "Consts.h"

@implementation Plotter
NSString *coord3d_name = @"coord3d";
NSString* model_name = @"transform";
NSString* color_name = @"color";
const int margin = 20;
const int ticksize = 10;

-(void)preRender {
    _offset_x = 0;
    _offset_y = 0;
    _scale_xy = 1.0;
    [self.program1 addAttribute:coord3d_name];
    [self.program1 addUniform:model_name];
    //[self.program1 addUniform:color_name];
    [self.program1 addUniform:model_name];
   
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
//    glUniform1i(self.material.textureId, /*GL_TEXTURE*/0);
    
}
-(void)Render {
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.9, 0.9, 0.9, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //glUniform4f([self.program1 uniformLocation:color_name], 1.0, 0.0, 0.0, 1.0);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    _matProjection = [CC3GLMatrix identity];
    _matView = [CC3GLMatrix identity];
    [_matView populateToLookAt:CC3VectorMake(0.0, 0.0, -1.2) withEyeAt:CC3VectorMake(0.1, -1.5, 0.0) withUp:CC3VectorMake(0.0, 0.0, 1.0)];
    float ratio = self.viewport.size.width / self.viewport.size.height;
    [_matProjection populateFromFrustumFov:45.0 andNear:0.1 andFar:10 andAspectRatio:ratio];
   
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = _offset_x;
    translateVector.y = _offset_y;
    translateVector.z = -1.2;

    [self.modelMatrix translateBy:translateVector];
    [self.modelMatrix scaleBy:CC3VectorMake(_scale_xy, _scale_xy, 1.0)];
    [_matProjection multiplyByMatrix:_matView];
    [_matProjection multiplyByMatrix:self.modelMatrix];
    
    //glViewport(margin+ticksize, margin+ticksize, window_width-2*margin-ticksize, window_height-2*margin-ticksize);
    glUniformMatrix4fv([self.program1 uniformLocation:model_name], 1, 0, _matProjection.glMatrix);
    GLsizei size;
    GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glVertexAttribPointer(
                          [self.program1 attributeLocation:coord3d_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glDrawArrays(GL_POINTS, 0, size/stride);
}
-(CC3GLMatrix*)viewport_transformX:(GLfloat) x andY:(GLfloat)y andWidth:(GLfloat)width andHeight:(GLfloat)height {
    float offset_x = (2.0 * x + (width - self.viewport.size.width)) / self.viewport.size.width;
    float offset_y = (2.0 * y + (height - self.viewport.size.height)) / self.viewport.size.height;
    
    // Calculate how to rescale the x and y coordinates:
    float scale_x = width / self.viewport.size.width;
    float scale_y = height / self.viewport.size.height;
    CC3Vector offset = CC3VectorMake(offset_x, offset_y, 0);
    CC3Vector scale = CC3VectorMake(scale_x, scale_y, 1);
    CC3GLMatrix *translate = [CC3GLMatrix identity];
    [translate translateBy:offset];
    [translate scaleBy:scale];
    return translate;
}
@end


