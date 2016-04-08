//
//  LMSGestureTypeB.m
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGestureTypeB.h"
#import "LMSConst.h"
#import "LeapObjectiveC.h"

@interface LMSGestureTypeB ()

@property (nonatomic, assign) float lastDistance;

@end

@implementation LMSGestureTypeB

- (id)initWithGestureName:(NSString*)name withShortName:(NSString*)shortName withDelegate:(id<LMSGestureDelegate>)delegate {
    if (self == [super initWithGestureName:name withShortName:(NSString*)shortName withDelegate:delegate]) {
        
    }
    return self;
}

- (BOOL)matchStart:(LeapFrame*)frame {
    if (frame.hands.count == 2) {
        LeapHand *handA = frame.hands[0];
        LeapHand *handB = frame.hands[1];
        
//        NSLog(@"Position: %@ and %@", [self toS:handA.palmPosition], [self toS:handB.palmPosition]);]
        float dist = [handA.palmPosition distanceTo:handB.palmPosition];
        float vax = fabs(handA.palmVelocity.x);
        float vbx = fabs(handB.palmVelocity.x);
        if (dist < self.lastDistance && dist >= 80 && vax > 200 && vbx > 200) {
            if (self.log) {
                NSLog(@"Distance: %f", dist);
                NSLog(@"Velocity: %f and %f", vax, vbx);
            }
            return YES;
        }
    }
    return [super matchStart:frame];
}

- (BOOL)matchEnd:(LeapFrame*)frame {
    if (frame.hands.count == 2) {
        LeapHand *handA = frame.hands[0];
        LeapHand *handB = frame.hands[1];
        
        float dist = [handA.palmPosition distanceTo:handB.palmPosition];
        float vax = fabs(handA.palmVelocity.x);
        float vbx = fabs(handB.palmVelocity.x);
        if (dist < 80 && vax > 100 && vbx > 100) {
            if (self.log) {
                NSLog(@"Distance end: %f", dist);
                NSLog(@"Velocity end: %f and %f", vax, vbx);
            }
            return YES;
        }
    }
    return [super matchEnd:frame];
}

- (void)resetStatus {
    [super resetStatus];
    self.lastDistance = 300;
}

- (NSString*)toS:(LeapVector*)vector {
    return [NSString stringWithFormat:@"(%f, %f, %f)", vector.x, vector.y, vector.z];
}

@end
