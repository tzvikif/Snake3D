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
NSString *offset_x_name = @"offset_x";
NSString *scale_x_name = @"scale_x";

-(void)preRender {
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = 0;
    translateVector.y = 0;
    translateVector.z = -4;
    [self.modelMatrix populateFromTranslation:translateVector];
    [self.modelMatrix scaleUniformlyBy:1.0];
    
    [self.program1 addAttribute:coord2d_name];
    
    [self.program1 addUniform:offset_x_name];
    [self.program1 addUniform:scale_x_name];
    _offset_x = 0;
    _scale_x = 1.0;
    glUniform1f([self.program1 uniformLocation:offset_x_name], _offset_x);
    glUniform1f([self.program1 uniformLocation:scale_x_name], _scale_x);
    
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
//    glUniform1i(self.material.textureId, /*GL_TEXTURE*/0);
    
}
-(void)Render {
    GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glVertexAttribPointer(
                          [self.program1 attributeLocation:coord2d_name], // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glDrawArrays(GL_POINTS, 0, N/2);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
//    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
//    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
}

@end


