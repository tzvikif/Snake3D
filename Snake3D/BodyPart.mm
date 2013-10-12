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
    _dir = DIR_UP;
    _currentRotatoinAngle = 0;
    _inRotation = NO;
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    [self setTurnsAndPositions:arrTemp];
    [arrTemp release];
    [self setRotatetionMat:[CC3GLMatrix identity]];

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
    [self.modelMatrix multiplyByMatrix:self.rotatetionMat];
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
    NSLog(@"curent posiont x=%f z=%f",_position.x,_position.z);
    static int maxStepsBeforeTurn = ceil(1.0/_speed); //cube size/speed
    if ([_turnsAndPositions count] > 0 && !_inRotation) {
        TurnPosition *turnPos = [_turnsAndPositions objectAtIndex:0];
        _nextTurnDir = turnPos.nextTurnDir;
        CC3Vector nextTurnPos = turnPos.nextTurnPos;
        CC3Vector deltaPos = CC3VectorAdd(nextTurnPos, CC3VectorNegate(_position));
        deltaPos = CC3VectorScale(deltaPos, CC3VectorMake(100.0, 100.0, 100.0));
        deltaPos.x = roundf(deltaPos.x);
        deltaPos.y = roundf(deltaPos.y);
        deltaPos.z = roundf(deltaPos.z);
        deltaPos = CC3VectorScale(deltaPos, CC3VectorMake(1/100.0, 1/100.0, 1/100.0));
        float numOfStepsRotation;
        if (_dir == DIR_UP || _dir == DIR_DOWN) {
            numOfStepsRotation = deltaPos.z / _velocity.z>0?deltaPos.z / _velocity.z:deltaPos.z / _velocity.z*-1;
        }
        else
        {
            numOfStepsRotation = deltaPos.x / _velocity.z>0?deltaPos.x / _velocity.z:deltaPos.x / _velocity.x*-1;
        }
        NSLog(@"numOfStepsRotation=%f",numOfStepsRotation);
        if (numOfStepsRotation <= maxStepsBeforeTurn) {
            _inRotation = YES;
            switch (turnPos.nextTurnDir) {
                case DIR_RIGHT:
                    _destAngle = 270.0;
                    break;
                case DIR_LEFT:
                    _destAngle = 90.0;
                    break;
                case DIR_UP:
                    _destAngle = 0.0;
                    break;
                case DIR_DOWN:
                    _destAngle = 180.0;
                    break;
                default:
                    NSException* myException = [NSException
                                                exceptionWithName:@"direction error"
                                                reason:[NSString stringWithFormat:@"%d: no such direction",turnPos.nextTurnDir]
                                                userInfo:nil];
                    @throw myException;
                    break;
            }
            _rotationAngleStep = (_destAngle - _currentRotatoinAngle)/numOfStepsRotation;
            _rotationAngleStep*=100;
            _rotationAngleStep = roundf(_rotationAngleStep);
            _rotationAngleStep/=100;
        }
    }
    if (_inRotation) {
        _currentRotatoinAngle += _rotationAngleStep;
        _currentRotatoinAngle*=100;
        _currentRotatoinAngle = roundf(_currentRotatoinAngle);
        _currentRotatoinAngle/=100;
        NSLog(@"_currentRotatoinAngle=%f _destAngle=%f",_currentRotatoinAngle,_destAngle);
        if (_currentRotatoinAngle >= _destAngle) {
            _currentRotatoinAngle = _destAngle;
            _inRotation = NO;
            [_turnsAndPositions removeObjectAtIndex:0];
            switch (_nextTurnDir) {
                case DIR_RIGHT:
                    _velocity = CC3VectorMake(0, 0, _speed);
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
                                                reason:[NSString stringWithFormat:@"%d: no such direction",_nextTurnDir]
                                                userInfo:nil];
                    @throw myException;
                    break;
            }
            
            
        }
        [self setRotatetionMat:[CC3GLMatrix identity]];
        [_rotatetionMat rotateByY:_currentRotatoinAngle];
    }
        //CC3Vector tempPos = CC3VectorAdd(_position, CC3VectorScale(_velocity, CC3VectorMake(stepsBeforeTurn, stepsBeforeTurn, stepsBeforeTurn)));
        //DIRECTION nextTurnDir = turnPos.nextTurnDir;
        //to avoid floating point problems
//        tempPos.x *= 100;
//        tempPos.z *= 100;
//        nextTurnPos.x *= 100;
//        nextTurnPos.z *= 100;
//        tempPos.x = roundf(tempPos.x);
//        tempPos.z = roundf(tempPos.z);
//        nextTurnPos.x = roundf(nextTurnPos.x);
//        nextTurnPos.z = roundf(nextTurnPos.z);
//        tempPos.x /= 100;
//        tempPos.z /= 100;
//        nextTurnPos.x /= 100;
//        nextTurnPos.z /= 100;
        
        //the position stepsBeforeTurn ahead.
        
//        if (tempPos.x == nextTurnPos.x &&
//            tempPos.z == nextTurnPos.z) {
 
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
