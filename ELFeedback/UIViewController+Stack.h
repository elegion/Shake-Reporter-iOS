//
//  UIViewController+stack.h
//  ELFeedbackApp
//
//  Created by Ivan Afanasyev on 16/04/14.
//  Copyright (c) 2014 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Stack)

+ (UIViewController*) topViewController;

+ (NSArray*)navigationStackForViewController;

@end
