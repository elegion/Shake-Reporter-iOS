//
//  ELFeedbackDataItem.h
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *(^ELFeedbackDataItemValueBlock)();

@interface ELFeedbackDataItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) ELFeedbackDataItemValueBlock valueBlock;
@property (nonatomic, copy) NSString *attachmentFilename;
@property (nonatomic, copy) NSString *attachmentMimeType;

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value;
- (instancetype)initWithTitle:(NSString *)title valueBlock:(ELFeedbackDataItemValueBlock)valueBlock;

@end
