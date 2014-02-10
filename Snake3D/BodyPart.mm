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
static NSString *model_name = @"Model";
static NSString *mvp_name = @"MVP";
static NSString *view_name = @"View";
static NSString *projection_name = @"Projection";
static NSString *position_name = @"Position";
static NSString *color_name = @"Color";
static NSString *textureCoord_name = @"TextureCoord";
static NSString *sample_name = @"Sampler";
static NSString *ambient_name = @"AmbientMaterial";
static NSString *diffuse_name = @"DiffuseMaterial";
static NSString *specular_name = @"SpecularMaterial";
static NSString *shininess_name = @"Shininess";
static NSString *lightPosition_name = @"LightPosition";
static NSString *normalMatrix_name = @"NormalMatrix";
static NSString *normal_name = @"Normal";




-(void)initResources {
    //attributes
    [self.program addAttribute:position_name];
    //[self.program addAttribute:color_name];
    [self.program addAttribute:normal_name];
//    [self.program addAttribute:textureCoord_name];
    //uniforms
    //[self.program addUniform:mvp_name];
    [self.program addUniform:model_name];
    [self.program addUniform:view_name];
    [self.program addUniform:projection_name];
//    [self.program addUniform:sample_name];
    [self.program addUniform:ambient_name];
    [self.program addUniform:diffuse_name];
    [self.program addUniform:specular_name];
    [self.program addUniform:shininess_name];
    [self.program addUniform:lightPosition_name];
    [self.program addUniform:normalMatrix_name];
    
    _velocity = CC3VectorMake(0, 0, -_speed);
    _dir = DIR_UP;
    _currentRotatoinAngle = 0;
    _isRotating = NO;
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
    //glActiveTexture(GL_TEXTURE0);
    //glBindTexture(GL_TEXTURE_2D, self.material.textureId);
    //glUniform1i([self.program uniformLocation:snakeSample_name], /*GL_TEXTURE*/0);
    //glClearColor(0.4, 0.9, 0.9, 1.0);
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    GLsizei window_height = self.viewport.size.height;
    GLsizei window_width = self.viewport.size.width;
    glViewport(0, 0, window_width, window_height);
    
    glUniform3f([self.program uniformLocation:ambient_name], 0.1f, 0.1f, 0.1f);
    glUniform3f([self.program uniformLocation:specular_name],9.0, 9.0, 0.0);
    glUniform1f([self.program uniformLocation:shininess_name],60);
    // Set the light position.
    CC3Vector4 lightPosition  = CC3Vector4Make(0.0,10.0,0.0,0.0);
    glUniform4f([self.program uniformLocation:lightPosition_name], lightPosition.x, lightPosition.y, lightPosition.z,lightPosition.w);
    CC3Vector color = CC3VectorMake(200.0/255.0, 150.0/255.0, 250.0/255.0);
    glUniform3f([self.program uniformLocation:diffuse_name], color.x, color.y, color.z);
    
    self.modelMatrix = [CC3GLMatrix identity];
    //CC3Vector translateVector = self.position;
    CC3Vector translateVector = self.crawlPosition;
    [self.modelMatrix translateBy:translateVector];
    [self.modelMatrix multiplyByMatrix:self.rotatetionMat];
    if (_myId == 0) {
        CC3GLMatrix *mat = [CC3GLMatrix identity];
        [mat rotateByY:180];
        [self.modelMatrix multiplyByMatrix:mat];
    }
    [self.modelMatrix scaleBy:self.scaleFactor];
    glUniformMatrix4fv([self.program uniformLocation:model_name], 1,   0, self.modelMatrix.glMatrix);
    glUniformMatrix4fv([self.program uniformLocation:view_name], 1,   0, self.viewMatrix.glMatrix);
    CC3GLMatrix *projectionMat = [CC3GLMatrix identity];
    [projectionMat populateFrom:self.projectionMatrix];
    glUniformMatrix4fv([self.program uniformLocation:projection_name], 1,   0, projectionMat.glMatrix);
//    NSLog(@"projection %@",[projectionMat description]);
//    NSLog(@"view %@",[self.viewMatrix description]);
    [projectionMat multiplyByMatrix:self.viewMatrix];
    [projectionMat multiplyByMatrix:self.modelMatrix];
    //[self setProjectionMatrix:[CC3GLMatrix identity]];
    //glUniformMatrix4fv([self.program uniformLocation:mvp_name], 1,   0, projectionMat.glMatrix);
    GLsizei size;
    GLsizei stride = [self getStride];
    glBindBuffer(GL_ARRAY_BUFFER, self.drawable.vboVertexBuffer);
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glVertexAttribPointer(
                          [self.program attributeLocation:position_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)0                  // offset of first element
                          );
    glVertexAttribPointer(
                          [self.program attributeLocation:normal_name], // attribute
                          3,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          stride,                  // no extra data between each position
                          (GLvoid*)sizeof(CC3Vector)                  // offset of first element
                          );
//    glVertexAttribPointer(
//                          [self.program attributeLocation:color_name], // attribute
//                          2,                  // number of elements per vertex, here (x,y)
//                          GL_FLOAT,           // the type of each element
//                          GL_FALSE,           // take our values as-is
//                          stride,                  // no extra data between each position
//                          (GLvoid*)(2*sizeof(CC3Vector))                  // offset of first element
//                          );
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
    if ([_turnsAndPositions count] > 0 && !_isRotating) {
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
            _isRotating = YES;
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
    if (_isRotating) {
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
        if ( ((_nextTurnDir == DIR_DOWN || _nextTurnDir == DIR_UP) && _position.x == _nextTurnPos.x) ||
            ((_nextTurnDir == DIR_RIGHT || _nextTurnDir == DIR_LEFT) && _position.z == _nextTurnPos.z) ) {
            _currentRotatoinAngle = _destAngle;
            _isRotating = NO;
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
        //NSLog(@"current rotation angle:%f",_currentRotatoinAngle);
    }
 
    _position = CC3VectorAdd(_position,_velocity);
    _crawlPosition = _position;
    
    GLfloat crawlPos;
    switch (_dir) {
        case DIR_LEFT:
        case DIR_RIGHT:
            crawlPos = sinf(_position.x*2*3.1415/4.0)/8.0;
            _crawlPosition.z += crawlPos;
            break;
        case DIR_DOWN:
        case DIR_UP:
            crawlPos = sinf(_position.z*2*3.1415/4.0)/8.0;
            _crawlPosition.x += crawlPos;
            break;
        default:
            break;
    }
//    NSLog(@"postion(%f,%f,%f",_position.x,_position.y,_position.z);
//    NSLog(@"crawlPostion(%f,%f,%f",_crawlPosition.x,_crawlPosition.y,_crawlPosition.z);
}
-(void)addTurnDirection:(DIRECTION)dir inPosition:(CC3Vector)pos {
    TurnPosition *tp = [[TurnPosition alloc] init];
    tp.nextTurnPos = pos;
    tp.nextTurnDir = dir;
    [_turnsAndPositions addObject:tp];
    [tp release];
    
}
-(void)setPosition:(CC3Vector)position {
    _position = position;
    _crawlPosition = _position;
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
