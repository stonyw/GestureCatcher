//
//  LMSGestureTypeD.m
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGestureTypeD.h"
#import "LMSConst.h"
#import "LeapObjectiveC.h"

@implementation LMSGestureTypeD

- (id)initWithGestureName:(NSString*)name withShortName:(NSString*)shortName withDelegate:(id<LMSGestureDelegate>)delegate {
    if (self == [super initWithGestureName:name withShortName:(NSString*)shortName withDelegate:delegate]) {
        
    }
    return self;
}

- (BOOL)matchStart:(LeapFrame*)frame {
    NSInteger count = 0;
    if (self.log) {
//        NSLog(@"matchStart:");
    }
    for (LeapHand *hand in frame.hands) {
        
        for (LeapFinger *finger in hand.fingers) {
            switch (finger.type) {
                case LEAP_FINGER_TYPE_THUMB:
                    if ([self matchThumbFingerStart:finger withHand:hand]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_MIDDLE:
                    if ([self matchMiddleFinger:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_RING:
                    if ([self matchRingFinger:finger withHandDirection:[hand direction]]) {
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
    if (self.log) {
        //        NSLog(@"matchEnd:");
    }
    for (LeapHand *hand in frame.hands) {
        
        for (LeapFinger *finger in hand.fingers) {
            switch (finger.type) {
                case LEAP_FINGER_TYPE_THUMB:
                    if ([self matchThumbFingerEnd:finger withHand:hand]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_MIDDLE:
                    if ([self matchMiddleFinger:finger withHandDirection:[hand direction]]) {
                        count ++;
                    }
                    break;
                case LEAP_FINGER_TYPE_RING:
                    if ([self matchRingFinger:finger withHandDirection:[hand direction]]) {
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

- (BOOL)matchThumbFingerStart:(LeapFinger*)finger withHand:(LeapHand*)hand {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float distance = [hand.palmPosition distanceTo:bone.direction];
    float angle = [hand.direction angleTo:bone.direction];
    if (self.log) {
        //        NSLog(@"  [%@]: %@ %f in [%f..%f]", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type], angle, 0.0, PI * 0.75);
    }
    if ((distance < 125 && distance > 115)&& (angle > 2.2f && angle < 2.6f)) {
        if (self.log) {
            NSLog(@"  [%@]: %@ finger gesture is ready (%f, %f)", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type], distance, angle);
        }
        return YES;
    }
    return NO;
}

- (BOOL)matchThumbFingerEnd:(LeapFinger*)finger withHand:(LeapHand*)hand {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float distance = [hand.palmPosition distanceTo:bone.direction];
    float angle = [hand.direction angleTo:bone.direction];
    if (self.log) {
        //        NSLog(@"  [%@]: %@ %f in [%f..%f]", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type], angle, 0.0, PI * 0.75);
    }
    if (distance > 125 && (angle > 2.2f && angle < 2.6f)) {
        if (self.log) {
            NSLog(@"  [%@]: %@ finger gesture is ready", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type]);
        }
        return YES;
    }
    return NO;
}

- (BOOL)matchMiddleFinger:(LeapFinger*)finger withHandDirection:(LeapVector*)direction {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float angle = [direction angleTo:bone.direction];
    if (angle < LEAP_PI * 0.15 && angle > 0) {
//        if (self.log) {
//            NSLog(@"   [%@]: %@ finger gesture is ready %f", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type], angle);
//        }
        return YES;
    }
    return NO;
}

- (BOOL)matchRingFinger:(LeapFinger*)finger withHandDirection:(LeapVector*)direction {
    LeapBone *bone = [finger bone:LEAP_BONE_TYPE_DISTAL];
    float angle = [direction angleTo:bone.direction];
    if (angle < LEAP_PI * 0.15 && angle > 0) {
//        if (self.log) {
//            NSLog(@"   [%@]: %@ finger gesture is ready", self.name, [[LMSConst FingerNames] objectAtIndex:finger.type]);
//        }
        return YES;
    }
    return NO;
}

@end
