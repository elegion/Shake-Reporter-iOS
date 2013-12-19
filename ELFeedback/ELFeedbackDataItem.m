//
//  ELFeedbackDataItem.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackDataItem.h"

@interface ELFeedbackDataItem ()

@end

@implementation ELFeedbackDataItem

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value
{
    return [self initWithTitle:title valueBlock:^NSString *{
        return value;
    }];
}

- (instancetype)initWithTitle:(NSString *)title valueBlock:(ELFeedbackDataItemValueBlock)valueBlock
{
    self = [super init];
    if (self) {
        self.title = title;
        self.valueBlock = valueBlock;
    }
    return self;
}

@end
