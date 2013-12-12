//
//  ELFeedbackOptionsViewController.h
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELFeedbackManager;

@interface ELFeedbackOptionsViewController : UITableViewController

@property (nonatomic, weak) ELFeedbackManager *feedbackManager;

/**
 Designated initializer
 */
- (instancetype)initWithSnapshotImage:(UIImage *)snapshotImage;

@end
