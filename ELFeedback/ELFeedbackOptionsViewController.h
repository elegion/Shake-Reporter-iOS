//
//  ELFeedbackOptionsViewController.h
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELFeedbackDataProvider.h"

@class ELFeedbackOptionsViewController;
@protocol ELFeedbackOptionsViewControllerDelegate <NSObject>

@optional
- (void)feedbackOptionsViewControllerDidFinish:(ELFeedbackOptionsViewController *)controller;

@end

@interface ELFeedbackOptionsViewController : UITableViewController

@property (nonatomic, weak) id<ELFeedbackOptionsViewControllerDelegate> delegate;

/**
 Designated initializer
 */
- (instancetype)initWithDataProvider:(ELFeedbackDataProvider *)dataProvider;

@end
