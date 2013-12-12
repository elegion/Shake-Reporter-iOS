//
//  ELFeedbackDataItem.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackDataItem.h"

@interface ELFeedbackDataItem ()

@property (nonatomic, copy) ELFeedbackDataItemValueBlock valueBlock;

@end

@implementation ELFeedbackDataItem

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.title = title;
        self.value = value;
    }
    return self;
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

- (NSString *)value
{
    if (self.valueBlock != nil)
        return self.valueBlock();
    else
        return _value;
}

@end
