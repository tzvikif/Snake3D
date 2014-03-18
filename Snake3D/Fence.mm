//
//  Fence.m
//  Snake3D
//
//  Created by tzviki fisher on 3/17/14.
//
//

#import "Fence.h"
#import "GLProgram.h"
#import "Consts.h"

static NSString *mvp_name = @"mvp";
static NSString *pos_name = @"pos";
//static NSString *foodColor_name = @"color";
static NSString *textureCoord_name = @"textureCoord";
static NSString *sample_name = @"sampler";

@implementation Fence

-(void)initResources {
    //attributes
    [self.program addAttribute:pos_name];
    [self.program addAttribute:textureCoord_name];
    
    //uniforms
    [self.program addUniform:mvp_name];
    [self.program addUniform:sample_name];
}

-(void)Render {
    [self.program use];
    glEnable(GL_DEPTH_TEST);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.material.textureId);
    glUniform1i([self.program uniformLocation:sample_name], /*GL_TEXTURE*/0);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    
    self.modelMatrix = [CC3GLMatrix identity];
    //CC3Vector translateVector = self.position;
    [self.modelMatrix scaleBy:CC3VectorMake(N/2.0, 32, N/2.0)];
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
                          [self.program attributeLocation:pos_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glVertexAttribPointer(
                          [self.program attributeLocation:textureCoord_name], // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)(3*sizeof(CC3Vector))                  // offset of first element
                          );
    
    //glDrawArrays(GL_TRIANGLES, 0, size/sizeof(_vertexPC));
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glDrawElements(GL_TRIANGLES, /*size/sizeof(GLushort)*/6, GL_UNSIGNED_SHORT, (GLvoid*)(0*sizeof(GLushort)));
}


@end
