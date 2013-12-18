//
//  ELFeedbackHTTPProtocol.h
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 13.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ELFeedbackHTTPProtocolStartLoadingHandler)(NSURLRequest *request);

@interface ELFeedbackHTTPProtocol : NSURLProtocol

+ (void)setTrackingEnabled:(BOOL)enabled;

+ (void)setStartLoadingHandler:(ELFeedbackHTTPProtocolStartLoadingHandler)handler;

@end
