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
NSString *coord1d_name = @"coord1d";
NSString *offset_x_name = @"offset_x";
NSString *scale_x_name = @"scale_x";
NSString *texture_name = @"mytexture";

-(void)preRender {
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = 0;
    translateVector.y = 0;
    translateVector.z = -4;
    [self.modelMatrix populateFromTranslation:translateVector];
    [self.modelMatrix scaleUniformlyBy:1.0];
    
    [self.program1 addAttribute:coord1d_name];
    
    [self.program1 addUniform:offset_x_name];
    [self.program1 addUniform:scale_x_name];
    [self.program1 addUniform:texture_name];
    _offset_x = 0;
    _scale_x = 1.0;
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
    glUniform1i([self.program1 uniformLocation:texture_name], /*GL_TEXTURE*/0);
    
}
-(void)Render {
    glClearColor(0.2, 0.2, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUniform1f([self.program1 uniformLocation:offset_x_name], _offset_x);
    glUniform1f([self.program1 uniformLocation:scale_x_name], _scale_x);
    GLsizei size;
    //GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    //glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    
    glVertexAttribPointer(
                          [self.program1 attributeLocation:coord1d_name],   // attribute
                          1,                   // number of elements per vertex, here just x
                          GL_FLOAT,            // the type of each element
                          GL_FALSE,            // take our values as-is
                          0,                   // no space between values
                          0                    // use the vertex buffer object
                          );
    glDrawArrays(GL_LINE_STRIP, 0, 101);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
//    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
//    glDrawElements(GL_POINTS, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
}

@end


