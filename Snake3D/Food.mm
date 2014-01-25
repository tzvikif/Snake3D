//
//  Food.m
//  Snake3D
//
//  Created by tzvifi on 10/16/13.
//
//

#import "Food.h"
#import "GLProgram.h"
#import "Consts.h"
//#import "Vectors.h"

@implementation Food
static NSString *mvp_name = @"mvp";
static NSString *foodPos_name = @"pos";
//static NSString *foodColor_name = @"color";
static NSString *foodTextureCoord_name = @"textureCoord";
static NSString *foodSample_name = @"sampler";

float food_bsf = 1.0/6.0;   //base scale factor
-(void)initResources {
    //attributes
    [self.program addAttribute:foodPos_name];
    [self.program addAttribute:foodTextureCoord_name];
    //[self.program addAttribute:foodColor_name];
    //uniforms
    [self.program addUniform:mvp_name];
    [self.program addUniform:foodSample_name];
}

-(void)Render {
    [self.program use];
    glEnable(GL_DEPTH_TEST);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
    glUniform1i([self.program uniformLocation:foodSample_name], /*GL_TEXTURE*/0);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translate = CC3VectorMake(self.position.x, self.position.y-0.5, self.position.z);
    //CC3Vector translateVector = self.position;
    [self.modelMatrix translateBy:translate];
    [self.modelMatrix scaleBy:CC3VectorMake(food_bsf, food_bsf, food_bsf)];
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
                          [self.program attributeLocation:foodPos_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glVertexAttribPointer(
                          [self.program attributeLocation:foodTextureCoord_name], // attribute
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
    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, (GLvoid*)0);
}

@end
