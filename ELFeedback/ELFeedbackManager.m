//
//  ELFeedbackManager.m
//  ELFeedback
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackManager.h"
#import "ELViewDataGetter.h"
#import "ELRuntimeClassModifications.h"
#import "UIWindow+ELMotionEnded.h"
#import <UIKit/UIKit.h>
#import "ELFeedbackOptionsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+ELSnapshot.h"

NSString * const ELFeedbackManagerDidReceiveShakeMotionNotification = @"ELFeedbackManagerDidReceiveShakeMotionNotification";

@interface ELFeedbackManager ()
<
ELFeedbackOptionsViewControllerDelegate
>

@property (nonatomic, strong) ELFeedbackDataProvider *dataProvider;
@property (nonatomic, strong) ELFeedbackOptionsViewController *optionsViewController;

@end

@implementation ELFeedbackManager

#pragma mark - Initialization

+ (instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self.class new];
    });
    return instance;
}

- (ELFeedbackDataProvider *)dataProvider
{
    if (_dataProvider == nil)
        _dataProvider = [ELFeedbackDataProvider new];
    
    return _dataProvider;
}

#pragma mark - Start and Stop

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

#pragma mark - Shake Notification

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
    if (self.optionsViewController.view.window != nil)
        // view controller is already presented
        return;

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self presentOptionsViewControllerAnimated:YES];
}

#pragma mark - Configuration

- (void)setURLRequestTrackingEnabledWithStartLoadingHandler:(ELFeedbackHTTPProtocolStartLoadingHandler)handler
{
    [ELFeedbackHTTPProtocol setTrackingEnabled:YES];
    [ELFeedbackHTTPProtocol setStartLoadingHandler:handler];
}

- (void)setURLRequestTrackingDisabled
{
    [ELFeedbackHTTPProtocol setTrackingEnabled:NO];
    [ELFeedbackHTTPProtocol setStartLoadingHandler:nil];
}

#pragma mark - Options View Controller

- (void)presentOptionsViewControllerAnimated:(BOOL)animated
{
    self.dataProvider.snapshotImage = [[UIApplication sharedApplication].keyWindow ELSnapshot];
    self.dataProvider.subviews = [ELViewDataGetter el_getSubviews];
    self.dataProvider.viewControllerInfo = [ELViewDataGetter el_getMainInfoAboutViewController];
    self.optionsViewController = [[ELFeedbackOptionsViewController alloc] initWithDataProvider:self.dataProvider];
    self.optionsViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.optionsViewController];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:animated completion:nil];
}

- (void)feedbackOptionsViewControllerDidFinish:(ELFeedbackOptionsViewController *)controller
{
    NSParameterAssert(controller == self.optionsViewController);
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.optionsViewController = nil;
}

@end
