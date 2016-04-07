//
//  LMSGesture.h
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MotionController.h"
#import "LeapObjectiveC.h"

typedef NS_ENUM(NSUInteger, LMSGestureStatus) {
    LMSGestureStatusReady,
    LMSGestureStatusStart,
    LMSGestureStatusUpdate,
    LMSGestureStatusFinish,
    LMSGestureStatusCancel
};

@class LMSGesture;

@protocol LMSGestureDelegate<NSObject>

- (void)onGestureEvent:(LeapController *)controller withGesture:(LMSGesture*)gesture;

@end

@interface LMSGesture : NSObject

@property (nonatomic, copy)   NSString                *name;
@property (nonatomic, assign) LMSGestureStatus         status;
@property (nonatomic, weak)   id<LMSGestureDelegate>   delegate;
@property (nonatomic, assign) BOOL                     enable;
@property (nonatomic, assign) BOOL                     log;

- (id)initWithGestureName:(NSString*)name withDelegate:(id<LMSGestureDelegate>)delegate;
- (BOOL)onMotionGesture:(LeapController *)controller;
- (BOOL)matchStart:(LeapFrame*)frame;
- (BOOL)matchEnd:(LeapFrame*)frame;
- (void)resetStatus;

@end
