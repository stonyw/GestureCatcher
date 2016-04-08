//
//  LMSGestureTypeB.h
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGesture.h"

@interface LMSGestureTypeB : LMSGesture

- (id)initWithGestureName:(NSString*)name withShortName:(NSString*)shortName withDelegate:(id<LMSGestureDelegate>)delegate;

@end
