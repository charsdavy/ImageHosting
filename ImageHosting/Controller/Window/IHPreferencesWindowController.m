//
//  IHPreferencesWindowController.m
//  ImageHosting
//
//  Created by chars on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesWindowController.h"
#import "IHViewController.h"

@interface IHPreferencesWindowController ()

@property (strong) NSArray *viewControllers;
@property (strong) NSViewController *currentViewController;

@end

@implementation IHPreferencesWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName:@"IHPreferencesWindowController"];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self createToolbarItemsToViewControllerMapping];
}

#pragma mark - Showing the Preferences Window

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler
{
    self.completionHandler = handler;
    [self showWindow:self];
}

#pragma mark - Tabbed Preferences

- (void)createToolbarItemsToViewControllerMapping
{
    self.viewControllers = @[];
    
    if (!self.window) {
        NSLog(@"A preferences controller cannot work without a window. Connect the window outlet to your preferences window.");
        return;
    }
    if (!self.window.toolbar) {
        NSLog(@"A preferences controller cannot work without a toolbar.");
        return;
    }
    
    NSToolbarItem *firstItem = nil;
    for (NSToolbarItem *visibleItem in self.window.toolbar.visibleItems) {
        if (!visibleItem.isEnabled || visibleItem.target != self) {
            continue;
        }
        IHViewController *controller = [self createViewControllerForToolbarItem:visibleItem];
        if (!controller) {
            continue;
        }
        self.viewControllers = [self.viewControllers arrayByAddingObject:controller];
        if (!firstItem) {
            firstItem = visibleItem;
        }
    }
    if (firstItem) {
        [self.window.toolbar setSelectedItemIdentifier:firstItem.itemIdentifier];
        [self showPreferencesFor:firstItem];
    }
}

- (IHViewController *)createViewControllerForToolbarItem:(NSToolbarItem *)item
{
    if (!item) {
        return nil;
    }
    NSString *identifier = item.itemIdentifier;
    IHViewController *result = [[NSClassFromString(identifier) alloc] initWithNibName:identifier bundle:nil];
    if (!result) {
        return nil;
    }
    result.preferencesWindow = self.window;
    [result view];
    return result;
}

- (NSViewController *)existingViewControllerForToolbarItemWithIdentifier:(NSString *)identifier
{
    if (!identifier) {
        return nil;
    }
    for (NSViewController *viewController in self.viewControllers) {
        if ([viewController.nibName isEqualToString:identifier]) {
            return viewController;
        }
    }
    return nil;
}

- (NSViewController *)existingViewControllerForToolbarItem:(NSToolbarItem *)item
{
    return [self existingViewControllerForToolbarItemWithIdentifier:item.itemIdentifier];
}

- (void)showViewController:(NSViewController *)newViewController
{
    if (!self.currentViewController) {
        CGFloat deltaHeight = NSHeight([self.window.contentView bounds]) - NSHeight(newViewController.view.frame);
        CGFloat deltaWidth = NSWidth([self.window.contentView bounds]) - NSWidth(newViewController.view.frame);
        
        NSRect newWindowFrame = self.window.frame;
        
        newWindowFrame.size.height -= deltaHeight;
        newWindowFrame.size.width -= deltaWidth;
        newWindowFrame.origin.y += deltaHeight;
        [self.window setFrame:newWindowFrame display:YES animate:YES];
        [self.window.contentView addSubview:newViewController.view];
        
        self.currentViewController = newViewController;
        [self.window.toolbar setSelectedItemIdentifier:NSStringFromClass([newViewController class])];
        return;
    }
    
    [self.currentViewController.view removeFromSuperview];
    
    CGFloat deltaHeight = NSHeight(self.currentViewController.view.frame) - NSHeight(newViewController.view.frame);
    CGFloat deltaWidth = NSWidth(self.currentViewController.view.frame) - NSWidth(newViewController.view.frame);
    
    NSRect newWindowFrame = self.window.frame;
    
    newWindowFrame.size.height -= deltaHeight;
    newWindowFrame.size.width -= deltaWidth;
    newWindowFrame.origin.y += deltaHeight;
    [self.window setFrame:newWindowFrame display:YES animate:YES];
    [self.window.contentView addSubview:newViewController.view];
    self.currentViewController = newViewController;
    [self.window.toolbar setSelectedItemIdentifier:NSStringFromClass([newViewController class])];
}

- (IBAction)showPreferencesFor:(id)sender
{
    NSViewController *newViewController = [self existingViewControllerForToolbarItem:sender];
    [self showViewController:newViewController];
}

@end
