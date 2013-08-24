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
NSString *texcoord_name = @"texcoord";
NSString* position_name = @"Position";
NSString* normal_name = @"Normal";

-(void)initialize {
    /*
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = 0;
    translateVector.y = 0;
    translateVector.z = -4;
    [self.modelMatrix populateFromTranslation:translateVector];
    [self.modelMatrix scaleUniformlyBy:1.0];
    
    
    [self.program1 addAttribute:position_name];
    [self.program1 addAttribute:normal_name];
    [self.program1 addAttribute:texcoord_name];
     */
    [self.program1 use];
}
-(void)Render {
    int size;
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D,self.material.textureId );
//    glUniform1i(self.material.textureId, /*GL_TEXTURE*/0);

    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    GLsizei stride =  _vs == PNCT?sizeof(Vertex4):sizeof(Vertex3);
    stride = 0;
    glVertexAttribPointer([self.program1 attributeLocation:position_name], 3, GL_FLOAT, GL_FALSE, stride,(GLvoid*)0);
//    glVertexAttribPointer([self.program1 attributeLocation:normal_name], 3, GL_FLOAT, GL_FALSE, stride, (GLvoid*)(sizeof(CC3Vector)));
    //glVertexAttribPointer([self.program1 attributeLocation:color_name], 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)(sizeof(CC3Vector)));
//    glVertexAttribPointer(
//                          [self.program1 attributeLocation:texcoord_name], // attribute
//                          2,                  // number of elements per vertex, here (x,y)
//                          GL_FLOAT,           // the type of each element
//                          GL_FALSE,           // take our values as-is
//                          stride,                  // no extra data between each position
//                          (GLvoid*)(2*sizeof(CC3Vector) + sizeof(CC3Vector4))                   // offset of first element
//                          );
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
}
  
@end
