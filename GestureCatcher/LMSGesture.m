//
//  LMSGesture.m
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGesture.h"

@implementation LMSGesture

- (id)initWithGestureName:(NSString*)name  withShortName:(NSString*)shortName withDelegate:(id<LMSGestureDelegate>)delegate {
    if (self == [super init]) {
        self.name = name;
        self.shortName = shortName;
        self.enable = YES;
        self.log = NO;
        self.delegate = delegate;
        [self resetStatus];
    }
    return self;
}

- (BOOL)onMotionGesture:(LeapController *)controller {
    
    LeapFrame *frame = [controller frame:0];
    
    switch (self.status) {
        case LMSGestureStatusReady:
            if ([self matchStart:frame]) {
                if (self.log) {
                    NSLog(@"Started");
                }
                self.status = LMSGestureStatusStart;
                return YES;
            } else {
//                NSLog(@"Not started");
            }
            break;
        case LMSGestureStatusStart:
            if ([self matchEnd:frame]) {
                if (self.log) {
                    NSLog(@"Finished");
                }
                self.status = LMSGestureStatusFinish;
                if (self.enable) {
                    if ([self.delegate respondsToSelector:@selector(onGestureEvent:withGesture:)]) {
                        [self.delegate onGestureEvent:controller withGesture:self];
                    }
                }
                return YES;
            } else if ([self matchStart:frame]) {
                // self.status = matchEnd;
//                NSLog(@"Started ...");
                return YES;
            } else {
                if (self.log) {
                    NSLog(@"Not started");
                }
                self.status = LMSGestureStatusReady;
            }
            break;
        case LMSGestureStatusFinish:
            break;
        default:
            break;
    }
    return NO;
}

- (BOOL)matchStart:(LeapFrame*)frame {
    return NO;
}

- (BOOL)matchEnd:(LeapFrame*)frame {
    return NO;
}

- (void)resetStatus {
    self.status = LMSGestureStatusReady;
}

@end
