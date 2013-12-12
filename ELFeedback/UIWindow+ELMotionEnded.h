//
//  UIWindow+ELMotionEnded.h
//  ELFeedback
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (ELMotionEnded)

- (void)EL_motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end
