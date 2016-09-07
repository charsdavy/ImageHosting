//
//  AppDelegate.m
//  ImageHosting
//
//  Created by chars on 16/8/16.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "AppDelegate.h"
#import "IHPreferencesWindowController.h"
#import "IHUploadWindowController.h"
#import "IHGeneralManager.h"
#import "const.h"
#import "IHAboutWindowController.h"
#import "IHGeneral.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenu *statusMenu;
@property (strong) IHPreferencesWindowController *preferencesWindowController;
@property (strong) IHUploadWindowController *uploadWindowController;
@property (strong) IHAboutWindowController *aboutWindowController;

@end

@implementation AppDelegate

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
}

- (NSStatusItem *)statusItem
{
    if (!_statusItem) {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        [_statusItem setImage:[NSImage imageNamed:@"logo"]];
        [_statusItem setHighlightMode:YES];
    }
    return _statusItem;
}

- (NSMenu *)statusMenu
{
    if (!_statusMenu) {
        _statusMenu = [[NSMenu alloc] initWithTitle:@""];
        [_statusMenu addItemWithTitle:@"About" action:@selector(aboutMenuAction) keyEquivalent:@""];
        [_statusMenu addItemWithTitle:@"Upload" action:@selector(uploadMenuAction) keyEquivalent:@"u"];
        [_statusMenu addItemWithTitle:@"Preferences" action:@selector(preferencesMenuAction) keyEquivalent:@","];
        [_statusMenu addItemWithTitle:@"Instruction" action:@selector(instructionMenuAction) keyEquivalent:@""];
        [_statusMenu addItemWithTitle:@"Update" action:@selector(updateMenuAction) keyEquivalent:@""];
        [_statusMenu addItemWithTitle:@"Quit" action:@selector(quitMenuAction) keyEquivalent:@"q"];
    }
    return _statusMenu;
}

- (void)uploadMenuAction
{
    [self.uploadWindowController showWithCompletionHandler:nil];
    [[self.uploadWindowController window] setLevel:kCGStatusWindowLevel];
}

- (void)preferencesMenuAction
{
    [self showPreferences:nil];
}

- (void)instructionMenuAction
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://charsdavy.github.io/2016/08/22/ImageHosting-use-introduction/"]];
}

- (void)updateMenuAction
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/charsdavy/ImageHosting/releases"]];
}

- (void)quitMenuAction
{
    [NSApp terminate:self];
}

- (void)aboutMenuAction
{
    [self.aboutWindowController showWithCompletionHandler:nil];
    [[self.aboutWindowController window] setLevel:kCGStatusWindowLevel];
}

- (IBAction)showPreferences:(id)sender
{
    [self.preferencesWindowController showWithCompletionHandler:nil];
    [[self.preferencesWindowController window] setLevel:kCGStatusWindowLevel];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.statusItem setMenu:self.statusMenu];
    
    [NSApp activateIgnoringOtherApps:YES]; 
    
    if (!self.preferencesWindowController) {
        self.preferencesWindowController = [[IHPreferencesWindowController alloc] init];
    }
    
    if (!self.uploadWindowController) {
        self.uploadWindowController = [[IHUploadWindowController alloc] init];
    }
    
    if (!self.aboutWindowController) {
        self.aboutWindowController = [[IHAboutWindowController alloc] init];
    }
    
    IHGeneral *general = [[IHGeneral alloc] init];
    general = [[IHGeneralManager sharedManager] unarchiveForKey:SYSTEM_NOTIFICATION_KEY];
    
    if (!general.userNotification) {
        general.userNotification = @"YES";
    }
    
    if (!general.launchStartUp) {
        general.launchStartUp = @"NO";
        [[IHGeneralManager sharedManager] startupAppWhenLogin:NO];
    }
    
    [[IHGeneralManager sharedManager] archive:general key:SYSTEM_NOTIFICATION_KEY];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end
