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
NSString *coord2d_name = @"coord2d";
NSString* model_name = @"transform";
NSString* color_name = @"color";
NSString* box_name = @"box";

-(void)preRender {
    _offset_x = 0;
    _scale_x = 1.0;
    [self.program1 addUniform:model_name];
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
//    glUniform1i(self.material.textureId, /*GL_TEXTURE*/0);
    
}
-(void)Render {
    const int margin = 20;
    const int ticksize = 10;
    glClearColor(0.9, 0.9, 0.9, 1.0);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    GLsizei height = window_height - 2 * margin - ticksize;
    GLsizei width  = window_width - 2 * margin - ticksize;
//    glScissor(
//              margin + ticksize,
//              margin + ticksize,
//              width - margin * 2 - ticksize,
//              height - margin * 2 - ticksize
//              );
//    
//    glEnable(GL_SCISSOR_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    GLuint box_vbo;
    glGenBuffers(1, &box_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, box_vbo);
    
    static const GLfloat box[] = {-1, -1, 1, -1, 1, 1, -1, 1};
    glBufferData(GL_ARRAY_BUFFER, sizeof(box), box, GL_STATIC_DRAW);
    [self.program1 addUniform:color_name];
    GLfloat black[4] = {0, 1, 0, 1};
    glUniform4fv([self.program1 uniformLocation:color_name], 1, black);
    self.modelMatrix = [self viewport_transformX:margin+ticksize y:margin+ticksize width:width height:height];
    glUniformMatrix4fv([self.program1 uniformLocation:model_name], 1, 0, self.modelMatrix.glMatrix);
    [self.program1 addAttribute:coord2d_name];
    glVertexAttribPointer([self.program1 attributeLocation:coord2d_name], 2, GL_FLOAT, GL_FALSE, 0, 0);
    glViewport(
               0,
               0,
               window_width,
               window_height
               );

    glDrawArrays(GL_LINE_LOOP, 0, 4);
    
    glUniform4f([self.program1 uniformLocation:color_name], 1.0, 0.0, 0.0, 1.0);

    glViewport(
               margin + ticksize,
               margin + ticksize,
               width,
               height
               );

    glUniform4f([self.program1 uniformLocation:color_name], 1.0, 0.0, 0.0, 1.0);
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = _offset_x;  
    translateVector.y = 0;
    translateVector.z = -0.5;
    [self.modelMatrix populateFromTranslation:translateVector];
    [self.modelMatrix scaleUniformlyBy:_scale_x];
    glUniformMatrix4fv([self.program1 uniformLocation:model_name], 1, 0, self.modelMatrix.glMatrix);
    GLsizei size;
    GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glVertexAttribPointer(
                          [self.program1 attributeLocation:coord2d_name], // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glDrawArrays(GL_LINE_STRIP, 0, size/stride);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
//    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
//    glDrawElements(GL_POINTS, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
}
-(CC3GLMatrix*) viewport_transformX:(GLfloat)x y:(GLfloat)y width:(GLfloat)width height:(GLfloat)height {
    // Calculate how to translate the x and y coordinates:
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    float offset_x = (2.0 * x + (width - window_width)) / window_width;
    offset_x = 1;
    float offset_y = (2.0 * y + (height - window_height)) / window_height;
    
    // Calculate how to rescale the x and y coordinates:
    float scale_x = width / window_width;
    float scale_y = height / window_height;
    CC3Vector scale = CC3VectorMake(scale_x, scale_y, 1);
    CC3Vector offset = CC3VectorMake(offset_x, offset_y, 0);
    CC3GLMatrix *model = [CC3GLMatrix identity];
    [model translateBy:offset];
    [model scaleBy:scale];
    return model;
}
@end


