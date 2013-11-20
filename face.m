//
//  face.m
//  cube
//
//  Created by tzvifi on 7/9/13.
//
//

#import "Face.h"

@implementation Face

-(BOOL)isEqual:(id)object {
    Face *obj;
    if ([object isKindOfClass:[Face class]]) {
        obj = (Face*)object;
    }
    else
    {
        return NO;
    }
    if (self.v == obj.v &&
        self.vt == obj.vt) {
        return YES;
    }
    return NO;
}
@end
