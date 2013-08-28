//
//  SimpleCube.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "SimpleCube.h"
#import "GLProgram.h"

@implementation SimpleCube
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
    
    [self.program1 uniformLocation:offset_x_name];
    glUniformMatrix4fv([self.program1 uniformLocation:offset_x_name], 1, 0, self.modelMatrix.glMatrix);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
    glUniform1i(self.material.textureId, /*GL_TEXTURE*/0);
        
}
-(void)Render {
    int size;
    GLsizei stride = [self getStride];
    glVertexAttribPointer([self.program1 attributeLocation:position_name], 3, GL_FLOAT, GL_FALSE, stride,(GLvoid*)0);
//    glVertexAttribPointer([self.program1 attributeLocation:normal_name], 3, GL_FLOAT, GL_FALSE, stride, (GLvoid*)(sizeof(CC3Vector)));
    //glVertexAttribPointer([self.program1 attributeLocation:color_name], 3, GL_FLOAT, GL_FALSE, stride, (GLvoid*)(sizeof(CC3Vector)));
    glVertexAttribPointer(
                          [self.program1 attributeLocation:texcoord_name], // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)(3*sizeof(CC3Vector))                   // offset of first element
                          );
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
}
  
@end
