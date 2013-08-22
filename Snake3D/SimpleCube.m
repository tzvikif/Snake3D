//
//  SimpleCube.m
//  Snake3D
//
//  Created by tzvifi on 8/21/13.
//
//

#import "SimpleCube.h"

@implementation SimpleCube
//glUniform1i(_uHandles.Texture, /*GL_TEXTURE*/0);
/*
-(void)Render {
   
    //CC3GLMatrix *model = [CC3GLMatrix identity];
    
    //CC3Vector rotationVect = {0,0,-1};
    //[model rotateBy:_rotationVector];
    
    CC3GLMatrix *view = [CC3GLMatrix identity];
    
    CC3GLMatrix *projection = [CC3GLMatrix identity];
    [view populateToLookAt:CC3VectorMake(0.0, 0.0, -4.0) withEyeAt:CC3VectorMake(1.0, 2.0, 0.0) withUp:CC3VectorMake(0.0, 1.0, 0.0)];
    float ratio =  self.view.frame.size.width / self.view.frame.size.height;
    //[projection populateFromFrustumLeft:-2 andRight:2 andBottom:-bottom andTop:bottom andNear:0.1 andFar:8];
    //[view multiplyByMatrix:model];
    glUniformMatrix4fv(_uHandles.Model, 1, 0, _model.glMatrix);
    glUniformMatrix4fv(_uHandles.View, 1, 0, view.glMatrix);
    [projection populateFromFrustumFov:45.0 andNear:0.1 andFar:10 andAspectRatio:ratio];
    glUniformMatrix4fv(_uHandles.Projection, 1, 0, projection.glMatrix);
    [view multiplyByMatrix:_model];
    glUniformMatrix4fv(_uHandles.NormalMatrix, 1, 0, view.glMatrix);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture_id);
    
    
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_texcoords);
    glVertexAttribPointer(
                          _aHandles.Texcoord, // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          0,                  // no extra data between each position
                          0                   // offset of first element
                          );
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_vertices);
    glVertexAttribPointer(_aHandles.Position, 3, GL_FLOAT, GL_FALSE, 0,(GLvoid*)0);
    
    //glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_colors);
    //glVertexAttribPointer(_aHandles.Color, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_normals);
    glVertexAttribPointer(_aHandles.Normal, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
    //GLfloat fade = sinf(_timeSinceLastUpdate / 2 *(2*M_PI)) / 2  + 0.5;
    //NSLog([NSString stringWithFormat:@"time since last update:%f",fade]);
    //glUniform1f(_uniform_fade, fade);
    //glDrawArrays(GL_TRIANGLES,0,sizeof(triangleVertices)/sizeof(triangleVertices[0]));
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo_cube_elements);
    int size;  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
    GLView *v = (GLView*)self.view;
    [v presentRenderbuffer];
    //[_context presentRenderbuffer:GL_RENDERBUFFER];

}
  */
@end
