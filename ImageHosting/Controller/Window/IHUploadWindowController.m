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

@interface IHUploadWindowController ()

@property (copy) NSArray *paths;
@property (assign) NSUInteger uploadFileCount;

@end

@implementation IHUploadWindowController

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
}

#pragma mark - Button Action

- (IBAction)clickedUpload:(id)sender
{
    if (!self.paths) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select you want to upload file(s) ! "];
        [alert runModal];
    }
    
    __block NSUInteger times = 0;
    for (NSString *path in self.paths) {
        [self uploadFileWithPath:path complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            times++;
            BOOL success = NO;
            if (resp) {
                success = YES;
            }
            [self uploadFileSuccess:success invoke:times];
        }];
    }
}

- (IBAction)clickedSelect:(id)sender
{
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
            NSAlert *alert = [NSAlert alertWithMessageText:@"" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Upload file(s) success ! "];
            [alert runModal];
            self.paths = nil;
        } else {
            NSAlert *alert = [NSAlert alertWithMessageText:@"" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%zi files upload filed, please select again ! ", self.uploadFileCount];
            [alert runModal];
            self.paths = nil;
        }
    }
}

- (void)uploadFileWithPath:(NSString *)path complete:(QNUpCompletionHandler)complete
{
    IHAccount *account = [[IHAccountManager sharedManager] currentAccount];
    if (!account) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please config account info by 'Preferences->Accounts' ! "];
        [alert runModal];
    }
    [[IHQiniuUploadManager sharedManager] uploadQiniuForAccount:account filePath:path complete:complete];
}

#pragma mark - Showing the Preferences Window

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler
{
    self.completionHandler = handler;
    [self showWindow:self];
}

@end
