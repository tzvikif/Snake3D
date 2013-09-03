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
const int margin = 20;
const int ticksize = 10;

-(void)preRender {
    _offset_x = 0;
    _scale_x = 1.0;

    [self.program1 addUniform:model_name];
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = _offset_x;
    translateVector.y = 0;
    translateVector.z = -0.5;
    [self.modelMatrix populateFromTranslation:translateVector];
    [self.modelMatrix scaleUniformlyBy:_scale_x];
    [self.program1 addAttribute:coord2d_name];
    
    [self.program1 addUniform:color_name];
    //CC3Vector4 color = CC3Vector4Make(1.0, 0.0, 0.0, 1.0);
    
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
//    glUniform1i(self.material.textureId, /*GL_TEXTURE*/0);
    
}
-(void)Render {
    glClearColor(0.9, 0.9, 0.9, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUniform4f([self.program1 uniformLocation:color_name], 1.0, 0.0, 0.0, 1.0);
    GLsizei height = self.viewport.size.height;
    GLsizei width = self.viewport.size.width;
    glViewport(margin+ticksize, margin+ticksize, width-2*margin-ticksize, height-2*margin-ticksize);
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
    glViewport(0, 0, width, height);
    
    GLuint box_vbo;
    glGenBuffers(1, &box_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, box_vbo);
    
    static const GLfloat box[] = {-1, -1, 1, -1, 1, 1, -1, 1};
    glBufferData(GL_ARRAY_BUFFER, sizeof box, box, GL_STATIC_DRAW);
    
    GLfloat black[4] = {0, 0, 0, 1};
    glUniform4fv([self.program1 uniformLocation:color_name], 1, black);
    
    glVertexAttribPointer([self.program1 attributeLocation:coord2d_name], 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    
    CC3GLMatrix *tranform = [self viewport_transformX:margin+ticksize andY:margin+ticksize andWidth:width-2*margin-ticksize andHeight: height-2*margin-ticksize];
    glUniformMatrix4fv([self.program1 uniformLocation:model_name], 1, 0, tranform.glMatrix);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
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


