//
//  ELFeedbackDataProvider.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackDataProvider.h"
#import "ELGzipUtil.h"

@interface ELFeedbackDataProvider ()

@end

@implementation ELFeedbackDataProvider

#pragma mark - Initialization

- (NSArray *)items
{
    if (_items == nil) {
        NSMutableArray *items = @[[[ELFeedbackDataItem alloc] initWithTitle:(__bridge NSString *)kCFBundleVersionKey
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
                   ].mutableCopy;

        if (self.logDataBlock) {
            ELFeedbackDataItem *logItem = [[ELFeedbackDataItem alloc] init];
            logItem.title = @"Logs";
            logItem.attachmentFilename = @"logs.zip";
            logItem.attachmentMimeType = @"application/zip";
            logItem.attachmentDataBlock = ^ {
                NSData* logData = self.logDataBlock();
                return logData ? [ELGzipUtil gzipData:logData] : nil;
            };
            [items addObject:logItem];
        }
        _items = items;
    }
    
    return _items;
}

@end
