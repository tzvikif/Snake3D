
//  SkyBox.m
//  Snake3D
//
//  Created by tzvikif on 1/7/14.
//
//

#import "SkyBox.h"
#import "GLProgram.h"
#import "Consts.h"

@interface SkyBox()
-(void)drawFace:(int)face;
@end

@implementation SkyBox
static NSString *skyBoxTextureCoord_name = @"textureCoord";
static NSString *skybox_mvp_name = @"mvp";
static NSString *skybox_sample_name = @"sampler";
static NSString *skyboxPos_name = @"pos";
//static NSString *skyboxColor_name = @"color";

-(void)initResources {
    [self.program addUniform:skybox_mvp_name];
    [self.program addUniform:skybox_sample_name];
    [self.program addAttribute:skyboxPos_name];
    [self.program addAttribute:skyBoxTextureCoord_name];
    [self setScaleFactor:CC3VectorMake(N/2.0, N/2.0, N/2.0)];
    //[self.program addAttribute:skyboxColor_name];
}
-(void)Render {
    [self.program use];
    //    if (_myId != 0 && _myId != 5) {
    //        return;
    //    }
    //glEnable(GL_TEXTURE_2D);
    glDisable(GL_DEPTH_TEST);
    glActiveTexture(GL_TEXTURE1);
    GLint OldCullFaceMode;
    glGetIntegerv(GL_CULL_FACE_MODE, &OldCullFaceMode);
    GLint OldDepthFuncMode;
    glGetIntegerv(GL_DEPTH_FUNC, &OldDepthFuncMode);
    glCullFace(GL_FRONT);
    
    glUniform1i([self.program uniformLocation:skybox_sample_name], /*GL_TEXTURE*/1);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector = CC3VectorMake(self.viewMatrix.glMatrix[12], self.viewMatrix.glMatrix[13], self.viewMatrix.glMatrix[14]);
    [self.modelMatrix translateBy:translateVector];
    //[self.modelMatrix multiplyByMatrix:self.rotatetionMat];
    [self.modelMatrix scaleBy:CC3VectorScale(self.scaleFactor, CC3VectorMake(4, 4, 4))];
    CC3GLMatrix *projectionMat = [CC3GLMatrix identity];
    [projectionMat populateFrom:self.projectionMatrix];
    //    NSLog(@"projection %@",[projectionMat description]);
    //    NSLog(@"view %@",[self.viewMatrix description]);
    [projectionMat multiplyByMatrix:self.viewMatrix];
    [projectionMat multiplyByMatrix:self.modelMatrix];
    //[self setProjectionMatrix:[CC3GLMatrix identity]];
    glUniformMatrix4fv([self.program uniformLocation:skybox_mvp_name], 1,   0, projectionMat.glMatrix);
    //    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    
    [self drawFace:GL_TEXTURE_CUBE_MAP_NEGATIVE_Z];
    [self drawFace:GL_TEXTURE_CUBE_MAP_NEGATIVE_X];
    [self drawFace:GL_TEXTURE_CUBE_MAP_POSITIVE_Y];
    [self drawFace:GL_TEXTURE_CUBE_MAP_NEGATIVE_Y];
    [self drawFace:GL_TEXTURE_CUBE_MAP_POSITIVE_Z];
    [self drawFace:GL_TEXTURE_CUBE_MAP_NEGATIVE_Z];
    glCullFace(OldCullFaceMode);
    glDepthFunc(OldDepthFuncMode);
}
-(void)drawFace:(int)face {
    Material *mtrl;
    mtrl = [self.materials objectForKey:[NSNumber numberWithInt:face]];
    glBindTexture(GL_TEXTURE_2D,mtrl.textureId);
    glUniform1i([self.program uniformLocation:skybox_sample_name], /*GL_TEXTURE*/1);
    GLsizei size;
    GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
    glVertexAttribPointer(
                          [self.program attributeLocation:skyboxPos_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glVertexAttribPointer(
                          [self.program attributeLocation:skyBoxTextureCoord_name], // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)sizeof(CC3Vector)                  // offset of first element
                          );
    
    switch (face) {
        case GL_TEXTURE_CUBE_MAP_POSITIVE_Z  :
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(12*sizeof(GLushort)));
            break;
        case GL_TEXTURE_CUBE_MAP_NEGATIVE_Z:
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(0*sizeof(GLushort)));
            break;
        case GL_TEXTURE_CUBE_MAP_NEGATIVE_Y:
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(18*sizeof(GLushort)));
            break;
        case GL_TEXTURE_CUBE_MAP_POSITIVE_Y:
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(6*sizeof(GLushort)));
            break;
        case GL_TEXTURE_CUBE_MAP_NEGATIVE_X:
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(24*sizeof(GLushort)));
            break;
        case GL_TEXTURE_CUBE_MAP_POSITIVE_X:
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid*)(30*sizeof(GLushort)));
            break;
        default:
            break;
    }
    
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.drawable.iboIndexBuffer);
//    glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
//    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, (GLvoid*)0);

}
@end