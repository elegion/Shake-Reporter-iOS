//
//  UIView+ELSnapshot.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "UIView+ELSnapshot.h"

@implementation UIView (ELSnapshot)

- (UIImage *)ELSnapshot
{
    UIImage *image;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0); {
        if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
        else
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    } UIGraphicsEndImageContext();
    
    return image;
}

@end
