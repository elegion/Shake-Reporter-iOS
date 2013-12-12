//
//  UIWindow+ELMotionEnded.m
//  ELFeedback
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "UIWindow+ELMotionEnded.h"
#import "ELFeedbackManager.h"

@implementation UIWindow (ELMotionEnded)

- (void)EL_motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
        [[NSNotificationCenter defaultCenter] postNotificationName:ELFeedbackManagerDidReceiveShakeMotionNotification object:nil];
}

@end
