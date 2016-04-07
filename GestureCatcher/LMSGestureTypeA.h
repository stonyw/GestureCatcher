//
//  LMSGestureTypeA.h
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGesture.h"

@interface LMSGestureTypeA : LMSGesture {
    NSArray *_lastFingersStatus;
}

@property (nonatomic, strong) NSMutableArray       *fingerStatus;

- (id)initWithGestureName:(NSString*)name withDelegate:(id<LMSGestureDelegate>)delegate;

@end
