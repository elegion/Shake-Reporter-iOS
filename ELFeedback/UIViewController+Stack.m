//
//  UIViewController+stack.m
//  ELFeedbackApp
//
//  Created by Ivan Afanasyev on 16/04/14.
//  Copyright (c) 2014 e-legion. All rights reserved.
//

#import "UIViewController+stack.h"


@implementation UIViewController (Stack)

+ (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}


+ (NSArray*)navigationStackForViewController
{
    return [self getViewControllersStackForRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}




+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


+ (NSArray*)getViewControllersStackForRootViewController:(UIViewController*)rootViewController
{
    return [self topViewController].navigationController ?
                [[self topViewController].navigationController viewControllers]:
                [NSArray array];
}


@end
