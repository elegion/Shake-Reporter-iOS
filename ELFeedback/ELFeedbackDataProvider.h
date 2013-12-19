//
//  ELFeedbackDataProvider.h
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELFeedbackDataItem.h"

@interface ELFeedbackDataProvider : NSObject

@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, strong) NSArray *items;

@end
