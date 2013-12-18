//
//  ELViewController.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELViewController.h"

@interface ELViewController ()

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation ELViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ya.ru"]];
    UIWebView *webView = [UIWebView new];
    [self.view addSubview:webView];
    [webView loadRequest:request];
}

@end
