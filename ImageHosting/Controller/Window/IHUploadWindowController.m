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

@end

@implementation IHUploadWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName:@"IHUploadWindowController"];
    if (self) {
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
    for (NSString *path in self.paths) {
        [self uploadFileWithPath:path complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp) {
                NSLog(@"%s info:%@", __FUNCTION__, info);
            }
        }];
    }
}

- (IBAction)clickedSelect:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];

    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSLog(@"%s urls:%@", __FUNCTION__, [openPanel URLs]);
            NSMutableArray *array = [NSMutableArray array];
            for (NSString *url in [openPanel URLs]) {
                NSString *path = [NSString stringWithFormat:@"%@", url];
                path = [path stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                [array addObject:path];
            }
            self.paths = array;
        }
    }];
}

#pragma mark - Private Methods

- (void)uploadFileWithPath:(NSString *)path complete:(QNUpCompletionHandler)complete
{
    IHAccount *account = [[IHAccountManager sharedManager] currentAccount];
    [[IHQiniuUploadManager sharedManager] uploadQiniuForAccount:account filePath:path complete:complete];
}

#pragma mark - Showing the Preferences Window

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler
{
    self.completionHandler = handler;
    [self showWindow:self];
}

@end
