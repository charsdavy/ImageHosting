//
//  IHAboutWindowController.m
//  ImageHosting
//
//  Created by dengw on 16/8/28.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHAboutWindowController.h"

#define VERSION @"1.1.1"
#define BUILD   @"8"

@interface IHAboutWindowController ()

@property (weak) IBOutlet NSTextField *versionTextField;
@property (weak) IBOutlet NSTextField *copyrightTextField;

@end

@implementation IHAboutWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName:@"IHAboutWindowController"];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    self.versionTextField.stringValue = [self version];
}

- (NSString *)version
{
    NSString *version = [NSString stringWithFormat:@"Version %@ (%@)", VERSION, BUILD];
    return version;
}

#pragma mark - Showing the Preferences Window

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler
{
    self.completionHandler = handler;
    [self showWindow:self];
}

@end
