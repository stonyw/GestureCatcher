//
//  MotionController.m
//  GestureCatcher
//
//  Created by Stony Wang on 22/01/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "MotionController.h"

@interface MotionController ()


@end

@implementation MotionController

- (id)init
{
    self = [super init];
    if (self) {
        _fingerNames = @[@"Thumb", @"Index finger", @"Middle finger",
                         @"Ring finger", @"Pinky"];
        _boneNames = @[@"Metacarpal", @"Proximal phalanx",
                       @"Intermediate phalanx", @"Distal phalanx"];
    }
    return self;
}

- (void)startWithListener:(id)listener
{
    self.controller = [[LeapController alloc] initWithListener:listener];
}

- (void)startWithDelegate:(id)delegate
{
    self.controller = [[LeapController alloc] initWithDelegate:delegate];
}

- (void)stop
{
    [self.controller removeDelegate];
}


@end
