//
//  IHUploadWindowController.m
//  ImageHosting
//
//  Created by chars on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHUploadWindowController.h"

@interface IHUploadWindowController ()

@end

@implementation IHUploadWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName:@"IHUploadWindowController"];
    if (self) {
        
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Showing the Preferences Window

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler {
    self.completionHandler = handler;
    [self showWindow:self];
}

@end
