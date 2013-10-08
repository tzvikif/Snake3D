//
//  bodyPart.m
//  Snake3D
//
//  Created by tzvifi on 9/30/13.
//
//

#import "BodyPart.h"
#import "GLProgram.h"
#import "Consts.h"
#import "TurnPosition.h"

@implementation BodyPart
extern NSString *mvp_name;
NSString *bp_name = @"gridFloor";
NSString *SnakeColor_name = @"color";
-(void)initResources {
    [self.program addAttribute:bp_name];
    [self.program addUniform:mvp_name];
    [self.program addAttribute:SnakeColor_name];
    _velocity = CC3VectorMake(0, 0, -_speed);
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    [self setTurnsAndPositions:arrTemp];
    [arrTemp release];

}
-(void)Render {
    [self.program use];
//    if (_myId != 0 && _myId != 5) {
//        return;
//    }
    glEnable(GL_DEPTH_TEST);
    //glClearColor(0.4, 0.9, 0.9, 1.0);
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    
    self.modelMatrix = [CC3GLMatrix identity];
    CC3Vector translateVector = self.position;
//    CC3Vector translateVector;
//    translateVector.x = 0.5;
//    translateVector.y = 0.5;
//    translateVector.z = 0.5;

    [self.modelMatrix translateBy:translateVector];
    [self.modelMatrix scaleBy:CC3VectorMake(self.scaleFactor, self.scaleFactor, self.scaleFactor)];
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
                          [self.program attributeLocation:SnakeColor_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
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
-(void)advance {
    if ([_turnsAndPositions count] > 0) {
        TurnPosition *turnPos = [_turnsAndPositions objectAtIndex:0];
        CC3Vector nextTurnPos = turnPos.nextTurnPos;
        DIRECTION nextTurnDir = turnPos.nextTurnDir;
        _position.x *= 100;
        _position.z *= 100;
        nextTurnPos.x *= 100;
        nextTurnPos.z *= 100;
        _position.x = roundf(_position.x);
        _position.z = roundf(_position.z);
        nextTurnPos.x = roundf(nextTurnPos.x);
        nextTurnPos.z = roundf(nextTurnPos.z);
        _position.x /= 100;
        _position.z /= 100;
        nextTurnPos.x /= 100;
        nextTurnPos.z /= 100;
        if (_position.x == nextTurnPos.x &&
            _position.z == nextTurnPos.z) {
            switch (nextTurnDir) {
                case DIR_RIGHT:
                    _velocity = CC3VectorMake(_speed, 0, 0);
                    break;
                case DIR_LEFT:
                    _velocity = CC3VectorMake(-_speed, 0, 0);
                    break;
                case DIR_UP:
                    _velocity = CC3VectorMake(0, 0, -_speed);
                    break;
                case DIR_DOWN:
                    _velocity = CC3VectorMake(0, 0, _speed);
                    break;
                default:
                    NSException* myException = [NSException
                                                exceptionWithName:@"direction error"
                                                reason:[NSString stringWithFormat:@"%d: no such direction",nextTurnDir]
                                                userInfo:nil];
                    @throw myException;
                    break;
            }
            [_turnsAndPositions removeObjectAtIndex:0];
        }

    }
    _position = CC3VectorAdd(_position,_velocity);
    //NSLog(@"id:%d pos.z:%f",_myId,_position.z);
}
-(void)addTurnDirection:(DIRECTION)dir inPosition:(CC3Vector)pos {
    TurnPosition *tp = [[TurnPosition alloc] init];
    tp.nextTurnPos = pos;
    tp.nextTurnDir = dir;
    [_turnsAndPositions addObject:tp];
    [tp release];
    
}
-(void)dealloc {
    [_turnsAndPositions release];
    [super dealloc];
}
@end
