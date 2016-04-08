//
//  ViewController.h
//  GestureCatcher
//
//  Created by Stony Wang on 22/01/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MotionController.h"
#import "LMSGesture.h"

@interface ViewController : NSViewController <LeapDelegate, LMSGestureDelegate>  {
    NSMutableArray *_gestureFiredList;
}

@property (nonatomic, strong) MotionController   *leapMotion;


@property (nonatomic, unsafe_unretained) IBOutlet NSTextView *textView;
@property (nonatomic, unsafe_unretained) IBOutlet NSTextField *serverField;

@property (nonatomic, unsafe_unretained) IBOutlet NSButton *startBtn;
@property (nonatomic, unsafe_unretained) IBOutlet NSButton *stopBtn;

- (IBAction)clickStart:(id)sender;

- (IBAction)clickStop:(id)sender;

- (IBAction)clickClear:(id)sender;

#pragma mark -- LMSGestureDelegate
- (void)onGestureEvent:(LeapController *)controller withGesture:(LMSGesture*)gesture;

@end

