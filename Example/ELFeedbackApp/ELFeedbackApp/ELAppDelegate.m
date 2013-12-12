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
    [[ELFeedbackManager sharedManager] start];

    return YES;
}

@end
