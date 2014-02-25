//
//  ELFeedbackManager.h
//  ELFeedback
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackHTTPProtocol.h"
#import "ELFeedbackDataProvider.h"

extern NSString * const ELFeedbackManagerDidReceiveShakeMotionNotification;

@interface ELFeedbackManager : NSObject

@property (nonatomic, strong, readonly) ELFeedbackDataProvider *dataProvider;

+ (instancetype)sharedManager;

- (void)start;

- (void)stop;

- (void)setURLRequestTrackingEnabledWithStartLoadingHandler:(ELFeedbackHTTPProtocolStartLoadingHandler)handler;
- (void)setURLRequestTrackingDisabled;

@end
