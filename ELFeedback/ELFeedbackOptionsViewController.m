//
//  ELFeedbackOptionsViewController.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackOptionsViewController.h"
#import <MessageUI/MessageUI.h>

NSString * const ELFeedbackOptionsViewControllerImageCellID = @"image";

@interface ELFeedbackOptionsViewController ()
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, strong) UIActionSheet *snapshotCellSelectedActionSheet;

@end

@implementation ELFeedbackOptionsViewController

#pragma mark - Initialization

- (instancetype)initWithSnapshotImage:(UIImage *)snapshotImage
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.snapshotImage = snapshotImage;
    }
    return self;
}

#pragma mark - Managing the View

- (NSString *)title
{
    return @"Обратная связь";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ELFeedbackOptionsViewControllerImageCellID];
}

#pragma mark - Navigation Interface

- (UINavigationItem *)navigationItem
{
    UINavigationItem *navigationItem = [super navigationItem];
    
    navigationItem.title = self.title;
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submit)];

    return navigationItem;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView imageCellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView imageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ELFeedbackOptionsViewControllerImageCellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ELFeedbackOptionsViewControllerImageCellID];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    cell.imageView.image = self.snapshotImage;
    cell.textLabel.text = @"Скриншот";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:ELFeedbackOptionsViewControllerImageCellID])
        [self.snapshotCellSelectedActionSheet showInView:self.view];
}

#pragma mark - Image Picker Controller

- (void)presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.sourceType = sourceType;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.snapshotImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - Action Sheets

- (UIActionSheet *)snapshotCellSelectedActionSheet
{
    if (_snapshotCellSelectedActionSheet == nil)
        _snapshotCellSelectedActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Сделать снимок", @"Выбрать из фотоальбома", nil];
    
    return _snapshotCellSelectedActionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.snapshotCellSelectedActionSheet) {
        if (buttonIndex == actionSheet.cancelButtonIndex)
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        
        else if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [[[UIAlertView alloc] initWithTitle:@"Камера недоступна на устройстве" message:nil delegate:nil cancelButtonTitle:@"Закрыть" otherButtonTitles:nil] show];
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
            } else
                [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        } else if (buttonIndex == 1) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [[[UIAlertView alloc] initWithTitle:@"Фотоальбом недоступен на устройстве" message:nil delegate:nil cancelButtonTitle:@"Закрыть" otherButtonTitles:nil] show];
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
            } else
                [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}

#pragma mark - Actions

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submit
{
    if (![MFMailComposeViewController canSendMail])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:%@"]];
    
    else {
        MFMailComposeViewController *controller = [MFMailComposeViewController new];
        [controller setSubject:[NSString stringWithFormat:@"[%@]", [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleNameKey]]];
        [controller setMessageBody:@"Feedback message body" isHTML:NO];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end
