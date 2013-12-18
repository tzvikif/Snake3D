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
    _isDrawEnabled = YES;

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
    if (_isDrawEnabled) {
        glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, (GLvoid*)0);
    }
}
-(void)advance {
    static int maxStepsBeforeTurn = ceil(1.0/_speed); //floor cube: size/speed
    if ([_turnsAndPositions count] > 0 && !_inRotation) {
        TurnPosition *turnPos = [_turnsAndPositions objectAtIndex:0];
        _nextTurnDir = turnPos.nextTurnDir;
        _nextTurnPos = turnPos.nextTurnPos;
        CC3Vector deltaPos = CC3VectorAdd(_nextTurnPos, CC3VectorNegate(_position));
        float numOfStepsRotation;
        if (_dir == DIR_UP || _dir == DIR_DOWN) {
            numOfStepsRotation = deltaPos.z / _velocity.z>0?deltaPos.z / _velocity.z:deltaPos.z / _velocity.z*-1;
        }
        else
        {
            numOfStepsRotation = deltaPos.x / _velocity.x>0?deltaPos.x / _velocity.x:deltaPos.x / _velocity.x*-1;
        }
        //NSLog(@"numOfStepsRotation=%f",numOfStepsRotation);
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
            float deltaAngle = _destAngle - _currentRotatoinAngle;
            if (deltaAngle < -90) {
                deltaAngle += 360;
            }
            else if (deltaAngle > 90) {
                deltaAngle -= 360;
            }
            _rotationAngleStep = (deltaAngle)/numOfStepsRotation;
            _rotationAngleStep = floorf(_rotationAngleStep);
//            _rotationAngleStep*=100;
//            _rotationAngleStep = roundf(_rotationAngleStep);
//            _rotationAngleStep/=100;
        }
    }
    if (_inRotation) {
        _currentRotatoinAngle += _rotationAngleStep;
        //NSLog(@"_destAngle=%f _currentRotatoinAngle=%f _rotationAngleStep=%f",_destAngle,_currentRotatoinAngle,_rotationAngleStep);
        GLfloat px,pz;
        px = _position.x;
        pz = _position.z;
        px*=100;
        pz*=100;
        px = roundf(px);
        pz = roundf(pz);
        px/=100;
        pz/=100;
        _position.x = px;
        _position.z = pz;
        //NSLog(@"current position x=%f z=%f. next turn position x=%f z=%f",_position.x,_position.z,_nextTurnPos.x,_nextTurnPos.z);
        if (_position.x == _nextTurnPos.x && _position.z == _nextTurnPos.z) {
            _currentRotatoinAngle = _destAngle;
            _inRotation = NO;
            [_turnsAndPositions removeObjectAtIndex:0];
            switch (_nextTurnDir) {
                case DIR_RIGHT:
                    _velocity = CC3VectorMake(_speed, 0, 0);
                    _dir = DIR_RIGHT;
                    break;
                case DIR_LEFT:
                    _velocity = CC3VectorMake(-_speed, 0, 0);
                    _dir = DIR_LEFT;
                    break;
                case DIR_UP:
                    _velocity = CC3VectorMake(0, 0, -_speed);
                    _dir = DIR_UP;
                    break;
                case DIR_DOWN:
                    _velocity = CC3VectorMake(0, 0, _speed);
                    _dir = DIR_DOWN;
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
        NSLog(@"current rotation angle:%f",_currentRotatoinAngle);
    }
    _position = CC3VectorAdd(_position,_velocity);
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
- (id)copyWithZone:(NSZone *)zone {
    BodyPart *bpCopy = [super copyWithZone:zone];
    bpCopy.position = self.position;
    bpCopy.velocity = self.velocity;
    bpCopy.dir = self.dir;
    bpCopy.nextTurnDir = self.nextTurnDir;
    bpCopy.nextTurnPos = self.nextTurnPos;
    bpCopy.scaleFactor = self.scaleFactor;
    bpCopy.rotatetionMat = self.rotatetionMat;
    bpCopy.myId = self.myId + 1;
    bpCopy.speed = self.speed;
    bpCopy.turnsAndPositions = [self.turnsAndPositions mutableCopy];
    bpCopy.isDrawEnabled = self.isDrawEnabled;
    return  bpCopy;
}
@end
