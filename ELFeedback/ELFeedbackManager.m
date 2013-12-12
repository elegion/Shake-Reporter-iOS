//
//  ELFeedbackManager.m
//  ELFeedback
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackManager.h"
#import "ELRuntimeClassModifications.h"
#import "UIWindow+ELMotionEnded.h"
#import <UIKit/UIKit.h>
#import "ELFeedbackOptionsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+ELSnapshot.h"

NSString * const ELFeedbackManagerDidReceiveShakeMotionNotification = @"ELFeedbackManagerDidReceiveShakeMotionNotification";

@implementation ELFeedbackManager

+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self.class new];
    });
    return instance;
}

- (void)start
{
    ELSwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), @selector(EL_motionEnded:withEvent:));
    [self setShakeMotionNotificationObservationEnabled:YES];
}

- (void)stop
{
    ELSwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), @selector(EL_motionEnded:withEvent:));
    [self setShakeMotionNotificationObservationEnabled:NO];
}

- (void)setShakeMotionNotificationObservationEnabled:(BOOL)enabled
{
    if (enabled)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveShakeMotionNotification:)
                                                     name:ELFeedbackManagerDidReceiveShakeMotionNotification
                                                   object:nil];
    else
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ELFeedbackManagerDidReceiveShakeMotionNotification object:nil];
}

- (void)didReceiveShakeMotionNotification:(NSNotification *)notification
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIImage *snapshot = [[UIApplication sharedApplication].keyWindow ELSnapshot];
    ELFeedbackOptionsViewController *controller = [[ELFeedbackOptionsViewController alloc] initWithSnapshotImage:snapshot];
    controller.feedbackManager = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
}

@end
