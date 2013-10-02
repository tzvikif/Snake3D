//
//  Floor.m
//  Snake3D
//
//  Created by tzviki fisher on 20/09/13.
//
//

#import "Floor.h"
#import "GLProgram.h"

@implementation Floor
NSString *gridFloor_name = @"gridFloor";
NSString *mvp_name = @"mvp";

-(void)initResources {
    [self.program1 addAttribute:gridFloor_name];
    [self.program1 addUniform:mvp_name];
}

-(void)Render {
    glEnable(GL_DEPTH_TEST);
    //glClearColor(0.4, 0.9, 0.9, 1.0);
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = 0.;
    translateVector.y = 0.0;
    translateVector.z = -1.0;
    
    [self.modelMatrix translateBy:translateVector];
    [self.modelMatrix scaleBy:CC3VectorMake(30.0,1.0, 30.0)];
    //[self.projectionMatrix print:@"Projection"];
    //[self.viewMatrix print:@"View"];
    CC3GLMatrix *projectionMat = [[CC3GLMatrix alloc] initFromGLMatrix:self.projectionMatrix.glMatrix];
    //NSLog(@"projection %@",[projectionMat description]);
    [projectionMat multiplyByMatrix:self.viewMatrix];
    [projectionMat multiplyByMatrix:self.modelMatrix];
    //[self setProjectionMatrix:[CC3GLMatrix identity]];
    glUniformMatrix4fv([self.program1 uniformLocation:mvp_name], 1,   0, projectionMat.glMatrix);
    GLsizei size;   
    GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glVertexAttribPointer(
                          [self.program1 attributeLocation:gridFloor_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    //glDrawArrays(GL_POINTS, 0, size/sizeof(CC3Vector));
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glDrawElements(GL_LINES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, (GLvoid*)(0*sizeof(GLushort)));
}

@end
