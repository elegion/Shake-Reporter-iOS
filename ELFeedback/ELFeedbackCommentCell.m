//
//  ELFeedbackCommentCell.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackCommentCell.h"

@implementation ELFeedbackCommentCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // text view
    CGRect textViewFrame = self.contentView.bounds;
    if ([self respondsToSelector:@selector(separatorInset)])
        textViewFrame = UIEdgeInsetsInsetRect(textViewFrame, self.separatorInset);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:textView];
    _textView = textView;
}

@end
