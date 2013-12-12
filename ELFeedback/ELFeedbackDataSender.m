//
//  ELFeedbackDataSender.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 12.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackDataSender.h"
#import <MessageUI/MessageUI.h>

@interface ELFeedbackDataSender ()
<
MFMailComposeViewControllerDelegate
>

@property (nonatomic, weak) UIViewController<ELFeedbackDataSenderDelegate> *presentingController;

@end

@implementation ELFeedbackDataSender

#pragma mark - Initialization

- (instancetype)initWithPresentingViewController:(UIViewController<ELFeedbackDataSenderDelegate> *)presentingController
{
    self = [super init];
    if (self) {
        self.presentingController = presentingController;
    }
    return self;
}

#pragma mark - Mail Compose View Controller

- (void)presentMailComposeViewControllerWithDataProvider:(ELFeedbackDataProvider *)dataProvider
{
    MFMailComposeViewController *controller = [MFMailComposeViewController new];
    controller.mailComposeDelegate = self;
    [controller setSubject:[NSString stringWithFormat:@"[%@]", [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleNameKey]]];
    
    NSMutableString *itemsHTML = [NSMutableString new];
    [dataProvider.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ELFeedbackDataItem *item = obj;
        [itemsHTML appendFormat:@"<dt><bold>%@</bold></dt><dd>%@</dd><dl>", item.title, item.value];
    }];
    [controller setMessageBody:[NSString stringWithFormat:@"%@<br><br><dl>%@</dl>", dataProvider.descriptionText ?: @"", itemsHTML] isHTML:YES];
    [controller addAttachmentData:UIImagePNGRepresentation(dataProvider.snapshotImage) mimeType:@"image/png" fileName:@"screenshot.png"];
    
    [self.presentingController presentViewController:controller animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    __weak typeof(self) weakSelf = self;
    [controller dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultCancelled) {
            if ([weakSelf.presentingController respondsToSelector:@selector(feedbackDataSenderDidCancel:)])
                [weakSelf.presentingController feedbackDataSenderDidCancel:weakSelf];
            
        } else {
            if ([weakSelf.presentingController respondsToSelector:@selector(feedbackDataSender:didFinishWithError:)])
                [weakSelf.presentingController feedbackDataSender:weakSelf didFinishWithError:error];
            
        }
    }];
}

#pragma mark - Actions

- (void)sendDataWithDataProvider:(ELFeedbackDataProvider *)dataProvider;
{
    [self presentMailComposeViewControllerWithDataProvider:dataProvider];
}

@end
