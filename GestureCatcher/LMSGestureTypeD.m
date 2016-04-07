//
//  LMSGestureTypeD.m
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGestureTypeD.h"

@implementation LMSGestureTypeD

- (id)initWithGestureName:(NSString*)name withDelegate:(id<LMSGestureDelegate>)delegate {
    if (self == [super initWithGestureName:name withDelegate:delegate]) {
        
    }
    return self;
}

- (BOOL)matchStart:(LeapFrame*)frame {
    return NO;
}

- (BOOL)matchEnd:(LeapFrame*)frame {
    return NO;
}

@end
