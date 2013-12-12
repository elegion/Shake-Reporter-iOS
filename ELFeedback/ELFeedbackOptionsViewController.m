//
//  ELFeedbackOptionsViewController.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackOptionsViewController.h"
#import "ELFeedbackDataSender.h"

NSString * const ELFeedbackOptionsViewControllerImageCellID = @"image";
NSString * const ELFeedbackOptionsViewControllerKeyValueCellID = @"keyValueCell";

@interface ELFeedbackOptionsViewController ()
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ELFeedbackDataSenderDelegate
>

// views
@property (nonatomic, strong) UIActionSheet *snapshotCellSelectedActionSheet;

// data
@property (nonatomic, strong) ELFeedbackDataProvider *dataProvider;
@property (nonatomic, strong) ELFeedbackDataSender *dataSender;

@end

@implementation ELFeedbackOptionsViewController

#pragma mark - Initialization

- (instancetype)initWithDataProvider:(ELFeedbackDataProvider *)dataProvider
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.dataProvider = dataProvider;
        self.dataSender = [[ELFeedbackDataSender alloc] initWithPresentingViewController:self];
    }
    return self;
}

#pragma mark - Managing the View

- (NSString *)title
{
    return @"Обратная связь";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;

    else
        return self.dataProvider.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return [self tableView:tableView imageCellForRowAtIndexPath:indexPath];
    
    else
        return [self tableView:tableView keyValueCellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView imageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ELFeedbackOptionsViewControllerImageCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ELFeedbackOptionsViewControllerImageCellID];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    cell.imageView.image = self.dataProvider.snapshotImage;
    cell.textLabel.text = @"Скриншот";
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView keyValueCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ELFeedbackOptionsViewControllerKeyValueCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ELFeedbackOptionsViewControllerKeyValueCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ELFeedbackDataItem *item = self.dataProvider.items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.value;
    
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
    self.dataProvider.snapshotImage = info[UIImagePickerControllerOriginalImage];
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

#pragma mark - Data Sender

- (void)feedbackDataSender:(ELFeedbackDataSender *)dataSender didFinishWithError:(NSError *)error
{
    if (error == nil) {
        if ([self.delegate respondsToSelector:@selector(feedbackOptionsViewControllerDidFinish:)])
            [self.delegate feedbackOptionsViewControllerDidFinish:self];
        return;
        
    } else
        [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"Закрыть" otherButtonTitles:nil] show];
}

#pragma mark - Actions

- (void)cancel
{
    if ([self.delegate respondsToSelector:@selector(feedbackOptionsViewControllerDidFinish:)])
        [self.delegate feedbackOptionsViewControllerDidFinish:self];
}

- (void)submit
{
    [self.dataSender sendDataWithDataProvider:self.dataProvider];
}

@end
