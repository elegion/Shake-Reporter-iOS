//
//  ELFeedbackDataProvider.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackDataProvider.h"

@interface ELFeedbackDataProvider ()

@end

@implementation ELFeedbackDataProvider

#pragma mark - Initialization

- (NSArray *)items
{
    if (_items == nil) {
        _items = @[[[ELFeedbackDataItem alloc] initWithTitle:(__bridge NSString *)kCFBundleVersionKey
                                                       value:[[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey]] ?: @"",
                   [[ELFeedbackDataItem alloc] initWithTitle:@"CFBundleShortVersionString"
                                                       value:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @""],
                   [[ELFeedbackDataItem alloc] initWithTitle:@"Устройство"
                                                       value:[UIDevice currentDevice].model],
                   [[ELFeedbackDataItem alloc] initWithTitle:@"iOS"
                                                       value:[UIDevice currentDevice].systemVersion],
                   [[ELFeedbackDataItem alloc] initWithTitle:@"Время"
                                                       valueBlock:^NSString *{
                                                           NSDateFormatter *dateFormatter = [NSDateFormatter new];
                                                           dateFormatter.dateFormat = @"dd.MM.yy, HH:mm:ss z";
                                                           return [dateFormatter stringFromDate:[NSDate date]];
                                                       }]
                   ];
    }
    
    return _items;
}

@end
