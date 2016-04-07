//
//  LMSConst.m
//  GestureCatcher
//
//  Created by Stony Wang on 04/03/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "LMSConst.h"


@implementation LMSConst

static NSArray *_fingerNames;
static NSArray *_boneNames;
static NSArray *_fingerStatusNames;

+ (void)initialize
{
    [super initialize];
    
//    _fingerNames = @[@"Thumb", @"Index finger", @"Middle finger",
//                     @"Ring finger", @"Pinky"];
//    _boneNames = @[@"Metacarpal", @"Proximal phalanx",
//                   @"Intermediate phalanx", @"Distal phalanx"];
    
    _fingerNames = @[@"拇指", @"食指", @"中指", @"无名指", @"小指"];
    _boneNames = @[@"掌", @"近节指骨", @"中节指骨", @"远节指骨"];
    
    _fingerStatusNames = @[@"Unkown", @"Start", @"End", @"Untracked", @"Keep position"];
    
}

+ (NSArray *)FingerNames
{
    return _fingerNames;
}

+ (NSArray *)BoneNames
{
    return _boneNames;
}

+ (NSArray *)FingerStatusNames
{
    return _fingerStatusNames;
}

@end
