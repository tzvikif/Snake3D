//
//  SkyBox.m
//  Snake3D
//
//  Created by tzvikif on 1/7/14.
//
//

#import "SkyBox.h"
#import "GLProgram.h"
#import "Consts.h"

@implementation SkyBox
NSString *snakeTextureCoordName = @"textureCoord";
static NSString *skybox_mvp_name = @"mvp";
static NSString *skybox_sample_name = @"sampler";
static NSString *skyboxPos_name = @"pos";

-(void)initResources {
    [self.program addUniform:skybox_mvp_name];
    [self.program addUniform:skybox_sample_name];
    [self.program addAttribute:skyboxPos_name];
}
-(void)Render {
    [self.program use];
    //    if (_myId != 0 && _myId != 5) {
    //        return;
    //    }
    glDisable(GL_DEPTH_TEST);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
    glUniform1i([self.program uniformLocation:skybox_sample_name], /*GL_TEXTURE*/1);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector = CC3VectorMake(self.viewMatrix.glMatrix[3], self.viewMatrix.glMatrix[7], self.viewMatrix.glMatrix[11]);
    [self.modelMatrix translateBy:translateVector];
    //[self.modelMatrix multiplyByMatrix:self.rotatetionMat];
    [self.modelMatrix scaleBy:self.scaleFactor];
    CC3GLMatrix *projectionMat = [CC3GLMatrix identity];
    [projectionMat populateFrom:self.projectionMatrix];
    //    NSLog(@"projection %@",[projectionMat description]);
    //    NSLog(@"view %@",[self.viewMatrix description]);
    [projectionMat multiplyByMatrix:self.viewMatrix];
    [projectionMat multiplyByMatrix:self.modelMatrix];
    //[self setProjectionMatrix:[CC3GLMatrix identity]];
    glUniformMatrix4fv([self.program uniformLocation:mvp_name], 1,   0, projectionMat.glMatrix);
    GLsizei size;
    GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glVertexAttribPointer(
                          [self.program attributeLocation:bp_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glVertexAttribPointer(
                          [self.program attributeLocation:snakeTextureCoordName], // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)sizeof(CC3Vector)                  // offset of first element
                          );
    
    //glDrawArrays(GL_TRIANGLES, 0, size/sizeof(_vertexPC));
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    if (_isDrawEnabled) {
        glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, (GLvoid*)0);
    }
}
@end
