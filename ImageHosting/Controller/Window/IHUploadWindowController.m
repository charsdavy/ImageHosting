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
#import "const.h"
#import "IHUploadFileCell.h"

#define CELL_HEIGHT 36.0f

@interface IHUploadWindowController ()<NSUserNotificationCenterDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (copy) NSArray *paths;
@property (copy) NSMutableArray<IHUploadFileCell *> *cells;
@property (assign) NSUInteger uploadFileCount;

@property (weak) IBOutlet NSTableView *tableView;

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
        _cells = [NSMutableArray array];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Button Action

- (IBAction)clickedUpload:(id)sender
{
    if (!self.paths) {
        NSString *alertMsg = @"Please select you want to upload file(s) ! ";
        NSString *title = @"Warning";
        [self showAlertTitle:title message:alertMsg style:IHAlertStyleWarning];
    }
    
    __block NSUInteger times = 0;
    __weak typeof(self) weakSelf = self;
    for (NSString *path in self.paths) {
        NSString *key = [path lastPathComponent];
        [self uploadFileWithPath:path key:key completion:^(NSString *key, NSDictionary *resp) {
            times++;
            BOOL success = NO;
            IHUploadFileCell *cell = [weakSelf cellForKey:key];
            if (resp) {
                success = YES;
                if (cell) {
                    cell.image = [NSImage imageNamed:@"success"];
                }
            } else {
                if (cell) {
                    cell.image = [NSImage imageNamed:@"fail"];
                }
            }
            [self uploadFileSuccess:success invoke:times];
        } progress:^(NSString *key, CGFloat percent) {
            NSLog(@"%s key:%@, progress:%f", __FUNCTION__, key, percent);
            IHUploadFileCell *cell = [weakSelf cellForKey:key];
            if (cell) {
                cell.progress = [NSString stringWithFormat:@"%f", percent * 100];
            }
        }];
    }
}

- (IBAction)clickedSelect:(id)sender
{
    NSOpenPanel *selectPanel = [NSOpenPanel openPanel];
    [selectPanel setAllowsMultipleSelection:YES];
    [selectPanel setCanChooseDirectories:NO];
    [selectPanel setCanChooseFiles:YES];
    
    [selectPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
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
            [self.tableView reloadData];
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
        NSString *title = @"Configure Guide";
        [self showAlertTitle:title message:alertMsg style:IHAlertStyleInformational];
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
    
    _paths = nil;
    [_cells removeAllObjects];
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message style:(IHAlertStyle)style
{
    NSAlertStyle alertStyle = NSInformationalAlertStyle;
    if (style == IHAlertStyleWarning) {
        alertStyle = NSWarningAlertStyle;
    } else if (style == IHAlertStyleCritical) {
        alertStyle = NSCriticalAlertStyle;
    } else if (style == IHAlertStyleInformational) {
        alertStyle = NSInformationalAlertStyle;
    } else {
        alertStyle = NSInformationalAlertStyle;
    }
    
    NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", message];
    alert.alertStyle = alertStyle;
    [alert beginSheetModalForWindow:self.window completionHandler:nil];
}

- (IHUploadFileCell *)cellForKey:(NSString *)key
{
    for (IHUploadFileCell *cell in self.cells) {
        if ([cell.title isEqualToString:key]) {
            return cell;
        }
    }
    return nil;
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

#pragma mark - NSTableViewDelegate

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    static NSString *identifier = @"IHUploadFileCellId";
    IHUploadFileCell *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    cell.progress = [NSString stringWithFormat:@"%f", 0.0f];
    cell.title = [self.paths[row] lastPathComponent];
    cell.image = nil;
    if (cell) {
        [self.cells addObject:cell];
    }
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return CELL_HEIGHT;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.paths.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}

@end
