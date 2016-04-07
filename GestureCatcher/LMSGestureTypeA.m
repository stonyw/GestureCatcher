//
//  LMSGestureTypeA.m
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGestureTypeA.h"
#import "LMSConst.h"
#import "LeapObjectiveC.h"

@implementation LMSGestureTypeA

- (id)initWithGestureName:(NSString*)name withDelegate:(id<LMSGestureDelegate>)delegate {
    if (self == [super initWithGestureName:name withDelegate:delegate]) {
        self.fingerStatus = [[NSMutableArray alloc] initWithArray:@[@0, @3, @0, @3, @0]];
        _lastFingersStatus = @[@0, @3, @0, @3, @0];
    }
    return self;
}

- (BOOL)temp:(LeapController *)controller {
    //    NSLog(@"New LeapFrame");
    LeapFrame *frame = [controller frame:0];
    
    BOOL fire = NO;
    
    // Get hands
    for (LeapHand *hand in frame.hands) {
        if (!hand.isLeft) {
            continue;
        }
        NSString *handType = hand.isLeft ? @"Left hand" : @"Right hand";
        //        NSLog(@"  %@, id: %i, palm position: %@",
        //              handType, hand.id, hand.palmPosition);
        
        // Get the hand's normal vector and direction
        const LeapVector *normal = [hand palmNormal];
        const LeapVector *direction = [hand direction];
        
        // Calculate the hand's pitch, roll, and yaw angles
        NSLog(@"  pitch: %f degrees, roll: %f degrees, yaw: %f degrees, palm direction: %@\n",
              [direction pitch] * LEAP_RAD_TO_DEG,
              [normal roll] * LEAP_RAD_TO_DEG,
              [direction yaw] * LEAP_RAD_TO_DEG,
              direction);
        
        //        // Get the Arm bone
        //        LeapArm *arm = hand.arm;
        //        NSLog(@"    Arm direction: %@, wrist position: %@, elbow position: %@", arm.direction, arm.wristPosition, arm.elbowPosition);
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        for (LeapFinger *finger in hand.fingers) {
            if (finger.type != LEAP_FINGER_TYPE_PINKY
                && finger.type != LEAP_FINGER_TYPE_THUMB
                && finger.type != LEAP_FINGER_TYPE_MIDDLE) {
                continue;
            }
            //            NSLog(@"    %@, id: %i, length: %fmm, width: %fmm",
            //                  [_fingerNames objectAtIndex:finger.type],
            //                  finger.id, finger.length, finger.width);
            
            for (int boneType = LEAP_BONE_TYPE_METACARPAL; boneType <= LEAP_BONE_TYPE_DISTAL; boneType++) {
                if (boneType != LEAP_BONE_TYPE_DISTAL) {
                    continue;
                }
                LeapBone *bone = [finger bone:boneType];
                //                NSLog(@"      %@ bone of %@, start: %@, end: %@, direction: %@,  palm angleto: %f",
                //                      [_boneNames objectAtIndex:boneType], [_fingerNames objectAtIndex:finger.type], bone.prevJoint, bone.nextJoint, bone.direction, [direction angleTo:bone.direction]);
                
                NSLog(@"      %@ bone of %@, direction: %@,  palm angleto: %f",
                      [[LMSConst BoneNames] objectAtIndex:boneType], [[LMSConst FingerNames] objectAtIndex:finger.type], bone.direction, [direction angleTo:bone.direction]);
                
                if (finger.type == LEAP_FINGER_TYPE_MIDDLE) {
                    float angle = [direction angleTo:bone.direction];
                    if (angle < LEAP_PI * 0.5 && angle > 0) {
                        NSLog(@"   %@ 手势开始", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @1;
                    } else if (angle < LEAP_PI && angle > LEAP_PI * 0.5) {
                        NSLog(@"   %@ 手势结束", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @2;
                    } else {
                        NSLog(@"   %@ 手势未知", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @0;
                    }
                }
                
                if (finger.type == LEAP_FINGER_TYPE_THUMB) {
                    float angle = [direction angleTo:bone.direction];
                    if (angle < LEAP_PI * 0.75 && angle > 0) {
                        NSLog(@"   %@ 手势就位", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @4;
                    } else if (angle < LEAP_PI && angle > LEAP_PI * 0.75) {
                        NSLog(@"   %@ 手势离开", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @0;
                    } else {
                        NSLog(@"   %@ 手势未知", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @0;
                    }
                }
                
                if (finger.type == LEAP_FINGER_TYPE_PINKY) {
                    float angle = [direction angleTo:bone.direction];
                    if (angle < LEAP_PI * 0.5 && angle > 0) {
                        NSLog(@"   %@ 手势就位", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @4;
                    } else if (angle < LEAP_PI && angle > LEAP_PI * 0.5) {
                        NSLog(@"   %@ 手势离开", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @0;
                    } else {
                        NSLog(@"   %@ 手势未知", [[LMSConst FingerNames] objectAtIndex:finger.type]);
                        self.fingerStatus[finger.type] = @0;
                    }
                }
            }
        }
        
        if (_lastFingersStatus != nil) {
            if ( ((NSNumber*)_lastFingersStatus[0]).intValue == 4
                && ((NSNumber*)_lastFingersStatus[1]).intValue == 3
                && ((NSNumber*)_lastFingersStatus[2]).intValue == 1
                && ((NSNumber*)_lastFingersStatus[3]).intValue == 3
                && ((NSNumber*)_lastFingersStatus[4]).intValue == 4
                && ((NSNumber*)self.fingerStatus[0]).intValue == 4
                && ((NSNumber*)self.fingerStatus[1]).intValue == 3
                && ((NSNumber*)self.fingerStatus[2]).intValue == 2
                && ((NSNumber*)self.fingerStatus[3]).intValue == 3
                && ((NSNumber*)self.fingerStatus[4]).intValue == 4) {
                fire = YES;
                
            }
        }
        _lastFingersStatus = [self.fingerStatus copy];
        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [self showFingerStatus:self.fingerStatus];
//        });
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    }
    return fire;
}

- (BOOL)matchStart:(LeapFrame*)frame {
    NSInteger count = 0;
    if (self.log) {
        NSLog(@"matchStart:");
    }
    for (LeapHand *hand in frame.hands) {
        if (!hand.isLeft) {
            continue;
        }
        
        for (LeapFinger *finger in hand.fingers) {
            switch (finger.type) {
                case LEAP_FINGER_TYPE_THUMB:
                    if ([self matchThumbFinger:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_MIDDLE:
                    if ([self matchMiddleFingerStart:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_PINKY:
                    if ([self matchPinkyFinger:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    return count == 3? YES : [super matchStart:frame];
}

- (BOOL)matchEnd:(LeapFrame*)frame {
    NSInteger count = 0;
    
    for (LeapHand *hand in frame.hands) {
//        if (!hand.isLeft) {
//            continue;
//        }
        
        for (LeapFinger *finger in hand.fingers) {
            switch (finger.type) {
                case LEAP_FINGER_TYPE_THUMB:
                    if ([self matchThumbFinger:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_MIDDLE:
                    if ([self matchMiddleFingerEnd:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_PINKY:
                    if ([self matchPinkyFinger:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    return count == 3? YES : [super matchEnd:frame];
}

- (BOOL)matchThumbFinger:(LeapFinger*)finger withHandDirection:(LeapVector*)direction {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float angle = [direction angleTo:bone.direction];
    if (self.log) {
//        NSLog(@"  [%@]: %@ %f in [%f..%f]", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type], angle, 0.0, PI * 0.75);
    }
    if (angle < LEAP_PI * 0.65 && angle > 0) {
        if (self.log) {
            NSLog(@"  [%@]: %@ 手势就位", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type]);
        }
        return YES;
    }
    return NO;
}

- (BOOL)matchMiddleFingerStart:(LeapFinger*)finger withHandDirection:(LeapVector*)direction {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float angle = [direction angleTo:bone.direction];
    if (angle < LEAP_PI * 0.65 && angle > 0) {
        if (self.log) {
            NSLog(@"   [%@]: %@ 手势开始", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type]);
        }
        return YES;
    }
    return NO;
}

- (BOOL)matchMiddleFingerEnd:(LeapFinger*)finger withHandDirection:(LeapVector*)direction {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float angle = [direction angleTo:bone.direction];
    if (angle < LEAP_PI && angle > LEAP_PI * 0.65) {
        if (self.log) {
            NSLog(@"   [%@]: %@ 手势结束", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type]);
        }
        return YES;
    }
    return NO;
}

- (BOOL)matchPinkyFinger:(LeapFinger*)finger withHandDirection:(LeapVector*)direction {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float angle = [direction angleTo:bone.direction];
    if (angle < LEAP_PI * 0.5 && angle > 0) {
        if (self.log) {
            NSLog(@"   [%@]: %@ 手势就位", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type]);
        }
        return YES;
    }
    return NO;
}

@end
