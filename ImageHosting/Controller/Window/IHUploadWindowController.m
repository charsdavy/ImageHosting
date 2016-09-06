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
#import "NSString+IHURL.h"
#import "IHDragTableView.h"

#define CELL_HEIGHT  36.0f
#define AGAIN_TITLE  @"Again"
#define UPLOAD_TITLE @"Upload"

@interface IHUploadWindowController ()<NSUserNotificationCenterDelegate, NSTableViewDelegate, NSTableViewDataSource, IHDragFileDelegate>

@property (copy) NSMutableArray *paths;
@property (copy) NSMutableArray<IHUploadFileCell *> *cells;
@property (assign) NSUInteger uploadFileCount;

@property (weak) IBOutlet IHDragTableView *tableView;
@property (weak) IBOutlet NSButton *selectButton;
@property (weak) IBOutlet NSButton *uploadButton;

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
        _paths = [NSMutableArray array];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.tableView.dragDelegate = self;

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Button Action

- (IBAction)clickedUpload:(id)sender
{
    if (!self.paths.count || !self.paths) {
        NSString *alertMsg = @"Please select you want to upload file(s) ! ";
        NSString *title = @"Warning";
        [self showAlertTitle:title message:alertMsg style:IHAlertStyleWarning];
    } else {
        self.selectButton.enabled = NO;
    }
    
    if ([self.uploadButton.title isEqualToString:AGAIN_TITLE]) {
        for (NSString *path in self.paths) {
            NSString *key = [path lastPathComponent];
            IHUploadFileCell *cell = [self cellForKey:key];
            if (cell) {
                cell.image = nil;
                cell.progress = @"0";
            }
        }
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
                [self removePathForKey:key];
                [self removeCellForKey:key];
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
            NSArray *urls = [selectPanel URLs];
            NSLog(@"%s urls:%@", __FUNCTION__, urls);
            for (NSString *url in urls) {
                NSString *path = [NSString stringWithFormat:@"%@", url];
                path = [path stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                path = [path URLDecodedString];
                [_paths addObject:path];
            }

            self.uploadFileCount = _paths.count;
            [self.tableView reloadData];
        }
    }];

    self.uploadButton.title = UPLOAD_TITLE;
}

#pragma mark - Private Methods

- (void)uploadFileSuccess:(BOOL)success invoke:(NSUInteger)times
{
    if (times == self.uploadFileCount) {
        if (0 == self.paths.count) {
            [self didUploadFilesSuccess:YES];
            self.uploadButton.title = UPLOAD_TITLE;
        } else {
            [self didUploadFilesSuccess:NO];
            self.uploadButton.title = AGAIN_TITLE;
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
    if ([[IHGeneralManager sharedManager] unarchiveForKey:SYSTEM_NOTIFICATION_KEY]) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        if (success) {
            notification.title = @"Upload Success";
            notification.informativeText = @"Upload file(s) success !";
        } else {
            notification.title = @"Upload Failed";
            notification.informativeText = [NSString stringWithFormat:@"OOh, %zi files upload failed, please select again or reconfigure account information! ", self.paths.count];
        }

        notification.soundName = @"NSUserNotificationDefaultSoundName";
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    }

    self.selectButton.enabled = YES;
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
        if ([cell.key isEqualToString:key]) {
            return cell;
        }
    }
    return nil;
}

- (void)removeCellForKey:(NSString *)key
{
    for (IHUploadFileCell *cell in self.cells) {
        if ([cell.key isEqualToString:key]) {
            [self.cells removeObject:cell];
            break;
        }
    }
}

- (void)removePathForKey:(NSString *)key
{
    for (NSString *path in self.paths) {
        if ([[path lastPathComponent] isEqualToString:key]) {
            [self.paths removeObject:path];
            break;
        }
    }
}

#pragma mark - Showing the Preferences Window

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler
{
    self.completionHandler = handler;
    [self showWindow:self];
}

#pragma mark - IHDragFileDelegate

- (void)didFinishedDragWithFile:(NSString *)path
{
    [self.paths addObject:path];
    self.uploadFileCount = _paths.count;
    [self.tableView reloadData];
}

#pragma mark - NSUserNotificationCenterDelegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    static NSString *identifier = @"IHUploadFileCellId";
    IHUploadFileCell *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    cell.progress = [NSString stringWithFormat:@"%f", 0.0f];
    cell.title = [[self.paths[row] lastPathComponent] URLDecodedString];
    cell.image = nil;
    cell.key = [self.paths[row] lastPathComponent];
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
