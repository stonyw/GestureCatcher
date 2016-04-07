//
//  LMSGestureTypeC.m
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGestureTypeC.h"

@interface LMSGestureTypeC ()

@property (nonatomic, assign) float   lastDistance;
@property (nonatomic, assign) BOOL    hitMinDistance;

@end

@implementation LMSGestureTypeC

- (id)initWithGestureName:(NSString*)name withDelegate:(id<LMSGestureDelegate>)delegate {
    if (self == [super initWithGestureName:name withDelegate:delegate]) {
        self.startDistance = 80;
        self.minDistance = 40;
        self.endDistance = 60;
    }
    return self;
}

- (BOOL)matchStart:(LeapFrame*)frame {
    if (frame.hands.count == 2) {
        LeapHand *handA = frame.hands[0];
        LeapHand *handB = frame.hands[1];
        if (handA.isLeft != handB.isLeft) {
            LeapHand *handL = handA;
            LeapHand *handR = handB;
            if (handA.isRight) {
                handL = handB;
                handR = handA;
            }
            
            if (self.log) {
                float angleL = [handL.palmNormal angleTo:[LeapVector down]];
                float angleR = [handR.palmNormal angleTo:[LeapVector down]];
                
                float angleNormal = [handL.palmNormal angleTo:handR.palmNormal];
                
                if (fabs(angleL) < LEAP_PI * 0.16 && fabs(angleR) < LEAP_PI * 0.16 &&  fabs(angleNormal) < LEAP_PI * 0.2) {
                    NSLog(@"Angle Normal: %f left: %f right:%f", angleNormal, angleL, angleR);
                    
                    LeapBone *indexFingerDistal = nil;
                    for (LeapFinger* finger in handL.fingers ) {
                        if (finger.type == LEAP_FINGER_TYPE_INDEX) {
                            indexFingerDistal = [finger bone:LEAP_BONE_TYPE_DISTAL];
                        }
                    }
                    
                    if (indexFingerDistal) {
                        float distance = [indexFingerDistal.center distanceTo:handR.palmPosition];
                        
                        
                        if (!self.hitMinDistance) {
                            if (distance < self.minDistance) {
                                // Min boundary value
                                self.lastDistance = distance;
                                self.hitMinDistance = YES;
                                return YES;
                            } else if (distance < self.lastDistance) {
                                // Distance decrease
                                self.lastDistance = distance;
                                return YES;
                            }
                        } else {
                            if (distance < self.minDistance) {
                                // Min boundary value
                                self.lastDistance = distance;
                                self.hitMinDistance = YES;
                                return YES;
                            } else if (distance > self.lastDistance){
                                // Distance increase
                                self.lastDistance = distance;
                                return YES;
                            }
                        }
                    }
                    
                    NSLog(@"Directions: %@ and %@", [self toS:handL.direction], [self toS:handR.direction]);
                    NSLog(@"Bone distance to Right: %f", [indexFingerDistal.center distanceTo:handR.palmPosition]);

                }
            }
        }
    }
    return [super matchStart:frame];
}

- (BOOL)matchEnd:(LeapFrame*)frame {
    if (frame.hands.count == 2) {
        LeapHand *handA = frame.hands[0];
        LeapHand *handB = frame.hands[1];
        if (handA.isLeft != handB.isLeft) {
            LeapHand *handL = handA;
            LeapHand *handR = handB;
            if (handA.isRight) {
                handL = handB;
                handR = handA;
            }
            
            if (self.log) {
                float angleL = [handL.palmNormal angleTo:[LeapVector down]];
                float angleR = [handR.palmNormal angleTo:[LeapVector down]];
                
                float angleNormal = [handL.palmNormal angleTo:handR.palmNormal];
                
                if (fabs(angleL) < LEAP_PI * 0.16 && fabs(angleR) < LEAP_PI * 0.16 &&  fabs(angleNormal) < LEAP_PI * 0.2) {
                    
                    LeapBone *indexFingerDistal = nil;
                    for (LeapFinger* finger in handL.fingers ) {
                        if (finger.type == LEAP_FINGER_TYPE_INDEX) {
                            indexFingerDistal = [finger bone:LEAP_BONE_TYPE_DISTAL];
                        }
                    }
                    
                    if (indexFingerDistal) {
                        float distance = [indexFingerDistal.center distanceTo:handR.palmPosition];
                        
                        if (self.hitMinDistance && distance > self.endDistance) {
                            return YES;
                        }
                    }
                }
            }
        }
    }
    return [super matchEnd:frame];
}

- (void)resetStatus {
    [super resetStatus];
    self.lastDistance = self.startDistance;
    self.hitMinDistance = NO;
}

- (NSString*)toS:(LeapVector*)vector {
    return [NSString stringWithFormat:@"(%f, %f, %f)", vector.x, vector.y, vector.z];
}

@end
