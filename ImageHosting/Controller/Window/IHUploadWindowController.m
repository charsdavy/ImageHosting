//
//  IHUploadWindowController.m
//  ImageHosting
//
//  Created by chars on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHUploadWindowController.h"
#import "IHQiniuUploadManager.h"
#import "IHAccountManager.h"
#import "IHGeneralManager.h"

@interface IHUploadWindowController ()<NSUserNotificationCenterDelegate>

@property (copy) NSArray *paths;
@property (assign) NSUInteger uploadFileCount;

@property (weak) IBOutlet NSImageView *hintImageView;
@property (weak) IBOutlet NSTextField *hintLabel;

@end

@implementation IHUploadWindowController

- (void)dealloc
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
}

- (instancetype)init
{
    self = [super initWithWindowNibName:@"IHUploadWindowController"];
    if (self) {
        _uploadFileCount = 0;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self clearHintMessage];
}

#pragma mark - Button Action

- (IBAction)clickedUpload:(id)sender
{
    if (!self.paths) {
        NSString *alertMsg = @"Please select you want to upload file(s) ! ";
        [self showAlertWithMessage:alertMsg];
    }
    
    __block NSUInteger times = 0;
    for (NSString *path in self.paths) {
        NSString *key = [path lastPathComponent];
        [self uploadFileWithPath:path key:key completion:^(NSDictionary *resp) {
            times++;
            BOOL success = NO;
            if (resp) {
                success = YES;
            }
            [self uploadFileSuccess:success invoke:times];
        } progress:^(CGFloat percent) {
            NSLog(@"%s percent:%f", __FUNCTION__, percent);
        }];
    }
}

- (IBAction)clickedSelect:(id)sender
{
    [self clearHintMessage];
    
    NSOpenPanel *selectPanel = [NSOpenPanel openPanel];
    [selectPanel setAllowsMultipleSelection:YES];
    [selectPanel setCanChooseDirectories:NO];
    [selectPanel setCanChooseFiles:YES];
    
    [selectPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *urls = [selectPanel URLs];
            NSLog(@"%s urls:%@", __FUNCTION__, urls);
            for (NSString *url in urls) {
                NSString *path = [NSString stringWithFormat:@"%@", url];
                path = [path stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                [array addObject:path];
            }
            self.paths = array;
            self.uploadFileCount = array.count;
        }
    }];
}

#pragma mark - Private Methods

- (void)uploadFileSuccess:(BOOL)success invoke:(NSUInteger)times
{
    if (success) {
        if (self.uploadFileCount) {
            self.uploadFileCount--;
        }
    }
    
    if (times == self.paths.count) {
        if (0 == self.uploadFileCount) {
            [self didUploadFilesSuccess:YES];
        } else {
            [self didUploadFilesSuccess:NO];
        }
    }
}

- (void)uploadFileWithPath:(NSString *)path key:(NSString *)key completion:(IHQiniuCompletionHandler)completion progress:(IHQiniuProgressHandler)progress
{
    IHAccount *account = [[IHAccountManager sharedManager] currentAccount];
    if (!account) {
        NSString *alertMsg = @"Please configure account info by 'Preferences -> Accounts', and again upload. ";
        [self showAlertWithMessage:alertMsg];
        return;
    }
    
    [[IHQiniuUploadManager sharedManager] uploadQiniuForAccount:account key:key filePath:path completion:completion progress:progress];
}

- (void)didUploadFilesSuccess:(BOOL)success
{
    if ([[IHGeneralManager sharedManager] systemNotification]) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        if (success) {
            notification.title = @"Upload Success";
            notification.informativeText = @"Upload file(s) success !";
        } else {
            notification.title = @"Upload Failed";
            notification.informativeText = [NSString stringWithFormat:@"OOh, %zi files upload failed, please select again or reconfigure account information! ", self.uploadFileCount];
        }
        
        notification.soundName = @"NSUserNotificationDefaultSoundName";
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    }
    
    [self showHintSuccessMessage:success];
    self.paths = nil;
}

- (void)showAlertWithMessage:(NSString *)message
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", message];
    [alert runModal];
}

- (void)showHintSuccessMessage:(BOOL)success
{
    if (success) {
        self.hintImageView.image = [NSImage imageNamed:@"success"];
        self.hintLabel.textColor = [NSColor blackColor];
        self.hintLabel.stringValue = @"Upload file(s) success !";
    } else {
        self.hintImageView.image = [NSImage imageNamed:@"fail"];
        self.hintLabel.textColor = [NSColor redColor];
        self.hintLabel.stringValue = [NSString stringWithFormat:@"%zi files upload failed ! ", self.uploadFileCount];
    }
}

- (void)clearHintMessage
{
    self.hintImageView.image = nil;
    self.hintLabel.stringValue = @"";
}

#pragma mark - Showing the Preferences Window

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler
{
    self.completionHandler = handler;
    [self showWindow:self];
}

#pragma mark - NSUserNotificationCenterDelegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
