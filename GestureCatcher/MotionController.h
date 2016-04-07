//
//  MotionController.h
//  GestureCatcher
//
//  Created by Stony Wang on 22/01/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

@interface MotionController : NSObject {
    NSArray *_fingerNames;
    NSArray *_boneNames;
}

@property (nonatomic, strong, readwrite) LeapController *controller;

- (void)startWithDelegate:(id)delegate;
- (void)startWithListener:(id)listener;
- (void)stop;

@end
