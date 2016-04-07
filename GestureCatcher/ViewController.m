//
//  ViewController.m
//  GestureCatcher
//
//  Created by Stony Wang on 22/01/2016.
//  Copyright © 2016 Stony Wang. All rights reserved.
//

#import "ViewController.h"
#import "LMSConst.h"
#import "LMSGestureTypeA.h"
#import "LMSGestureTypeB.h"
#import "LMSGestureTypeC.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray*    gestures;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.leapMotion = [[MotionController alloc] init];
    
    NSMutableArray *array = [NSMutableArray array];
    LMSGesture *gestureA =[[LMSGestureTypeA alloc] initWithGestureName:@"Type A" withDelegate:self];
    gestureA.log = NO;
    [array addObject:gestureA];
    LMSGesture *gestureB = [[LMSGestureTypeB alloc] initWithGestureName:@"Type B" withDelegate:self];
    gestureB.log = NO;
    [array addObject:gestureB];
    LMSGesture *gestureC = [[LMSGestureTypeC alloc] initWithGestureName:@"Type C" withDelegate:self];
    gestureC.log = YES;
    [array addObject:gestureC];
    
    self.gestures = [array copy];
    
    
    _gestureFiredList = [NSMutableArray array];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)clickStart:(id)sender {
    [self.leapMotion startWithDelegate:self];
}

- (IBAction)clickStop:(id)sender {
    [self.leapMotion stop];
}

- (void)showFingerStatus:(NSArray *)status {
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < status.count; i++) {
        NSNumber * s = status[i];
        [string appendFormat:@"%@: %@ (%@)\n",  [LMSConst FingerNames][i], [LMSConst FingerStatusNames][s.intValue], s];
    }
    
//    if (fired) {
//        [_gestureFiredList addObject:[NSString stringWithFormat:@"%@ Gesture 2 is fired!\n", [[NSDate date] description]]];
//    }
    
    
    for (NSString *s in _gestureFiredList) {
        [string appendString:s];
    }
    
    [self.textView setString:string];
}

#pragma mark -- LMSGestureDelegate
- (void)onGestureEvent:(LeapController *)controller withGesture:(LMSGesture*)gesture {
    
    
    const NSString *name = gesture.name;
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSMutableString *string = [NSMutableString string];
        [_gestureFiredList addObject:[NSString stringWithFormat:@"%@ is fired.\n", name]];
        for (NSString *s in _gestureFiredList) {
            [string appendString:s];
        }
        [self.textView setString:string];
    });
    
    [gesture resetStatus];
    
}

#pragma mark - LeapDelegate
/**
 * Called once, when the LeapController has finished initializing.
 *
 *
 *     - (void)onInit:(LeapController *)controller
 *     {
 *         NSLog(@"Initialized");
 *         //...
 *     }
 *
 * @param controller The parent LeapController object.
 * @available Since 1.0
 */
- (void)onInit:(LeapController *)controller {
    NSLog(@"onInit");
}
/**
 * Called when the LeapController object connects to the Leap software, or when
 * this ListenerDelegate object is added to a controller that is already connected.
 *
 *     - (void)onConnect:(LeapController *)controller
 *     {
 *         NSLog(@"Connected");
 *         [controller enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
 *         //...
 *     }
 *
 * @param controller The parent LeapController object.
 * @available Since 1.0
 */
- (void)onConnect:(LeapController *)controller {
    NSLog(@"onConnect");
}
/**
 * Called when the LeapController object disconnects from the Leap software.
 * The controller can disconnect when the Leap device is unplugged, the
 * user shuts the Leap software down, or the Leap software encounters an
 * unrecoverable error.
 *
 *     - (void)onDisconnect:(LeapController *)controller
 *     {
 *         NSLog(@"Disconnected");
 *     }
 *
 * @param controller The parent LeapController object.
 * @available Since 1.0
 */
- (void)onDisconnect:(LeapController *)controller {
    NSLog(@"onDisconnect");
}
/**
 * Called when this LeapDelegate object is removed from the LeapController
 * or the controller instance is destroyed.
 *
 *     - (void)onExit:(LeapController *)controller
 *     {
 *         NSLog(@"Exited");
 *     }
 *
 * Note: When you launch a Leap-enabled application in a debugger, the
 * Leap library does not disconnect from the application. This is to allow
 * you to step through code without losing the connection because of time outs.
 *
 * @param controller The parent LeapController object.
 * @available Since 1.0
 */
- (void)onExit:(LeapController *)controller {
    NSLog(@"onExit");
}
/**
 * Called when a new frame of hand and finger tracking data is available.
 * Access the new frame data using the [LeapController frame:] function.
 *
 *     - (void)onFrame:(LeapController *)controller
 *     {
 *          NSLog(@"New LeapFrame");
 *          LeapFrame *frame = [controller frame:0];
 *          //...
 *     }
 *
 * Note, the LeapController skips any pending frames while your
 * onFrame handler executes. If your implementation takes too long to return,
 * one or more frames can be skipped. The controller still inserts the skipped
 * frames into the frame history. You can access recent frames by setting
 * the history parameter when calling the [LeapController frame:] function.
 * You can determine if any pending frames were skipped by comparing
 * the ID of the current frame with the ID of the previous received frame.
 *
 * @param controller The parent LeapController object.
 * @available Since 1.0
 */
- (void)onFrame:(LeapController *)controller {
//    NSLog(@"New LeapFrame");
    for (LMSGesture * gesture in self.gestures) {
        if (gesture) {
            [gesture onMotionGesture:controller];
        }
    }
}
/**
 * Called when this application becomes the foreground application.
 *
 * Only the foreground application receives tracking data from the Leap
 * Motion Controller. This function is only called when the controller
 * object is in a connected state.
 *
 *     - (void)onFocusGained:(LeapController *)controller
 *     {
 *         NSLog(@"Focus Gained");
 *     }
 *
 * @param controller The parent LeapController object.
 * @available Since 1.0
 */
- (void)onFocusGained:(LeapController *)controller {
    NSLog(@"Focus Gained");
}
/**
 * Called when this application loses the foreground focus.
 *
 * Only the foreground application receives tracking data from the Leap
 * Motion Controller. This function is only called when the controller
 * object is in a connected state.
 *
 *     - (void)onFocusLost:(LeapController *)controller
 *     {
 *         NSLog(@"Focus Lost");
 *     }
 *
 * @param controller The parent LeapController object.
 * @available Since 1.0
 */
- (void)onFocusLost:(LeapController *)controller {
    NSLog(@"Focus Lost");
}
/**
 * Called if the Leap Motion daemon/service disconnects from your application Controller.
 *
 * Normally, this callback is not invoked. It is only called if some external event
 * or problem shuts down the service or otherwise interrupts the connection.
 *
 *     - (void)onServiceConnect:(LeapController *)controller
 *     {
 *         NSLog(@"Service Connected");
 *     }
 *
 * @param controller The Controller object invoking this callback function.
 * @available Since 1.2
 */
- (void)onServiceConnect:(LeapController *)controller {
    NSLog(@"Service Connected");
}

/**
 * Called if the Leap Motion daemon/service disconnects from your application Controller.
 *
 * Normally, this callback is not invoked. It is only called if some external event
 * or problem shuts down the service or otherwise interrupts the connection.
 *
 *     - (void)onServiceDisconnect:(LeapController *)controller
 *     {
 *         NSLog(@"Service Disconnected");
 *     }
 *
 * @param controller The Controller object invoking this callback function.
 * @available Since 1.2
 */
- (void)onServiceDisconnect:(LeapController *)controller {
    NSLog(@"Service Disconnected");
}
/**
 * Called when a Leap Motion controller plugged in, unplugged, or the device changes state.
 *
 * State changes include changes in frame rate and entering or leaving "robust" mode.
 * Note that there is currently no way to query whether a device is in robust mode.
 * You can use Frame::currentFramerate() to get the framerate.
 *
 *     - (void)onDeviceChange:(LeapController *)controller
 *     {
 *         NSLog(@"Device Changed");
 *     }
 *
 * @param controller The Controller object invoking this callback function.
 * @since 1.2
 */
- (void)onDeviceChange:(LeapController *)controller {
    NSLog(@"Device Changed");
}
/**
 * Called when new images are available.
 * Access the NSArray containing the new images using the ``[LeapController images]`` function.
 *
 *     - (void)onImages:(LeapController *)controller
 *     {
 *          NSLog(@"New image list");
 *          NSArray *images = [controller images];
 *          //...
 *     }
 *
 * @param controller The Controller object invoking this callback function.
 * @since 2.2.1
 */
//- (void)onImages:(LeapController *)controller {
//    NSLog(@"New image list");
//    NSArray *images = [controller images];
//}

@end
