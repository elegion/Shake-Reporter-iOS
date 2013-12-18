//
//  ELFeedbackManager.h
//  ELFeedback
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELFeedbackHTTPProtocol.h"

extern NSString * const ELFeedbackManagerDidReceiveShakeMotionNotification;

@class ELFeedbackManager;
@protocol ELFeedbackManagerDelegate <NSObject>

@optional
- (void)feedbackManager:(ELFeedbackManager *)manager;

@end


@interface ELFeedbackManager : NSObject

@property (nonatomic, weak) id<ELFeedbackManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)start;

- (void)stop;

- (void)setURLRequestTrackingEnabledWithStartLoadingHandler:(ELFeedbackHTTPProtocolStartLoadingHandler)handler;
- (void)setURLRequestTrackingDisabled;

@end
