//
//  ELFeedbackDataSender.h
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELFeedbackDataProvider.h"

@class ELFeedbackDataSender;
@protocol ELFeedbackDataSenderDelegate <NSObject>

@optional
- (void)feedbackDataSender:(ELFeedbackDataSender *)dataSender didFinishWithError:(NSError *)error;
- (void)feedbackDataSenderDidCancel:(ELFeedbackDataSender *)dataSender;

@end

@interface ELFeedbackDataSender : NSObject

- (instancetype)initWithPresentingViewController:(UIViewController<ELFeedbackDataSenderDelegate> *)presentingController;

- (void)sendDataWithDataProvider:(ELFeedbackDataProvider *)dataProvider;

@end
