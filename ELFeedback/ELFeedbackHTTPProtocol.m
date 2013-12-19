//
//  ELFeedbackHTTPProtocol.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 13.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackHTTPProtocol.h"

static BOOL ELFeedbackHTTPProtocolTrackingEnabled;
static ELFeedbackHTTPProtocolStartLoadingHandler ELFeedbackHTTPProtocolStartLoadingBlock;

@implementation ELFeedbackHTTPProtocol

+ (void)setTrackingEnabled:(BOOL)enabled
{
    if (ELFeedbackHTTPProtocolTrackingEnabled == enabled)
        return;
    
    ELFeedbackHTTPProtocolTrackingEnabled = enabled;
    if (ELFeedbackHTTPProtocolTrackingEnabled) {
        BOOL success = [NSURLProtocol registerClass:self.class];
        NSAssert(success, @"Can not register %@ custom protocol", NSStringFromClass(self.class));
    } else
        [NSURLProtocol unregisterClass:self.class];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *scheme = request.URL.scheme.lowercaseString;
    return ELFeedbackHTTPProtocolTrackingEnabled && ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]);
}

- (void)startLoading
{
    if (ELFeedbackHTTPProtocolStartLoadingBlock != nil)
        ELFeedbackHTTPProtocolStartLoadingBlock(self.request);
}

- (void)stopLoading
{
    // do nothing
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (void)setStartLoadingHandler:(ELFeedbackHTTPProtocolStartLoadingHandler)handler
{
    ELFeedbackHTTPProtocolStartLoadingBlock = [handler copy];
}

@end
