//
//  ELFeedbackOptionsViewController.m
//  ELFeedbackApp
//
//  Created by Dmitry Nesterenko on 11.12.13.
//  Copyright (c) 2013 e-legion. All rights reserved.
//

#import "ELFeedbackOptionsViewController.h"
#import "ELFeedbackDataSender.h"
#import "ELFeedbackCommentCell.h"

NSString * const ELFeedbackOptionsViewControllerImageCellID = @"image";
NSString * const ELFeedbackOptionsViewControllerKeyValueCellID = @"keyValueCell";
NSString * const ELFeedbackOptionsViewControllerCommentCellID = @"comment";

@interface ELFeedbackOptionsViewController ()
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ELFeedbackDataSenderDelegate,
UITextViewDelegate
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
        return 2;

    else
        return self.dataProvider.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]])
        return 88;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            return [self tableView:tableView commentCellForRowAtIndexPath:indexPath];
        else
            return [self tableView:tableView imageCellForRowAtIndexPath:indexPath];
    
    } else
        return [self tableView:tableView keyValueCellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView commentCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELFeedbackCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ELFeedbackOptionsViewControllerCommentCellID];
    if (cell == nil) {
        cell = [[ELFeedbackCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ELFeedbackOptionsViewControllerCommentCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
    }
    
    cell.textView.text = self.dataProvider.descriptionText;
    
    return cell;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
        [scrollView endEditing:YES]; // dismiss keyboard on scroll
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

#pragma mark - Text View

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.dataProvider.descriptionText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return YES;
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
