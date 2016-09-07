//
//  AppDelegate.m
//  ImageHostingHelper
//
//  Created by chars on 16/9/7.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void)terminate
{
    [NSApp terminate:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString *mainAppId = @"cn.zaker.chars.ImageHosting";
    NSArray *apps = [NSWorkspace sharedWorkspace].runningApplications;
    BOOL alreadyRunning = NO;
    for (NSRunningApplication *app in apps) {
        if ([app.bundleIdentifier isEqualToString:mainAppId]) {
            alreadyRunning = YES;
            break;
        }
    }
    
    if (!alreadyRunning) {
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(terminate) name:@"killIHhelper" object:mainAppId];
        NSString *path = [NSBundle mainBundle].bundlePath;
        NSMutableArray *components = [[path pathComponents] mutableCopy];
        [components removeLastObject];
        [components removeLastObject];
        [components removeLastObject];
        [components addObject:@"MacOS"];
        [components addObject:@"ImageHosting"];
        
        NSString *newPath = [NSString pathWithComponents:components];
        [[NSWorkspace sharedWorkspace] launchApplication:newPath];
    } else {
        [self terminate];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
