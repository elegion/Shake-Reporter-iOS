//
//  ELAppDelegate.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELAppDelegate.h"
#import "ELFeedback.h"

@implementation ELAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // copy console.log file to the tmp dir
    NSError *error;
    NSURL *applicationDirectory = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    NSAssert(error == nil, @"%@", error);
    NSString *logsFilePath = [applicationDirectory.path stringByAppendingPathComponent:@"console.log"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:logsFilePath]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"console" ofType:@"log"]
                                                toPath:logsFilePath error:&error];
        NSAssert(error == nil, @"%@", error);
    }

    ELFeedbackManager *feedbackManager = [ELFeedbackManager sharedManager];
    [feedbackManager setURLRequestTrackingEnabledWithStartLoadingHandler:^(NSURLRequest *request) {
        // append url to the end of the log file
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logsFilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[NSString stringWithFormat:@"%@\n", request.URL] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }];
    ELFeedbackDataItem *logs = [[ELFeedbackDataItem alloc] initWithTitle:nil valueBlock:^NSString *{
        NSStringEncoding encoding;
        NSError *error;
        NSString *value = [NSString stringWithContentsOfFile:logsFilePath usedEncoding:&encoding error:&error];
        NSCAssert(error == nil, @"%@", error);
        return value;
    }];
    logs.attachmentFilename = logsFilePath.lastPathComponent;
    logs.attachmentMimeType = @"text/plain";
    feedbackManager.dataProvider.items = [feedbackManager.dataProvider.items arrayByAddingObject:logs];
    [feedbackManager start];

    return YES;
}

@end
