//
//  LMSGestureTypeC.h
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSGesture.h"

@interface LMSGestureTypeC : LMSGesture

@property (nonatomic, assign) float   startDistance;
@property (nonatomic, assign) float   minDistance;
@property (nonatomic, assign) float   endDistance;

- (id)initWithGestureName:(NSString*)name withShortName:(NSString*)shortName withDelegate:(id<LMSGestureDelegate>)delegate;

@end
